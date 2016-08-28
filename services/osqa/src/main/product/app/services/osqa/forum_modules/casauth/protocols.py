from django.http import get_host
from django.utils.html import escape
from django.contrib.sessions.models import Session
from forum import settings
from urllib import urlencode, urlopen
from urlparse import urlparse, urljoin
from socket import gethostbyname
import logging

CAS_TICKET_SESSION_ATTR = '_cas_ticket'

def login_url(request, service):
    if not settings.CAS_SERVER_URL:
        raise ValueError('Missing CAS_SERVER_URL in configuration')
    if not service.startswith('http://') and not service.startswith('https://'):
        service = _get_url_host(request) + service
    return urljoin(settings.CAS_SERVER_URL, 'login') + '?' + urlencode({'service': service})

def logout_url(request, service=None):
    if not settings.CAS_SERVER_URL:
        raise ValueError('Missing CAS_SERVER_URL in configuration')
    url = urljoin(settings.CAS_SERVER_URL, 'logout')
    if service:
        if not service.startswith('http://') and not service.startswith('https://'):
            service = _get_url_host(request) + service
        url += '?' + urlencode({'service': service})
    return url

def service_url(request):
    return _get_url_host(request) + request.path

def validate(ticket, service):
    protocol = str(settings.CAS_PROTOCOL)
    if protocol not in _PROTOCOLS:
        raise ValueError('Unsupported CAS_PROTOCOL %s' % protocol)
    verify = _PROTOCOLS[protocol]
    return verify(ticket, service)

def handle_logout_request(request, logout_request):
    allowed_servers = _get_allowed_logout_servers(request)
    if request.META['REMOTE_ADDR'] in allowed_servers:
        ticket = _get_ticket_from_logout_request(logout_request)
        if ticket:
            sessions = _find_sessions_by_ticket(ticket)
            for session in sessions:
                session.delete()
    else:
        logging.error('Client IP address %s is not allowed to send CAS logout requests' % request.META['REMOTE_ADDR'])

def _get_url_host(request):
    protocol = ('http', 'https')[request.is_secure()]
    host = escape(get_host(request))
    return '%s://%s' % (protocol, host)

def _verify_cas1(ticket, service):
    params = {'ticket': ticket, 'service': service}
    url = urljoin(settings.CAS_SERVER_URL, 'validate') + '?' + urlencode(params)
    page = urlopen(url)
    try:
        verified = page.readline().strip()
        if verified == 'yes':
            return page.readline().strip(), None
        else:
            return None, None
    finally:
        page.close()

def _verify_cas2(ticket, service):
    try:
        from xml.etree import ElementTree
    except ImportError:
        from elementtree import ElementTree
    params = {'ticket': ticket, 'service': service}
    url = urljoin(settings.CAS_SERVER_URL, 'serviceValidate') + '?' + urlencode(params)
    page = urlopen(url)
    try:
        user = None
        attributes = {}
        response = page.read()
        tree = ElementTree.fromstring(response)
        if tree[0].tag.endswith('authenticationSuccess'):
            for element in tree[0]:
                if element.tag.endswith('user'):
                    user = element.text
                elif element.tag.endswith('attributes'):
                    for attribute in element:
                        attributes[attribute.tag.split("}").pop()] = attribute.text
        return user, attributes
    finally:
        page.close()

def _verify_cas3(ticket, service):
    try:
        from xml.etree import ElementTree
    except ImportError:
        from elementtree import ElementTree
    params = {'ticket': ticket, 'service': service}
    url = urljoin(settings.CAS_SERVER_URL, 'p3/serviceValidate') + '?' + urlencode(params)
    page = urlopen(url)
    try:
        user = None
        attributes = {}
        response = page.read()
        tree = ElementTree.fromstring(response)
        if tree[0].tag.endswith('authenticationSuccess'):
            for element in tree[0]:
                if element.tag.endswith('user'):
                    user = element.text
                elif element.tag.endswith('attributes'):
                    for attribute in element:
                        attributes[attribute.tag.split("}").pop()] = attribute.text
        return user, attributes
    finally:
        page.close()

def _get_allowed_logout_servers(request):
    allowed_servers = []
    if settings.CAS_LOGOUT_REQUESTS_SERVERS:
        allowed_servers = str(settings.CAS_LOGOUT_REQUESTS_SERVERS).split(' ')
    elif settings.CAS_SERVER_URL:
        hostname = urlparse(str(settings.CAS_SERVER_URL)).hostname
        allowed_servers.append(hostname)
    return [ gethostbyname(server) for server in allowed_servers ]

def _get_ticket_from_logout_request(logout_request):
    try:
        from xml.etree import ElementTree
    except ImportError:
        from elementtree import ElementTree
    ticket = None
    tree = ElementTree.fromstring(logout_request)
    for element in tree:
        if element.tag.endswith('SessionIndex'):
            ticket = element.text
    return ticket

def _find_sessions_by_ticket(ticket):
    found = []
    sessions = Session.objects.all()
    for session in sessions:
        session_decoded = session.get_decoded()
        if CAS_TICKET_SESSION_ATTR in session_decoded and session_decoded[CAS_TICKET_SESSION_ATTR] == ticket:
            found.append(session)
    return found

_PROTOCOLS = {'cas1': _verify_cas1, 'cas2': _verify_cas2, 'cas3': _verify_cas3}

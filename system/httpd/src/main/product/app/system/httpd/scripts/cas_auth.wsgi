# WSGI CAS Authentication module, for use with WSGIAuthUserScript directive
# More info: http://code.google.com/p/modwsgi/wiki/AccessControlMechanisms
#
# Author: Fabien CRESPEL <fabien@crespel.net>
#

from time import time
from hashlib import sha1
from urllib import urlencode, urlopen
from urlparse import urlparse, urljoin, urlunsplit
import httplib
import logging

# CAS server configuration
CAS_SERVER_URL = '@{cas.url}'
CAS_SERVER_TICKETS_URL = urljoin(CAS_SERVER_URL, 'api/rest/tickets/')
CAS_ATTRIBUTE_GROUPS = 'groups'

# Cache storage and configuration
CAS_AUTH_CACHE_DATA = {}
CAS_AUTH_CACHE_TIMEOUT = 120
CAS_AUTH_CACHE_CLEANUP_DELAY = 10
CAS_AUTH_CACHE_CLEANUP_LAST = 0

# WSGI authentication provider
def check_password(environ, user, password):
    global CAS_AUTH_CACHE_DATA
    _cleanup_cache()
    password_hash = sha1(password).hexdigest()
    if user in CAS_AUTH_CACHE_DATA and CAS_AUTH_CACHE_DATA[user][0] == password_hash:
        logging.debug('CAS Auth: password matched from cache for user ' + user)
        return True
    else:
        ret, attributes = _cas_auth(environ, user, password)
        if ret:
            logging.debug('CAS Auth: adding user ' + user + ' to auth cache')
            CAS_AUTH_CACHE_DATA[user] = password_hash, time(), attributes
        return ret

# WSGI authorization provider
def groups_for_user(environ, user):
    if user in CAS_AUTH_CACHE_DATA:
        if CAS_ATTRIBUTE_GROUPS in CAS_AUTH_CACHE_DATA[user][2]:
            return CAS_AUTH_CACHE_DATA[user][2][CAS_ATTRIBUTE_GROUPS]
    return ['']

# Remove expired entries from cache
def _cleanup_cache():
    global CAS_AUTH_CACHE_DATA
    global CAS_AUTH_CACHE_CLEANUP_LAST
    cur_time = time()
    if cur_time - CAS_AUTH_CACHE_CLEANUP_LAST >= CAS_AUTH_CACHE_CLEANUP_DELAY:
        logging.debug('CAS Auth: executing cache cleanup')
        cache = {}
        for user,data in CAS_AUTH_CACHE_DATA.iteritems():
            if (cur_time - data[1]) < CAS_AUTH_CACHE_TIMEOUT:
                cache[user] = data
            else:
                logging.debug('CAS Auth: removing user ' + user + ' from auth cache')
        CAS_AUTH_CACHE_DATA = cache
        CAS_AUTH_CACHE_CLEANUP_LAST = cur_time

# Perform CAS authentication
def _cas_auth(environ, user, password):
    tgt_url = _create_tgt(user, password)
    if not tgt_url:
        logging.info('CAS Auth: failed to create TGT for user ' + user)
        return None, {}
    else:
        try:
            service_url = _service_url(environ)
            st = _grant_st(tgt_url, service_url)
            if not st:
                logging.error('CAS Auth: failed to grant ST for user ' + user)
                return False, {}
            else:
                username, attributes = _validate_st(st, service_url)
                if not username:
                    logging.error('CAS Auth: failed to validate ST ' + st + ' for user ' + user)
                    return False, {}
                else:
                    return True, attributes
        finally:
            try:
                _destroy_tgt(tgt_url)
            except:
                pass

# Build a service URL from the current location
def _service_url(environ):
    return urlunsplit(['http', environ['SERVER_NAME'], environ['REQUEST_URI'], environ['QUERY_STRING'], ''])

# Create a Ticket Granting Ticket
def _create_tgt(user, password):
    params = {'username': user, 'password': password}
    response = urlopen(CAS_SERVER_TICKETS_URL, urlencode(params))
    try:
        return response.info().get('Location')
    finally:
        response.close()

# Grant a Service Ticket
def _grant_st(tgt_url, service):
    params = {'service': service}
    response = urlopen(tgt_url, urlencode(params))
    try:
        return response.readline().strip()
    finally:
        response.close();

# Validate a Service Ticket (CAS 2.0-style)
def _validate_st(ticket, service):
    try:
        from xml.etree import ElementTree
    except ImportError:
        from elementtree import ElementTree
    params = {'ticket': ticket, 'service': service}
    url = urljoin(CAS_SERVER_URL, 'proxyValidate') + '?' + urlencode(params)
    response = urlopen(url)
    try:
        user = None
        attributes = {}
        body = response.read()
        tree = ElementTree.fromstring(body)
        if tree[0].tag.endswith('authenticationSuccess'):
            for element in tree[0]:
                if element.tag.endswith('user'):
                    user = element.text
                elif element.tag.endswith('attributes'):
                    for attribute in element:
                        attributes.setdefault(attribute.tag.split("}").pop(), []).append(attribute.text)
        return user, attributes
    finally:
        response.close()

# Destroy a Ticket Granting Ticket
def _destroy_tgt(tgt_url):
    tgt_url_parsed = urlparse(tgt_url)
    conn = httplib.HTTPConnection(tgt_url_parsed.netloc)
    conn.request('DELETE', tgt_url_parsed.path)

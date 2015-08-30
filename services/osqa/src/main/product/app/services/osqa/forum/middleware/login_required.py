from django.http import HttpResponseRedirect
from django.core.urlresolvers import reverse
from django.utils.translation import ugettext as _
from re import compile
from forum import settings

REQUIRE_LOGIN_EXEMPT_URLS = [
    r'^favicon\.ico$',
    r'^cstyle\.css$',
    r'^opensearch\.xml$',
    r'^m/',
    r'^%s' % _('upfiles/'),
    r'^%s' % _('account/'),
    r'^%s$' % _('faq/'),
    r'^%s$' % _('about/'),
    r'^%s$' % _('markdown_help/'),
    r'^%s$' % _('privacy/'),
    r'^%s$' % _('contact/'),
]
REQUIRE_LOGIN_EXEMPT_RE = [compile(expr) for expr in REQUIRE_LOGIN_EXEMPT_URLS]

class LoginRequiredMiddleware:
    """
    Middleware that requires a user to be authenticated to view any page other
    than authentication, about, faq, privacy and contact. Static resources and
    custom CSS are also excluded from the list.

    Requires authentication middleware and template context processors to be
    loaded. You'll get an error if they aren't.
    """
    def process_request(self, request):
        assert hasattr(request, 'user'), "The Login Required middleware\
 requires authentication middleware to be installed. Edit your\
 MIDDLEWARE_CLASSES setting to insert\
 'django.contrib.auth.middlware.AuthenticationMiddleware'. If that doesn't\
 work, ensure your TEMPLATE_CONTEXT_PROCESSORS setting includes\
 'django.core.context_processors.auth'."
        if settings.REQUIRE_LOGIN and not request.user.is_authenticated():
            path = request.path_info.lstrip('/')
            if not any(m.match(path) for m in REQUIRE_LOGIN_EXEMPT_RE):
                return HttpResponseRedirect(reverse('auth_signin'))

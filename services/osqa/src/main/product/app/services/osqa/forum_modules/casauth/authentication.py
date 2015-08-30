from django.core.urlresolvers import reverse
from django.http import HttpResponseRedirect
from django.utils.translation import ugettext as _
from django.views.decorators.csrf import csrf_exempt
from django.contrib.auth.signals import user_logged_out

import forum
from forum import settings
from forum.authentication.base import AuthenticationConsumer, ConsumerTemplateContext, InvalidAuthentication
from forum.models import User
from forum.actions import UserJoinsAction

from protocols import CAS_TICKET_SESSION_ATTR, login_url, logout_url, service_url, validate, handle_logout_request

class CASAuthConsumer(AuthenticationConsumer):

    def prepare_authentication_request(self, request, redirect_to):
        return login_url(request, redirect_to)

    @csrf_exempt
    def process_authentication_request(self, request):
        logout_request = request.POST.get('logoutRequest', None)
        if logout_request:
            if settings.CAS_LOGOUT_REQUESTS_ENABLED:
                handle_logout_request(request, logout_request)
                raise InvalidAuthentication('CAS logout request processed')
            else:
                raise InvalidAuthentication('CAS logout request ignored, disabled in configuration')

        ticket = request.GET.get('ticket', None)
        if not ticket:
            raise InvalidAuthentication(_('Login failed. CAS ticket is missing.'))

        service = service_url(request)
        username, attributes = validate(ticket, service)
        if not username:
            raise InvalidAuthentication(_('Login failed. CAS ticket is invalid.'))

        try:
            _user = User.objects.get(username=username)
            self._sync_user_attributes(_user, attributes)
        except User.DoesNotExist:
            _user = User(username=username)
            _user.set_unusable_password()
            self._sync_user_attributes(_user, attributes)
            _user.save()
            UserJoinsAction(user=_user, ip=request.META['REMOTE_ADDR']).save()

        request.session[CAS_TICKET_SESSION_ATTR] = ticket
        return _user

    def _sync_user_attributes(self, user, attributes):
        if not attributes:
            return
        if settings.CAS_ATTRIBUTE_NAME and attributes[str(settings.CAS_ATTRIBUTE_NAME)]:
            user.real_name = attributes[str(settings.CAS_ATTRIBUTE_NAME)]
        if settings.CAS_ATTRIBUTE_EMAIL and attributes[str(settings.CAS_ATTRIBUTE_EMAIL)]:
            user.email = attributes[str(settings.CAS_ATTRIBUTE_EMAIL)]
            user.email_isvalid = True

class CASAuthContext(ConsumerTemplateContext):
    mode = 'BIGICON'
    type = 'DIRECT'
    weight = 50
    human_name = 'CAS authentication'
    icon = '/media/images/openid/cas.png'
    show_to_logged_in_user = False

def cas_user_logged_out(sender, request, user, **kwargs):
    if CAS_TICKET_SESSION_ATTR in request.session and hasattr(forum, 'RESPONSE_HOLDER'):
        forum.RESPONSE_HOLDER.response = HttpResponseRedirect(logout_url(request, reverse('index')))

user_logged_out.connect(cas_user_logged_out, dispatch_uid='cas_user_logged_out')

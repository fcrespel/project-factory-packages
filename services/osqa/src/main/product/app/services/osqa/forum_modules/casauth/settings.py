from forum.settings.base import Setting, SettingSet
from django.forms.widgets import Select
from django.utils.translation import ugettext_lazy as _

CAS_PROTOCOL_CHOICES = (
('cas1', _('CAS 1.0')),
('cas2', _('CAS 2.0'))
)

CAS_SET = SettingSet('cas', _('CAS settings'), _("CAS configuration for OSQA"), 4)

CAS_SERVER_URL = Setting('CAS_SERVER_URL', '', CAS_SET, dict(
label = _("CAS Server URL"),
help_text = _("The URL of the CAS server to use for authentication, e.g. https://cas.example.org or https://example.org/cas/"),
required = False))

CAS_PROTOCOL = Setting('CAS_PROTOCOL', 'cas2', CAS_SET, dict(
label = _("CAS Protocol"),
help_text = _("The CAS server protocol to use for ticket validation. Only CAS 2.0 supports attributes."),
widget=Select(choices=CAS_PROTOCOL_CHOICES),
required = False))

CAS_ATTRIBUTE_NAME = Setting('CAS_ATTRIBUTE_NAME', 'displayName', CAS_SET, dict(
label = _("User Name Attribute"),
help_text = _("The user attribute holding the full name."),
required = False))

CAS_ATTRIBUTE_EMAIL = Setting('CAS_ATTRIBUTE_EMAIL', 'mail', CAS_SET, dict(
label = _("User Email Attribute"),
help_text = _("The user attribute holding the email address."),
required = False))

CAS_LOGOUT_REQUESTS_ENABLED = Setting('CAS_LOGOUT_REQUESTS_ENABLED', True, CAS_SET, dict(
label = _("Enable Single Sign-Out"),
help_text = _("Whether Single Sign-Out should be enabled or not."),
required = False))

CAS_LOGOUT_REQUESTS_SERVERS = Setting('CAS_LOGOUT_REQUESTS_SERVERS', '', CAS_SET, dict(
label = _("Single Sign-Out Servers"),
help_text = _("Space-separated list of hostnames or IP addresses allowed to send logout requests for Single Sign-Out. If empty, the CAS server defined above is used."),
required = False))

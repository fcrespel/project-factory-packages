from base import Setting, SettingSet
from django.utils.translation import ugettext_lazy as _

BASIC_SET = SettingSet('auth', _('Authentication settings'), _("User authentication settings"), 2)

REQUIRE_LOGIN = Setting('REQUIRE_LOGIN', False, BASIC_SET, dict(
label = _("Require login to view site"),
help_text = _("If checked, users will be forced to log in to view site content."),
required=False))

DEFAULT_AUTH_PROVIDER = Setting('DEFAULT_AUTH_PROVIDER', '', BASIC_SET, dict(
label = _("Default authentication provider"),
help_text = _("If defined, this provider will be used in replacement of the standard login page, except if an error occurs."),
required=False))

IMMEDIATE_LOGOUT = Setting('IMMEDIATE_LOGOUT', False, BASIC_SET, dict(
label = _("Hide logout confirmation page"),
help_text = _("If checked, users will be logged out as soon as they click the 'logout' link."),
required=False))

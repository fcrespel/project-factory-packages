class RequestHolder(object):
    def __init__(self):
        self.request = None

REQUEST_HOLDER = RequestHolder()

# F. CRESPEL EDIT 2013-01-28: added ResponseHolder for use with ResponseUtilsMiddleware
class ResponseHolder(object):
    def __init__(self):
        self.response = None

RESPONSE_HOLDER = ResponseHolder()

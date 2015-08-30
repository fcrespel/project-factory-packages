import forum

class ResponseUtilsMiddleware(object):
    def process_request(self, request):
        forum.RESPONSE_HOLDER.response = None
        return None

    def process_response(self, request, response):
        if forum.RESPONSE_HOLDER.response:
            response = forum.RESPONSE_HOLDER.response
            forum.RESPONSE_HOLDER.response = None
            return response
        else:
            return response

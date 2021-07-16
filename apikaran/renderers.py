from rest_framework.renderers import JSONRenderer


class CustomJsonRender(JSONRenderer):

    def render(self, data, accepted_media_type=None, renderer_context=None):
        if renderer_context:
            response = renderer_context['response']
            code = response.status_code
            error = None
            new_data = None
            if code >= 400:
                error = data
            else:
                new_data = data
            res = {
                'code': code,
                'data': new_data,
                'error': error
            }
            return super().render(res, accepted_media_type, renderer_context)
        else:
            return super().render(data, accepted_media_type, renderer_context)
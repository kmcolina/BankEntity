from oauthlib import common


def random_token_generator(request, refresh_token=False):
    """
    :param request: OAuthlib request.
    :type request: oauthlib.common.Request
    :param refresh_token:
    """
    return common.generate_token(length=255)

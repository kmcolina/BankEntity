import json

from oauth2_provider.models import get_access_token_model
from oauth2_provider.views import TokenView
from rest_framework import status, viewsets
from rest_framework.decorators import action
from rest_framework.response import Response

# Create your views here.
from apikaran.authentication.serializers import UserNaturalSignUpSerializer, UserModelSerializer, \
    UserJuridicoSignUpSerializer


class AuthViewSet(viewsets.ViewSet):
    authentication_classes = []
    permission_classes = []

    @action(detail=False, methods=['post'], url_path='register/natural', name='register Natural')
    def signupnatural(self, request):
        serializer = UserNaturalSignUpSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        user = serializer.save()
        data = UserModelSerializer(user).data
        return Response(data, status=status.HTTP_201_CREATED)

    @action(detail=False, methods=['post'], url_path='register/juridico')
    def signupjuridico(self, request):
        serializer = UserJuridicoSignUpSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        user = serializer.save()
        data = UserModelSerializer(user).data
        return Response(data, status=status.HTTP_201_CREATED)


class AuthLogin(TokenView):
    def create_token_response(self, request):
        url, headers, body, status = super().create_token_response(request)
        new_body = json.loads(body)
        if status == 200:
            access_token = json.loads(body).get("access_token")
            token = get_access_token_model().objects.select_related("user").filter(token=access_token).first()
            data = UserModelSerializer(token.user).data
            new_body = json.loads(body)
            new_body['user'] = data
        new_body = json.dumps(new_body)
        return url, headers, new_body, status

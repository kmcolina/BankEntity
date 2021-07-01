from django.contrib.auth import login
from rest_framework import status, viewsets
from rest_framework.decorators import action
from rest_framework.response import Response
# Create your views here.
from apikaran.authentication.serializers import UserNaturalSignUpSerializer, UserModelSerializer, \
    UserJuridicoSignUpSerializer, LoginSerializers


class AuthViewSet(viewsets.ViewSet):
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

    @action(detail=False, methods=['post'], url_path='login')
    def login(self, request):
        serializer = LoginSerializers(data=request.data, context={'request': request})
        serializer.is_valid(raise_exception=True)
        user = serializer.validated_data['user']
        login(request, user)
        return Response(status=status.HTTP_200_OK)

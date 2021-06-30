from rest_framework import status, viewsets
from rest_framework.decorators import action
from rest_framework.response import Response
# Create your views here.
from apikaran.authentication.serializers import UserNaturalSignUpSerializer, UserModelSerializer


class AuthViewSet(viewsets.GenericViewSet):
    @action(detail=False, methods=['post'], url_path='register/natural')
    def signupnatural(self, request):
        serializer = UserNaturalSignUpSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        user = serializer.save()
        data = UserModelSerializer(user).data
        return Response(data, status=status.HTTP_201_CREATED)
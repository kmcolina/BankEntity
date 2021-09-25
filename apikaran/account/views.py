from django.shortcuts import render

# Create your views here.
from rest_framework import generics
from rest_framework.permissions import IsAuthenticated

from apikaran.account.serializers import AccountSerializer


class BasicAccountView(generics.RetrieveUpdateAPIView):
    permission_classes = [IsAuthenticated]
    serializer_class = AccountSerializer

    def get_object(self):
        if self.request.user.is_authenticated:
            return self.request.user

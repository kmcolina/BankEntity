from django.contrib.auth.models import User
from rest_framework import serializers

from apikaran.cliente.serializers import ClienteSerializer


class AccountSerializer(serializers.ModelSerializer):
    cliente = ClienteSerializer()

    class Meta:
        model = User
        fields = [
            'username',
            'first_name',
            'last_name',
            'email',
            'cliente'
        ]

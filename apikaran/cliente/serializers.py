from rest_framework import serializers

from apikaran.cliente.models import Cliente, TipoCliente


class TipoClienteSerializer(serializers.ModelSerializer):
    class Meta:
        model = TipoCliente
        fields = ['descripcion']


class ClienteSerializer(serializers.ModelSerializer):
    tipoCliente = serializers.StringRelatedField(many=False)

    class Meta:
        model = Cliente
        fields = [
            'dni',
            'tipoCliente'
        ]

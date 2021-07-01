from django.contrib.auth import password_validation, authenticate
from django.contrib.auth.models import User
from rest_framework import serializers
from rest_framework.validators import UniqueValidator

from apikaran.cliente.models import Cliente, TipoCliente


class UserModelSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = (
            'username',
            'first_name',
            'last_name',
            'email',
        )


class UserNaturalSignUpSerializer(serializers.Serializer):
    email = serializers.EmailField(
        required=True,
        validators=[UniqueValidator(queryset=User.objects.all())]
    )
    username = serializers.CharField(
        min_length=6,
        max_length=20,
        required=True,
        validators=[UniqueValidator(queryset=User.objects.all())]
    )

    dni = serializers.IntegerField(
        required=True,
        min_value=1,
        validators=[UniqueValidator(queryset=Cliente.objects.all())]
    )

    first_name = serializers.CharField(
        min_length=2, max_length=50,
        required=True,
    )
    last_name = serializers.CharField(
        min_length=2, max_length=100,
        required=True,
    )

    password = serializers.CharField(min_length=8, max_length=64)
    password_confirmation = serializers.CharField(min_length=8, max_length=64)

    def validate(self, data):
        passwd = data['password']
        passwd_conf = data['password_confirmation']
        if passwd != passwd_conf:
            raise serializers.ValidationError("Las contraseñas no coinciden")
        password_validation.validate_password(passwd)
        return data

    def update(self, instance, validated_data):
        pass

    def get_tipo_cliente(self):
        return TipoCliente.objects.get(descripcion__exact='Natural')

    def create(self, data):

        try:
            tipo_cliente = self.get_tipo_cliente()
        except TipoCliente.DoesNotExist:
            raise serializers.ValidationError("No se puede registrar usuario")

        user = User.objects.create(
            email=data['email'],
            username=data['username'],
            first_name=data['first_name'],
            last_name=data['last_name']
        )

        user.set_password(data['password'])
        user.save()

        cliente = Cliente.objects.create(
            dni=data['dni'],
            user=user,
            tipoCliente=tipo_cliente
        )

        cliente.save()

        return user


class UserJuridicoSignUpSerializer(UserNaturalSignUpSerializer):
    def get_tipo_cliente(self):
        return TipoCliente.objects.get(descripcion__exact='Juridico')


class LoginSerializers(serializers.Serializer):
    username = serializers.CharField(required=True)
    password = serializers.CharField(trim_whitespace=False, required=True)

    def validate(self, data):
        username = data.get('username')
        password = data.get('password')

        if username and password:
            user = authenticate(request=self.context.get('request'),
                                username=username, password=password)
            if not user:
                msg = 'Credenciales invalidas'
                raise serializers.ValidationError(msg, code='authorization')
        else:
            msg = 'Debe incluir "username" y "password"'
            raise serializers.ValidationError(msg, code='authorization')

        data['user'] = user
        return data

    def update(self, instance, validated_data):
        pass

    def create(self, validated_data):
        pass



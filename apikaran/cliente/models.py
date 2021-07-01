from django.db import models
from django.contrib.auth.models import User


class TipoCliente(models.Model):
    descripcion = models.CharField(max_length=50)

    class Meta:
        db_table = 'tipo_cliente'

    def __str__(self):
        return self.descripcion


class Cliente(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE)
    dni = models.IntegerField(unique=True)
    tipoCliente = models.ForeignKey(TipoCliente, on_delete=models.RESTRICT)

    class Meta:
        db_table= 'clientes'

    def __str__(self):
        return self.user.email

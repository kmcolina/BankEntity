from django.contrib.auth.models import AbstractUser
from django.db import models

from apikaran.cliente.customusermanager import CustomUserManager


class TipoCliente(models.Model):
    descripcion = models.CharField(max_length=50)

    class Meta:
        db_table = 'tipo_cliente'

    def __str__(self):
        return self.descripcion


class Cliente(AbstractUser):
    dni = models.IntegerField(unique=True)
    tipoCliente = models.OneToOneField(TipoCliente, on_delete=models.RESTRICT)
    objects = CustomUserManager()

    class Meta:
        db_table= 'clientes'

    def __str__(self):
        return self.email

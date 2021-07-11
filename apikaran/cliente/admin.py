from django.contrib import admin

# Register your models here.
from apikaran.cliente.models import Cliente, TipoCliente

admin.site.register(Cliente)
admin.site.register(TipoCliente)

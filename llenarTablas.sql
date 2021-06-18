--script para llenar las tablas 


--lleno las tablas tipo que son valores predefinidos 

--tabla tipo cliente
--solo los clientes juridicos pueden tener api key asignada 


insert into tipo_cliente (id_tipo_cliente,descripcion) values (
(1,"natural"),
(2,"juridico")
);

--tabla estado transaccion
--exitoso todo bien y/o falta de fondos
--fallida caida de conexion 

insert into estado_transaccion (id_estado_transaccion,descripcion)
values (
(1,"exitosa"),
(2,"fallida")
);


--tabla tipo transaccion
--debito, credito, transferencia a una cuenta, pago con tarjeta de credito, pago del monto minimo de tarjeta de credito

insert into tipo_transaccion (id_tipo_transaccion,descripcion) values (
(1,"debito compra a comercio"),
(2,"credito por venta"),
(3,"transferencia entre cuentas"),
(4,"pago deuda tarjeta de credito")
);



--tabla cliente
--call insert_random_clientes( )

--tengo un cliente por defecto
-insert into clientes values (
(1,gen_CIRif (),"","","Primer Comercio","primercomercio@correo.com",2, "primcomer1","clavecomer1")
);


--tabla auditor 
-- call insert_random_auditor( )


--tabla api key se llena con un trigger cada vez que se cree un cliente tipo juridico o se llena a solicitud del cliente? - uso triger/ uso procedimiento

--tabla cuenta 
--call insert_random_cuenta(id_cliente)

--tabla tarjeta
--call insert_random_tarjeta(id_cliente)



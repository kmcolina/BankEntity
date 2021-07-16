--script para llenar las tablas 


--lleno las tablas tipo que son valores predefinidos 

--tabla tipo cliente
--solo los clientes juridicos pueden tener api key asignada 


insert into tipo_cliente (id_tipo_cliente ,descripcion) values 
(DEFAULT,'natural'),
(DEFAULT,'juridico')
;

--tabla estado transaccion
--exitoso todo bien y/o falta de fondos
--fallida caida de conexion 

insert into estado_transaccion  (id_estado_transaccion,descripcion)
values 
(DEFAULT,'exitosa'),
(DEFAULT,'fallida')
;


--tabla tipo transaccion
--debito, credito, transferencia a una cuenta, pago con tarjeta de credito, pago del monto minimo de tarjeta de credito

insert into tipo_transaccion  (id_tipo_transaccion,descripcion) values

(DEFAULT,'debito compra a comercio / credito por venta'),
(DEFAULT,'transferencia entre cuentas'),
(DEFAULT,'pago deuda tarjeta de credito'),
(DEFAULT, 'deposito en cuenta')
;



--tabla cliente
--tengo un cliente comercio por defecto
insert into cliente 
values (DEFAULT,gen_CIRif (),null,null,'Primer Comercio','primercomercio@correo.com',2, 'primcomer1','primcomer1','clavecomer1');

select insert_random_clientes();
--tabla auditor 
select insert_random_auditor();

--genero el log
select insert_random_log();


--tabla api key se llena con un trigger cada vez que se cree un cliente tipo juridico o se llena a solicitud del cliente? - uso triger/ uso procedimiento

--tabla cuenta 
--call insert_random_cuenta(id_cliente)

--tabla tarjeta
--call insert_random_tarjeta(id_cliente)

--tabla api key 
-- call insert_random_apiKey

----------------------------------------------
--tablas historiales se llenan con triggers



--------------------------------------
--------------------------------------

--para la simulacion iniciar
-- necesito
--mes, día, año e intervalos de tiempo de:
--	Transacciones fallidas/exitosas por Clientes
--	Clientes ordenados por cantidad de transacciones
--	Días y horas con más transaccionalidad


-- por hora minimo 10*5 - 24*5 operaciones exitosas por cliente -- min 50 ,max 120 por hora por cliente
-- por dia da 10*5*5 - 24*5*5 -- min max 600 trans por dia  - son por 5 por valor hora
-- transaciones fallidas 10*1 - 24*1 // una quinta parte falla


--pasos simulacion , insertar tabla usuarios, disparar triger asignar cuenta, tarjeta y api,
-- llamar a funcion insertar log, disparar trigger actualizar cuenta y tarjeta.

--falta hacer funcion llenar log 
-- en el simulador del log, al crear un monto trnasaccion validar si es valido respecto al saldo de la tarjeta es exitoso de lo contrario es fallido







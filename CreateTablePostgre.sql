

--tabla tipo cliente

CREATE TABLE [IF NOT EXISTS] tipo_cliente (
   id_tipo_cliente int PRIMARY KEY,
   descripcion varchar(20)
   
);

--tabla cliente 

CREATE TABLE [IF NOT EXISTS] cliente (
   id_cliente int PRIMARY KEY,
   cedula int unique,
   nombre varchar (20),
   apellido varchar (20),
   nombre_Comercio varchar (50),
   correo varchar (50) unique ,
   id_tipo_cliente int REFERENCES tipo_cliente (id_tipo_cliente),
   usuario varchar(15) unique,
   clave varchar(15) not null
);

--validar formato de correo en el formulario 



--tabla AuditorloginAut
CREATE TABLE [IF NOT EXISTS] AuditorloginAut (
   id_Auditorlogin int PRIMARY KEY,
   usuario varchar(15) unique,
   clave varchar(15)
   
);


--tabla cuenta

CREATE TABLE [IF NOT EXISTS] cuenta (
   id_cuenta int PRIMARY KEY,
   id_cliente int REFERENCES cliente (id_cliente),
   numero_cuenta int  unique
);

--tabla tipo transaccion

CREATE TABLE [IF NOT EXISTS] tipo_transaccion (
   id_tipo_transaccion int PRIMARY KEY,
   descripcion varchar(20) 
);


--tabla estado de la transaccion

CREATE TABLE [IF NOT EXISTS] estado_transaccion (
   id_estado_transaccion int PRIMARY KEY,
   descripcion varchar(20) 
);




--tabla tarjeta

CREATE TABLE [IF NOT EXISTS] tarjeta (
   id_tarjeta int PRIMARY KEY,
   id_cliente int REFERENCES cliente (id_cliente),
   numero_tarjeta int unique,
   ccv int,
   fecha_vencimiento date
);


--tabla api key

CREATE TABLE [IF NOT EXISTS] api_key (
   id_api_key int PRIMARY KEY,
   valor_api_key varchar(40) unique,
   id_comercio int REFERENCES cuenta (id_cuenta), 
);


---tablas historial que se llenan con triggers 

--se llena cada vez que hay una llamada desde la api 
--tabla log transaccion

CREATE TABLE [IF NOT EXISTS] log_transaccion (
   id_log_transaccion int PRIMARY KEY,
   id_tipo_transaccion int REFERENCES tipo_transaccion (id_tipo_transaccion),
   id_tarjeta int REFERENCES tarjeta (id_tarjeta),
   id_cuenta int REFERENCES cuenta(id_cuenta),
   fecha_operacion timestamp,
   monto_operacion int,
);


--en estas tablas las fechas son las del log 

--tabla historial cuenta

CREATE TABLE [IF NOT EXISTS] historial_cuenta (
   id_historial_cuenta int PRIMARY KEY,
   id_cuenta int REFERENCES cuenta (id_cuenta),
   saldo_actual int ,
   fecha_operacion timestamp ,
   id_log_transaccion int REFERENCES log_transaccion (id_log_transaccion)
);

--tabla historial tarjeta

CREATE TABLE [IF NOT EXISTS] historial_tarjeta (
   id_historial_tarjeta int PRIMARY KEY,
   id_tarjeta int REFERENCES tarjeta (id_tarjeta),
   saldo_disponible int ,
   limite_saldo int,
   deuda_saldo int,
   fecha_operacion timestamp
   id_log_transaccion int REFERENCES log_transaccion (id_log_transaccion)
);


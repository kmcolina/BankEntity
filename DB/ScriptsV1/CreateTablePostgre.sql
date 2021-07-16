

--tabla tipo cliente

CREATE TABLE IF NOT EXISTS tipo_cliente (
   id_tipo_cliente serial PRIMARY KEY,
   descripcion varchar (20)
   );

--tabla cliente 

CREATE TABLE IF NOT EXISTS cliente (
   id_cliente serial PRIMARY KEY,
   cedula int unique,
   nombre varchar (20),
   apellido varchar (20),
   nombre_Comercio varchar (50),
   correo varchar (50) unique ,
   id_tipo_cliente integer REFERENCES tipo_cliente (id_tipo_cliente),
   usuario varchar (32) unique,
   usr varchar (32),
   clave varchar (32) not null,
   pass varchar (32)
);

--validar formato de correo en el formulario 

--tabla AuditorloginAut
CREATE TABLE IF NOT EXISTS AuditorloginAut (
   id_Auditorlogin serial PRIMARY KEY,
   usuario varchar (32) unique,
   usr varchar (32),
   clave varchar (32),
   pass varchar (32)
   
);


--tabla cuenta

CREATE TABLE IF NOT EXISTS cuenta (
   id_cuenta serial PRIMARY KEY,
   id_cliente integer REFERENCES cliente (id_cliente),
   numero_cuenta decimal unique,
   saldo_actual int
);

--tabla tipo transaccion

CREATE TABLE IF NOT EXISTS tipo_transaccion (
   id_tipo_transaccion serial PRIMARY KEY,
   descripcion varchar(100) 
);


--tabla estado de la transaccion

CREATE TABLE IF NOT EXISTS estado_transaccion (
   id_estado_transaccion serial PRIMARY KEY, descripcion varchar(20) 
);


--tabla tarjeta

CREATE TABLE IF NOT EXISTS tarjeta (
   id_tarjeta serial PRIMARY KEY,
   id_cliente integer REFERENCES cliente (id_cliente),
   numero_tarjeta decimal unique,
   ccv int,
   fecha_vencimiento date,
   saldo_disponible int ,
   limite_saldo int,
   deuda_saldo int
   

);


--tabla api key

CREATE TABLE IF NOT EXISTS api_key (
   id_api_key serial PRIMARY KEY,
   valor_api_key varchar(40) unique,
   id_comercio integer REFERENCES cuenta (id_cuenta)
);


---tablas historial que se llenan con triggers 

--se llena cada vez que hay una llamada desde la api 
--tabla log transaccion

CREATE TABLE IF NOT EXISTS log_transaccion (
   id_log_transaccion serial PRIMARY KEY,
   id_tipo_transaccion integer REFERENCES tipo_transaccion (id_tipo_transaccion),
   id_tarjeta integer REFERENCES tarjeta (id_tarjeta),
   id_cuenta_c integer REFERENCES cuenta(id_cuenta),
   id_cuenta_d integer REFERENCES cuenta(id_cuenta),
   id_estado_transaccion integer REFERENCES estado_transaccion,
   fecha_operacion timestamp,
   fecha date,
   hora time,
   monto_operacion int
);





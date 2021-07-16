--\i 'C:/Users/Mochileiros/Documents/comercio electronico/0_crearBD.sql'
\c postgres;
drop database CargarBanco;
create database CargarBanco;
\c cargarbanco;

--Creo y cargo la BD transaccional
\ir 1_script_generar_datos.sql


--crear tablas 
--archivo createtablepostgr.sql

--cargar funciones
--funciones_script.sql

--cargar procedimientos
--archivo procemientos_version10_Funciones_script.sql

--cargar triggers
--arcjhivo triggers_scripts.sql


--llenar tablas
--llenartabla.sql

--call insert_random_clientes( )


--cargar llenar log
--llenarlog.sql







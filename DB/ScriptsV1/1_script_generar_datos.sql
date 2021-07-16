--creo las tablas 
\ir CreateTablePostgre.sql
--genero las secuencias
\ir secuencias_script.sql

--genero las funciones
\ir Funciones_script.sql

--genero los procedimientos
--\ir procedimientos_script.sql
\ir procedimientos_Version10_Funciones_script.sql

--genero los triggers
\ir Triggers_script.sql


--genero procedimiento llenar log 
\ir  llenarLog.sql


--lleno las tablas
\ir llenarTablas.sql


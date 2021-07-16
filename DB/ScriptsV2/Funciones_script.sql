--funcion ci/rif

CREATE OR REPLACE FUNCTION gen_CIRif () RETURNS int AS $$
  select concat(floor(random()*(9999999-1111111+1))+1111111)::int;
$$ LANGUAGE sql;

--funcion usuarui

CREATE OR REPLACE FUNCTION gen_Urs() RETURNS text AS $$
    SELECT array_to_string(ARRAY(SELECT chr((97 + round(random() * 25)) :: integer)
    FROM generate_series(1,8)), '')::text;
$$ LANGUAGE sql;
--nsert
--SELECT md5(random()::text || clock_timestamp()::text)::uuid


--funcion contraseña or api_key
CREATE FUNCTION gen_pass(a int) RETURNS text AS $$
    SELECT SUBSTRING ((MD5(random()::text)),1,a)::text;
$$ LANGUAGE sql;


--funcion numero random

CREATE OR REPLACE FUNCTION gen_number(a int) RETURNS decimal AS $$

    SELECT array_to_string(ARRAY(SELECT chr((48 + round(random() * 9)) :: integer)
    FROM generate_series(1,a)), '')::decimal;

$$ LANGUAGE sql;


--guarda en un arreglo el retorno diario entre dos fechas
--esta la uso para vencimiento tarjeta

CREATE OR REPLACE FUNCTION series_fechas(inicio timestamp, fin timestamp) RETURNS date[] AS $$
    select array(
        select (generate_series(inicio, fin, '1 day'::interval))::date)
    as areas;
$$ LANGUAGE sql;


--por entrada busco el random entre dos numeros
CREATE OR REPLACE FUNCTION gen_rand_num (a int, b int ) RETURNS int AS $$
    SELECT cast( floor(random()*(b-a+1)+a)::int as int);
$$ LANGUAGE sql;




--este la uso para  horas log

CREATE OR REPLACE FUNCTION series_fechas_hora(inicio timestamp,cant int ) RETURNS timestamp[] AS $$
    select array(

        select (inicio + ((a-1)||' hour')::interval)::timestamp
        from generate_series(1, cant) a

    )
    as areas;
$$ LANGUAGE sql;


--genero un valor random entre maxim dado  y 1
CREATE OR REPLACE FUNCTION gen_random10 (maxim int) RETURNS int AS $$
    SELECT cast( floor(random()*(maxim-1+1))+1::int as int);
$$ LANGUAGE sql;


--para cuentas
 CREATE OR REPLACE FUNCTION series_cuentas(a int) RETURNS int[] AS $$
    select array(
     select id
                    from clientes
                    where "tipoCliente_id" =a
    )
    as areas;
$$ LANGUAGE sql;


--para cuentas
 CREATE OR REPLACE FUNCTION series_Todas_cuentas() RETURNS int[] AS $$
    select array(
     select id
                    from clientes

    )
    as areas;
$$ LANGUAGE sql;



--para clientes
 CREATE OR REPLACE FUNCTION series_clientes(a int) RETURNS int[] AS $$
    select array(
     select id
                    from clientes
                    where "tipoCliente_id" =a
    )
    as areas;
$$ LANGUAGE sql;



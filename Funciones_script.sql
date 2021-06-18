--funcion ci/rif

CREATE OR REPLACE FUNCTION gen_CIRif () RETURNS int AS $$
  select concat(floor(random()*(9999999-1111111+1))+1111111)::int;
$$ LANGUAGE sql;

--funcion usuarui

CREATE OR REPLACE FUNCTION gen_Urs() RETURNS text AS $$
    SELECT array_to_string(ARRAY(SELECT chr((97 + round(random() * 25)) :: integer) 
    FROM generate_series(1,8)), '')::text;;
$$ LANGUAGE sql;

--funcion contraseña or api_key
CREATE FUNCTION gen_pass(a int) RETURNS text AS $$
    SELECT SUBSTRING ((MD5(random()::text)),1,a)::text;
$$ LANGUAGE sql;


--funcion numero random

CREATE OR REPLACE FUNCTION gen_number(a int) RETURNS int AS $$

    SELECT array_to_string(ARRAY(SELECT chr((48 + round(random() * 9)) :: integer) 
    FROM generate_series(1,a)), '');

$$ LANGUAGE sql;


--guarda en un arreglo el retorno diario entre dos fechas 
--esta la uso para vencimiento tarjeta

CREATE OR REPLACE FUNCTION series_fechas() RETURNS date[] AS $$   
    select array(
        select (generate_series('2026-01-01', '2026-12-31', '1 day'::interval))::date)
    as areas;
$$ LANGUAGE sql;




 


set transaction read write; 
-- asociar una cuenta a un cliente cuando este se crea en la bd 


CREATE OR REPLACE FUNCTION gen_number(a int) RETURNS decimal AS $$

    SELECT array_to_string(ARRAY(SELECT chr((48 + round(random() * 9)) :: integer) 
    FROM generate_series(1,a)), '')::decimal;

$$ LANGUAGE sql;

CREATE TABLE  cliente (
   id_cliente int PRIMARY KEY,
   cedula int unique,
   nombre varchar (20),
   apellido varchar (20),
   nombre_Comercio varchar (50),
   correo varchar (50) unique ,
   usuario varchar(32) unique,
   clave varchar(32) not null
);

CREATE TABLE cuenta (
   id_cuenta int PRIMARY KEY,
   id_cliente int REFERENCES cliente (id_cliente),
   numero_cuenta decimal  unique
);


CREATE OR REPLACE FUNCTION cuenta_insert_trigger_fnc()

  RETURNS trigger AS

$$
DECLARE

num_cuenta  decimal;
done bool;

BEGIN

        WHILE NOT done LOOP
            num_cuenta := gen_number(20);
            done := NOT exists(SELECT 1 FROM cuenta WHERE numero_cuenta=num_cuenta );
        END LOOP;

             insert into cuenta 
            values (
           nextval('sec_id_cuenta'),NEW.id_cliente,num_cuenta
            );




RETURN NEW;

END;

$$

LANGUAGE 'plpgsql';



CREATE TRIGGER cuenta_insert_trigger

  AFTER INSERT

  ON "cliente"

  FOR EACH ROW

  EXECUTE PROCEDURE cuenta_insert_trigger_fnc();



CREATE OR REPLACE FUNCTION gen_CIRif () RETURNS int AS $$
  select concat(floor(random()*(9999999-1111111+1))+1111111)::int;
$$ LANGUAGE sql;


create sequence  sec_id_cuenta
  start with 1
  increment by 1
  maxvalue 99999
  minvalue 1;

DELETE FROM cuenta
WHERE id_cuenta=1;

DELETE FROM cliente
WHERE id_cliente=1;

insert into cliente values (1,gen_CIRif (),null,null,'Primer Comercio','primercomercio@correo.com', 'primcomer1','clavecomer1');

select * from cuenta;


-- asociar una cuenta a un cliente cuando este se crea en la bd 
--asocia un api key a un comercion



CREATE OR REPLACE FUNCTION cuenta_insert_trigger_fnc()

  RETURNS trigger AS

$$
DECLARE

num_cuenta  decimal;
done bool;
idc int;
BEGIN

        done := true;
 idc := nextval('sec_id_cuenta');
        WHILE done LOOP
            num_cuenta := gen_number(20);
           
            done := exists(SELECT 1 FROM cuenta WHERE numero_cuenta=num_cuenta );
        END LOOP;

            insert into cuenta 
            values (
           idc,NEW.id_cliente,num_cuenta
            );

        if (NEW.id_tipo_cliente=2) then     
            done := true;

            WHILE done LOOP
                akey := gen_pass(30);
            END LOOP;
            insert into api_key 
            values (
            nextval('sec_id_api_key'),akey,sec_idc
            );

        END IF;  

RETURN NEW;

END;

$$

LANGUAGE 'plpgsql';



------ no borrar 


--genera 32 col = 10*0.3

select (current_date::timestamp + ((a-1)||' days')::interval)::timestamp
from generate_series(1, 10, .03) a


--- 1 por hora  y en total 10 inicia en la fecha indicada 
select (current_date::timestamp + ((a-1)||' hour')::interval)::timestamp
from generate_series(1, 10) a

--puede ser por año
--extraer hora de un timestamp
SELECT EXTRACT(HOUR FROM TIMESTAMP '2001-02-16 20:38:40');



--a una hora le suma n horas 
SELECT timestamp  '2005-04-02 12:00:00-07' + interval '4 hours'; 


--extraer fecha de un timestamp 
SELECT  '2021-06-20 12:40:20'::TIMESTAMP::date;

--extraer time de un timestamp
SELECT  '2021-06-20 12:40:20'::TIMESTAMP::time;
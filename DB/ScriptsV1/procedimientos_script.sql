-----------------------------------------------------------
-----------------------------------------------------------
---clientes
--debe usarse el trigger que al insertar un cliente se llene la tabla cuenta pasandole el id cliente por parametro


CREATE or replace PROCEDURE insert_random_clientes( )
AS $$
DECLARE

ci_rif numeric;
nombres Text[];
apellidos Text[];
correos Text[];
selecName text;
selecApellido text;
selecMail text;
usr text;
pass text;


BEGIN

nombres  := '{
Mellissa,
Lesia,
Pauletta,
Solomon,
Neville,
Vera,
Lawerence,
Cedrick,
Melinda,
Alma

      }' ::text[]; 

apellidos  := '{
Mortimore,
Stoute,
Murton,
Chamberlin,
Yocom,
Edmiston,
Amburn,
Agnew,
Kuchta,
Gelinas,

      }' ::text[]; 

correos  := '{
Mellissa.Mortimore@correo.com,
Lesia.Stoute@correo.com,
Pauletta.Murton@correo.com,
Solomon.Chamberlin@correo.com,
Neville.Yocom@correo.com,
Vera.Edmiston@correo.com,
Lawerence.Amburn@correo.com,
Cedrick.Agnew@correo.com,
Melinda.Kuchta@correo.com,
Alma.Gelinas@correo.com
      }' ::text[]; 

   FOR counter IN 1..10 LOOP
            ci_rif := gen_CIRif ();
            selecName:= nombres[counter];
            selecApellido:= apellidos[counter];
            selecMail:= correos[counter];
            usr := gen_User();
            pass := gen_pass();

            insert into cliente 
            values (
    (nextval('sec_id_cliente'),ci_rif , selecName, selecApellido, selecMail, 1,usr,pass)
            );
   END LOOP;

end;
$$ LANGUAGE plpgsql;

----------------------------------------------------------------
----------------------------------------------------------------
------------AUDITOR

CREATE or replace PROCEDURE insert_random_auditor( )
AS $$
DECLARE

usr text;
pass text;

BEGIN

   FOR counter IN 1..10 LOOP
            usr := gen_User();
            pass := gen_pass();

            insert into cliente 
            values (
            (nextval('sec_id_auditor'),usr,pass(8))
            );
   END LOOP;

end;
$$ LANGUAGE plpgsql;


----------------------------------------------------------------
----------------------------------------------------------------
--usar esto si se llena por peticion, se llama por el back
--es necesario pasarle el id de la cuenta del comercio que solicita

CREATE or replace PROCEDURE insert_random_apiKey(id_cuenta int )
AS $$
DECLARE

akey  text;

BEGIN

            akey := gen_pass(30);
            insert into api_key 
            values (
            (nextval('sec_id_api_key'),akey,id_cuenta)
            );


end;
$$ LANGUAGE plpgsql;




----------------------------------------------------------------
----------------------------------------------------------------
--tabla cuenta
--cuando se crea un cliente se le debe asignar un numero de cuenta usando esta funcion y pasandole por parametros el id del cliente

CREATE or replace PROCEDURE insert_random_cuenta(id_cliente int )
AS $$
DECLARE

num_cuenta  int;
done bool;
BEGIN

        WHILE NOT done LOOP
            num_cuenta := gen_number(20);
            done := NOT exists(SELECT 1 FROM cuenta WHERE numero_cuenta=num_cuenta );
        END LOOP;

            insert into api_key 
            values (
            (nextval('sec_id_cuenta'),id_cliente,num_cuenta)
            );

end;
$$ LANGUAGE plpgsql;



----------------------------------------------------------------
----------------------------------------------------------------
--tabla tarjeta
--se puede llenar a solicitud usando solo el procedimiento o al crear una nueva cuenta un trigger que la llene 
--los cuatro primeros numeros de la tarjeta indican si son o no de mi banco
--se usara por defecto 6304

CREATE or replace PROCEDURE insert_random_tarjeta(id_cliente int )
AS $$
DECLARE

num_tarjeta  int;
ccv int;
fecha date;
done bool;
fechasArr date [];


BEGIN
fechasArr := series_fechas();


        WHILE NOT done LOOP
            num_tarjeta := select concat(6304,gen_number(14)::int);
            done := NOT exists(SELECT 1 FROM tarjeta WHERE numero_tarjeta=num_tarjeta );
        END LOOP;

            fecha:=  fechasArr [floor(random()*((array_length(fechasArr, 1))-1+1))+1::int];
            ccv :=gen_number(3);

            insert into api_key 
            values (
            (nextval('sec_id_tarjeta'),id_cliente,num_tarjeta,ccv,fecha)
            );

end;
$$ LANGUAGE plpgsql;



----------------------------------------------------------------
----------------------------------------------------------------

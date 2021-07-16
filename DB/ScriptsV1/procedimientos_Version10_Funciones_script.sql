-----------------------------------------------------------
-----------------------------------------------------------
---clientes
--debe usarse el trigger que al insertar un cliente se llene la tabla cuenta pasandole el id cliente por parametro


CREATE or replace function insert_random_clientes()
RETURNS void AS $$
DECLARE

ci_rif numeric;
nombres Text[];
apellidos Text[];
correos Text[];
selecName text;
selecApellido text;
selecMail text;
usr text;
usrU text;
pass text;
passU text;

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
Gelinas

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

--almaceno las contraseñas y usuarios cifradas en md5 

   FOR counter IN 1..10 LOOP
            ci_rif := gen_CIRif ();
            selecName:= nombres[counter];
            selecApellido:= apellidos[counter];
            selecMail:= correos[counter];
            usrU :=  gen_Urs()::text;
            usr :=  md5(usrU::text);
            passU :=gen_pass(8)::text;
            pass :=  md5(passU::text);

            insert into cliente 
            values (DEFAULT,ci_rif , selecName, selecApellido,null, selecMail, 1,usr,usrU,pass,passU
            );
   END LOOP;

end;
$$ LANGUAGE plpgsql;

----------------------------------------------------------------
----------------------------------------------------------------
------------AUDITOR

CREATE or replace function insert_random_auditor()
RETURNS void AS $$
DECLARE

usr text;
pass text;
usrU text;
passU text;

BEGIN

   FOR counter IN 1..10 LOOP
            usrU := gen_Urs()::text;
            usr := md5(usrU::text);
            passU := gen_pass(8)::text;
            pass := md5(passU::text);

            insert into AuditorloginAut
            values (
            DEFAULT,usr,usrU,pass,passU
            );
   END LOOP;

end;
$$ LANGUAGE plpgsql;


----------------------------------------------------------------
----------------------------------------------------------------
--usar esto si se llena por peticion, se llama por el back
--es necesario pasarle el id de la cuenta del comercio que solicita

CREATE or replace function insert_random_apiKey(id_cuenta integer )
RETURNS void AS $$
DECLARE

akey  text;
done bool;
BEGIN
        done := true;

        WHILE done LOOP
            akey := gen_pass(30);
             done := exists(SELECT 1 FROM api_key WHERE valor_api_key=akey);
         END LOOP;
            insert into api_key 
            values (
            DEFAULT,akey,id_cuenta
            );


end;
$$ LANGUAGE plpgsql;




----------------------------------------------------------------
----------------------------------------------------------------
--tabla cuenta
--cuando se crea un cliente se le debe asignar un numero de cuenta usando esta funcion y pasandole por parametros el id del cliente

CREATE or replace function insert_random_cuenta(id_cliente integer )
RETURNS void AS $$
DECLARE

num_cuenta  decimal;
done bool;
saldo int;
BEGIN

        done := true;
saldo := gen_rand_num(200,500);
        WHILE done LOOP
            num_cuenta := gen_number(20);
            done := exists(SELECT 1 FROM cuenta WHERE numero_cuenta=num_cuenta );
        END LOOP;

            insert into cuenta 
            values (
           DEFAULT,NEW.id_cliente,num_cuenta,saldo
            );


end;
$$ LANGUAGE plpgsql;



----------------------------------------------------------------
----------------------------------------------------------------
--tabla tarjeta
--se puede llenar a solicitud usando solo el procedimiento o al crear una nueva cuenta un trigger que la llene 
--los cuatro primeros numeros de la tarjeta indican si son o no de mi banco
--se usara por defecto 6304

CREATE or replace function insert_random_tarjeta(id_cliente int )
RETURNS void AS $$
DECLARE

num_tarjeta  decimal;
ccv int;
fecha date;
done bool;
fechasArr date [];
saldo int;
limite int;
deuda int;


BEGIN
fechasArr := series_fechas('2026-01-01','2026-12-31');

 done := true;
        WHILE done LOOP
            num_tarjeta := concat(6304,gen_number(12)::decimal);
            done := exists(SELECT 1 FROM tarjeta WHERE numero_tarjeta=num_tarjeta );
        END LOOP;

            fecha:=  fechasArr [floor(random()*((array_length(fechasArr, 1))-1+1))+1::int];
            ccv :=gen_number(3);
            limite :=gen_rand_num(100,300);
                        
            insert into tarjeta
            values (
            DEFAULT,id_cliente,num_tarjeta,ccv,fecha,limite,limite,0
            );

end;
$$ LANGUAGE plpgsql;

   
----------------------------------------------------------------
----------------------------------------------------------------
--de prueba no borrar 

--tabla tarjeta
--
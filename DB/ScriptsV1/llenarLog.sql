--llenar log por default

CREATE or replace function insert_random_log()
RETURNS void 
AS $$
DECLARE

  
   id_tipo_transaccion integer ;
   ---id_tarjeta integer ;
   id_cuenta_c integer;
   id_cuenta_d integer;
   id_estado_transaccion integer;
  
   monto_operacion int;


fechasHoraArr  timestamp [];

fecha_operacion timestamp;
trans_por_hora int;

registrosTarjeta int;


TodasCuenta int []; -- array
TodasCuentaI int ; 
registrosCuenta int;

id_tarjetaa int;

fecha date;
hora  time;

saldo_disponiblee int;


saldo_actual_d int ;

TodasCliente int ;

id_cliente_Ran  int ;

saldo_actuall int;

deuda int;


done bool;


saldo_t int;
deuda_t int;
limite_t int;

BEGIN
-- 1 mayo a 30 junio
-- cada hora 
fechasHoraArr := series_fechas_hora('2021-05-01',1440);

--ciclo seleccion dia 

FOR counter IN 1.. 1440 LOOP
--selecciono cada feha hora del registro
fecha_operacion := fechasHoraArr[counter];

--para cada fechahora hago esto entre 10 a 20 veces
trans_por_hora := gen_rand_num(10,20);

--cliclo trans por hora
for counter in 1.. trans_por_hora loop 

--id_log_transaccion:= (nextval('sec_id_log');
id_tipo_transaccion :=  gen_rand_num(1,3) ::int;

--condicional
--depende del id tipo transaccion sera lo que lleno

-- id 1 compra con tarjeta / credito a cuenta comercio

if (id_tipo_transaccion=1) then 


--obtengo el total de tarjetas
registrosTarjeta := (
 select id_tarjeta from tarjeta order by id_tarjeta desc limit 1
);

--obtengo el total de cuentas de tipo cliente juridico
TodasCuenta := series_cuentas(2);
registrosCuenta := TodasCuenta[floor(random()*((array_length(TodasCuenta, 1))-1+1))+1::int];


--tomo una cuenta de las existentes al azar 
id_cuenta_c := registrosCuenta;
--tomo una tarjeta de las existentes al azar 
id_tarjetaa := gen_random10(registrosTarjeta);

--monto al azar para monto de la operacion dentro de los limites de tarjetas
monto_operacion := gen_rand_num(1,20);

fecha := (SELECT fecha_operacion ::date);

hora :=(SELECT fecha_operacion::time);

saldo_disponiblee := (
 
 select saldo_disponible
 from tarjeta
 where id_tarjeta=id_tarjetaa

);

--para determinar estado transaccion exitosa/fallida
-- comparo monto op con saldo disponible tarjeta

--transaccion exitosa
if (saldo_disponiblee >= monto_operacion) then
id_estado_transaccion:=1; 

else 
--transaccion fallida
id_estado_transaccion:=2; 
end if ;
-- en if transaccion exitosa / fallida

--inserto lo alores en la tabla 
insert into log_transaccion values(

   DEFAULT,
   id_tipo_transaccion,
   id_tarjetaa ,
   id_cuenta_c ,
   null,
   id_estado_transaccion,
   fecha_operacion,
   fecha,
   hora,
   monto_operacion
);

end if;
--en if  id tipo transaccion = 1 

--if  transaccion transferencia entre cuentas
if (id_tipo_transaccion=2) then 

--todos cuenta

TodasCuentaI  := (select id_cuenta 
from cuenta 
order by id_cuenta 
desc limit 1);

id_cuenta_d := gen_random10(TodasCuentaI);
done := true;
      WHILE done LOOP   
         id_cuenta_c := gen_random10(TodasCuentaI);
         --done := exists(SELECT 1 FROM cuenta WHERE id_cuenta=id_cuenta_d );
      if(id_cuenta_c!=id_cuenta_d ) then 
      done :=false;
      end if;
      END LOOP;

saldo_actual_d := (select saldo_actual
from cuenta
where  id_cuenta= id_cuenta_d );


monto_operacion :=gen_rand_num(1,20);


fecha := (SELECT fecha_operacion ::date);

hora :=(SELECT fecha_operacion::time);

--transaccion exitosa
if (monto_operacion <= saldo_actual_d ) then
id_estado_transaccion:=1; 
else 
--transaccion fallida
id_estado_transaccion:=2; 

end if ;
-- en if transaccion exitosa / fallida

--inserto lo alores en la tabla 
insert into log_transaccion values(

   DEFAULT,
   id_tipo_transaccion,
   null,
   id_cuenta_c,
   id_cuenta_d,
   id_estado_transaccion,
   fecha_operacion,
   fecha,
   hora,
   monto_operacion
);




end if ;
--end if tipo transaccion 2

--if pago deuda tarjeta
if (id_tipo_transaccion=3) then 

--todos clientes 

TodasCliente := (select id_cliente from cliente order by id_cliente desc limit 1);

id_cliente_Ran := gen_random10(TodasCliente);

id_tarjetaa := (select id_tarjeta
from tarjeta
where id_cliente=id_cliente_Ran );

deuda_t := (select deuda_saldo
from tarjeta
where id_tarjeta=id_tarjetaa  );

limite_t := (select limite_saldo
from tarjeta
where id_tarjeta=id_tarjetaa  );

id_cuenta_d := (select id_cuenta
from cuenta
where id_cliente= id_cliente_Ran);

saldo_actuall :=(select saldo_actual
from cuenta
where  id_cliente= id_cliente_Ran );

--monto_operacion :=gen_rand_num(1,20);
if (deuda_t>limite_t) then

monto_operacion :=gen_rand_num(1,limite_t);
else 
monto_operacion :=gen_rand_num(1,deuda_t);
end if;
--end if deuda limite tarjeta

fecha := (SELECT fecha_operacion ::date);

hora :=(SELECT fecha_operacion::time);

--transaccion exitosa
if (monto_operacion <= saldo_actuall  ) then
id_estado_transaccion:=1; 

else 
--transaccion fallida
id_estado_transaccion:=2; 

end if ;
-- en if transaccion exitosa / fallida

--inserto lo alores en la tabla 
insert into log_transaccion values(
   DEFAULT,
   id_tipo_transaccion,
   id_tarjetaa ,
   null,
   id_cuenta_d,
   id_estado_transaccion,
   fecha_operacion,
   fecha,
   hora,
   monto_operacion
);




end if ;
--end if tipo transaccion 3

--deposito en cuenta
--if (id_tipo_transaccion=4) then



--end if;
--end if tipo transaccion 4
END LOOP;
--end loop transaccion por hora
END LOOP;
--en loop fechas

--seleccionar un id random de cuenta comercio
--seleccionar un id random de tarjeta 


--seleccionar un id random de estado transaccion
 --- los select los hago ordenenando por id de mayor a menor y tomando solo el primero
 --select id from tabla order by desc limit 1

-- seleccionar un random monto de operacion gen_rand_num(1,40)
-- para cada iteracion hacer select del saldo actual de la tarjeta, para generar exitosas colocandolo menor a ese valor y para fallidas colocandolo mayor

--hacer un arr de fechas para diass meses y años

--si lo guardo en un array lo puedo recorrer como el de fecha_arra


end;
$$ LANGUAGE plpgsql;

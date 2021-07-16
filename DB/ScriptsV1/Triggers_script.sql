-- asociar una cuenta a un cliente cuando este se crea en la bd 
--asocia un api key a un comercion



CREATE OR REPLACE FUNCTION cuenta_insert_trigger_fnc()

  RETURNS trigger AS

$$
DECLARE

num_cuenta  decimal;
num_tarjeta  int;
done bool;
idc int;
id_api int;
idt int;
saldo int;
id_cli integer;
t int;
a int;
cuenta int;

BEGIN

 done := true;
 
        WHILE done LOOP
            num_cuenta := gen_number(20);
            done := exists(SELECT 1 FROM cuenta WHERE numero_cuenta=num_cuenta );
        END LOOP;

saldo := gen_rand_num(200,500);
id_cli:=NEW.id_cliente;

    -- asigno cuenta
              insert into cuenta 
              values (
            DEFAULT,id_cli,num_cuenta,saldo
              );


-- asigno tarjeta  llamo al procedimiento
  -- t:= 
perform insert_random_tarjeta(id_cli);

      --si es comercio le asigno un api key
      --llamo al procedimiento
cuenta := (select id_cuenta from cuenta  where numero_cuenta=num_cuenta);

        if (NEW.id_tipo_cliente=2) then     
      perform  insert_random_apiKey(cuenta);

        END IF;  

RETURN NEW;

END;

$$

LANGUAGE 'plpgsql';


----------------------------------------------------------
----------------------------------------------------------
-- historiales

--actualizo los montos de la tarjeta cuando se inserte algo en el log de transaccion

CREATE OR REPLACE FUNCTION montos_tarjeta_update_trigger_fnc()

  RETURNS trigger AS

  $$
  DECLARE
  saldo_actual_t int;
  deuda_actual_t int;
  limite_t int;
  saldoo int;
  deudaa int;

  nuevaFecha timestamp [];
  nuevaFechaT timestamp;
  nuevo_saldo int;
  monto_saldo int;
  monto_operacion int;
  saldo_actuall int;
  id_clientee  int ;
  id_cuenta_d int;
  id_estado_transaccion int;

  BEGIN

  if(NEW.id_estado_transaccion=1) THEN
          --uso de tarjeta para compra en comercio
      if (NEW.id_tipo_transaccion=1) then 

        saldo_actual_t :=(select saldo_disponible
        from tarjeta
        where  id_tarjeta=NEW.id_tarjeta );

        deuda_actual_t :=(select deuda_saldo
        from tarjeta
        where  id_tarjeta=NEW.id_tarjeta );

        limite_t:= (select limite_saldo
        from tarjeta
        where  id_tarjeta=NEW.id_tarjeta );


        --saldo en tarjeta queda 0
        if (saldo_actual_t-NEW.monto_operacion<=0) then

            --hacer un insert de pago de tarjeta

            --selecciono la siguiente fecha a la actual
            nuevaFecha :=series_fechas_hora(new.fecha_operacion,2) ;

            nuevaFechaT :=nuevaFecha [2];


                --tomo los datos del cliente
                --todos clientes 

                id_clientee := (select id_cliente
                from tarjeta
                where id_tarjeta=new.id_tarjeta );

                id_cuenta_d := (select id_cuenta
                from cuenta
                where id_cliente= id_clientee);

                saldo_actuall :=(select saldo_actual
                from cuenta
                where  id_cliente= id_clientee );



            --saldo cuenta es 0
            if (saldo_actuall <=0) then
                --hago un deposito en cuenta

                nuevo_saldo:= gen_rand_num(200,500);
                --inserto un deposito en la cuenta 
                nuevaFecha :=series_fechas_hora(new.fecha_operacion,2) ;

                nuevaFechaT :=nuevaFecha [2];
              

                insert into log_transaccion values(
                DEFAULT,
                4,
                null,
                new.id_cuenta_d,
                null,
                1,
                nuevaFechaT,
                nuevaFechaT::date,
                nuevaFechaT::time,
                nuevo_saldo
                );


            else 

                --saldo que quiero pagar tarjeta que esta dentro del monto de la cuenta
                --nuevo_saldo:= gen_rand_num(1,saldo_actuall);
              --busco que el valor sea menor al limite
              --busco que valor sea <= deuda
              
              if (deuda_actual_t>limite_t) then
                    if(saldo_actuall>limite_t) then
                      monto_operacion :=gen_rand_num(1,limite_t);
                    else
                     monto_operacion :=gen_rand_num(1,saldo_actuall);
                    end if;
              else 

                    if(saldo_actuall>deuda_actual_t) then
                      monto_operacion :=gen_rand_num(1,deuda_actual_t);
                    else
                     monto_operacion :=gen_rand_num(1,saldo_actuall);
                    end if;
              end if;
              --end if deuda limite tarjeta

              
                nuevaFecha :=series_fechas_hora(new.fecha_operacion,2) ;
                nuevaFechaT :=nuevaFecha [2];

                insert into log_transaccion values(
                DEFAULT,
                3,
                new.id_tarjeta,
                null,
                id_cuenta_d,
                1,
                nuevaFechaT,
                nuevaFechaT::date,
                nuevaFechaT::time,
                monto_operacion
                );

            end if;
            --end if saldo cuenta 0


        else
          --tengo saldo en la tarjeta
                --actualizo montos tarjeta

                saldoo:=saldo_actual_t-NEW.monto_operacion;
                deudaa:=deuda_actual_t+NEW.monto_operacion;

                update tarjeta 
                set 
                    saldo_disponible=saldoo,
                    deuda_saldo =deudaa
                WHERE id_tarjeta=NEW.id_tarjeta
                ;
        end if;
        --end if saldo tarjeta 0 

    end if;
    -- end if trans tipo 1

  --pago deuda tarjeta de credito
  if (NEW.id_tipo_transaccion=3) then


    saldo_actual_t :=(select saldo_disponible
    from tarjeta
    where  id_tarjeta=NEW.id_tarjeta );

    deuda_actual_t :=(select deuda_saldo
    from tarjeta
    where  id_tarjeta=NEW.id_tarjeta );

    --validar que ese monto este dentro del limite y el saldo en el log

    saldoo:=saldo_actual_t+NEW.monto_operacion;
    deudaa:=deuda_actual_t-NEW.monto_operacion;

                update tarjeta 
                set 
                    saldo_disponible=saldoo,
                    deuda_saldo =deudaa
                WHERE id_tarjeta=NEW.id_tarjeta
                ;
  END IF;
  --en if transaccion tipo 3
  END IF; 
  --end if transaccion exitosa 

  RETURN NEW;

  END;

  $$
LANGUAGE 'plpgsql';


-------------------------------------------------------------
-------------------------------------------------------------

CREATE OR REPLACE FUNCTION montos_cuenta_update_trigger_fnc()

  RETURNS trigger AS

    $$
    DECLARE
    saldo_actuall_c int;
    saldo_actuall_d int;

    nuevo_saldo int;

    nuevaFecha timestamp [];

    nuevaFechaT timestamp;
    id_tipo_transaccion int;

    BEGIN


  if(NEW.id_estado_transaccion=1) THEN
  --credito por venta/credito
    if (NEW.id_tipo_transaccion=1) then

      saldo_actuall_c:=(select saldo_actual
      from cuenta
      where id_cuenta=NEW.id_cuenta_c);

                nuevo_saldo:=saldo_actuall_c+NEW.monto_operacion;
                update cuenta 
                set 
                saldo_actual=nuevo_saldo
                    
                WHERE id_cuenta=NEW.id_cuenta_c
                ;
    end if;
    --end if tipo 1

    --pago deuda tarjeta de credito
    if (NEW.id_tipo_transaccion=3) then


    saldo_actuall_d:=(select saldo_actual
    from cuenta
    where id_cuenta=NEW.id_cuenta_d);

    if (saldo_actuall_d-NEW.monto_operacion<=0 )then
        --nuevo_saldo:= gen_rand_num(40,100);
        --hacer deposito en la cuenta, insert en el log
        --tomo la siguiente fecha y hora
        nuevaFecha :=series_fechas_hora(new.fecha_operacion,2) ;

        nuevaFechaT :=nuevaFecha [2];
        nuevo_saldo:= gen_rand_num(100,500);

        insert into log_transaccion values(
          DEFAULT,
          4,
          null,
          new.id_cuenta_d,
          null,
          1,
          nuevaFechaT,
          nuevaFechaT::date,
          nuevaFechaT::time,
          nuevo_saldo
        );
      else 
                nuevo_saldo:=saldo_actuall_d-NEW.monto_operacion;

                update cuenta 
                set 
                saldo_actual=nuevo_saldo
                    
                WHERE id_cuenta=NEW.id_cuenta_d
                ;

      end if;
      --end if cuenta sin fondo 


    END IF;
    --end if tipo 3

    --transferencia entre cuentas

    if (NEW.id_tipo_transaccion=2) then
        saldo_actuall_d:=(select saldo_actual
        from cuenta
        where id_cuenta=NEW.id_cuenta_d);


        saldo_actuall_c:=(select saldo_actual
        from cuenta
        where id_cuenta=NEW.id_cuenta_c);

        if (saldo_actuall_d-NEW.monto_operacion<=0 )then
          --nuevo_saldo:= gen_rand_num(40,100);
          --hacer deposito en la cuenta de debitp
          nuevaFecha :=series_fechas_hora(new.fecha_operacion,2) ;

          nuevaFechaT :=nuevaFecha [2];
          nuevo_saldo:= gen_rand_num(100,500);

          insert into log_transaccion values(
            DEFAULT,
            4,
            null,
            new.id_cuenta_d,
            null,
            1,
            nuevaFechaT,
            nuevaFechaT::date,
            nuevaFechaT::time,
            nuevo_saldo
          );


                  --agrego saldo a esta cuenta
                update cuenta 
                set 
                      saldo_actual=saldo_actuall_c+NEW.monto_operacion
                    
                WHERE id_cuenta=NEW.id_cuenta_c
                ;

        else
          nuevo_saldo:=saldo_actuall_d-NEW.monto_operacion;
                --debito de esta cuenta
                update cuenta 
                set 
                      saldo_actual=nuevo_saldo
                    
                WHERE id_cuenta=NEW.id_cuenta_d
                ;

                --agrego saldo a esta cuenta
                update cuenta 
                set 
                      saldo_actual=saldo_actuall_c+NEW.monto_operacion
                    
                WHERE id_cuenta=NEW.id_cuenta_c
                ;

        end if;
        --end if saldo final es cero


    END IF;
    -- end if  tipo transaccion 2

    --deposito en cuenta
    if (new.id_tipo_transaccion=4) then
                --agrego saldo a esta cuenta
                update cuenta 
                set 
                      saldo_actual=NEW.monto_operacion
                    
                WHERE id_cuenta=NEW.id_cuenta_c
                ;
    end if ;
    --fin if deposito


      END IF; 
      --en if estado transaccion 1 / exito-

    RETURN NEW;

    END;

    $$

LANGUAGE 'plpgsql';
------------------------------------------------------
----------------------------------------------------
CREATE OR REPLACE FUNCTION cliente_update_trigger_fnc()

  RETURNS trigger AS

$$
DECLARE

BEGIN

update  cliente 
set 
usuario =md5(NEW.usuario),
clave=md5(NEW.clave)
where id_cliente=NEW.id_cliente;


RETURN NEW;

END;

$$

LANGUAGE 'plpgsql';



------------------------------------------------
-----------------------------------------------
------------------------------------------------
-----------------------------------------------
------------------------------------------------
-----------------------------------------------


--actualizo monto cuenta si una transaccion es exitosa

CREATE TRIGGER cuentaCliente_insert_monto_cuenta

  AFTER INSERT

  ON "log_transaccion"

  FOR EACH ROW

  EXECUTE PROCEDURE montos_cuenta_update_trigger_fnc();


------------------------------------------------
-----------------------------------------------



CREATE TRIGGER cuentaCliente_insert_trigger

  AFTER INSERT

  ON "cliente"

  FOR EACH ROW

  EXECUTE PROCEDURE cuenta_insert_trigger_fnc();

------------------------------------------------
-----------------------------------------------


--actualizo monto tarjetas si una transaccion es exitosa

CREATE TRIGGER cuentaCliente_insert_monto_Tarjeta

  AFTER INSERT

  ON "log_transaccion"

  FOR EACH ROW

  EXECUTE PROCEDURE montos_tarjeta_update_trigger_fnc();

--------------------------------------------------------------
-------------------------------------------------------------
--aferte insertar en cliente poner clave usuario en md5


CREATE TRIGGER Cliente_update_trigger

  AFTER INSERT

  ON "cliente"

  FOR EACH ROW

  EXECUTE PROCEDURE cliente_update_trigger_fnc();


-------------------------------------------------------------
------------------------------------------------------------------
--- si las cuentas y tarjetas llegan a 0 reiniciar


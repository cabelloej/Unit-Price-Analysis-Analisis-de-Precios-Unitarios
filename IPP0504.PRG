***********************************
* INFORME de total de obra
***********************************

SET EXACT OFF
select 1
use ipppresu index ipppresu alias presup
select 2
use ippparti index ipppart1,ipppart2 alias partida
store .t. to analiza
do while analiza
   @ 5,1 clear to 15,78
   @ 5,1 to 15,78 double
   @ 5,10 say "CONSULTA DE TOTAL DEL PRESUPUESTO"
   @ 7,5 SAY "PRESUPUESTO:"
   @ 9,5 SAY "TOTAL Bs.  :"
   STORE WPARPRE   TO WPRECOD
   @ 7,18 GET WPRECOD
   READ
   IF WPRECOD = SPACE(10)   .OR. READKEY() = 12 .OR. READKEY() = 268
      SET EXACT ON
      CLOSE DATA
      CLOSE INDEX
      RETURN
   ENDIF
   SELECT 1
   STORE UPPER(WPRECOD) TO WPRECOD
   FIND &WPRECOD
   IF EOF()
      STORE "ERROR, Codigo de presupuesto no registrado" to mes
      do aviso with mes
      loop
   endif
   @ 7,18 say preobra
   STORE PRECLIENTE TO WCLIENTE
   store preobra to wpreobra
   STORE PREOBRA2 TO WPREOBRA2
   store preobra3 to wpreobra3
   store preobra4 to wpreobra4
   STORE PREDIR TO WDIR
   store "Opciones: (C)ontinuar, (S)alir " to mes
   store "C" to p1
   store "S" to p2
   store " " to resp
   do pide2 with p1,p2,mes,resp
   if resp = "S"
      select 1
      loop
   endif
   STORE 0 TO SALTAR
   DO CHKPRINT WITH SALTAR
   IF SALTAR = 1
      SELECT 1
      LOOP
   ENDIF

   STORE "COMANDO EN PROGRESO..." TO MES
   DO MENSAJE WITH MES

   SELECT 2
   FIND &WPRECOD
   IF EOF()
      STORE "Este presupuesto no tiene partidas registradas" to mes
      do aviso with mes
      loop
   endif
   STORE 0 TO WTOTPRE
   do while .not. eof() .and. parpre = wprecod
      IF PARASUME > 0
         STORE WTOTPRE + (PARASUME*PARCANT) TO WTOTPRE
      ELSE
         STORE WTOTPRE + (PARPREUNI*PARCANT) TO WTOTPRE
      ENDIF
      SKIP
   ENDDO
   @ 9,18 SAY WTOTPRE PICTURE "###,###,###.##"
   STORE "OPRIMA <ENTER> PARA CONTINUAR" TO MES
   DO AVISO WITH MES
enddo


SET EXACT OFF
select 1
use ipppresu index ipppresu alias presup
select 2
use ippparti index ipppart1,ipppart2 alias partida
store .t. to analiza
do while analiza
   @ 4,0 clear to 21,79
   @ 4,20 say "ASUMIR PRECIOS UNITARIOS"
   @ 6,5  SAY "PRESUPUESTO:"
   @ 7,5  SAY "PARTIDA    :"
    STORE WPARPRE   TO WPRECOD
*   STORE SPACE(13)  TO WPARCOD
   @ 6,18 GET WPRECOD
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
   @ 6,18 say preobra
   @ 7,18 get wparcod
   read
   if wparcod = SPACE(13)   .OR. READKEY() = 12 .OR. READKEY() = 268
      select 1
      loop
   endif
   STORE UPPER(WPARCOD) TO WPARCOD
   select 2
   store wprecod+Wparcod to clave
   find &clave
   if eof()
      store "ERROR, Codigo de partida no registrado para este Presupuesto" to mes
      do aviso with mes
      select 1
      loop
   endif
   @ 07,18  say pardes1
   @ 08,18  say pardes2
   @ 09,18  say pardes3
   @ 10,18  say pardes4
   @ 11,18  say pardes5
   @ 12,18  say pardes6

   if paranalis <> "SI"
      store "ERROR, Esta partida esta definida sin analisis (Ù)" to mes
      do aviso with mes
      loop
   endif

   store parasume to wasume
   @ 14,5  SAY "PRECIO     :" get wasume picture "##########.##"
   read
   IF WASUME <> PARASUME
      store "Opciones: (A)ceptar, (R)echazar" to mes
      store "A" to p1
      store "R" to p2
      store " " to resp
      do pide2 with p1,p2,mes,resp
      if resp = "R"
         select 1
         loop
      endif
      replace parasume with wasume
   ENDIF
enddo

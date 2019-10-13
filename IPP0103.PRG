
SET EXACT OFF
select 1
use ipppresu index ipppresu alias presup
select 2
use ippparti index ipppart1,ipppart2 alias partida
store .t. to analiza
do while analiza
   @ 4,0 clear to 21,79
   @ 4,20 say "CONSULTA DE PRECIOS UNITARIOS"
   @ 6,5  SAY "PRESUPUESTO:"
   @ 7,5  SAY "PARTIDA    :"
    STORE WPARPRE    TO WPRECOD
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

   store "Opciones: (C)ontinuar, (S)alir " to mes
   store "C" to p1
   store "S" to p2
   store " " to resp
   do pide2 with p1,p2,mes,resp
   if resp = "S"
      select 1
      loop
   endif

   @ 5,0 clear to 20,79
   @ 05,0 SAY "+-----------------+-------------+-----------------------------+--------------+"
   @ 06,0 SAY "|                 |TOTAL Bs.    |                             |COSTO x UNIDAD|"
   @ 07,0 SAY "|1- MATERIALES    |             |                             |              |"
   @ 08,0 SAY "|2- EQUIPOS       |             |                             |              |"
   @ 09,0 SAY "+-----------------+-------------+----------------+------------+              |"
   @ 10,0 SAY "|                 |             |VALOR x UNIDAD  |       % LDT|              |"
   @ 11,0 SAY "+-----------------+-------------+----------------+------------+              |"
   @ 12,0 SAY "|3- MANO DE OBRA  |             |                |            |              |"
   @ 13,0 SAY "+-----------------+-------------+----------------+------------+--------------+"
   @ 14,0 SAY "|                                COSTO DIRECTO SUB-TOTAL (A): |              |"
   @ 15,0 SAY "|4- ADMINISTRACION Y GAST.GEN.         % SOBRE SUB-TOTAL (A): |              |"
   @ 16,0 SAY "|                                              SUB-TOTAL (B): |              |"
   @ 17,0 SAY "|5- IMPREVISTOS Y UTILIDAD             % SOBRE SUB-TOTAL (B): |              |"
   @ 18,0 SAY "|                                           PRECIO UNITARIO : |              |"
   @ 19,0 SAY "+-------------------------------------------------------------+--------------+"
   @ 10,50 SAY PARTIDA->PARPORLDT PICTURE "####.##"
   @ 15,32 SAY PARTIDA->PARPORADM PICTURE "####.##"
   @ 17,32 SAY PARTIDA->PARPORIMP PICTURE "####.##"
   STORE 0 TO WTOTMATBS
   *************   MATERIALES ***********
   SELECT 3
   USE IPPMATER INDEX IPPMATER ALIAS MATERIAL
   SELECT 4
   USE IPPTIMAT INDEX IPPTIMAT ALIAS TIPOS
   SELECT 3
   FIND &CLAVE
   DO WHILE .NOT. EOF() .AND. MATERPRE = WPRECOD .AND. MATERPAR = WPARCOD
      STORE MATERCOD TO WMATERCOD
      SELECT 4
      FIND &WMATERCOD
      IF EOF()
        STORE WMATERCOD+" NO REGISTRADO" TO MES
        DO AVISO WITH MES
      ENDIF
      SELECT 3
      STORE MATERCAN*MATERPREUN TO WMATBS
      STORE WTOTMATBS+WMATBS TO WTOTMATBS
      SKIP
   ENDDO
   STORE (WTOTMATBS*PARTIDA->PARPORDES)/100 TO WPORDESBS
   STORE WTOTMATBS+WPORDESBS TO WTOTMATBS
   IF PARTIDA->MATERDIV = "N"
      STORE WTOTMATBS TO WPUMAT
   ELSE
      IF PARTIDA->MATERDIV = "R"
         STORE WTOTMATBS/PARTIDA->PARREND  TO WPUMAT
      ELSE
         IF PARTIDA->MATERDIV = "U"
            STORE WTOTMATBS/PARTIDA->PARCANT TO WPUMAT
         ENDIF
      ENDIF
   ENDIF
   @ 7,21 SAY WTOTMATBS PICTURE "########.##"
   @ 7,66 SAY WPUMAT    PICTURE "########.##"
   ****************** EQUIPOS ******************
   STORE 0 TO WTOTEQPBS
   SELECT 3
   USE IPPEQUIP INDEX IPPEQUIP ALIAS EQUIPOS
   SELECT 4
   USE IPPTIEQP INDEX IPPTIEQP ALIAS TIPOS
   SELECT 3
   FIND &CLAVE
   DO WHILE .NOT. EOF() .AND. EQUIPPRE = WPRECOD .AND. EQUIPPAR = WPARCOD
      STORE EQUIPCOD TO WEQUIPCOD
      SELECT 4
      FIND &WEQUIPCOD
      IF EOF()
        STORE WEQUIPCOD+" NO REGISTRADO" TO MES
        DO AVISO WITH MES
      ENDIF
      SELECT 3
      STORE EQUIPCAN*EQUIPPREUN*EQUIPDEPRE TO WEQPBS
      STORE WTOTEQPBS+WEQPBS TO WTOTEQPBS
      SKIP
   ENDDO
   STORE WTOTEQPBS/PARTIDA->PARREND TO WPUEQP
   @ 8,21 SAY WTOTEQPBS PICTURE "########.##"
   @ 8,66 SAY WPUEQP    PICTURE "########.##"
*********************  MANO DE OBRA   ****************
   STORE 0 TO WTOTMDOBS
   SELECT 3
   USE IPPMDO INDEX IPPMDO ALIAS MDO
   SELECT 4
   USE IPPTIMDO INDEX IPPTIMDO ALIAS TIPOS
   SELECT 3
   FIND &CLAVE
   DO WHILE .NOT. EOF() .AND. MOBRAPRE = WPRECOD .AND. MOBRAPAR = WPARCOD
      STORE MOBRACOD TO WMOBRACOD
      SELECT 4
      FIND &WMOBRACOD
      IF EOF()
        STORE WMOBRACOD+" NO REGISTRADO" TO MES
        DO AVISO WITH MES
      ENDIF
      SELECT 3
      STORE MOBRANUM*(MOBRAJOR+MOBRABON) TO WMDOBS
      STORE WTOTMDOBS+WMDOBS TO WTOTMDOBS
      SKIP
   ENDDO
   STORE WTOTMDOBS/PARTIDA->PARREND TO WVALORMDO
   STORE (WVALORMDO*PARTIDA->PARPORLDT)/100 TO WLDTBS
   STORE WVALORMDO+WLDTBS TO WPUMDO
   STORE WPUMAT+WPUEQP+WPUMDO TO WCOSTODIR
   IF PARTIDA->PARPORADM>0
      STORE (WCOSTODIR*PARTIDA->PARPORADM)/100  TO WADMBS
   ELSE
      STORE PARTIDA->PARBSADM                   TO WADMBS
   ENDIF
   STORE WCOSTODIR+WADMBS TO WSUBTOTALB
   IF PARTIDA->PARPORIMP>0
      STORE (WSUBTOTALB*PARTIDA->PARPORIMP)/100 TO WIMPBS
   ELSE
      STORE PARTIDA->PARBSIMP                   TO WIMPBS
   ENDIF
   STORE WSUBTOTALB+WIMPBS TO WPRECIO
   @ 12,21 SAY WTOTMDOBS PICTURE "########.##"
   @ 12,38 SAY WVALORMDO PICTURE "########.##"
   @ 12,51 SAY WLDTBS    PICTURE "########.##"
   @ 12,66 SAY WPUMDO    PICTURE "########.##"
   @ 14,66 SAY WCOSTODIR PICTURE "########.##"
   @ 15,66 SAY WADMBS    PICTURE "########.##"
   @ 16,66 SAY WSUBTOTALB PICTURE "########.##"
   @ 17,66 SAY WIMPBS    PICTURE "########.##"
   @ 18,66 SAY WPRECIO PICTURE "########.##"
   @ 20,1 say "CANTIDAD DE UNIDADES: "+STR(PARTIDA->PARCANT,11,2)
   @ 20,38 SAY "RENDIMIENTO: "+STR(PARTIDA->PARREND,11,2)
   @ 21,1 SAY "PRECIO UNIT. ASUMIDO: "+STR(PARTIDA->PARASUME,11,2)
   SELECT 2
   REPLACE PARBSADM  WITH WADMBS
   REPLACE PARBSIMP  WITH WIMPBS
   REPLACE PARPREUNI WITH WPRECIO
   store "Oprima (Ù) para Salir" to mes
   do aviso with mes
enddo


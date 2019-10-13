***********************************
* INFORME COMPLETO DE PRESUPUESTO *
***********************************
SET EXACT OFF
select 1
use ipppresu index ipppresu alias presup
select 2
use ippparti index ipppart1,ipppart2 alias partida
SELECT 5
USE IPPPARDE INDEX IPPPARDE
store .t. to analiza
do while analiza
   @ 5,1 clear to 15,78
   @ 5,1 to 15,78 double
   @ 5,10 say "INFORME COMPLETO DE PRESUPUESTO"
   @ 7,5 SAY "PRESUPUESTO:"
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
   @ 7,18  say preobra
   @ 8,18  say preobra2
   @ 9,18  say preobra3
   @ 10,18 say preobra4
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
   do while .not. eof() .and. parpre = wprecod
      if paranalis <> "SI"
         SELECT 2
         SKIP
         loop
      endif
      store parcod to wparcod
      store wprecod+wparcod to clave
      SET DEVI TO PRINT
      STORE 0 TO PAGINA
      store 100 to line
      STORE 0 TO WTOTMATBS
      *************   MATERIALES ***********
      SELECT 3
      USE IPPMATER INDEX IPPMATER ALIAS MATERIAL
      SELECT 4
      USE IPPTIMAT INDEX IPPTIMAT ALIAS TIPOS
      SELECT 3
      FIND &CLAVE
      DO WHILE .NOT. EOF() .AND. MATERPRE = WPRECOD .AND. MATERPAR = WPARCOD
         store line + 1 to line
         if line > 50
            DO PAGEMAT
            STORE LINE+1 TO LINE
         endif
         STORE MATERCOD TO WMATERCOD
         SELECT 4
         FIND &WMATERCOD
         IF EOF()
           STORE WMATERCOD+" NO REGISTRADO" TO WMATDES
           STORE "??????????" TO WMATUND
         ELSE
           STORE MATDES TO WMATDES
           STORE MATUND TO WMATUND
         ENDIF
         SELECT 3
         @ LINE,0 SAY "|                              |          |           |            |           |"
         @ LINE,0 SAY CHR(15)
         @ LINE,2 SAY WMATDES
         @ LINE,60 SAY WMATUND
         @ LINE,83 SAY STR(MATERCAN,11,2)
         @ LINE,105 SAY STR(MATERPREUN,11,2)
         STORE MATERCAN*MATERPREUN TO WMATBS
         @ LINE,126 SAY STR(WMATBS,11,2)
         @ LINE,0 SAY CHR(18)
         STORE WTOTMATBS+WMATBS TO WTOTMATBS
         SKIP
      ENDDO
      STORE (WTOTMATBS*PARTIDA->PARPORDES)/100 TO WPORDESBS
      IF WTOTMATBS > 0 .AND. PARTIDA->PARPORDES > 0
         STORE LINE+1 TO LINE
         @ LINE,0 SAY "|                              |          |           |            |           |"
         @ LINE, 0 SAY CHR(15)
         @ LINE,2 SAY "DESPERDICIO = "+STR(PARTIDA->PARPORDES,6,2)
         @ LINE,126 SAY STR(Wpordesbs,11,2)
         @ LINE, 0 SAY CHR(18)
      ENDIF
      STORE WTOTMATBS+WPORDESBS TO WTOTMATBS
      STORE 0 TO WPUMAT
      IF LINE <> 100
         STORE LINE+ 1 TO LINE
         @ LINE,0 SAY "+------------------------------+----------+-----------+------------+-----------+"
         STORE LINE+1 TO LINE
         @ LINE,40 SAY "TOTAL MATERIALES ..........:"
         @ LINE,68 SAY STR(WTOTMATBS,11,2)
         STORE LINE+1 TO LINE
         @ LINE,40 SAY "COSTO UNITARIO MATERIALES .:"
         @ LINE,40 SAY "COSTO UNITARIO MATERIALES .:"
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
         @ LINE,68 SAY STR(WPUMAT,11,2)
         @ LINE,68 SAY STR(WPUMAT,11,2)
      ENDIF
      ****************** EQUIPOS ******************
      IF LINE > 50
         STORE 100 TO LINE
      ELSE
         DO HEADEQP
      ENDIF
      STORE 0 TO WTOTEQPBS
      SELECT 3
      USE IPPEQUIP INDEX IPPEQUIP ALIAS EQUIPOS
      SELECT 4
      USE IPPTIEQP INDEX IPPTIEQP ALIAS TIPOS
       SELECT 3
     FIND &CLAVE
      DO WHILE .NOT. EOF() .AND. EQUIPPRE = WPRECOD .AND. EQUIPPAR = WPARCOD
         store line + 1 to line
         if line > 50
            DO PAGEEQP
            store line + 1 to line
         endif
         STORE EQUIPCOD TO WEQUIPCOD
         SELECT 4
         FIND &WEQUIPCOD
         IF EOF()
           STORE WEQUIPCOD+" NO REGISTRADO" TO WEQPDES
         ELSE
           STORE EQPDES TO WEQPDES
         ENDIF
         SELECT 3
         @ LINE,0 SAY "|                              |          |           |            |           |"
         @ LINE,0 SAY CHR(15)
         @ LINE,2 SAY WEQPDES
         @ LINE,60 SAY STR(EQUIPCAN,11,2)
         @ LINE,83 SAY STR(EQUIPPREUN,11,2)
         @ LINE,105 SAY STR(EQUIPDEPRE,11,5)
         STORE EQUIPCAN*EQUIPPREUN*EQUIPDEPRE TO WEQPBS
         @ LINE,126 SAY STR(WEQPBS,11,2)
         @ LINE,0 SAY CHR(18)
         STORE WTOTEQPBS+WEQPBS TO WTOTEQPBS
         SKIP
      ENDDO
      STORE 0 TO WPUEQP
      IF WTOTEQPBS <> 0
         STORE LINE+ 1 TO LINE
         @ LINE,0 SAY "+------------------------------+----------+-----------+------------+-----------+"
         STORE LINE+1 TO LINE
         @ LINE,40 SAY "TOTAL EQUIPOS .............:"
         @ LINE,68 SAY STR(WTOTEQPBS,11,2)
         STORE LINE+1 TO LINE
         @ LINE,40 SAY "COSTO UNITARIO EQUIPOS ....:"
         @ LINE,40 SAY "COSTO UNITARIO EQUIPOS ....:"
         STORE WTOTEQPBS/PARTIDA->PARREND TO WPUEQP
         @ LINE,68 SAY STR(WPUEQP,11,2)
         @ LINE,68 SAY STR(WPUEQP,11,2)
      ENDIF

*********************  MANO DE OBRA   ****************
   store 0 to contmdo
   store 0 to numhom
   IF LINE > 50
      STORE 100 TO LINE
   ELSE
      DO HEADMDO
   ENDIF
   STORE 0 TO WTOTMDOBS
   SELECT 3
   USE IPPMDO INDEX IPPMDO ALIAS MDO
   SELECT 4
   USE IPPTIMDO INDEX IPPTIMDO ALIAS TIPOS
   SELECT 3
   FIND &CLAVE
   DO WHILE .NOT. EOF() .AND. MOBRAPRE = WPRECOD .AND. MOBRAPAR = WPARCOD
      store line + 1 to line
      if line > 50
         if contmdo > 0
            @ LINE,0 SAY "+------------------------------+----------+-----------+------------+-----------+"
         endif
         store contmdo + 1 to contmdo
         DO PAGEMDO
         store line + 1 to line
      ENDIF
      STORE MOBRACOD TO WMOBRACOD
      SELECT 4
      FIND &WMOBRACOD
      IF EOF()
        STORE WMOBRACOD+" NO REGISTRADO" TO WMDODES
      ELSE
        STORE MDODES TO WMDODES
      ENDIF
      SELECT 3
      @ LINE,0 SAY "|                              |          |           |            |           |"
      @ LINE,0 SAY CHR(15)
      @ LINE,2 SAY WMDODES
      @ LINE,60 SAY STR(MOBRANUM,11,2)
      @ LINE,83 SAY STR(MOBRAJOR,11,2)
      @ LINE,105 SAY STR(MOBRABON,11,2)
      STORE MOBRANUM*(MOBRAJOR+MOBRABON) TO WMDOBS
      STORE WTOTMDOBS+WMDOBS TO WTOTMDOBS
      @ LINE,126 SAY STR(WMDOBS,11,2)
      @ LINE,0 SAY CHR(18)
      store numhom+mobranum to numhom
      SKIP
   ENDDO
   STORE 0 TO WPUMDO
   STORE 0 TO WVALORMDO
   STORE 0 TO WLDTBS

   store (numhom/partida->parrend)*8 to wproduc
   STORE (WTOTMDOBS)/PARTIDA->PARREND TO WVALORMDO
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
   SELECT 2
   REPLACE PARBSADM WITH WADMBS
   REPLACE PARBSIMP WITH WIMPBS

   STORE (WPUMAT*100)/(WPUMAT+WPUEQP+WPUMDO) TO WPORPUMAT
   STORE (WPUEQP*100)/(WPUMAT+WPUEQP+WPUMDO) TO WPORPUEQP
   STORE (WPUMDO*100)/(WPUMAT+WPUEQP+WPUMDO) TO WPORPUMDO

   IF WTOTMDOBS <> 0
      STORE LINE+ 1 TO LINE
      @ LINE,0 SAY "+------------------------------+----------+-----------+------------+-----------+"
   ENDIF
   STORE LINE+1 TO LINE
   @ LINE,1 SAY "Productividad (HH-Und):"+str(wproduc,10,2)
   IF WTOTMDOBS <> 0
      @ LINE,40 SAY "TOTAL LABOR ...............:"
      @ LINE,68 SAY STR(WTOTMDOBS,11,2)
   ENDIF

   STORE LINE+1 TO LINE
   @ LINE,1 SAY "(%)   Materiales .....:"+str(wporpumat,10,2)
   IF WTOTMDOBS <> 0
      @ LINE,40 SAY "VALOR LABOR x UNIDAD ......:"
      @ LINE,68 SAY STR(WVALORMDO,11,2)
   ENDIF

   STORE LINE+1 TO LINE
   @ LINE,1 SAY "(%)   Equipos ........:"+str(wporpueqp,10,2)
   IF WTOTMDOBS <> 0
      @ LINE,40 SAY STR(PARTIDA->PARPORLDT,6,2)+" % LEY DEL TRABAJO ..:"
      @ LINE,68 SAY STR(WLDTBS,11,2)
   ENDIF

   STORE LINE+1 TO LINE
   @ LINE,1 SAY "(%)   Labor ..........:"+str(wporpumdo,10,2)
   IF WTOTMDOBS <> 0
      @ LINE,40 SAY "COSTO UNITARIO LABOR ......:"
      @ LINE,40 SAY "COSTO UNITARIO LABOR ......:"
      @ LINE,68 SAY STR(WPUMDO,11,2)
      @ LINE,68 SAY STR(WPUMDO,11,2)
   ENDIF

      IF LINE > 55
         DO PAGEMDO
      ELSE
         STORE 55 TO LINE
      ENDIF

      STORE LINE+1 TO LINE
      @ LINE,0 SAY "    C O S T O   D I R E C T O   S U B - T O T A L  (A) :"
      @ LINE,68 SAY STR(WCOSTODIR,11,2)
      STORE LINE+1 TO LINE
      @ LINE,0 SAY "4.- ADM. Y GASTOS GENERALES:"
      @ LINE,0 SAY "4.- ADM. Y GASTOS GENERALES:"+STR(PARTIDA->PARPORADM,8,2)+" % SOBRE SUB-TOTAL (A) :"
      @ LINE,68 SAY STR(WADMBS,11,2)
      STORE LINE+1 TO LINE
      @ LINE,0 SAY "    S U B - T O T A L  (B) :"
      @ LINE,68 SAY STR(WSUBTOTALB,11,2)
      STORE LINE+1 TO LINE
      @ LINE,0 SAY "5.- IMPREVISTOS, UTILIDAD:  "
      @ LINE,0 SAY "5.- IMPREVISTOS, UTILIDAD:  "+STR(PARTIDA->PARPORIMP,8,2)+" % SOBRE SUB-TOTAL (B) :"
      @ LINE,68 SAY STR(WIMPBS,11,2)
      STORE LINE+1 TO LINE
      @ LINE,0 SAY "    P R E C I O   U N I T A R I O  :"
      @ LINE,0 SAY "    P R E C I O   U N I T A R I O  :"
      @ LINE,68 SAY STR(WPRECIO,11,2)
      @ LINE,68 SAY STR(WPRECIO,11,2)
      IF PARTIDA->PARASUME > 0
         STORE LINE+1 TO LINE
         @ LINE,0 SAY "    P R E C I O   U N I T A R I O   A S U M I D O  :"
         @ LINE,0 SAY "    P R E C I O   U N I T A R I O   A S U M I D O  :"
         @ LINE,68 SAY STR(PARTIDA->PARASUME,11,2)
         @ LINE,68 SAY STR(PARTIDA->PARASUME,11,2)
      ENDIF
      select 2
      replace parpreuni with wprecio
      skip
   enddo
   EJECT

   STORE 0 TO WTOTALPRE
   select 2
   go top
   STORE 0 TO PAGINA
   store 100 to line
   store "P R E S U P U E S T O    D E    O B R A" TO HEAD
   STORE WPREOBRA TO HEAD2
   STORE WPREOBRA2 TO HEAD3
   STORE WPREOBRA3 TO HEAD4
   STORE WPREOBRA4 TO HEAD5
   STORE WCLIENTE  TO HEAD6
   STORE "----------" TO Q
   STORE Q+Q+Q+Q+Q+Q+Q+Q+Q+Q+Q+Q+Q+"------" TO Q
   STORE 0 TO PAGINA
   GO TOP
   SET EXACT OFF
   FIND &WPrecod
   if eof()
      store "No existen partidas para este presupuesto" to mes
      set devi to scre
      do aviso with mes
      loop
   endif
   set devi to print
   DO WHILE .NOT. EOF() .AND. PARPRE = WPRECOD
      store parcod to wrparcod
      IF LINE > 52
         DO HEAD0501
      ENDIF
      STORE LINE+1 TO LINE
      @ LINE,0 SAY "|"
      @ LINE,16 SAY "|"
      @ LINE,64 SAY "|"
      @ LINE,76 SAY "|"
      @ LINE,93 SAY "|"
      @ LINE,112 SAY "|"
      @ LINE,135 SAY "|"
      @ LINE,1    SAY PARCOD

      store wprecod+wrparcod to wbusca
      select 5
      find &wbusca
      if eof()
         select 2
         @ LINE,17    SAY PARDES1
         IF PARDES2 <> SPACE(35)
            STORE LINE+1 TO LINE
            @ LINE,0 SAY "|"
            @ LINE,16 SAY "|"
            @ LINE,64 SAY "|"
            @ LINE,76 SAY "|"
            @ LINE,93 SAY "|"
            @ LINE,112 SAY "|"
            @ LINE,135 SAY "|"
            @ LINE,17 SAY PARDES2
         ENDIF
         IF PARDES3 <> SPACE(35)
            STORE LINE+1 TO LINE
            @ LINE,0 SAY "|"
            @ LINE,16 SAY "|"
            @ LINE,64 SAY "|"
            @ LINE,76 SAY "|"
            @ LINE,93 SAY "|"
            @ LINE,112 SAY "|"
            @ LINE,135 SAY "|"
            @ LINE,17 SAY PARDES3
         ENDIF
         IF PARDES4 <> SPACE(35)
            STORE LINE+1 TO LINE
            @ LINE,0 SAY "|"
            @ LINE,16 SAY "|"
            @ LINE,64 SAY "|"
            @ LINE,76 SAY "|"
            @ LINE,93 SAY "|"
            @ LINE,112 SAY "|"
            @ LINE,135 SAY "|"
            @ LINE,17 SAY PARDES4
         ENDIF
         IF PARDES5 <> SPACE(35)
            STORE LINE+1 TO LINE
            @ LINE,0 SAY "|"
            @ LINE,16 SAY "|"
            @ LINE,64 SAY "|"
            @ LINE,76 SAY "|"
            @ LINE,93 SAY "|"
            @ LINE,112 SAY "|"
            @ LINE,135 SAY "|"
            @ LINE,17 SAY PARDES5
         ENDIF
         IF PARDES6 <> SPACE(35)
            STORE LINE+1 TO LINE
            @ LINE,0 SAY "|"
            @ LINE,16 SAY "|"
            @ LINE,64 SAY "|"
            @ LINE,76 SAY "|"
            @ LINE,93 SAY "|"
            @ LINE,112 SAY "|"
            @ LINE,135 SAY "|"
            @ LINE,17 SAY PARDES6
         ENDIF
      ELSE
         DO WHILE .NOT. EOF() .AND. PRESU = WPRECOD .AND. PARTI = WRPARCOD
            @ LINE,0 SAY "|"
            @ LINE,16 SAY "|"
            @ LINE,64 SAY "|"
            @ LINE,76 SAY "|"
            @ LINE,93 SAY "|"
            @ LINE,112 SAY "|"
            @ LINE,135 SAY "|"
            @ LINE,17 SAY TEXTO
            IF LINE > 52
               STORE RECNO() TO WSIGUE
               SKIP
               IF .NOT. EOF() .AND. PRESU = WPRECOD .AND. PARTI = WRPARCOD
                  *** CONTINUA LA MISMA PARTIDA
                  DO HEAD0501
               ELSE
                  *** FIN DE DESCRIPCION, IMPRIMIR MONTOS
               ENDIF
               GO WSIGUE
            ENDIF
            STORE LINE+1 TO LINE
            SKIP
         ENDDO
         STORE LINE-1 TO LINE
      ENDIF
      SELECT 2

      IF PARTIPO <> "T"
         @ LINE,65   SAY PARUNID
         @ LINE,79   SAY STR(PARCANT,11,2)

         IF PARASUME = 0
            @ LINE,99   SAY STR(PARPREUNI,11,2)
            STORE PARCANT*PARPREUNI TO WPARTOTAL
          ELSE
            @ LINE,99   SAY STR(PARASUME,11,2)
            STORE PARCANT*PARASUME TO WPARTOTAL
         ENDIF

         @ LINE,122  SAY STR(WPARTOTAL,11,2)
         STORE WTOTALPRE+WPARTOTAL TO WTOTALPRE
      ENDIF
      STORE LINE+1 TO LINE
      @ LINE,0 SAY "|"
      @ LINE,16 SAY "|"
      @ LINE,64 SAY "|"
      @ LINE,76 SAY "|"
      @ LINE,93 SAY "|"
      @ LINE,112 SAY "|"
      @ LINE,135 SAY "|"
      SKIP
   ENDDO
   DO WHILE LINE <= 55
      STORE LINE+1 TO LINE
      @ LINE,0 SAY "|"
      @ LINE,16 SAY "|"
      @ LINE,64 SAY "|"
      @ LINE,76 SAY "|"
      @ LINE,93 SAY "|"
      @ LINE,112 SAY "|"
      @ LINE,135 SAY "|"
   ENDDO
   STORE LINE+1 TO LINE
   @ LINE,0 SAY Q
   @ LINE+1,0 SAY "|"
   @ LINE+1,135 SAY "|"
   @ LINE+1,8 SAY "M O N T O     T O T A L     D E L      P R E S U P U E S T O :"
   @ LINE+1,122 SAY STR(WTOTALPRE,11,2)
   @ LINE+2,0 SAY Q
   @ LINE+2,115 SAY CHR(18)
   EJECT
   SET DEVI TO SCRE
enddo

***********************************
* RESUMEN DE MATERIALES POR OBRA
***********************************
SET EXACT OFF
SELECT 1
use ipppresu index ipppresu alias presup
SELECT 2
use ippparti index ipppart1,ipppart2 alias partida
SELECT 3
USE IPPMATER INDEX IPPMATER ALIAS MATERIAL
SELECT 4
USE IPPTIMAT INDEX IPPTIMAT ALIAS TIPOS
store .t. to analiza
do while analiza
   SELECT 5
   USE IPPRESMAT
   ZAP
   INDEX ON MATERIAL+PARTIDA TO IPPRESMAT
   @ 5,1 clear to 15,79
   @ 5,1 to 15,79 double
   @ 5,10 say "RESUMEN DE MATERIALES POR OBRA"
   @ 07,5 SAY "PRESUPUESTO:"
   @ 12,5 SAY "MATERIAL   :"
   STORE SPACE(10) TO WPRECOD
   STORE SPACE(6)  TO WMATERIAL
   @ 7,18 GET WPRECOD
   READ
   IF WPRECOD = SPACE(10)
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
   store preobra  to wDESCRI1
   store preobra2 to wDESCRI2
   store preobra3 to wDESCRI3
   store preobra4 to wDESCRI4
   @ 12,18 GET WMATERIAL
   READ
   IF WMATERIAL <>  SPACE(6)
      SELECT 4
      STORE UPPER(WMATERIAL) TO WMATERIAL
      FIND &WMATERIAL
      IF EOF()
         STORE "ERROR, Material del presupuesto no registrado" to mes
         do aviso with mes
         loop
      endif
      @ 13,18 say MATDES
   ELSE
      @ 13,18 say "TODOS"
   ENDIF

   store "Opciones: (C)ontinuar, (S)alir " to mes
   store "C" to p1
   store "S" to p2
   store " " to resp
   do pide2 with p1,p2,mes,resp
   if resp = "S"
      select 1
      loop
   endif
   STORE "COMANDO EN PROGRESO ..." TO MES
   DO MENSAJE WITH MES
   store 0 to wmontpre
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
      SELECT 3
      FIND &CLAVE
      DO WHILE .NOT. EOF() .AND. MATERPRE = WPRECOD .AND. MATERPAR = WPARCOD
         IF WMATERIAL <> SPACE(6) .AND. MATERCOD <> WMATERIAL
            SELECT 3
            SKIP
            LOOP
         ENDIF
         STORE MATERCOD   TO WMAT
         STORE MATERPAR   TO WPAR
         STORE MATERCAN   TO WCAN
         STORE MATERPREUN TO WPRE
         STORE WMAT+WPAR  TO WCLAVEMAT
         STORE "PARTIDA :" +WPAR+"  MATERIAL:"+WMAT+" CANTIDAD:"+STR(WCAN,10,2) TO MES
         DO MENSAJE WITH MES
         SELECT 5
         FIND &WCLAVEMAT
         IF EOF()
            APPEND BLANK
            REPLACE MATERIAL WITH WMAT
            REPLACE PARTIDA WITH WPAR
         ENDIF
         REPLACE CANTIDAD WITH CANTIDAD + WCAN
         REPLACE BOLIVARES WITH BOLIVARES + (WCAN*WPRE)
         SELECT 3
         SKIP
      ENDDO
      SELECT 2
      SKIP
   ENDDO

   *** IMPRIME
   STORE 0 TO SALTAR
   DO CHKPRINT WITH SALTAR
   IF SALTAR = 1
      SELECT 1
      LOOP
   ENDIF

   SET DEVI TO PRINT
   STORE 0   TO PAGINA
   STORE 100 TO LINEA
   STORE 0   TO WTOTCAN
   STORE 0   TO WTOTBOL
   STORE 0   TO WGENBOL
   STORE 0   TO WGENACT
   STORE 0   TO WTOTACT
   STORE "*" TO WRUPMAT
   SELECT 5
   GO TOP
   DO WHILE .NOT. EOF()
      IF MATERIAL <> WRUPMAT
         IF WTOTCAN > 0
            STORE LINEA + 1 TO LINEA
            @ LINEA,85  SAY "----------"
            @ LINEA,103 SAY "--------------"
            @ LINEA,122 SAY "--------------"
            STORE LINEA + 1 TO LINEA
            @ LINEA,83  SAY WTOTCAN PICTURE "#,###,###.##"
            @ LINEA,103 SAY WTOTBOL PICTURE "###,###,###.##"
            @ LINEA,122 SAY WTOTACT PICTURE "###,###,###.##"
            STORE LINEA + 1 TO LINEA
            @ LINEA,00 SAY REPLICATE("-",136)
            STORE WGENBOL + WTOTBOL TO WGENBOL
            STORE WGENACT + WTOTACT TO WGENACT
            STORE 0 TO WTOTCAN
            STORE 0 TO WTOTBOL
            STORE 0 TO WTOTACT
         ENDIF
         STORE MATERIAL TO WCLAVE
         SELECT 4
         FIND &WCLAVE
         IF EOF()
            STORE "?????????????????????????" TO WDESMAT
            STORE "????????"                  TO WUNDMAT
            STORE 0                           TO WBOLMAT
         ELSE
            STORE MATDES                      TO WDESMAT
            STORE MATUND                      TO WUNDMAT
            STORE MATPRE                      TO WBOLMAT
         ENDIF
         SELECT 5
         STORE LINEA + 1 TO LINEA
         IF LINEA > 55
            DO HEAD0503
         ENDIF
         @ LINEA,00 SAY WDESMAT
         @ LINEA,55 SAY WUNDMAT
         STORE MATERIAL TO WRUPMAT
      ENDIF
      SELECT 5
      STORE LINEA + 1 TO LINEA
      IF LINEA > 55
         DO HEAD0503
      ENDIF
      @ LINEA,70  SAY PARTIDA
      @ LINEA,83  SAY CANTIDAD             PICTURE "#,###,###.##"
      @ LINEA,103 SAY BOLIVARES            PICTURE "###,###,###.##"
      STORE WTOTCAN + CANTIDAD             TO WTOTCAN
      STORE WTOTBOL + BOLIVARES            TO WTOTBOL
      STORE WTOTACT + (CANTIDAD*WBOLMAT)   TO WTOTACT
      SKIP
   ENDDO
   IF WTOTCAN > 0
      STORE LINEA + 1 TO LINEA
      @ LINEA,85  SAY "----------"
      @ LINEA,103 SAY "--------------"
      @ LINEA,122 SAY "--------------"
      STORE LINEA + 1 TO LINEA
      @ LINEA,83  SAY WTOTCAN PICTURE "#,###,###.##"
      @ LINEA,103 SAY WTOTBOL PICTURE "###,###,###.##"
      @ LINEA,122 SAY WTOTACT PICTURE "###,###,###.##"
      STORE LINEA + 1 TO LINEA
      @ LINEA,00 SAY REPLICATE("-",136)
      STORE LINEA + 1 TO LINEA
      IF LINEA > 55
         DO HEAD0503
      ENDIF
      STORE WGENBOL + WTOTBOL TO WGENBOL
      STORE WGENACT + WTOTACT TO WGENACT
      @ LINEA,00  SAY "TOTAL GENERAL DEL INFORME:"
      @ LINEA,102 SAY WGENBOL PICTURE "####,###,###.##"
      @ LINEA,121 SAY WGENACT PICTURE "####,###,###.##"
   ENDIF
   EJECT
   SET DEVI TO SCRE
ENDDO



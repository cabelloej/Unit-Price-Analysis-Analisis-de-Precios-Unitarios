*********************************
* INFORME RESUMEN DE VALUACIONES
*********************************
SELECT 1
USE IPPPRESU INDEX IPPPRESU ALIAS PRESUP
SELECT 2
USE IPPVALGE INDEX IPPVALGE
SELECT 3
USE IPPVALDE INDEX IPPVALDE
select 4
use ippparti index ipppart1
SET COLOR TO W/N
STORE .T. TO PRE
DO WHILE PRE
   SET COLOR TO W/N
   @ 04,0 CLEAR TO 21,79
   @ 04,0 SAY "+------------------------------------------------------------------------------+"
   @ 05,0 SAY "|                  R E S U M E N    D E    V A L U A C I O N E S               |"
   @ 06,0 SAY "+-------------------------------------+----------------------------------------+"
   @ 07,0 SAY "|OBRA:                                |LUGAR:                                  |"
   @ 08,0 SAY "+-------------------------------------+----------------------------------------+"
   @ 09,0 SAY "|DENOMINACION DE LA OBRA:                                                      |"
   @ 10,0 SAY "|                                                                              |"
   @ 11,0 SAY "|                                                                              |"
   @ 12,0 SAY "+------------------------------------------------------------------------------+"
   STORE WPARPRE   TO WPRECOD
   STORE "Codigo de la obra a imprimir" to mes
   do mensaje with mes
   @ 7,6 GET WPRECOD
   READ
   STORE UPPER(WPRECOD) TO WPRECOD
   if wprecod = space(10)
      close data
      close index 
      return
   endif
   select 1
   FIND &WPRECOD
   IF EOF()
      STORE "Codigo de presupuesto no registrado, (Ù)" to mes
      do aviso with mes
      loop
   endif
   store preobra  to wpredes1
   store preobra2 to wpredes2
   store preobra3 to wpredes3
   store preobra4 to wpredes4
   store predir   to wpredir
   STORE PREREF     TO WPREREFER
   STORE PRECLIENTE TO WCLIENTE
   @ 10,1 SAY WPREDES1+WPREDES2
   @ 11,1 SAY WPREDES3+WPREDES4
   @ 7,45 say substr(wpredir,1,34)
   STORE "Opciones: (A)ceptar, (R)echazar" to mes
   store "A" to p1
   store "R" to p2
   store " " to resp
   do pide2 with p1,p2,mes,resp
   if resp = "R"
      loop
   endif
   store 0   to pagina
   store 100 to line
   store 0   to wtotREP
   set devi  to print
   select 2
   set exact off
   find &wPRECOD
   set exact on
   do while .not. eof() .and. obra = wprecod
      STORE VALUACION  TO WVALUACION
      STORE FECHA      TO WFECHAVAL
      STORE INSPECCION TO WINSPEVAL
      STORE DESDE      TO WDESDEVAL
      STORE HASTA      TO WHASTAVAL
      STORE 0 TO WTOTVAL
      SELECT 3
      SET EXACT OFF
      STORE WPRECOD+WVALUACION TO WCLAVE2
      FIND &WCLAVE2
      SET EXACT ON
      DO WHILE .NOT. EOF() .AND. OBRA = WPRECOD .AND. VALUACION = WVALUACION
         STORE PARTIDA TO WCODPAR
         STORE WPRECOD+WCODPAR TO WCLAVEPAR
         SELECT 4
         FIND &WCLAVEPAR
         IF EOF()
            SET DEVI TO SCRE
            STORE "PARTIDA: "+WCODPAR+" EN VALUACION: "+WVALUACION+", NO EXISTE" TO MES
            DO AVISO WITH MES
            CLOSE DATA
            CLOSE INDEX
            RETURN
         ELSE
            IF PARASUME > 0
               STORE PARASUME  TO WPARPREUNI
            ELSE
               STORE PARPREUNI TO WPARPREUNI
            ENDIF
         ENDIF
         SELECT 3
         STORE WTOTVAL + (CANTIDAD*WPARPREUNI) TO WTOTVAL
         SKIP
      ENDDO
      store line + 1 to line
      if line > 50
         STORE PAGINA + 1 TO PAGINA
         @ 00,0 SAY CHR(18)
         @ 00,0 SAY CHR(14)+qqww
         @ 01,65 SAY "PAGINA:"+STR(PAGINA,2)
         @ 02,65 SAY "FECHA :"+DTOC(WFECACT)
         @ 3,0 SAY "RESUMEN DE VALUACIONES"
         @ 3,0 SAY "RESUMEN DE VALUACIONES"
         @ 4,0 SAY "DE LA OBRA: "+WPRECOD
         @ 5,0 SAY WPREDES1
         @ 6,0 SAY WPREDES2
         @ 7,0 SAY WPREDES3
         @ 8,0 SAY WPREDES4
         @ 11,0 SAY CHR(18)
         @ 13,0 SAY "+-------------+--------+--------+--------+----------+--------------+"
         @ 14,0 SAY "|VALUACION No.| FECHA  | DESDE  | HASTA  |INSPECCION|   TOTAL Bs.  |"
         @ 15,0 SAY "+-------------+--------+--------+--------+----------+--------------+"
         STORE 16 TO LINE
      endif
      @ LINE,1  SAY WVALUACION
      @ LINE,15 SAY DTOC(WFECHAVAL)
      @ LINE,24 SAY DTOC(WDESDEVAL)
      @ LINE,33 SAY DTOC(WHASTAVAL)
      @ LINE,42 SAY WINSPEVAL
      @ LINE,55 SAY STR(WTOTVAL,12,2)
      STORE WTOTREP + WTOTVAL TO WTOTREP
      @ LINE,0 SAY "|             |        |        |        |          |              |"
      SELECT 2
      skip
   enddo
   DO WHILE LINE <=50
      STORE LINE + 1 TO LINE
      @ LINE,0 SAY "|             |        |        |        |          |              |"
   ENDDO
   STORE LINE+1 TO LINE
   @ LINE,0 SAY    "+-------------+--------+--------+--------+----------+--------------+"
   STORE LINE+1 TO LINE
   @ LINE,1 SAY "T O T A L E S :"
   @ LINE,1 SAY "T O T A L E S :"
   @ LINE,55 SAY WTOTREP PICTURE "#########.##"
   EJECT
   SET DEVI TO SCRE
ENDDO


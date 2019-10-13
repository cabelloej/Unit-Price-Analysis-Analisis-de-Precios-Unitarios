*********************************
* INFORME de valuaciones  *
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
   @ 05,0 SAY "|              I N F O R M E    D E    V A L U A C I O N E S                   |"
   @ 06,0 SAY "+---------------+--------------------+-----------------------------------------+"
   @ 07,0 SAY "|OBRA:          |VALUACION:          |LUGAR:                                   |"
   @ 08,0 SAY "+---------------+--------------------+----------------+------------------------+"
   @ 09,0 SAY "|FECHA:         |INSPECCION:         |DESDE:          |HASTA:                  |"
   @ 10,0 SAY "+---------------+--------------------+----------------+------------------------+"
   @ 11,0 SAY "|DENOMINACION DE LA OBRA:                                                      |"
   @ 12,0 SAY "|                                                                              |"
   @ 13,0 SAY "|                                                                              |"
   @ 14,0 SAY "+------------------------------------------------------------------------------+"

   STORE WPARPRE   TO WPRECOD
   STORE "Codigo de la obra a imprimir" to mes
   do mensaje with mes
   @ 7,6 GET WPRECOD
   READ
   STORE UPPER(WPRECOD) TO WPRECOD
   if wprecod = space(10)   .OR. READKEY() = 12 .OR. READKEY() = 268
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
   STORE PREREF TO WPREREFER
   STORE PRECLIENTE TO WCLIENTE
   @ 12,1 SAY WPREDES1+WPREDES2
   @ 13,1 SAY WPREDES3+WPREDES4
   @ 7,44 say substr(wpredir,1,35)
   store space(10) to wvalua
   store "Ingrese el codigo de la valuacion a imprimir" to mes
   do mensaje with mes
   @ 7,27 get wvalua
   read
   if wvalua = space(10)
      close data
      close index
      return
   endif
   select 2
   store wprecod+wvalua to wcodval
   find &wcodval
   if eof()
      store "Esta valuacion no esta registrada, verifique" to mes
      do aviso with mes
      loop
   endif
   @ 09,7 SAY  fecha
   @ 09,28 SAY inspeccion
   @ 09,44 SAY desde
   @ 09,61 SAY hasta
   STORE "Opciones: (A)ceptar, (R)echazar" to mes
   store "A" to p1
   store "R" to p2
   store " " to resp
   do pide2 with p1,p2,mes,resp
   if resp = "R"
      loop
   endif
   store fecha to wfecha
   store inspeccion to winspe
   store desde to wdesde
   store hasta to whasta
   store 0 to pagina
   store 100 to line
   store 0 to wtotval
   store 0 to wtotpag
   set devi to print
   select 3
   set exact off
   find &wcodval
   set exact on
   do while .not. eof() .and. obra = wprecod .and. valuacion = wvalua
      STORE PARTIDA TO WCODPAR
      store recno() to wregresa
      *** CALCULO DEL ACUMULADO ANTERIOR A LA VALUACION EN CURSO
      select 3
      set exact off
      find &wprecod
      store 0 to wacumulado
      do while .not. eof() .and. obra = wprecod .and. valuacion < wvalua
         if partida = wcodpar
            store wacumulado + cantidad to wacumulado
         endif
         skip
      enddo
      set exact on
      *** @ 17,53 SAY STR(WACUMULADO,11,2)
      *** FIN CALCULO DEL ACUMULADO
      go wregresa
      **** FIN CALCULO DEL ACUMULADO

      select 4
      store wprecod+wcodpar to wclave
      find &wclave
      if eof()
         set devi to scre
         store "Partida "+rtrim(wcodpar)+"en valuacion no registrada en la obra" to mes
         do aviso with mes
         close data
         close index
         return
      endif
      store pardes1 to wpardes1
      store pardes2 to wpardes2
      store pardes3 to wpardes3
      store pardes4 to wpardes4
      store pardes5 to wpardes5
      store pardes6 to wpardes6
      store parunid to wparunid
      store parcant to wparcant
      IF PARASUME > 0
         store parasume to wparpreuni
      else
         store parpreuni to wparpreuni
      endif
      SELECT 3
      store line + 1 to line
      if line > 55
         STORE PAGINA + 1 TO PAGINA
         if pagina > 1
            @ LINE,0 SAY "+-------------+----------------------------------------+-----------+-----------+------------+------------+------------+------------+"
            STORE LINE+1 TO LINE
            @ LINE,1 SAY "                                 S U B - T O T A L    P A G I N A   Bs."
            @ LINE,118 SAY WTOTPAG PICTURE "##########.##"
         endif
         @ 00,0 SAY CHR(18)
         @ 00,0 SAY CHR(14)+qqww
         @ 01,00 SAY CHR(14)+"INFORME DE EJECUCION DE OBRA"
         @ 03,0 SAY "SE¥ORES  :"+WCLIENTE
         @ 03,65 SAY "PAGINA:"+STR(PAGINA,2)
         @ 04,65 SAY "FECHA :"+DTOC(WFECHA)
         @ 04,0 SAY "OBRA     :"+WPREDES1
         @ 05,0 SAY "          "+WPREDES2
         @ 06,0 SAY "          "+WPREDES3
         @ 07,0 SAY "          "+WPREDES4
         @ 08,0 SAY "UBICACION:"+WPREDIR
         @ 09,0 SAY "CONTRATO :"+WPREREFER
         @ 10,0 SAY  CHR(14)+"VALUACION  No. "+WVALUA
         @ 11,0 SAY  CHR(14)+"INSPECCION No. "+ltrim(WINSPE)
         @ 12,0 SAY "PERIODO  :"+DTOC(WDESDE)+" AL "+DTOC(WHASTA)
         @ 13,0 say chr(15)
         @ 13,0 SAY "+-------------+----------------------------------------+-----------+-----------+------------+------------+------------+------------+"
         @ 14,0 SAY "|No.          |DESCRIPCION                             |  UNIDAD   |CANT.CONTR.|COSTOxUNIDAD|CANT.EJECUT.|ACU.AL PERD.|TOT. PARTIDA|"
         @ 15,0 SAY "+-------------+----------------------------------------+-----------+-----------+------------+------------+------------+------------+"
         STORE 16 TO LINE
      endif
      @ LINE,1 SAY WCODPAR
      @ LINE,15 SAY WPARDES1
      @ LINE,0 SAY "|             |                                        |           |           |            |            |            |            |"
      IF WPARDES2 <> SPACE(40)
         STORE LINE + 1 TO LINE
         @ LINE,15 SAY WPARDES2
      @ LINE,0 SAY "|             |                                        |           |           |            |            |            |            |"
      ENDIF
      IF WPARDES3 <> SPACE(40)
         STORE LINE + 1 TO LINE
         @ LINE,15 SAY WPARDES3
      @ LINE,0 SAY "|             |                                        |           |           |            |            |            |            |"
      ENDIF
      IF WPARDES4 <> SPACE(40)
         STORE LINE + 1 TO LINE
         @ LINE,15 SAY WPARDES4
      @ LINE,0 SAY "|             |                                        |           |           |            |            |            |            |"
      ENDIF
      IF WPARDES5 <> SPACE(40)
         STORE LINE + 1 TO LINE
         @ LINE,15 SAY WPARDES5
      @ LINE,0 SAY "|             |                                        |           |           |            |            |            |            |"
      ENDIF
      IF WPARDES6 <> SPACE(40)
         STORE LINE + 1 TO LINE
         @ LINE,15 SAY WPARDES6
      @ LINE,0 SAY "|             |                                        |           |           |            |            |            |            |"
      ENDIF
      @ LINE,56 SAY WPARUNID
      @ LINE,68 SAY WPARCANT   PICTURE "########.##"
      @ LINE,80 SAY WPARPREUNI PICTURE "#########.##"
      @ LINE,93 SAY CANTIDAD   PICTURE "#########.##"
      @ LINE,106 SAY WACUMULADO+CANTIDAD PICTURE "#########.##"
      STORE CANTIDAD*WPARPREUNI TO WTOTPAR
      @ LINE,119 SAY WTOTPAR   PICTURE "#########.##"
      STORE WTOTVAL + WTOTPAR TO WTOTVAL
      STORE WTOTpag + WTOTPAR TO WTOTpag
      skip
   enddo
   DO WHILE LINE <=55
      STORE LINE + 1 TO LINE
      @ LINE,0 SAY "|             |                                        |           |           |            |            |            |            |"
   ENDDO
   STORE LINE+1 TO LINE
   @ LINE,0 SAY "+-------------+----------------------------------------+-----------+-----------+------------+------------+------------+------------+"
   STORE LINE+1 TO LINE
   @ LINE,1 SAY "                                         T O T A L    V A L U A C I O N   Bs."
   @ LINE,118 SAY WTOTVAL PICTURE "##########.##"
   EJECT
   SET DEVI TO SCRE
ENDDO



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
   @ 05,0 SAY "|                  R E S U M E N    D E    P A R T I D A S                     |"
   @ 06,0 SAY "+---------------+---------------------+----------------------------------------+"
   @ 07,0 SAY "|OBRA:          |PARTIDA:             |LUGAR:                                  |"
   @ 08,0 SAY "+---------------+---------------------+----------------------------------------+"
   @ 09,0 SAY "|DENOMINACION DE LA OBRA:                                                      |"
   @ 10,0 SAY "|                                                                              |"
   @ 11,0 SAY "|                                                                              |"
   @ 12,0 SAY "+------------------------------------------------------------------------------+"
   @ 13,0 SAY "|DENOMINACION DE LA PARTIDA:                                                   |"
   @ 14,0 SAY "|                                                                              |"
   @ 15,0 SAY "|                                                                              |"
   @ 16,0 SAY "|                                                                              |"
   @ 17,0 SAY "|                                                                              |"
   @ 18,0 SAY "|                                                                              |"
   @ 19,0 SAY "|                                                                              |"
   @ 20,0 SAY "+------------------------------------------------------------------------------+"
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
   STORE PREREF TO WPREREFER
   STORE PRECLIENTE TO WCLIENTE
   @ 10,1 SAY WPREDES1+WPREDES2
   @ 11,1 SAY WPREDES3+WPREDES4
   @ 7,45 say substr(wpredir,1,34)
   store space(13) to wCODPAR
   store "Ingrese el codigo de la partida" to mes
   do mensaje with mes
   @ 7,25 get wcodpar
   read
   if wcodpar= space(13)
      close data
      close index
      return
   endif
   select 4
   store wprecod+wcodpar to wcodbus
   find &wcodbus
   if eof()
      store "Esta partida no esta registrada, verifique" to mes
      do aviso with mes
      loop
   endif
   @ 14,1 SAY PARDES1
   @ 15,1 SAY PARDES2
   @ 16,1 SAY PARDES3
   @ 17,1 SAY PARDES4
   @ 18,1 SAY PARDES5
   @ 19,1 SAY PARDES6
   STORE "Opciones: (A)ceptar, (R)echazar" to mes
   store "A" to p1
   store "R" to p2
   store " " to resp
   do pide2 with p1,p2,mes,resp
   if resp = "R"
      loop
   endif
   store 0 to pagina
   store 100 to line
   store 0 to wtotREP
   store 0 to wtotUNI
   set devi to print
   select 3
   set exact off
   find &wPRECOD
   set exact on
   do while .not. eof() .and. obra = wprecod
      IF PARTIDA <> WCODPAR
         SKIP
         LOOP
      ENDIF
      store VALUACION TO WVALUACION
      STORE WPRECOD+WVALUACION TO WCLAVE2
      SELECT 2
      FIND &WCLAVE2
      IF EOF()
         SET DEVI TO SCRE
         STORE "No existe descripcion general de la valuacion "+wvaluacion to mes
         do aviso with mes
         close data
         close index
         return
      ENDIF
      STORE FECHA TO WFECHAVAL
      STORE INSPECCION TO WINSPEVAL
      STORE DESDE TO WDESDEVAL
      STORE HASTA TO WHASTAVAL

      select 4
      store wprecod+wcodpar to wclave
      find &wclave
      if eof()
         set devi to scre
         store "Partida "+rtrim(wcodpar)+"en valuacion "+WVALUACION+" no registrada en la obra" to mes
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
         STORE PARASUME     TO WPARPREUNI
      ELSE
         STORE PARPREUNI    TO WPARPREUNI
      ENDIF
      SELECT 3
      store line + 1 to line
      if line > 50
         STORE PAGINA + 1 TO PAGINA
         @ 00,0 SAY CHR(18)
         @ 00,0 SAY CHR(14)+qqww
         @ 01,65 SAY "PAGINA:"+STR(PAGINA,2)
         @ 02,65 SAY "FECHA :"+DTOC(WFECACT)
         @ 3,0 SAY "RESUMEN DE LA PARTIDA: "+WCODPAR
         @ 3,0 SAY "RESUMEN DE LA PARTIDA: "+WCODPAR
         @ 3,41 SAY "DE LA OBRA: "+WPRECOD
         @ 3,41 SAY "DE LA OBRA: "+WPRECOD
         @ 4,0 SAY IPPPARTI->PARDES1
         @ 4,41 SAY WPREDES1
         @ 5,0 SAY IPPPARTI->PARDES2
         @ 5,41 SAY WPREDES2
         @ 6,0 SAY IPPPARTI->PARDES3
         @ 6,41 SAY WPREDES3
         @ 7,0 SAY IPPPARTI->PARDES4
         @ 7,41 SAY WPREDES4
         @ 8,0 SAY IPPPARTI->PARDES5
         @ 9,0 SAY IPPPARTI->PARDES6
         @ 11,0 SAY CHR(15)
         @ 11,1 SAY "UNIDAD: "+WPARUNID
         @ 11,30 SAY "CANTIDAD:"+STR(WPARCANT,10,2)
         @ 11,70 SAY "PRECIO UNID.:"+STR(WPARPREUNI,12,2)
         @ 11,105 SAY "TOTAL:"+STR((WPARPREUNI*WPARCANT),12,2)
         @ 11,0 SAY CHR(18)
         @ 11,0 SAY CHR(15)
         @ 13,0 SAY "+-------------+--------+--------+--------+----------+----------+-------------+--------------+"
         @ 14,0 SAY "|VALUACION No.| FECHA  | DESDE  | HASTA  |INSPECCION|UNID.EJEC.|PREC.UNITARIO|  TOTAL Bs.   |"
         @ 15,0 SAY "+-------------+--------+--------+--------+----------+----------+-------------+--------------+"
         STORE 16 TO LINE
      endif
      @ LINE,1  SAY WVALUACION
      @ LINE,15 SAY DTOC(WFECHAVAL)
      @ LINE,24 SAY DTOC(WDESDEVAL)
      @ LINE,33 SAY DTOC(WHASTAVAL)
      @ LINE,42 SAY WINSPEVAL
      @ LINE,51 SAY STR(CANTIDAD,12,2)
      @ LINE,65 SAY STR(WPARPREUNI,12,2)
      STORE WPARPREUNI*CANTIDAD TO WTOTPAR
      @ LINE,80 SAY STR(WTOTPAR,12,2)
      STORE WTOTUNI + CANTIDAD TO WTOTUNI
      STORE WTOTREP + WTOTPAR TO WTOTREP
      @ LINE,0 SAY "|             |        |        |        |          |          |             |              |"
      skip
   enddo
   DO WHILE LINE <=50
      STORE LINE + 1 TO LINE
      @ LINE,0 SAY "|             |        |        |        |          |          |             |              |"
   ENDDO
   STORE LINE+1 TO LINE
   @ LINE,0 SAY "+-------------+--------+--------+--------+----------+----------+-------------+--------------+"
   STORE LINE+1 TO LINE
   @ LINE,1 SAY "T O T A L E S :"
   @ LINE,1 SAY "T O T A L E S :"
   @ LINE,51 SAY STR(WTOTUNI,12,2)
   @ LINE,80 SAY STR(WTOTREP,12,2)
   EJECT
   SET DEVI TO SCRE
ENDDO



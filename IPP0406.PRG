SELECT 1
USE IPPPRESU INDEX IPPPRESU
SELECT 2
USE IPPPARTI INDEX IPPPART1,IPPPART2
SELECT 3
USE IPPVALGE INDEX IPPVALGE
SELECT 4
USE IPPVALDE INDEX IPPVALDE
STORE .T. TO WSIEMPRE
DO WHILE WSIEMPRE
   SET COLOR TO W/N
   @ 04,0 CLEAR TO 21,79
   @ 04,0 SAY "+------------------------------------------------------------------------------+"
   @ 05,0 SAY "|   I N F O R M E    D E    A U M E N T O S    Y    D I S M I N U C I O N E S  |"
   @ 06,0 SAY "+------------------------------------------------------------------------------+"
   @ 07,0 SAY "|OBRA:                                                                         |"
   @ 08,0 SAY "|                                                                              |"
   @ 09,0 SAY "|                                                                              |"
   @ 10,0 SAY "|                                                                              |"
   @ 11,0 SAY "+------------------------------------------------------------------------------+"
*  @ 12,0 SAY "|DESDE LA VALUACION NUMERO:                                                    |"
*  @ 13,0 SAY "+---------------+--------------------+----------------+------------------------+"
*  @ 14,0 SAY "|FECHA:         |INSPECCION:         |DESDE:          |HASTA:                  |"
*  @ 15,0 SAY "+---------------+--------------------+----------------+------------------------+"
*  @ 16,0 SAY "+------------------------------------------------------------------------------+"
*  @ 17,0 SAY "|HASTA LA VALUACION NUMERO:                                                    |"
*  @ 18,0 SAY "+---------------+--------------------+----------------+------------------------+"
*  @ 19,0 SAY "|FECHA:         |INSPECCION:         |DESDE:          |HASTA:                  |"
*  @ 20,0 SAY "+---------------+--------------------+----------------+------------------------+"
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
   @ 08,1 SAY PREOBRA +PREOBRA2
   @ 09,1 SAY PREOBRA3+PREOBRA4
*  store space(10) to wdesde
*  store space(10) to whasta
*  store "Ingrese el codigo de la valuacion a inicial" to mes
*  do mensaje with mes
*  @ 12,28 get wdesde
*  read
*  if wdesde = space(10)
*     close data
*     close index
*     return
*  endif
*  select 3
*  store wprecod+wdesde to wcodval
*  set exact off
*  find &wcodval
*  set exact on
*  if eof()
*     store "Esta valuacion no esta registrada, verifique" to mes
*     do aviso with mes
*     loop
*  endif
*  @ 14,7  SAY fecha
*  @ 14,28 SAY inspeccion
*  @ 14,44 SAY desde
*  @ 14,61 SAY hasta
*  store recno() to winival
*  store "Ingrese el codigo de la valuacion a final" to mes
*  do mensaje with mes
*  @ 17,28 get whasta
*  read
*  if whasta = space(10)
*     close data
*     close index
*     return
*  endif
*  select 3
*  store wprecod+whasta to wcodval
*  set exact off
*  find &wcodval
*  set exact on
*  if eof()
*     store "Esta valuacion no esta registrada, verifique" to mes
*     do aviso with mes
*     loop
*  endif
*  @ 19,7  SAY fecha
*  @ 19,28 SAY inspeccion
*  @ 19,44 SAY desde
*  @ 19,61 SAY hasta
*  store recno() to wfinval
   STORE "Opciones: (A)ceptar, (R)echazar" to mes
   store "A" to p1
   store "R" to p2
   store " " to resp
   do pide2 with p1,p2,mes,resp
   if resp = "R"
      loop
   endif
   set devi to print
   STORE 0 TO WTOTPREORI
   STORE 0 TO WTOTPREAUM
   STORE 0 TO WTOTPREDIS
   STORE 0 TO WTOTPREEXT
   STORE 0 TO WTOTPREMOD
   STORE 0 TO WPAGINA
   STORE 100 TO WLINEA
   select 2
   set exact off
   find &wprecod
   set exact on
   if eof()
      set devi to scre
      store "No existen partidas para este presupuesto" to mes
      set devi to scre
      do aviso with mes
      loop
   endif
   do while .not. eof() .and. parpre=wprecod
      store parcod       to wparcod
      store partipo      to wpartipo
      store parunid      to wparunid
      store parcant      to wparcantori
      if parasume > 0
         store parasume  to wparpuori
      else
         store parpreuni to wparpuori
      endif
      if wpartipo <> "T"
         store wparcantori*wparpuori to wpartotori
      else
         store 0                     to wpartotori
      endif
      store 0            to wcantproc
      store 0            to wboliproc
      store wlinea + 1   to wlinea
      IF WLINEA > 55
         @ 00,00 SAY CHR(18)
         @ 00,00 SAY CHR(14)+QQWW
         @ 01,00 SAY "CUADRO DE AUMENTOS Y DISMINUCIONES"
         @ 03,00 SAY "OBRA    :"+IPPPRESU->PREOBRA +IPPPRESU->PREOBRA2
         @ 04,00 SAY "         "+IPPPRESU->PREOBRA3+IPPPRESU->PREOBRA4
         @ 05,00 SAY "CONTRATO:"+IPPPRESU->PREREF
         @ 06,00 SAY "CLIENTE :"+IPPPRESU->PRECLIENTE
         @ 07,00 SAY CHR(15)
         @ 07,00 SAY "+----------------------------------------------------------------------------------------------------++----------------------++----------------------++----------------------------------++------------------------------------+"
         @ 08,00 SAY "|P R E S U P U E S T O    O R I G I N A L                                                            ||   A U M E N T O S    ||   D I S M I N U C.   ||     O B R A S    E X T R A S     ||        M O D I F I C A D O         |"
         @ 09,00 SAY "+-------------+----------------------------------------+----------+---------+-----------+------------++---------+------------++---------+------------++---------+-----------+------------++---------+-----------+--------------+"
         @ 10,00 SAY "|PARTIDA      |DESCRIPCION                             |UNIDAD    | CANTIDAD|PRECIO UNT.| MONTO (Bs.)|| CANTIDAD| MONTO (Bs.)|| CANTIDAD| MONTO (Bs.)|| CANTIDAD|PRECIO UNT.| MONTO (Bs.)|| CANTIDAD|PRECIO UNT.|  MONTO (Bs.) |"
         @ 11,00 SAY "+-------------+----------------------------------------+----------+---------+-----------+------------++---------+------------++---------+------------++---------+-----------+------------++---------+-----------+--------------+"
         STORE 12 TO WLINEA
      ENDIF
      @ WLINEA,00 SAY "|             |                                        |          |         |           |            ||         |            ||         |            ||         |           |            ||         |           |              |"
      @ WLINEA,01  SAY WPARCOD
      @ WLINEA,15  SAY PARDES1
      IF PARDES2 <> SPACE(40)
         STORE WLINEA + 1 TO WLINEA
         @ WLINEA,15 SAY PARDES2
         @ WLINEA,00 SAY "|             |                                        |          |         |           |            ||         |            ||         |            ||         |           |            ||         |           |              |"
      ENDIF
      IF PARDES3 <> SPACE(40)
         STORE WLINEA + 1 TO WLINEA
         @ WLINEA,15 SAY PARDES3
         @ WLINEA,00 SAY "|             |                                        |          |         |           |            ||         |            ||         |            ||         |           |            ||         |           |              |"
      ENDIF
      IF PARDES4 <> SPACE(40)
         STORE WLINEA + 1 TO WLINEA
         @ WLINEA,15 SAY PARDES4
         @ WLINEA,00 SAY "|             |                                        |          |         |           |            ||         |            ||         |            ||         |           |            ||         |           |              |"
      ENDIF
      IF PARDES5 <> SPACE(40)
         STORE WLINEA + 1 TO WLINEA
         @ WLINEA,15 SAY PARDES5
         @ WLINEA,00 SAY "|             |                                        |          |         |           |            ||         |            ||         |            ||         |           |            ||         |           |              |"
      ENDIF
      IF PARDES6 <> SPACE(40)
         STORE WLINEA + 1 TO WLINEA
         @ WLINEA,15 SAY PARDES6
         @ WLINEA,00 SAY "|             |                                        |          |         |           |            ||         |            ||         |            ||         |           |            ||         |           |              |"
      ENDIF
      @ WLINEA,56  SAY WPARUNID
      IF WPARTIPO = "T"
         SELECT 2
         SKIP
         LOOP
      ENDIF
      IF WPARTIPO <> "A"
         @ WLINEA,65   SAY STR(WPARCANTORI,11,2)
         @ WLINEA,77   SAY STR(WPARPUORI  ,11,2)
         @ WLINEA,90   SAY STR(WPARTOTORI ,11,2)
      ENDIF
      SELECT 3
      SET EXACT OFF
      FIND &WPRECOD
      SET EXACT ON
      DO WHILE .NOT. EOF() .AND. OBRA = WPRECOD
         STORE WPRECOD+VALUACION+WPARCOD TO WCLAVEVAL
         SELECT 4
         SET EXACT OFF
         FIND &WCLAVEVAL
         IF .NOT. EOF()
            STORE WCANTPROC + CANTIDAD              TO WCANTPROC
            STORE WBOLIPROC + (CANTIDAD*WPARPUORI)  TO WBOLIPROC
         ENDIF
         SELECT 3
         SKIP
      ENDDO
      STORE 0 TO WCANTAUM
      STORE 0 TO WBOLIAUM
      STORE 0 TO WCANTDIS
      STORE 0 TO WBOLIDIS
      STORE 0 TO WCANTEXT
      STORE 0 TO WBOLIEXT
      IF WPARTIPO <> "A"
         IF WCANTPROC>WPARCANTORI
            *** AUMENTOS
            STORE WCANTPROC-WPARCANTORI TO WCANTAUM
            @ WLINEA,103  SAY STR(WCANTAUM,9,2)
            STORE WCANTAUM*WPARPUORI TO WBOLIAUM
           @ WLINEA,113  SAY STR(WBOLIAUM,12,2)
         ELSE
            IF WCANTPROC<WPARCANTORI
               *** DISMINUCIONES
               STORE WPARCANTORI-WCANTPROC TO WCANTDIS
               @ WLINEA,127  SAY STR(WCANTDIS,9,2)
               STORE WCANTDIS*WPARPUORI TO WBOLIDIS
               @ WLINEA,137  SAY STR(WBOLIDIS,12,2)
            ENDIF
         ENDIF
      ELSE
         *** OBRAS EXTRAS
         STORE WCANTPROC TO WCANTEXT
         @ WLINEA,151 SAY STR(WCANTEXT,9,2)
         @ WLINEA,161 SAY STR(WPARPUORI,11,2)
         STORE WCANTEXT*WPARPUORI TO WBOLIEXT
         @ WLINEA,173 SAY STR(WBOLIEXT,12,2)
      ENDIF
      *** MODIFICADO
      STORE WCANTPROC   TO WCANTMOD
      STORE WBOLIPROC   TO WBOLIMOD
      @ WLINEA,187 SAY STR(WCANTMOD,9,2)
      @ WLINEA,197 SAY STR(WPARPUORI,11,2)
      @ WLINEA,211 SAY STR(WBOLIMOD,12,2)
      *** TOTALES
      IF WPARTIPO <> "A"
         STORE WTOTPREORI + WPARTOTORI  TO WTOTPREORI
      ENDIF
      STORE WTOTPREAUM + WBOLIAUM    TO WTOTPREAUM
      STORE WTOTPREDIS + WBOLIDIS    TO WTOTPREDIS
      STORE WTOTPREEXT + WBOLIEXT    TO WTOTPREEXT
      STORE WTOTPREMOD + WBOLIMOD    TO WTOTPREMOD
      STORE WLINEA + 1 TO WLINEA
      @ WLINEA,00 SAY "+-------------+----------------------------------------+----------+---------+-----------+------------++---------+------------++---------+------------++---------+-----------+------------++---------+-----------+--------------+"
      select 2
      skip
   enddo
   STORE WLINEA + 1 TO WLINEA
   @ WLINEA,000  SAY " T O T A L E S  :"
   @ WLINEA,087  SAY WTOTPREORI    PICTURE "###,###,###.##"
   @ WLINEA,111  SAY WTOTPREAUM    PICTURE "###,###,###.##"
   @ WLINEA,135  SAY WTOTPREDIS    PICTURE "###,###,###.##"
   @ WLINEA,171  SAY WTOTPREEXT    PICTURE "###,###,###.##"
   @ WLINEA,209  SAY WTOTPREMOD    PICTURE "###,###,###.##"
   @ WLINEA,00 SAY "|                                                                                                    ||                      ||                      ||                                  ||                                    |"
   STORE WLINEA + 1 TO WLINEA
   @ WLINEA,00 SAY "+----------------------------------------------------------------------------------------------------++----------------------++----------------------++----------------------------------++------------------------------------+"
   EJECT
   SET DEVI TO SCRE
enddo



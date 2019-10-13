SELECT 1
USE IPPTIEQP INDEX IPPTIEQP ALIAS EQUIPOS
STORE .T. TO MM
DO WHILE MM
   @ 5,0 CLEAR TO 15,70
*  @ 5,0 TO 15,70 DOUBLE
   @ 5,0  SAY "+------------------------------------------------------------------------------+"
   @ 6,0  SAY "|      M A N T E N I M I E N T O     D E     E Q U I P O S                     |"
   @ 7,0  SAY "+---------------+--------------------------------------------------------------+"
   @ 8,0  SAY "| CODIGO:       |DESCRIPCION:                                                  |"
   @ 09,0 SAY "+---------------+-----------------------------+--------------------------------+"
   @ 10,0 SAY "| TIPO:         |DEPRECIACION:                | PRECIO:                        |"
   @ 11,0 SAY "+---------------+-----------------------------+--------------------------------+"
   @ 12,0 SAY "| COSTO DIARIO:                               |"
   @ 13,0 SAY "+---------------------------------------------+"

   STORE SPACE(6) TO WEQPCOD
   STORE "Codigo de equipo a Procesar (*IMP*) = imprimir, (*?*) = consultar" to mes
   do MENSAJE WITH MES

   @ 8,9 GET WEQPCOD
   read
   store upper(wEQPcod) to wEQPcod
   if wEQPcod = "*IMP*"
      store "Indique el tipo de equipo a imprimir (Ù para imprimir todos)" to mes
      store space(3) to ztipo
      set color to w/n
      @ 23,1 say space(78)
      @ 23,40-(len(mes)/2) say mes
      @ 23,75 get ztipo
      read
      store upper(ztipo) to ztipo
      STORE 0 TO SALTAR
      DO CHKPRINT WITH SALTAR
      if salTAR = 1
         loop
      endif
      store "Imprimiendo equipos ..." to mes
      do mensaje with mes
      set devi to print
      STORE 1 TO PAGINA
      store "LISTADO DE EQUIPOS" TO HEAD
      STORE "--------" TO Q
      STORE Q+Q+Q+Q+Q+Q+Q+Q+Q TO Q
      @ 1,40-(len(RTRIM(QQWW))/2) say QQWW
      @ 2,1 SAY "FECHA:"+DTOC(WFECACT)
      @ 2,70 SAY "PAGINA:"+STR(PAGINA,3)
      @ 3,40-(len(HEAD)/2) say HEAD
      @ 5,0 SAY "CODIGO  DESCRIPCION                            TIPO       DEPREC.        PRECIO"
      STORE 6 TO LINE
      GO TOP
      DO WHILE .NOT. EOF()
         if ztipo <> space(3) .and. ztipo <> EQPtip
            skip
            loop
         endif
         @ LINE,0 SAY Q
         IF LINE > 50
            STORE PAGINA + 1 TO PAGINA
            @ 1,40-(len(RTRIM(QQWW))/2) say QQWW
            @ 2,1 SAY "FECHA:"+DTOC(WFECACT)
            @ 2,70 SAY "PAGINA:"+STR(PAGINA,3)
            @ 3,40-(len(HEAD)/2) say HEAD
            @ 5,0 SAY "CODIGO  DESCRIPCION                            TIPO       DEPREC.        PRECIO"
            STORE 6 TO LINE
         ENDIF
         @ LINE+1,1 SAY EQPCOD
         @ LINE+1,0 SAY CHR(15)
         @ LINE+1,15 SAY EQPDES
         @ LINE+1,0 SAY CHR(18)
         @ LINE+1,50 SAY EQPTIP
         @ LINE+1,58 SAY EQPdep
         @ LINE+1,68 SAY STR(EQPPRE,11,2)
         STORE LINE+2 TO LINE
         SKIP
      ENDDO
      @ LINE,0 SAY Q
      EJECT
      SET DEVI TO SCREE
      LOOP
   endif
   if wEQPcod = "*?*"
      save scre to save01
      set color to w+/b
      store "Indique el tipo de equipo a consultar (Ù para consultar todos)" to mes
      store space(3) to ztipo
      @ 23,1 say space(78)
      @ 23,40-(len(mes)/2) say mes
      @ 23,75 get ztipo
      read
      store upper(ztipo) to ztipo
      STORE 1 TO PAGINA
      store "LISTADO DE EQUIPOS" TO HEAD
      STORE "---------" TO Q
      STORE Q+Q+Q+Q+Q+Q+Q+Q TO Q
      @ 0,0 clear
      @ 1,40-(len(RTRIM(QQWW))/2) say QQWW
      @ 2,1 SAY "FECHA:"+DTOC(WFECACT)
      @ 2,70 SAY "PAGINA:"+STR(PAGINA,3)
      @ 3,40-(len(HEAD)/2) say HEAD
      @ 5,0 SAY "CODIGO  DESCRIPCION                            TIPO       DEPREC.        PRECIO"
      STORE 6 TO LINE
      GO TOP
      DO WHILE .NOT. EOF()
         if ztipo <> space(3) .and. ztipo <> EQPtip
            skip
            loop
         endif
         @ LINE,0 SAY Q
         IF LINE > 20
            store "oprima Ù para continuar" to mes
            do aviso with mes
            STORE PAGINA + 1 TO PAGINA
            @ 0,0 clear
            @ 1,40-(len(RTRIM(QQWW))/2) say QQWW
            @ 2,1 SAY "FECHA:"+DTOC(WFECACT)
            @ 2,70 SAY "PAGINA:"+STR(PAGINA,3)
            @ 3,40-(len(HEAD)/2) say HEAD
            @ 5,0 SAY "CODIGO  DESCRIPCION                            TIPO       DEPREC.        PRECIO"
            STORE 6 TO LINE
         ENDIF
         @ LINE+1,1 SAY EQPCOD
         @ LINE+1,8 SAY SUBSTR(EQPDES,1,30)
         @ LINE+1,50 SAY EQPTIP
         @ LINE+1,58 SAY EQPdep
         @ LINE+1,68 SAY STR(EQPPRE,11,2)
         STORE LINE+2 TO LINE
         SKIP
      ENDDO
      @ LINE,0 SAY Q
      store "oprima Ù para finalizar" to mes
      do aviso with mes
      restore scre from save01
      LOOP
   endif

   if wEQPcod = space(6)
      close data
      close index
      return
   endif
   find &wEQPcod
   if eof()
      store "Codigo no registrado: (I)ngresar, (S)alir" to mes
      store "I" to p1
      store "S" to p2
      store " " to resp
      do pide2 with p1,p2,mes,resp
      if resp = "S"
         loop
      endif
      store space(50) to wEQPdes
      store space(3)  to wEQPtip
      store 0.00      to wEQPdep
      store 0.00      to wEQPpre

      store "Descripcion del equipo" to mes
      do mensaje with mes
      @ 8,29 get wEQPdes
      read

      store "Tipo de equipo" to mes
      do MENSAJE with mes
      @ 10,7 get wEQPtip
      read

      store "Depreciacion del equipo" TO MES
      DO MENSAJE WITH MES
      @ 10,30 GET WEQPdep picture "####.#####"
      READ

      do while wEQPpre = 0.00
         STORE "Precio unitario del equipo" to mes
         do mensaje with mes
         @ 10,56 get wEQPpre picture "########.##"
         read
      enddo

      store wEQPdep*wEQPpre TO WPRECDIA
      @ 12,15 SAY STR(WPRECDIA,12,2)

      store "Opciones (A)ceptar, (R)echazar" to mes
      store "A" to p1
      store "R" to p2
      store " " to resp
      do pide2 with p1,p2,mes,resp
      if resp = "A"
         append blank
         replace EQPcod with wEQPcod
         replace EQPdes with wEQPdes
         replace EQPtip with wEQPtip
         replace EQPdep with wEQPdep
         replace EQPpre with wEQPpre
      endif
   else
      @ 8,29 say EQPdes
      @ 10,7 say EQPtip
      @ 10,30 say EQPdep
      @ 10,56 say EQPpre picture "########.##"
      store EQPdep*EQPpre TO WPRECDIA
      @ 12,15 SAY STR(WPRECDIA,12,2)

      store "Opciones (M)odificar, (E)liminar, (S)alir" to mes
      store "M" to p1
      store "E" to p2
      store "S" to p3
      store " " to resp
      do pide3 with p1,p2,p3,mes,resp
      store resp to funcion
      if funcion = "S"
         loop
      endif
      if funcion = "M"
         store EQPdes to wEQPdes
         store EQPtip to wEQPtip
         store EQPdep to wEQPdep
         store EQPpre to wEQPpre

         store "Descripcion del equipo" to mes
         do mensaje with mes
         @ 8,29 get wEQPdes
         read

         store "Tipo de equipo" to mes
         do MENSAJE with mes
         @ 10,7 get wEQPtip
         read

         store "Depreciacion del equipo" TO MES
         DO MENSAJE WITH MES
         @ 10,30 GET Weqpdep
         READ

         STORE "Precio unitario del equipo" to mes
         do mensaje with mes
         @ 10,56 get wEQPpre picture "########.##"
         read

         store wEQPdep*wEQPpre TO WPRECDIA
         @ 12,15 SAY STR(WPRECDIA,12,2)

         store "Opciones (A)ceptar, (R)echazar" to mes
         store "A" to p1
         store "R" to p2
         store " " to resp
         do pide2 with p1,p2,mes,resp
         if resp = "A"
            replace EQPcod with wEQPcod
            replace EQPdes with wEQPdes
            replace EQPtip with wEQPtip
            replace eqpdep with weqpdep
            replace EQPpre with wEQPpre
         endif
      endif
      if funcion = "E"
         select 2
         use ippEQuiP
         locate for EQuipcod = wEQPcod
         if found()
            store "ERROR, este equipo esta relacionado con el presupuesto "+EQUIPpre to mes
            do aviso with mes
            loop
         endif
         select 1
         store "Reorganizando archivo de equipo, Favor esperar..." to mes
         do mensaje with mes
         delete
         pack
         reindex
      endif
   endif
enddo


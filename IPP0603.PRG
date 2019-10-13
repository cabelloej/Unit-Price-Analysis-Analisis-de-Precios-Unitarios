SELECT 1
USE IPPTIMAT INDEX IPPTIMAT
STORE .T. TO MM
DO WHILE MM
   @ 5,0 CLEAR TO 15,70
*  @ 5,0 TO 15,70 DOUBLE
   @ 5,0  SAY "+------------------------------------------------------------------------------+"
   @ 6,0  SAY "|      M A N T E N I M I E N T O     D E     M A T E R I A L E S               |"
   @ 7,0  SAY "+---------------+--------------------------------------------------------------+"
   @ 8,0  SAY "| CODIGO:       |DESCRIPCION:                                                  |"
   @ 09,0 SAY "+---------------+-----------------------------+--------------------------------+"
   @ 10,0 SAY "| TIPO:         |UNIDAD DE MEDIDA:            | PRECIO:                        |"
   @ 11,0 SAY "+---------------+-----------------------------+--------------------------------+"
   STORE SPACE(6) TO WMATCOD
   STORE "Codigo del material a Procesar (*IMP*) = imprimir, (*?*) = consultar" to mes
   do MENSAJE WITH MES
   @ 8,9 GET WMATCOD
   read
   store upper(wmatcod) to wmatcod
   if wmatcod = "*IMP*"
      store "Indique el tipo de material a imprimir (Ù para imprimir todos)" to mes
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
      store "Imprimiendo Materiales ..." to mes
      do mensaje with mes
      set devi to print
      STORE 1 TO PAGINA
      store "LISTADO DE MATERIALES" TO HEAD
      STORE "---------" TO Q
      STORE Q+Q+Q+Q+Q+Q+Q+Q TO Q
      @ 1,40-(len(RTRIM(QQWW))/2) say QQWW
      @ 2,1 SAY "FECHA:"+DTOC(WFECACT)
      @ 2,70 SAY "PAGINA:"+STR(PAGINA,3)
      @ 3,40-(len(HEAD)/2) say HEAD
      @ 5,0 SAY "CODIGO  DESCRIPCION                            TIPO       UNIDAD         PRECIO"
      STORE 6 TO LINE
      GO TOP
      DO WHILE .NOT. EOF()
         if ztipo <> space(3) .and. ztipo <> mattip
            skip
            loop
         endif
         @ LINE,1 SAY Q
         IF LINE > 50
            STORE PAGINA + 1 TO PAGINA
            @ 1,40-(len(RTRIM(QQWW))/2) say QQWW
            @ 2,1 SAY "FECHA:"+DTOC(WFECACT)
            @ 2,70 SAY "PAGINA:"+STR(PAGINA,3)
            @ 3,40-(len(HEAD)/2) say HEAD
            @ 5,0 SAY "CODIGO  DESCRIPCION                            TIPO       UNIDAD         PRECIO"
            STORE 6 TO LINE
         ENDIF
         @ LINE+1,1 SAY MATCOD
         @ LINE+1,0 SAY CHR(15)
         @ LINE+1,15 SAY MATDES
         @ LINE+1,0 SAY CHR(18)
         @ LINE+1,50 SAY MATTIP
         @ LINE+1,58 SAY MATUND
         @ LINE+1,68 SAY STR(MATPRE,11,2)
         STORE LINE+2 TO LINE
         SKIP
      ENDDO
      @ LINE,1 SAY Q
      EJECT
      SET DEVI TO SCREE
      LOOP
   endif
   if wmatcod = "*?*"
      set color to w+/b
      save scre to save01
      store "Indique el tipo de material a consultar (Ù para consulatar todos)" to mes
      store space(3) to ztipo
      @ 23,1 say space(78)
      @ 23,40-(len(mes)/2) say mes
      @ 23,75 get ztipo
      read
      store upper(ztipo) to ztipo
      STORE 1 TO PAGINA
      store "LISTADO DE MATERIALES" TO HEAD
      STORE "---------" TO Q
      STORE Q+Q+Q+Q+Q+Q+Q+Q TO Q
      @ 0,0 clear
      @ 1,40-(len(RTRIM(QQWW))/2) say QQWW
      @ 2,1 SAY "FECHA:"+DTOC(WFECACT)
      @ 2,70 SAY "PAGINA:"+STR(PAGINA,3)
      @ 3,40-(len(HEAD)/2) say HEAD
      @ 5,0 SAY "CODIGO  DESCRIPCION                            TIPO       UNIDAD         PRECIO"
      STORE 6 TO LINE
      GO TOP
      DO WHILE .NOT. EOF()
         if ztipo <> space(3) .and. ztipo <> mattip
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
            @ 5,0 SAY "CODIGO  DESCRIPCION                            TIPO       UNIDAD         PRECIO"
            STORE 6 TO LINE
         ENDIF
         @ LINE+1,1 SAY MATCOD
         @ LINE+1,8 SAY SUBSTR(MATDES,1,30)
         @ LINE+1,50 SAY MATTIP
         @ LINE+1,58 SAY MATUND
         @ LINE+1,68 SAY STR(MATPRE,11,2)
         STORE LINE+2 TO LINE
         SKIP
      ENDDO
      @ LINE,1 SAY Q
      store "oprima Ù para finalizar" to mes
      do aviso with mes
      restore scre from save01
      LOOP
   endif


   if wmatcod = space(6)
      close data
      close index
      return
   endif
   find &wmatcod
   if eof()
      store "Codigo no registrado: (I)ngresar, (S)alir" to mes
      store "I" to p1
      store "S" to p2
      store " " to resp
      do pide2 with p1,p2,mes,resp
      if resp = "S"
         loop
      endif
      store space(50) to wmatdes
      store space(3)  to wmattip
      store space(10) to wmatund
      store 0.00      to wmatpre

      store "Descripcion del material" to mes
      do mensaje with mes
      @ 8,29 get wmatdes
      read

      store "Tipo de material" to mes
      do MENSAJE with mes
      @ 10,7 get wmattip
      read

      store "Unidad de medida del material, ejemplo: M2,SACOS,KILOS,M3, ETC." TO MES
      DO MENSAJE WITH MES
      @ 10,35 GET WMATUND
      READ

      do while wmatpre = 0.00
         STORE "Precio unitario del material" to mes
         do mensaje with mes
         @ 10,56 get wmatpre picture "#######.##"
         read
      enddo

      store "Opciones (A)ceptar, (R)echazar" to mes
      store "A" to p1
      store "R" to p2
      store " " to resp
      do pide2 with p1,p2,mes,resp
      if resp = "A"
         append blank
         replace matcod with wmatcod
         replace matdes with wmatdes
         replace mattip with wmattip
         replace matund with wmatund
         replace matpre with wmatpre
      endif
   else
      @ 8,29 say matdes
      @ 10,7 say mattip
      @ 10,35 say MATUND
      @ 10,35 say MATUND
      @ 10,56 say matpre picture "#######.##"
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
         store matdes to wmatdes
         store mattip to wmattip
         store matund to wmatund
         store matpre to wmatpre

         store "Descripcion del material" to mes
         do mensaje with mes
         @ 8,29 get wmatdes
         read

         store "Tipo de material" to mes
         do MENSAJE with mes
         @ 10,7 get wmattip
         read

         store "Unidad de medida del material, ejemplo: M2,SACOS,KILOS,M3, ETC." TO MES
         DO MENSAJE WITH MES
         @ 10,35 GET WMATUND
         READ

         STORE "Precio unitario del material" to mes
         do mensaje with mes
         @ 10,56 get wmatpre picture "#######.##"
         read

         store "Opciones (A)ceptar, (R)echazar" to mes
         store "A" to p1
         store "R" to p2
         store " " to resp
         do pide2 with p1,p2,mes,resp
         if resp = "A"
            replace matcod with wmatcod
            replace matdes with wmatdes
            replace mattip with wmattip
            replace matund with wmatund
            replace matpre with wmatpre
         endif
      endif
      if funcion = "E"
         select 2
         use ippmater
         locate for matercod = wmatcod
         if found()
            store "ERROR, este material esta relacionado con el presupuesto "+materpre to mes
            do aviso with mes
            loop
         endif
         select 1
         store "Reorganizando archivo de materiales, Favor esperar..." to mes
         do mensaje with mes
         delete
         pack
         reindex
      endif
   endif
enddo


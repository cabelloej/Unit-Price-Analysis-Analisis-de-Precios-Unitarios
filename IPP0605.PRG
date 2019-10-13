SELECT 1
USE IPPTImdo INDEX IPPTImdo
STORE .T. TO MM
DO WHILE MM
   @ 5,0 CLEAR TO 15,70
*  @ 5,0 TO 15,70 DOUBLE
   @ 5,0  SAY "+------------------------------------------------------------------------------+"
   @ 6,0  SAY "|    M A N T E N I M I E N T O     D E     M A N O   D E   O B R A             |"
   @ 7,0  SAY "+---------------+--------------------------------------------------------------+"
   @ 8,0  SAY "| CODIGO:       |DESCRIPCION:                                                  |"
   @ 09,0 SAY "+---------------+-----------------------------+--------------------------------+"
   @ 10,0 SAY "| TIPO:         |BONO COMPENSATORIO:          | JORNAL:                        |"
   @ 11,0 SAY "+---------------+-----------------------------+--------------------------------+"
   STORE SPACE(6) TO WmdoCOD
   STORE "Codigo de mano de obra. (*IMP*) = imprimir, (*?*) = consultar" to mes
   do MENSAJE WITH MES

   @ 8,9 GET WmdoCOD
   read
   store upper(wmdocod) to wmdocod
   if wmdocod = "*IMP*"
      store "Indique el tipo de mano de obra a imprimir (Ù para imprimir todos)" to mes
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
      store "Imprimiendo mano de obra ..." to mes
      do mensaje with mes
      set devi to print
      STORE 1 TO PAGINA
      store "LISTADO DE MANO DE OBRA" TO HEAD
      STORE "---------" TO Q
      STORE Q+Q+Q+Q+Q+Q+Q+Q TO Q
      @ 1,40-(len(RTRIM(QQWW))/2) say QQWW
      @ 2,1 SAY "FECHA:"+DTOC(WFECACT)
      @ 2,70 SAY "PAGINA:"+STR(PAGINA,3)
      @ 3,40-(len(HEAD)/2) say HEAD
      @ 5,0 SAY "CODIGO  DESCRIPCION                            TIPO                      JORNAL"
      STORE 6 TO LINE
      GO TOP
      DO WHILE .NOT. EOF()
         if ztipo <> space(3) .and. ztipo <> mdotip
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
            @ 5,0 SAY "CODIGO  DESCRIPCION                            TIPO                      JORNAL"
            STORE 6 TO LINE
         ENDIF
         @ LINE+1,1 SAY mdoCOD
         @ LINE+1,0 SAY CHR(15)
         @ LINE+1,15 SAY mdoDES
         @ LINE+1,0 SAY CHR(18)
         @ LINE+1,50 SAY mdoTIP
         @ LINE+1,68 SAY STR(MDOJOR,11,2)
         STORE LINE+2 TO LINE
         SKIP
      ENDDO
      @ LINE,1 SAY Q
      EJECT
      SET DEVI TO SCREE
      LOOP
   endif
   if wmdocod = "*?*"
      save scre to save01
      store "Indique el tipo de mano de obra a consultar (Ù para consultar todos)" to mes
      store space(3) to ztipo
      @ 23,1 say space(78)
      @ 23,40-(len(mes)/2) say mes
      @ 23,75 get ztipo
      read
      store upper(ztipo) to ztipo
      STORE 1 TO PAGINA
      store "LISTADO DE MANO DE OBRA" TO HEAD
      STORE "---------" TO Q
      STORE Q+Q+Q+Q+Q+Q+Q+Q TO Q
      @ 0,0 clear
      @ 1,40-(len(RTRIM(QQWW))/2) say QQWW
      @ 2,1 SAY "FECHA:"+DTOC(WFECACT)
      @ 2,70 SAY "PAGINA:"+STR(PAGINA,3)
      @ 3,40-(len(HEAD)/2) say HEAD
      @ 5,0 SAY "CODIGO  DESCRIPCION                            TIPO                      JORNAL"
      STORE 6 TO LINE
      GO TOP
      DO WHILE .NOT. EOF()
         if ztipo <> space(3) .and. ztipo <> mdotip
            skip
            loop
         endif

         @ LINE,0 SAY Q
         IF LINE > 20
            store "Oprima Ù para continuar" to mes
            do aviso with mes
            STORE PAGINA + 1 TO PAGINA
            @ 0,0 clear
            @ 1,40-(len(RTRIM(QQWW))/2) say QQWW
            @ 2,1 SAY "FECHA:"+DTOC(WFECACT)
            @ 2,70 SAY "PAGINA:"+STR(PAGINA,3)
            @ 3,40-(len(HEAD)/2) say HEAD
            @ 5,0 SAY "CODIGO  DESCRIPCION                            TIPO                      JORNAL"
            STORE 6 TO LINE
         ENDIF
         @ LINE+1,1 SAY mdoCOD
         @ LINE+1,8 SAY SUBSTR(mdoDES,1,30)
         @ LINE+1,50 SAY mdoTIP
         @ LINE+1,68 SAY STR(MDOJOR,11,2)
         STORE LINE+2 TO LINE
         SKIP
      ENDDO
      @ LINE,0 SAY Q
      store "Oprima  Ù para finalizar" to mes
      do aviso with mes
      restore scre from save01
      LOOP
   endif


   if wmdocod = space(6)
      close data
      close index
      return
   endif
   find &wmdocod
   if eof()
      store "Codigo no registrado: (I)ngresar, (S)alir" to mes
      store "I" to p1
      store "S" to p2
      store " " to resp
      do pide2 with p1,p2,mes,resp
      if resp = "S"
         loop
      endif
      store space(50) to wmdodes
      store space(3)  to wmdotip
      store 0.00      to wMDOJOR
      STORE 0 TO  WBONO
      store "Descripcion del mano de obra" to mes
      do mensaje with mes
      @ 8,29 get wmdodes
      read

      store "Tipo de mano de obra" to mes
      do MENSAJE with mes
      @ 10,7 get wmdotip
      read

      store "Ingrese el monto dirario por concepto de bono compensatorio." to mes
      do MENSAJE with mes
      @ 10,38 get wbono picture "####.##"
      read

      do while wMDOJOR = 0.00
         STORE "Precio unitario del mano de obra" to mes
         do mensaje with mes
         @ 10,56 get wMDOJOR picture "#######.##"
         read
      enddo

      store "Opciones (A)ceptar, (R)echazar" to mes
      store "A" to p1
      store "R" to p2
      store " " to resp
      do pide2 with p1,p2,mes,resp
      if resp = "A"
         append blank
         replace mdocod with wmdocod
         replace mdodes with wmdodes
         replace mdotip with wmdotip
         replace MDOJOR with wMDOJOR
         replace mdobon with wbono
      endif
   else
      @ 8,29 say mdodes
      @ 10,7 say mdotip
      @ 10,38 say mdobon picture "###.##"
      @ 10,56 say MDOJOR picture "#######.##"
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
         store mdodes to wmdodes
         store mdotip to wmdotip
         store MDOJOR to wMDOJOR
         store mdobon to wbono

         store "Descripcion del mano de obra" to mes
         do mensaje with mes
         @ 8,29 get wmdodes
         read

         store "Tipo de mano de obra" to mes
         do MENSAJE with mes
         @ 10,7 get wmdotip
         read
   
         store "Ingrese el monto dirario por concepto de bono compensatorio." to mes
         do MENSAJE with mes
         @ 10,38 get wbono picture "####.##"
         read
   
         STORE "Precio unitario del mano de obra" to mes
         do mensaje with mes
         @ 10,56 get wMDOJOR picture "#######.##"
         read

         store "Opciones (A)ceptar, (R)echazar" to mes
         store "A" to p1
         store "R" to p2
         store " " to resp
         do pide2 with p1,p2,mes,resp
         if resp = "A"
            replace mdocod with wmdocod
            replace mdodes with wmdodes
            replace mdotip with wmdotip
            replace MDOJOR with wMDOJOR
            replace mdobon with wbono
         endif
      endif
      if funcion = "E"
         select 2
         use ippmdo
         locate for mOBRAcod = wmdocod
         if found()
            store "ERROR, este mano de obra esta relacionado con el presupuesto "+mOBRApre to mes
            do aviso with mes
            loop
         endif
         select 1
         store "Reorganizando archivo de mano de obraes, Favor esperar..." to mes
         do mensaje with mes
         delete
         pack
         reindex
      endif
   endif
enddo


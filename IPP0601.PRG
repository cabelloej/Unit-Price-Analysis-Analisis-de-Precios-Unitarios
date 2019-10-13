*********************************
* mantenimiento de presupuestos *
*********************************
set confirm off
SELECT 1
USE IPPPRESU INDEX IPPPRESU ALIAS PRESUP
SET COLOR TO W/N
STORE .T. TO PRE
DO WHILE PRE
   SET COLOR TO W/N
   @ 05,0 CLEAR TO 21,79
   @ 05,0 SAY "+------------------------------------------------------------------------------+"
   @ 06,0 SAY "|       M A N T E N I M I E N T O     D E      P R E S U P U E S T O S         |"
   @ 07,0 SAY "+------------------+---------------+-------------------------------------------+"
   @ 08,0 SAY "|CODIGO:           |FECHA:         |CLIENTE:                                   |"
   @ 09,0 SAY "+------------------+---------------+-------------------------------------------+"
   @ 10,0 SAY "|DIRECCION:                                                                    |"
   @ 11,0 SAY "+------------------------------------------------------------------------------+"
   @ 12,0 SAY " OBRA:                                                                          "
   @ 13,0 SAY "                                                                                "
   @ 14,0 SAY "                                                                                "
   @ 15,0 SAY "                                                                                "
   @ 16,0 SAY "+---------------------------------+--------------------------------------------+"
   @ 17,0 SAY "|REFERENCIA:                      |"
   @ 18,0 SAY "+---------------------------------+"
   STORE SPACE(10) TO WPRECOD
   STORE "Codigo de Presupuesto a procesar. (*IMP*) = Imprimir, (*?*) = consultar" to mes
   do mensaje with mes
   @ 8,8 GET WPRECOD
   READ
   STORE UPPER(WPRECOD) TO WPRECOD
   if wprecod = "*IMP*"
      STORE 0 TO SALTAR
      DO CHKPRINT WITH SALTAR
      if salTAR = 1
         loop
      endif
      store "Imprimiendo Presupuestos ..." to mes
      do mensaje with mes
      set devi to print
      STORE 1 TO PAGINA
      store "LISTADO DE PRESUPUESTOS" TO HEAD
      STORE "----------" TO Q
      STORE Q+Q+Q+Q+Q+Q+Q+Q TO Q
      @ 1,40-(len(RTRIM(QQWW))/2) say QQWW
      @ 2,1 SAY "FECHA:"+DTOC(WFECACT)
      @ 2,70 SAY "PAGINA:"+STR(PAGINA,3)
      @ 3,40-(len(HEAD)/2) say HEAD
      STORE 5 TO LINE
      GO TOP
      DO WHILE .NOT. EOF()
         @ LINE,1 SAY Q
         IF LINE > 50
            STORE PAGINA + 1 TO PAGINA
            @ 1,40-(len(RTRIM(QQWW))/2) say QQWW
            @ 2,1 SAY "FECHA:"+DTOC(WFECACT)
            @ 2,70 SAY "PAGINA:"+STR(PAGINA,3)
            @ 3,40-(len(HEAD)/2) say HEAD
            STORE 5 TO LINE
         ENDIF
         @ LINE+1,1 SAY "CODIGO:"+PRECOD
         @ LINE+1,30 SAY "OBRA:"+PREOBRA
         @ LINE+2,1  SAY "FECHA:"+DTOC(PREDATE)
         @ LINE+2,30 SAY "CLIENTE:"+PRECLIENTE
         @ LINE+3,1 SAY  "REF.:"+PREREF
         @ LINE+3,30 SAY "DIRECCION:"+PREDIR
         STORE LINE+4 TO LINE
         SKIP
      ENDDO
      @ LINE+1,1 SAY Q
      EJECT
      SET DEVI TO SCREE
      LOOP
   endif

   if wprecod = "*?*"
      SAVE SCREE TO SAVE01
      @ 0,0 clear
      STORE 1 TO PAGINA
      store "LISTADO DE PRESUPUESTOS" TO HEAD
      STORE "----------" TO Q
      STORE Q+Q+Q+Q+Q+Q+Q+Q TO Q
      @ 1,40-(len(RTRIM(QQWW))/2) say QQWW
      @ 2,1 SAY "FECHA:"+DTOC(WFECACT)
      @ 2,70 SAY "PAGINA:"+STR(PAGINA,3)
      @ 3,40-(len(HEAD)/2) say HEAD
      STORE 5 TO LINE
      GO TOP
      DO WHILE .NOT. EOF()
         @ LINE,0 SAY Q
         IF LINE > 15
            STORE "Oprima Ù para continuar" to mes
            do aviso with mes
            STORE PAGINA + 1 TO PAGINA
            @ 0,0 clear
            @ 1,40-(len(RTRIM(QQWW))/2) say QQWW
            @ 2,1 SAY "FECHA:"+DTOC(WFECACT)
            @ 2,70 SAY "PAGINA:"+STR(PAGINA,3)
            @ 3,40-(len(HEAD)/2) say HEAD
            STORE 5 TO LINE
         ENDIF
         @ LINE+1,1 SAY "CODIGO:"+PRECOD
         @ LINE+1,30 SAY "OBRA:"+PREOBRA
         @ LINE+2,1  SAY "FECHA:"+DTOC(PREDATE)
         @ LINE+2,30 SAY "CLIENTE:"+PRECLIENTE
         @ LINE+3,1 SAY  "REF.:"+PREREF
         @ LINE+3,30 SAY "DIRECCION:"+PREDIR
         STORE LINE+4 TO LINE
         SKIP
      ENDDO
      @ LINE,0 SAY Q
      STORE "Oprima Ù para salir" to mes
      do aviso with mes
      restore scre from save01
      LOOP
   endif

   if wprecod = space(10)
      set confirm on
      close data
      close index 
      return
   endif
   FIND &WPRECOD
   IF EOF()
      STORE "Codigo de presupuesto no registrado, Desea ingresar (S/N)" to mes
      store "S" to p1
      store "N" to p2
      store " " to resp
      do pide2 with p1,p2,mes,resp
      if resp <> "S"
         loop
      endif
      store ctod("  -  -  ") to wfecha
      store space(30)        to wcliente
      store space(59)        to wpredir
      store space(39)        to wpreobra
      store space(39)        to wpreobra2
      store space(39)        to wpreobra3
      store space(39)        to wpreobra4
      store space(10)        to wpreref
      @ 8,26 get wfecha
      read
      @ 8,44 get wcliente
      read
      @ 10,11 get wpredir
      read
      @ 13,01 get wpreobra
      @ 13,40 get wpreobra2
      @ 14,01 get wpreobra3
      @ 14,40 get wpreobra4
      read
      @ 17,12 get wpreref
      read
      store "Opciones: (A)ceptar, (R)echazar" to mes
      store "A" to p1
      store "R" to p2
      store " " to resp
      do pide2 with p1,p2,mes,resp
      if resp = "A"
         append blank
         replace precod     with wprecod
         replace predate    with wfecha
         replace precliente with wcliente
         replace predir     with wpredir
         replace preobra    with wpreobra
         replace preobra2   with wpreobra2
         replace preobra3   with wpreobra3
         replace preobra4   with wpreobra4
         replace preref     with wpreref
      endif
   else
      @ 8,26  say PREDATE
      @ 8,44  say PRECLIENTE
      @ 10,11 say predir
      @ 13,01 say preobra
      @ 13,40 say preobra2
      @ 14,01 say preobra3
      @ 14,40 say preobra4
      @ 17,12 say preref
      stoRe "Opciones: (M)odificar, (E)liminar, (S)alir" to mes
      store "M" to p1
      store "E" to p2
      store "S" to p3
      store " " to resp
      do pide3 with p1,p2,p3,mes,resp
      if resp = "M"
         store predate          to wfecha
         store precliente       to wcliente
         store predir           to wpredir
         store preobra          to wpreobra
         store preobra2         to wpreobra2
         store preobra3         to wpreobra3
         store preobra4         to wpreobra4
         store preref           to wpreref
         @ 8,26 get wfecha
         read
         @ 8,44 get wcliente
         read
         @ 10,11 get wpredir
         read
         @ 13,01 get wpreobra
         @ 13,40 get wpreobra2
         @ 14,01 get wpreobra3
         @ 14,40 get wpreobra4
         read
         @ 17,12 get wpreref
         read
         store "Opciones: (A)ceptar, (R)echazar" to mes
         store "A" to p1
         store "R" to p2
         store " " to resp
         do pide2 with p1,p2,mes,resp
         if resp = "A"
            replace precod     with wprecod
            replace predate    with wfecha
            replace precliente with wcliente
            replace predir     with wpredir
            replace preobra    with wpreobra
            replace preobra2   with wpreobra2
            replace preobra3   with wpreobra3
            replace preobra4   with wpreobra4
            replace preref     with wpreref
         endif
      endif
      IF RESP = "E"
         STORE "Advertencia: Esta operacion eliminara las partidas asociadas. Clave:" to mes
         do mensaje with mes
         store space(5) to wclave
         set color to n/n
         set intensity off
         @ 23,73 get wclave
         read
         set color to w/n
         set intensity on
         if  upper(wclave) <> "IPPOK"
             loop
         endif
         STORE "Comando en progreso, favor esperar..." to mes
         do MENSAJE with mes
         SELECT 1
         delete
*        pack
         select 2
         use ippparti index ipppart1,ipppart2
         delete all for parpre = wprecod
*        pack
         SELECT 3
         USE IPPMATER INDEX IPPMATER
         DELETE ALL FOR MATERPRE = WPRECOD
*        PACK
         SELECT 3
         use ippequip index ippequip
         delete all for equippre = wprecod
*        pack
         select 3
         use ippmdo index ippmdo
         delete all for mobrapre = wprecod
*        pack
         select 1
      endif
   endif
ENDDO


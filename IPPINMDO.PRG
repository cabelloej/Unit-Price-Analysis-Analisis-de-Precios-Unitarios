*****************************
* INGRESO DE MANO DE OBRA   *
*****************************
select 3
use ippmdo index ippmdo
SELECT 4
USE IPPTImdo INDEX IPPTImdo
SELECT 5
USE IPPEQUIP INDEX IPPEQUIP
SELECT 6
USE IPPTIEQP INDEX IPPTIEQP
@ 4,0 CLEAR TO 15,79
@ 4,1 SAY "CODIGO"
@ 4,15 SAY "DESCRIPCION"
@ 4,55 SAY "CANTIDAD"

STORE 4 TO LINE
STORE WPARPRE+WPARCOD TO WCLAVEEJC
SELECT 5
SET EXACT OFF
FIND &WCLAVEEJC
SET EXACT ON
DO WHILE .NOT. EOF() .AND. EQUIPPRE = WPARPRE .AND. EQUIPPAR = WPARCOD
    STORE EQUIPCOD TO WXXX
    SELECT 6
    FIND &WXXX
    IF EOF()
       STORE "NO REGISTRADO" TO WWDE
       ELSE
       STORE EQPDES TO WWDE
    ENDIF
   SELECT 5
   STORE LINE+1 TO LINE
   @ LINE,1 SAY EQUIPCOD
   @ LINE,15 SAY WWDE
   @ LINE,55 SAY STR(EQUIPCAN,11,2)
   SKIP
ENDDO
SELECT 5
USE
SELECT 6
USE
SET COLOR TO W/N
STORE .T. TO mdo
DO WHILE mdo
   SET COLOR TO W/N
   @ 16,0 CLEAR TO 21,79
   @ 16,0 SAY "|------------------------------+---------++---------+-+----------++------------|"
   @ 17,0 SAY "|  DESCRIPCION DE MANO DE OBRA |CANTIDAD  | JORNAL    | BONO COM.|  BOLIVARES  |"
   @ 18,0 SAY "|------------------------------+----------+-----------+----------+-------------|"
   @ 19,0 SAY "|                              |          |           |          |             |"
   @ 20,0 SAY "+------------------------------+----------+--- -------+----------+-------------+"
   STORE SPACE(6) TO WMDOCOD
   store 0 to wmdocant
   STORE "Codigo de la mano de obra. (*IMP*) = imprimir, (*?*) = consultar" to mes
   do mensaje with mes
   @ 19,1 GET Wmdocod
   READ
   STORE UPPER(Wmdocod) TO Wmdocod
   if wmdocod = space(6)
      return
   endif
   if WMDOcod = "*IMP*"
      select 3
      go top
      STORE 0 TO SALIDA
      DO CHKPRINT WITH SALIDA
      if salida = 1
         loop
      endif
      store "Imprimiendo Mano de Obra de esta Partida ..." to mes
      do mensaje with mes
      set devi to print
      STORE 1 TO PAGINA
      store "LISTADO DE MANO DE OBRA DE LA PARTIDA "+WPARCOD+" DEL PRESUPUESTO:" TO HEAD
      STORE WPREOBRA TO HEAD2
      STORE "----------" TO Q
      STORE Q+Q+Q+Q+Q+Q+Q+Q TO Q
      @ 1,40-(len(RTRIM(QQWW))/2) say QQWW
      @ 2,1 SAY "FECHA:"+DTOC(WFECACT)
      @ 2,70 SAY "PAGINA:"+STR(PAGINA,3)
      @ 3,40-(len(HEAD)/2) say HEAD
      @ 4,40-(len(HEAD2)/2) say HEAD2
      @ 6,1 SAY "CODIGO"
      @ 6,20 SAY "DESCRIPCION"
      @ 6,50 SAY "CANTIDAD"
      @ 6,64 SAY "JORNAL"
      @ 6,73 SAY "BOLIVARES"
      STORE 7 TO LINE
      GO TOP
      DO WHILE .NOT. EOF()
         IF MOBRAPRE <> WPARPRE .OR. MOBRAPAR <> WPARCOD
            SKIP
            LOOP
         ENDIF
         @ LINE,1 SAY Q
         IF LINE > 50
            STORE PAGINA + 1 TO PAGINA
            @ 1,40-(len(RTRIM(QQWW))/2) say QQWW
            @ 2,1 SAY "FECHA:"+DTOC(WFECACT)
            @ 2,70 SAY "PAGINA:"+STR(PAGINA,3)
            @ 3,40-(len(HEAD)/2) say HEAD
            @ 4,40-(len(HEAD2)/2) say HEAD2
            @ 6,1 SAY "CODIGO"
            @ 6,20 SAY "DESCRIPCION"
            @ 6,50 SAY "CANTIDAD"
            @ 6,64 SAY "JORNAL"
            @ 6,73 SAY "BOLIVARES"
            STORE 7 TO LINE
         ENDIF
         STORE LINE+1 TO LINE
         STORE MOBRACOD TO WMOBRACOD
         SELECT 4
         FIND &WMOBRACOD
         IF EOF()
            STORE "NO REGISTRADO" TO WMDODES
            ELSE
            STORE MDODES TO WMDODES
         ENDIF
         SELECT 3
         @ LINE,1    SAY MOBRACOD
         @ LINE,8    SAY SUBSTR(WMDODES,1,30)
         @ LINE,45   SAY STR(MOBRANUM,11,2)
         @ LINE,59   SAY STR(MOBRAJOR,11,2)
         STORE MOBRAJOR*MOBRANUM TO WMDOBS
         @ LINE,70   SAY STR(WMDOBS,11,2)
         STORE LINE+1 TO LINE
         SKIP
      ENDDO
      @ LINE+1,1 SAY Q
      EJECT
      SET DEVI TO SCREE
      LOOP
   endif
   if WMDOcod = "*?*"
      save scre to save01
      select 3
      go top
      STORE 1 TO PAGINA
      store "LISTADO DE MANO DE OBRA DE LA PARTIDA "+WPARCOD+" DEL PRESUPUESTO:" TO HEAD
      STORE WPREOBRA TO HEAD2
      STORE "----------" TO Q
      STORE Q+Q+Q+Q+Q+Q+Q+Q TO Q
      @ 0,0 clear
      @ 1,40-(len(RTRIM(QQWW))/2) say QQWW
      @ 2,1 SAY "FECHA:"+DTOC(WFECACT)
      @ 2,70 SAY "PAGINA:"+STR(PAGINA,3)
      @ 3,40-(len(HEAD)/2) say HEAD
      @ 4,40-(len(HEAD2)/2) say HEAD2
      @ 6,1 SAY "CODIGO"
      @ 6,20 SAY "DESCRIPCION"
      @ 6,50 SAY "CANTIDAD"
      @ 6,60 SAY "JORNAL"
      @ 6,70 SAY "BOLIVARES"
      STORE 7 TO LINE
      GO TOP
      DO WHILE .NOT. EOF()
         IF MOBRAPRE <> WPARPRE .OR. MOBRAPAR <> WPARCOD
            SKIP
            LOOP
         ENDIF
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
            @ 4,40-(len(HEAD2)/2) say HEAD2
            @ 6,1 SAY "CODIGO"
            @ 6,20 SAY "DESCRIPCION"
            @ 6,50 SAY "CANTIDAD"
            @ 6,60 SAY "JORNAL"
            @ 6,70 SAY "BOLIVARES"
            STORE 7 TO LINE
         ENDIF
         STORE LINE+1 TO LINE
         STORE MOBRACOD TO WMOBRACOD
         SELECT 4
         FIND &WMOBRACOD
         IF EOF()
            STORE "NO REGISTRADO" TO WMDODES
            ELSE
            STORE MDODES TO WMDODES
         ENDIF
         SELECT 3
         @ LINE,1    SAY MOBRACOD
         @ LINE,8    SAY SUBSTR(WMDODES,1,30)
         @ LINE,45   SAY STR(MOBRANUM,11,2)
         @ LINE,58   SAY STR(MOBRAJOR,11,2)
         STORE MOBRAJOR*MOBRANUM TO WMDOBS
         @ LINE,69   SAY STR(WMDOBS,11,2)
         STORE LINE+1 TO LINE
         SKIP
      ENDDO
      @ LINE,0 SAY Q
      store "Oprima Ù para finalizar" to mes
      do aviso with mes
      restore scre from save01
      LOOP
   endif

   if WMDOcod = "*??*"
      save scre to save01
      select 4
      go top
      STORE 1 TO PAGINA
      STORE 100 TO LINE
      store "LISTADO DEL MAESTRO DE MANO DE OBRA" TO HEAD
      STORE WPREOBRA TO HEAD2
      GO TOP
      DO WHILE .NOT. EOF()
         STORE LINE+1 TO LINE
         IF LINE > 20
            store "Oprima Ù para continuar, <ESC> para salir" to mes
            do aviso with mes
            if readkey()=12.or.readkey()=268
               exit
            endif
            STORE PAGINA + 1 TO PAGINA
            @ 0,0 clear
            @ 1,40-(len(RTRIM(QQWW))/2) say QQWW
            @ 2,1 SAY "FECHA:"+DTOC(WFECACT)
            @ 2,70 SAY "PAGINA:"+STR(PAGINA,3)
            @ 3,40-(len(HEAD)/2) say HEAD
            @ 4,40-(len(HEAD2)/2) say HEAD2
            @ 6,1 SAY "CODIGO"
            @ 6,20 SAY "DESCRIPCION"
            @ 7,1 SAY replicate("-",78)
            STORE 8 TO LINE
         ENDIF
         @ LINE,1    SAY MDOCOD
         @ LINE,8    SAY MDODES
         SKIP
      ENDDO
      store "Oprima Ù para finalizar" to mes
      do aviso with mes
      restore scre from save01
      LOOP
   endif
   select 4
   FIND &Wmdocod
   store 0 to inmat
   IF EOF()
      STORE "Codigo de mano de obra no registrado. Actualizar Sistema? (S/N)" to mes
      store "S" to p1
      store "N" to p2
      store " " to resp
      do pide2 with p1,p2,mes,resp
      if resp = "S"
         store 1 to inmat
         store space(30) to wmdodes
         store 0.00 to wmdopre
         STORE 0.00 TO WMDOBON
         store 0.00 to wmdocant
      else
         store 0 to inmat
         loop
      endif
   else
      store mdodes to wmdodes
      store mdojor to wmdopre
      STORE MDOBON TO WMDOBON
      @ 19,1 say  SUBSTR(mdodes,1,30)
      @ 19,43 say mdojor picture "########.##"
      @ 19,56 SAY MDOBON PICTURE "###.##"
   endif

   store wparpre+wparcod+wmdocod to clave
   select 3
   STORE  0 TO FLAGMOD
   find &clave
   if .not. eof()
      @ 19,1 say SUBSTR(wmdodes,1,30)
      @ 19,32 say mobranum picture "#######.##"
      @ 19,43 say mobrajor picture "########.##"
      @ 19,56 SAY MOBRABON PICTURE "###.##"
      @ 19,68 say mobranum*(mobrajor+MOBRABON) picture "########.##"
      store "Opciones: (M)odificar, (E)liminar, (S)alir" to mes
      store "M" to p1
      store "E" to p2
      store "S" to p3
      STORE " " TO RESP
      DO PIDE3 WITH P1,P2,P3,MES,RESP
      IF RESP = "E"
         DELETE
         PACK
         LOOP
      ENDIF
      IF RESP = "S"
         LOOP
      ENDIF
      STORE 1 TO FLAGMOD
      STORE MOBRANUM TO WMDOCANT
      STORE MOBRAJOR TO WMDOPRE
      STORE MOBRABON TO WMDOBON
   endif
   if inmat = 1
      store "Ingrese la descripcion de la nueva mano de obra" to mes
      do mensaje with mes
      @ 19,1 get wmdodes
      read
   endif

   store "Ingrese el numero de personas con esta calificacion" to mes
   do mensaje with mes
   @ 19,32 get wmdocant PICTURE "#######.##"
   read

   store "Ingrese el jornal por unidad de este personal" to mes
   do mensaje with mes
   @ 19,43 get wmdopre PICTURE "########.##"
   read

   store "Ingrese el monto diario por concepto de bono compensatorio" to mes
   do mensaje with mes
   @ 19,56 get wmdobon PICTURE "###.##"
   read

   store (wmdopre+wmdobon)*wmdocant to wmdobs
   @ 19,68 say wmdobs picture "########.##"

   store "Opciones: (A)ceptar, (R)echazar" to mes
   store "A" to p1
   store "R" to p2
   store " " to resp
   do pide2 with p1,p2,mes,resp
   if resp = "A"
      if flagmod = 0
         SELECT 3
         append blank
         replace mobrapre with wparpre
         replace mobrapar with wparcod
         replace mobracod with wmdocod
         replace mobranum with wmdocant
         replace mobrajor with wmdopre
         replace mobrabon with wmdobon

         if inmat = 1
            select 4
            append blank
            replace mdocod with wmdocod
            replace mdodes with wmdodes
            replace mdojor with wmdopre
            replace mdobon with wmdobon
            select 3
         endif
      else
         select 3
         replace mobranum with wmdocant
         replace mobrajor with wmdopre
         replace mobrabon with wmdobon
      endif
   endif
ENDDO


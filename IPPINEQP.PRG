
*****************************
* INGRESO DE EQUIPOS        *
*****************************
select 3
use ippEQUIP index ippEQUIP
SELECT 4
USE IPPTIEQP INDEX IPPTIEQP
SET COLOR TO W/N
STORE .T. TO EQP
DO WHILE EQP
   SET COLOR TO W/N
   @ 16,0 CLEAR TO 21,79
   @ 16,0 SAY "|------------------------------+---------++---------+-+----------++------------|"
   @ 17,0 SAY "|  DESCRIPCION DE EQUIPOS      |CANTIDAD  |PRECIO UND.|  DEPREC. |  BOLIVARES  |"
   @ 18,0 SAY "|------------------------------+----------+-----------+----------+-------------|"
   @ 19,0 SAY "|                              |          |           |          |             |"
   @ 20,0 SAY "+------------------------------+----------+--- -------+----------+-------------+"
   STORE SPACE(6) TO WEQUIPCOD
   store 0 to weqpcant
   STORE "Codigo del equipo a procesar. (*IMP*) = imprimir, (*?*) = consultar" to mes
   do mensaje with mes
   @ 19,1 GET Wequipcod
   READ
   STORE UPPER(Wequipcod) TO Wequipcod
   if wequipcod = space(6)
      return
   endif
   if WEQUIPcod = "*IMP*"
      select 3
      go top
      STORE 0 TO SALIDA
      DO CHKPRINT WITH SALIDA
      if salida = 1
         loop
      endif
      store "Imprimiendo Equipos de esta Partida ..." to mes
      do mensaje with mes
      set devi to print
      STORE 1 TO PAGINA
      store "LISTADO DE EQUIPOS DE LA PARTIDA "+WPARCOD+" DEL PRESUPUESTO:" TO HEAD
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
      @ 6,50 SAY "PRECIO"
      @ 6,62 SAY "DEPREC."
      @ 6,73 SAY "BOLIVARES"
      STORE 7 TO LINE
      GO TOP
      DO WHILE .NOT. EOF()
         IF EQUIPPRE <> WPARPRE .OR. EQUIPPAR <> WPARCOD
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
            @ 6,50 SAY "PRECIO"
            @ 6,62 SAY "DEPREC."
            @ 6,73 SAY "BOLIVARES"
            STORE 7 TO LINE
         ENDIF
         STORE LINE+1 TO LINE
         STORE EQUIPCOD TO WEQUIPCOD
         SELECT 4
         FIND &WEQUIPCOD
         IF EOF()
            STORE "NO REGISTRADO" TO WEQPDES
            ELSE
            STORE EQPDES TO WEQPDES
         ENDIF
         SELECT 3
         @ LINE,1    SAY EQUIPCOD
         @ LINE,8    SAY SUBSTR(WEQPDES,1,30)
         @ LINE,45   SAY STR(EQUIPPREUN,11,2)
         @ LINE,57   SAY STR(EQUIPDEPRE,11,5)
         STORE EQUIPPREUN*EQUIPDEPRE TO WEQPBS
         @ LINE,70   SAY STR(WEQPBS,11,2)
         STORE LINE+1 TO LINE
         SKIP
      ENDDO
      @ LINE+1,1 SAY Q
      EJECT
      SET DEVI TO SCREE
      LOOP
   endif
   if WEQUIPcod = "*?*"
      SAVE SCRE TO SAVE01
      select 3
      go top
      STORE 1 TO PAGINA
      store "LISTADO DE EQUIPOS DE LA PARTIDA "+WPARCOD+" DEL PRESUPUESTO:" TO HEAD
      STORE WPREOBRA TO HEAD2
      STORE "----------" TO Q
      STORE Q+Q+Q+Q+Q+Q+Q+Q TO Q
      @ 0,0 CLEAR
      @ 1,40-(len(RTRIM(QQWW))/2) say QQWW
      @ 2,1 SAY "FECHA:"+DTOC(WFECACT)
      @ 2,70 SAY "PAGINA:"+STR(PAGINA,3)
      @ 3,40-(len(HEAD)/2) say HEAD
      @ 4,40-(len(HEAD2)/2) say HEAD2
      @ 6,1 SAY "CODIGO"
      @ 6,20 SAY "DESCRIPCION"
      @ 6,50 SAY "PRECIO"
      @ 6,60 SAY "DEPREC."
      @ 6,70 SAY "BOLIVARES"
      STORE 7 TO LINE
      GO TOP
      DO WHILE .NOT. EOF()
         IF EQUIPPRE <> WPARPRE .OR. EQUIPPAR <> WPARCOD
            SKIP
            LOOP
         ENDIF
         @ LINE,0 SAY Q
         IF LINE > 20
            STORE "Oprima Ù para continuar" to mes
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
            @ 6,50 SAY "PRECIO"
            @ 6,60 SAY "DEPREC."
            @ 6,70 SAY "BOLIVARES"
            STORE 7 TO LINE
         ENDIF
         STORE LINE+1 TO LINE
         STORE EQUIPCOD TO WEQUIPCOD
         SELECT 4
         FIND &WEQUIPCOD
         IF EOF()
            STORE "NO REGISTRADO" TO WEQPDES
            ELSE
            STORE EQPDES TO WEQPDES
         ENDIF
         SELECT 3
         @ LINE,1    SAY EQUIPCOD
         @ LINE,8    SAY SUBSTR(WEQPDES,1,30)
         @ LINE,45   SAY STR(EQUIPPREUN,11,2)
         @ LINE,55   SAY STR(EQUIPDEPRE,11,5)
         STORE EQUIPPREUN*EQUIPDEPRE TO WEQPBS
         @ LINE,69   SAY STR(WEQPBS,11,2)
         STORE LINE+1 TO LINE
         SKIP
      ENDDO
      @ LINE,0 SAY Q
      store "Oprima Ù para finalizar" to mes
      do aviso with mes
      restore scre from save01
      LOOP
   endif

   if WEQUIPCOD = "*??*"
      save scre to save01
      select 4
      go top
      STORE 1 TO PAGINA
      STORE 100 TO LINE
      store "LISTADO DEL MAESTRO DE EQUIPOS" TO HEAD
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
         @ LINE,1    SAY EQPCOD
         @ LINE,8    SAY EQPDES
         SKIP
      ENDDO
      store "Oprima Ù para finalizar" to mes
      do aviso with mes
      restore scre from save01
      LOOP
   endif

   select 4
   FIND &Wequipcod
   store 0 to inmat
   IF EOF()
      STORE "Codigo de equipo no registrado. Actualizar Sistema? (S/N)" to mes
      store "S" to p1
      store "N" to p2
      store " " to resp
      do pide2 with p1,p2,mes,resp
      if resp = "S"
         store 1 to inmat
         store space(30) to weqpdes
         store 0.00 to weqppre
         store 0.0000 to weqpdep
         store 0.00 to weqpcant
      else
         store 0 to inmat
         loop
      endif
   else
      STORE EQPDES TO WEQUIPDES
      store eqppre to WeqpPRE
      store eqpdep to weqpdep
      @ 19,1 SAY SUBSTR(WEQUIPDES,1,30)
      @ 19,43 say eqppre picture "########.##"
      @ 19,55 say eqpdep PICTURE "###.#####"
   endif

   store wparpre+wparcod+wequipcod to clave
   select 3
   STORE  0 TO FLAGMOD
   find &clave
   if .not. eof()
      @ 19,1 SAY SUBSTR(WEQUIPDES,1,30)
      @ 19,32 say equipcan PICTURE "#######.##"
      @ 19,43 say equippreun picture "########.##"
      @ 19,55 say equipdepre PICTURE "###.#####"
      @ 19,68 say equipcan*equipdepre*equippreun picture "########.##"
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
      STORE equipcan TO WeqpCANT
      STORE equippreun TO WeqpPRE
      store equipdepre to weqpdep
   endif
   if inmat = 1
      store "Ingrese la descripcion del nuevo equipo" to mes
      do mensaje with mes
      @ 19,1 get weqpdes
      read
   endif

   store "Ingrese el numero de equipos a utilizar" to mes
   do mensaje with mes
   @ 19,32 get weqpcant PICTURE "#######.##"
   read

   store "Ingrese el precio por unidad del equipo" to mes
   do mensaje with mes
   @ 19,43 get weqppre PICTURE "########.##"
   read

   store "Ingrese la depreciacion del equipo" to mes
   do mensaje with mes
   @ 19,55 get weqpdep PICTURE "###.#####"
   read

   store weqppre*weqpcant*weqpdep to weqpbs
   @ 19,68 say weqpbs picture "########.##"

   store "Opciones: (A)ceptar, (R)echazar" to mes
   store "A" to p1
   store "R" to p2
   store " " to resp
   do pide2 with p1,p2,mes,resp
   if resp = "A"
      if flagmod = 0
         SELECT 3
         append blank
         replace equippre with wparpre
         replace equippar with wparcod
         replace equipcod with wequipcod
         replace equipcan with weqpcant
         replace equippreun with weqppre
         replace equipdepre with weqpdep

         if inmat = 1
            select 4
            append blank
            replace eqpcod with wequipcod
            replace eqpdes with weqpdes
            replace eqppre with weqppre
            replace eqpdep with weqpdep
            select 3
         endif
      else
         select 3
         replace equipcan with weqpcant
         replace equippreun with weqppre
         replace equipdepre with weqpdep
      endif
   endif
ENDDO


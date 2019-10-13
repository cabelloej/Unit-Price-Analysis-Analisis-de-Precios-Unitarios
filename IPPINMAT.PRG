
*****************************
* INGRESO DE MATERIALES     *
*****************************
select 3
use ippmater index ippmater
SELECT 4
USE IPPTIMAT INDEX IPPTIMAT
SET COLOR TO W/N
STORE .T. TO MAT
DO WHILE MAT
   SET COLOR TO W/N
   @ 16,0 CLEAR TO 21,79
   @ 16,0 SAY "|------------------------------+---------++---------+-+----------++------------|"
   @ 17,0 SAY "|  DESCRIPCION DEL MATERIAL    | UNIDAD   | CANTIDAD  | PRECIO   |  BOLIVARES  |"
   @ 18,0 SAY "|------------------------------+----------+-----------+----------+-------------|"
   @ 19,0 SAY "|                              |          |           |          |             |"
   @ 20,0 SAY "+------------------------------+----------+--- -------+----------+-------------+"
   STORE SPACE(6) TO WMATERCOD
   store 0 to wmatcant
   STORE "Codigo de material:(*I*)=Imp.mater.de part., (*?*)=Cons.Part., (*??*)=Cons.Maest." to mes
   do mensaje with mes
   @ 19,1 GET Wmatercod
   READ
   STORE UPPER(Wmatercod) TO Wmatercod
   if wmatercod = space(6)
      return
   endif
   if Wmatercod = "*IMP*"
      select 3
      go top
      STORE 0 TO SALIDA
      DO CHKPRINT WITH SALIDA
      if salida = 1
         loop
      endif
      store "Imprimiendo Materiales de esta Partida ..." to mes
      do mensaje with mes
      set devi to print
      STORE 1 TO PAGINA
      store "LISTADO DE MATERIALES DE LA PARTIDA "+WPARCOD+" DEL PRESUPUESTO:" TO HEAD
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
      @ 6,62 SAY "PRE. UNI."
      @ 6,73 SAY "BOLIVARES"
      STORE 7 TO LINE
      GO TOP
      DO WHILE .NOT. EOF()
         IF MATERPRE <> WPARPRE .OR. MATERPAR <> WPARCOD
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
            @ 6,62 SAY "PRE. UNI."
            @ 6,73 SAY "BOLIVARES"
            STORE 7 TO LINE
         ENDIF
         STORE LINE+1 TO LINE
         STORE MATERCOD TO WMATERCOD
         SELECT 4
         FIND &WMATERCOD
         IF EOF()
            STORE "NO REGISTRADO" TO WMATDES
            ELSE
            STORE MATDES TO WMATDES
         ENDIF
         SELECT 3
         @ LINE,1    SAY MATERCOD
         @ LINE,8    SAY SUBSTR(WMATDES,1,29)
         @ LINE,45   SAY STR(MATERCAN,11,2)
         @ LINE,59   SAY STR(MATERPREUN,11,2)
         STORE MATERCAN*MATERPREUN TO WMATBS
         @ LINE,70   SAY STR(WMATBS,11,2)
         STORE LINE+1 TO LINE
         SKIP
      ENDDO
      @ LINE+1,1 SAY Q
      EJECT
      SET DEVI TO SCREE
      LOOP
   endif

   if Wmatercod = "*?*"
      save scre to save01
      select 3
      go top
      STORE 1 TO PAGINA
      store "LISTADO DE MATERIALES DE LA PARTIDA "+WPARCOD+" DEL PRESUPUESTO:" TO HEAD
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
      @ 6,60 SAY "PRE. UNI."
      @ 6,70 SAY "BOLIVARES"
      STORE 7 TO LINE
      GO TOP
      DO WHILE .NOT. EOF()
         IF MATERPRE <> WPARPRE .OR. MATERPAR <> WPARCOD
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
            @ 6,60 SAY "PRE. UNI."
            @ 6,70 SAY "BOLIVARES"
            STORE 7 TO LINE
         ENDIF
         STORE LINE+1 TO LINE
         STORE MATERCOD TO WMATERCOD
         SELECT 4
         FIND &WMATERCOD
         IF EOF()
            STORE "NO REGISTRADO" TO WMATDES
            ELSE
            STORE MATDES TO WMATDES
         ENDIF
         SELECT 3
         @ LINE,1    SAY MATERCOD
         @ LINE,8    SAY SUBSTR(WMATDES,1,29)
         @ LINE,50   SAY STR(MATERCAN,10,2)
         @ LINE,60   SAY STR(MATERPREUN,11,2)
         STORE MATERCAN*MATERPREUN TO WMATBS
         @ LINE,69   SAY STR(WMATBS,11,2)
         STORE LINE+1 TO LINE
         SKIP
      ENDDO
      @ LINE,0 SAY Q
      store "Oprima Ù para finalizar" to mes
      do aviso with mes
      restore scre from save01
      LOOP
   endif

   if Wmatercod = "*??*"
      save scre to save01
      select 4
      go top
      STORE 1 TO PAGINA
      STORE 100 TO LINE
      store "LISTADO DEL MAESTRO DE MATERIALES" TO HEAD
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
         @ LINE,1    SAY MATCOD
         @ LINE,8    SAY MATDES
         SKIP
      ENDDO
      store "Oprima Ù para finalizar" to mes
      do aviso with mes
      restore scre from save01
      LOOP
   endif

   select 4
   FIND &Wmatercod
   store 0 to inmat
   IF EOF()
      STORE "Codigo de material no registrado. Actualizar Sistema? (S/N)" to mes
      store "S" to p1
      store "N" to p2
      store " " to resp
      do pide2 with p1,p2,mes,resp
      if resp = "S"
         store 1 to inmat
         store space(30) to wmatdes
         store space(10) to wmatund
         store 0.00 to wmatpre
         store 0.00 to wmatcant
      else
         store 0 to inmat
         loop
      endif
   else
      store matdes to wmatdes
      store matund to wmatund
      store matpre to wmatpre
      @ 19,1 say SUBSTR(wmatdes,1,30)
      @ 19,32 say wmatund
   endif

   store wparpre+wparcod+wmatercod to clave
   select 3
   STORE  0 TO FLAGMOD
   find &clave
   if .not. eof()
      @ 19,1 say SUBS(wmatdes,1,30)
      @ 19,32 say wmatund
      @ 19,43 say matercan
      @ 19,55 say materpreun PICTURE "#######.##"
      @ 19,68 SAY MATERCAN*MATERPREUN PICTURE "########.##"
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
      STORE MATERCAN TO WMATCANT
      STORE MATERPREUN TO WMATPRE
   endif
   if inmat = 1
      store "Ingrese la descripcion del nuevo material" to mes
      do mensaje with mes
      @ 19,1 get wmatdes
      read
      store "Ingrese la unidad de medida del nuevo material" to mes
      do mensaje with mes
      @ 19,32 get wmatund
   endif

   store "Ingrese la cantidad de unidades a utilizar del material" to mes
   do mensaje with mes
   @ 19,43 get wmatcant PICTURE "########.##"
   read

   store "Ingrese el precio por unidad del material" to mes
   do mensaje with mes
   @ 19,55 get wmatpre PICTURE "#######.##"
   read

   store wmatpre*wmatcant to wmatbs
   @ 19,68 say wmatbs picture "########.##"

   store "Opciones: (A)ceptar, (R)echazar" to mes
   store "A" to p1
   store "R" to p2
   store " " to resp
   do pide2 with p1,p2,mes,resp
   if resp = "A"
      if flagmod = 0
         SELECT 3
         append blank
         replace materpre with wparpre
         replace materpar with wparcod
         replace matercod with wmatercod
         replace matercan with wmatcant
         replace materpreun with wmatpre

         if inmat = 1
            select 4
            append blank
            replace matcod with wmatercod
            replace matdes with wmatdes
            replace matund with wmatund
            replace matpre with wmatpre
            select 3
         endif
      else
         select 3
         replace matercan with wmatcant
         replace materpreun with wmatpre
      endif
   endif
ENDDO


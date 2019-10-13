*****************************
* mantenimiento de partidas *
*****************************
set exact off
select 1
use ipppresu index ipppresu ALIAS PRESUP
SELECT 2
USE IPPPARTI INDEX IPPPART1,IPPPART2  ALIAS PARTIDA
SELECT 5
USE IPPPARDE INDEX IPPPARDE
SET COLOR TO W+/b
STORE .T. TO PAR
DO WHILE PAR
   SET COLOR TO W/N
   @ 04,0 CLEAR TO 21,79
   @ 05,0 SAY "+------------------------------------------------------------------------------+"
   @ 06,0 SAY "|  A C T U A L I Z A R   A N A L I S I S   D E   P R E C I O   U N I T A R I O |"
   @ 07,0 SAY "|------------------------------------------------+------------+------------+---|"
   @ 08,0 SAY "|             O   B   R   A                      |PRESUPUESTO|   PARTIDA   |TIP|"
   @ 09,0 SAY "|                                                |           |             |   |"
   @ 10,0 SAY "|----------------------------------------+-------+-+---------+----+----+---+---|"
   @ 11,0 SAY "| DESCRIPCION RESUMIDA DE LA PARTIDA     |  UNIDAD  |  CANTIDAD   |ANL.| MATER.|"
   @ 12,0 SAY "|----------------------------------------|          |             |    |       |"
   @ 13,0 SAY "|                                        |----------|-------------|----+-------|"
   @ 14,0 SAY "|                                        |REFERENCIA| P. UNITARIO |RENDIMIENTO |"
   @ 15,0 SAY "|                                        |          |             |            |"
   @ 16,0 SAY "|                                        |------+---+--------+----+------+-----|"
   @ 17,0 SAY "|                                        |% LDT.|    ADM.    |   UTLD.   |DESP.|"
   @ 18,0 SAY "|                                        |      |            |           |     |"
   @ 19,0 SAY "+----------------------------------------+------+------------+-----------+-----+"
*  STORE SPACE(10) TO WPARPRE
   STORE "Ingrese el codigo del Presupuesto asociado " to mes
   do mensaje with mes
   @ 9,51 GET WPARPRE
   READ
   STORE UPPER(WPARPRE) TO WPARPRE
   if wPARPRE = space(10) .OR. READKEY() = 12 .OR. READKEY() = 268
      close data
      close index
      set exact on
      return
   endif
   select 1
   FIND &WPARPRE
   IF EOF()
      STORE "Codigo de presupuesto no registrado. (Ù)" to mes
      do aviso with mes
      loop
   endif
   @ 9,1 say preobra
   STORE PREOBRA TO WPREOBRA
 * store SPACE(13) to wparcod
   store "Codigo de partida. (Ù) = salir, (*IMP*) = imprimir, (*?*) = consultar" to mes
   do mensaje with mes
   @ 9,62 get wparcod
   read
   store upper(wparcod) to wparcod
   if Wparcod = "*IMP*"
      select 2
      go top
      STORE 0 TO SALTAR
      DO CHKPRINT WITH SALTAR
      if salTAR = 1
         loop
      endif
      store "Imprimiendo Partidas ..." to mes
      do mensaje with mes
      set devi to print
      STORE 1 TO PAGINA
      store "LISTADO DE PARTIDAS DEL PRESUPUESTO:" TO HEAD
      STORE WPREOBRA TO HEAD2
      STORE "----------" TO Q
      STORE Q+Q+Q+Q+Q+Q+Q+Q TO Q
      @ 1,40-(len(RTRIM(QQWW))/2) say QQWW
      @ 2,1 SAY "FECHA:"+DTOC(WFECACT)
      @ 2,70 SAY "PAGINA:"+STR(PAGINA,3)
      @ 3,40-(len(HEAD)/2) say HEAD
      @ 4,40-(len(HEAD2)/2) say HEAD2
      @ 6,1 SAY "No."
      @ 6,20 SAY "DESCRIPCION"
      @ 6,50 SAY "UNIDAD"
      @ 6,62 SAY "CANTIDAD"
      @ 6,73 SAY "RENDIMI."
      STORE 7 TO LINE
      GO TOP
      DO WHILE .NOT. EOF()
         IF PARPRE <> WPARPRE
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
            @ 6,1 SAY "No."
            @ 6,20 SAY "DESCRIPCION"
            @ 6,50 SAY "UNIDAD"
            @ 6,62 SAY "CANTIDAD"
            @ 6,73 SAY "RENDIMI."
            STORE 7 TO LINE
         ENDIF
         STORE LINE+1 TO LINE
         @ LINE,0    SAY PARCOD
         @ LINE,9    SAY PARDES1
         IF PARTIPO <> "T"
            @ LINE,50   SAY PARUNID
            @ LINE,59   SAY STR(PARCANT,11,2)
            @ LINE,70   SAY STR(PARREND,11,2)
         ENDIF
         IF PARDES2 <> SPACE(40)
            STORE LINE+1 TO LINE
            @ LINE,9 SAY PARDES2
         ENDIF
         IF PARDES3 <> SPACE(40)
            STORE LINE+1 TO LINE
            @ LINE,9 SAY PARDES3
         ENDIF
         IF PARDES4 <> SPACE(40)
            STORE LINE+1 TO LINE
            @ LINE,9 SAY PARDES4
         ENDIF
         IF PARDES5 <> SPACE(40)
            STORE LINE+1 TO LINE
            @ LINE,9 SAY PARDES5
         ENDIF
         IF PARDES6 <> SPACE(40)
            STORE LINE+1 TO LINE
            @ LINE,9 SAY PARDES6
         ENDIF
         STORE LINE+1 TO LINE
         SKIP
      ENDDO
      @ LINE+1,1 SAY Q
      EJECT
      SET DEVI TO SCREE
      LOOP
   endif
   if Wparcod = "*?*"
      save scre to save01
      select 2
      go top
      STORE 1 TO PAGINA
      store "LISTADO DE PARTIDAS DEL PRESUPUESTO:" TO HEAD
      STORE WPREOBRA TO HEAD2
      STORE "----------" TO Q
      STORE Q+Q+Q+Q+Q+Q+Q+Q TO Q
      @ 0,0 clear
      @ 1,40-(len(RTRIM(QQWW))/2) say QQWW
      @ 2,1 SAY "FECHA:"+DTOC(WFECACT)
      @ 2,70 SAY "PAGINA:"+STR(PAGINA,3)
      @ 3,40-(len(HEAD)/2) say HEAD
      @ 4,40-(len(HEAD2)/2) say HEAD2
      @ 6,1 SAY "No."
      @ 6,20 SAY "DESCRIPCION"
      STORE 7 TO LINE
      GO TOP
      DO WHILE .NOT. EOF()
         IF PARPRE <> WPARPRE
            SKIP
            LOOP
         ENDIF
         @ LINE,0 SAY Q
         IF LINE > 15
            store "Oprima Ù para continuar" to mes
            do aviso with mes
            @ 0,0 clear
            STORE PAGINA + 1 TO PAGINA
            @ 1,40-(len(RTRIM(QQWW))/2) say QQWW
            @ 2,1 SAY "FECHA:"+DTOC(WFECACT)
            @ 2,70 SAY "PAGINA:"+STR(PAGINA,3)
            @ 3,40-(len(HEAD)/2) say HEAD
            @ 4,40-(len(HEAD2)/2) say HEAD2
            @ 6,1 SAY "No."
            @ 6,20 SAY "DESCRIPCION"
            STORE 7 TO LINE
         ENDIF
         STORE LINE+1 TO LINE
         @ LINE,0    SAY PARCOD
         @ LINE,9    SAY PARDES1
         IF PARDES2 <> SPACE(40)
            STORE LINE+1 TO LINE
            @ LINE,9 SAY PARDES2
         ENDIF
         IF PARDES3 <> SPACE(40)
            STORE LINE+1 TO LINE
            @ LINE,9 SAY PARDES3
         ENDIF
         IF PARDES4 <> SPACE(40)
            STORE LINE+1 TO LINE
            @ LINE,9 SAY PARDES4
         ENDIF
         IF PARDES5 <> SPACE(40)
            STORE LINE+1 TO LINE
            @ LINE,9 SAY PARDES5
         ENDIF
         IF PARDES6 <> SPACE(40)
            STORE LINE+1 TO LINE
            @ LINE,9 SAY PARDES6
         ENDIF
         STORE LINE+1 TO LINE
         SKIP
      ENDDO
      @ LINE,0 SAY Q
      store "Oprima Ù para finalizar" to mes
      do aviso with mes
      restore scree from save01
      LOOP
   endif

   IF WPARCOD = SPACE(13) .OR. READKEY() = 12 .OR. READKEY() = 268
     *STORE SPACE(10) TO WPARPRE
      LOOP
   ENDIF
   select 2
   STORE WPARPRE+WPARCOD TO WCLAVE
   find &WCLAVE
   if eof()
      store "Codigo de partida no registrado en el Presupuesto: (I)ngresar, (R)echazar" to mes
      store "I" to p1
      store "R" to p2
      store " " to resp
      do pide2 with p1,p2,mes,resp
      if resp = "R"
         loop
      endif
      *********  i  n  g  r  e  s  o  ************
      DIME TEXT(65)
      store space(3)  to wpartipo
      store space(40) to wpardes1
      store space(40) to wpardes2
      store space(40) to wpardes3
      store space(40) to wpardes4
      store space(40) to wpardes5
      store space(40) to wpardes6
      store space(10) to wparunid
      store 0.00      to wparcant
      store 0.00      to wparrend
      store space(10) to wparref
      store WWPORADM     to wparporadm
      store WWPORLDT     to wparporldt
      store WWPORIMP     to wparporimp
      STORE WWPORDES     TO WPARPORDES
      store space(1)  to wanalisis
      store space(1)  to wMATERDIV
      store 0.00      to wparpreuni
      store 0.00      to wparbsadm
      store 0.00      to wparbsimp
      store .t. to ingresando
      do while ingresando
         store "TIPOS: (T)exto, (O)rdinaria, (A)dicional" to mes
         store "T" to p1
         store "O" to p2
         store "A" to p3
         store " " to resp
         do pide3 with p1,p2,p3,mes,resp
         store resp to wpartipo
         @ 9,76 say wpartipo

         store "Descripcion de la partida" to mes
         do mensaje with mes
         STORE .T. TO TEXTO
         DO WHILE TEXTO
            @ 13,1 get wpardes1
            READ
            IF WPARDES1 = SPACE(40)
               EXIT
            ENDIF
            @ 14,1 get wpardes2
            READ
            IF WPARDES2 = SPACE(40)
               EXIT
            ENDIF
            @ 15,1 get wpardes3
            READ
            IF WPARDES3 = SPACE(40)
               EXIT
            ENDIF
            @ 16,1 get wpardes4
            READ
            IF WPARDES4 = SPACE(40)
               EXIT
            ENDIF
            @ 17,1 get wpardes5
            READ
            IF WPARDES5 = SPACE(40)
               EXIT
            ENDIF
            @ 18,1 get wpardes6
            READ
            STORE .F. TO TEXTO
         ENDDO

         STORE "Desea ingresar una descripcion detallada de la partida? (S/N)" to mes
         store "S" to p1
         store "N" to p2
         store " " to resp
         do pide2 with p1,p2,mes,resp
         STORE 0 TO WMODESDE
         if resp = "S"
            store "Use las flechas para moverse y (ESC) para salir" to mes
            do mensaje with mes
            STORE 1 TO WMODESDE
            STORE 1 TO POINTER
            do while pointer <= 60
               store space(40) to text(pointer)
               store pointer + 1 to pointer
            enddo
            STORE 1 TO POINTER
            SAVE SCREE TO TEXTUAL
            SELECT 5
            USE IPPPARDE INDEX IPPPARDE
            @ 5,0 CLEAR TO 21,42
            @ 5,0 TO 21,42 DOUBLE
            @ 5,10 SAY "DESCRIPCION DETALLADA"
            STORE 1 TO XLL
            STORE 1 TO WLAST
            STORE WPARPRE+WPARCOD TO PPP
            FIND &PPP
            IF .NOT. EOF()
               DO WHILE .NOT. EOF() .AND. PRESU = WPARPRE .AND. PARTI = WPARCOD
                  STORE TEXTO TO TEXT(POINTER)
                  STORE POINTER + 1 TO POINTER
                  SKIP
               ENDDO
            endif
            STORE 0 TO ZXC
            STORE 0 TO BLOQUE
            DO WHILE ZXC = 0
               STORE 1 TO AZX
               DO WHILE AZX <= 15
                  STORE ((BLOQUE*15)+AZX) TO QWERTY
                  IF QWERTY > 60
                     STORE 60 TO QWERTY
                  ENDIF
                  @ AZX+5,2 SAY TEXT(QWERTY)
                  STORE AZX+1 TO AZX
               ENDDO
               @ WLAST+5,1 SAY " "
               @ XLL+5,1 SAY ""
               STORE XLL TO WLAST
               CLEAR TYPEAHEAD
               STORE 0 TO WA
               DO WHILE WA = 0
                  WA=INKEY()
               ENDDO
               IF (WA <> 5) .AND. (WA <> 24) .AND. (WA <> 27)
                  IF WA >= 32  .OR. WA = 4
                     STORE (BLOQUE*15)+XLL TO INDICE
                     IF WA <> 4
                        STORE SUBSTR(TEXT(INDICE),2,39) TO TEXT(INDICE)
                        SET COLOR TO N/BG
                        @ XLL+5,2 SAY CHR(WA)
                        SET COLOR TO W+/B
                        @ XLL+5,3 GET TEXT(INDICE)
                     ELSE
                        @ XLL+5,2 GET TEXT(INDICE)
                     ENDIF
                     READ
                     IF WA <> 4
                        STORE CHR(WA)+TEXT(INDICE) TO TEXT(INDICE)
                     ENDIF
                     STORE 24 TO WA
                  ELSE
                     LOOP
                  ENDIF
               ENDIF
               IF WA = 27
                  STORE 1 TO ZXC
                  LOOP
               ENDIF
               IF WA = 5
                  STORE XLL - 1 TO XLL
                  IF XLL = 0
                     STORE 1 TO XLL
                     STORE BLOQUE - 1 TO BLOQUE
                     IF BLOQUE < 0
                        STORE 0 TO BLOQUE
                     ENDIF
                  ENDIF
               ENDIF
               IF WA = 24
                  STORE XLL+1 TO XLL
                  IF XLL > 15
                     STORE 1 TO XLL
                     STORE BLOQUE + 1 TO BLOQUE
                     IF BLOQUE >= 4
                        STORE 4 TO BLOQUE
                     ENDIF
                  ENDIF
               ENDIF
            ENDDO
            RESTORE SCREE FROM TEXTUAL
            SELECT 2
         ENDIF

         if wpartipo = "T"
            exit
         endif

         store "Unidad de medida de la Partida" to mes
         do mensaje with mes
         @ 12,42 get wparunid
         read

         store "Cantidad de unidades presupuestadas" to mes
         do MENSAJE WITH MES
         @ 12,53 get wparcant picture "########.##"
         read

         STORE "Indique si la partida requiere Analisis (S/N)" to mes
         store "S" to p1
         store "N" to p2
         store " " to resp
         do pide2 with p1,p2,mes,resp
         if resp = "S"
            store "SI" to wanalisis
         else
            store "NO" to wanalisis
         endif
         @ 12,68 say wanalisis

         IF WANALISIS = "SI"
            STORE "Dividir materiales entre: (N)o dividir, (R)endimiento, (U)nidades " to mes
            store "N" to p1
            store "R" to p2
            store "U" to p3
            store " " to resp
            do pide3 with p1,p2,P3,mes,resp
            STORE RESP TO WMATERDIV
            if resp = "N"
               store "NO DIV." to wMADES
            endif
            if resp = "U"
               store "UNDS." to wMADES
            endif
            if resp = "R"
               store "RENDTO." to wMADES
            endif
            @ 12,72 say wMADES
         ELSE
            STORE "N" TO WMATERDIV
         ENDIF

         store "Ingrese las Referencias de la partida" to mes
         do mensaje with mes
         @ 15,42 get wparref
         read

         if wanalisis = "NO"
            store "Precio unitario fijado directamente (Mayor que 0)" to mes
            do mensaje with mes
            @ 15,53 get wparpreuni picture "#######.##"
            read
            exit
         endif

         store 0 to wparrend
         DO WHILE WPARREND = 0
            store "Rendimiento diario en unidades (Mayor que 0)" to mes
            do mensaje with mes
            @ 15,68 get wparrend picture "#######.##"
            read
         ENDDO

         store "Ingrese el Porcentaje de Ley del Trabajo, Etc." to mes
         do mensaje with mes
         @ 18,42 get wparporldt picture "###.##"
         read

         store "Porcentaje Administracion y Gastos Generales. (0 para ingresar Monto Directo)" to mes
         do mensaje with mes
         @ 18,49 get wparporadm picture "###.##"
         read
         store 0 to wparbsadm
         IF WPARPORADM = 0
            store "Monto directo de Administracion :" to mes
            do mensaje with mes
            @ 18,49 get wparbsadm picture "########.##"
            read
         ENDIF

         store "Porcentaje Imprevistos, Utilidad. (0 para ingresar Monto Directo)" to mes
         do mensaje with mes
         @ 18,62 get wparporimp picture "###.##"
         read
         store 0 to wparbsimp
         IF WPARPORIMP = 0
            store "Monto directo de Imprevistos y Utilidad :" to mes
            do mensaje with mes
            @ 18,62 get wparbsimp picture "########.##"
            read
         ENDIF

         store "Porcentaje Desperdicio de material" to mes
         do mensaje with mes
         @ 18,74 get wparpordes picture "##.##"
         read
         store .f. to ingresando
      enddo

      store "Opciones: (A)ceptar, (R)echazar" to mes
      store "A" to p1
      store "R" to p2
      store " " to resp
      do pide2 with p1,p2,mes,resp
      if resp = "A"
         SELECT 2
         APPEND BLANK
         replace parpre    with wparpre
         replace parcod    with wparcod
         replace partipo   with wpartipo
         replace pardes1   with wpardes1
         replace pardes2   with wpardes2
         replace pardes3   with wpardes3
         replace pardes4   with wpardes4
         replace pardes5   with wpardes5
         replace pardes6   with wpardes6
         replace parunid   with wparunid
         replace parcant   with wparcant
         REPLACE MATERDIV  WITH WMATERDIV
         replace paranalis with wanalisis
         replace parrend   with wparrend
         replace parref    with wparref
         replace parporldt with wparporldt
         replace parporadm with wparporadm
         replace parbsadm  with wparbsadm
         replace parporimp with wparporimp
         replace parbsimp  with wparbsimp
         replace parpordes with wparpordes
         replace parpreuni with wparpreuni

         IF WMODESDE = 1
            select 5
            USE IPPPARDE INDEX IPPPARDE
            FIND &PPP
            IF .NOT. EOF()
               DO WHILE .NOT. EOF() .AND. PRESU = WPARPRE .AND. PARTI = WPARCOD
                  delete
                  SKIP
               ENDDO
               PACK
            endif
            STORE 1 TO AZX
            DO WHILE AZX <= 60
               if text(azx) <> space(40)
                  append blank
                  replace presu with wparpre
                  replace parti with wparcod
                  replace texto with text(azx)
               endif
               store azx + 1 to azx
            ENDDO
            select 2
         ENDIF
         ****   B O R R A R   D E   M E M O R I A    L A   T A B L A  ****
         RELEASE TEXT*
         IF WANALISIS = "SI"
            DO IPPINMAT
            DO IPPINEQP
            DO IPPINMDO
         ENDIF
      endif
   else
      store PARTIPO         to wPARTIPO
      store PARDES1         to WPARDES1
      store PARDES2         to WPARDES2
      store PARDES3         to WPARDES3
      store PARDES4         to WPARDES4
      store PARDES5         to WPARDES5
      store PARDES6         to WPARDES6
      STORE PARUNID         TO WPARUNID
      STORE PARCANT         TO WPARCANT
      STORE PARREND         TO WPARREND
      STORE PARREF          TO WPARREF
      STORE PARPORLDT       TO WPARPORLDT
      STORE PARPORADM       TO WPARPORADM
      STORE PARBSADM        TO WPARBSADM
      STORE PARPORIMP       TO WPARPORIMP
      STORE PARBSIMP        TO WPARBSIMP
      STORE PARPORDES       TO WPARPORDES
      STORE PARANALIS       TO WANALISIS
      store parpreuni       to wparpreuni
      STORE MATERDIV        TO WMATERDIV
      @ 9,76 SAY WPARTIPO
      @ 13,1 SAY WPARDES1
      @ 14,1 SAY WPARDES2
      @ 15,1 SAY WPARDES3
      @ 16,1 SAY WPARDES4
      @ 17,1 SAY WPARDES5
      @ 18,1 SAY WPARDES6
      IF WPARTIPO <> "T"
         @ 12,42 SAY wparunid
         @ 12,53 SAY wparcant picture "########.##"
         @ 12,68 say wanalisis
         store space(7) to wmades
         if wmaterdiv = "N"
            store "NO DIV." to wMADES
         endif
         if wmaterdiv = "U"
            store "UNDS." to wMADES
         endif
         if wmaterdiv = "R"
            store "RENDTO." to wMADES
         endif
         @ 12,72 say wMADES
         @ 12,72 say wMATERDIV
         @ 15,42 SAY wparref
         IF WANALISIS = "NO"
            @ 15,53 SAY wparpreuni picture "#######.##"
         ENDIF
         IF WANALISIS = "SI"
            @ 15,68 SAY wparrend picture "#######.##"
            @ 18,42 SAY wparporldt picture "###.##"
            @ 18,49 SAY wparporadm picture "###.##"
            @ 18,62 SAY wparporimp picture "###.##"
            @ 18,74 SAY wparporDES picture "##.##"
         ENDIF
      ENDIF
      store "Opciones: (M)odificar, (E)liminar, (S)alir" to mes
      store "M" to p1
      store "E" to p2
      store "S" to p3
      store " " to resp
      do pide3 with p1,p2,p3,mes,resp

      if resp = "M"
         ********** M O D I F I C A N D O   *******************
         STORE "Opciones para modificar: (D)atos generales, (I)nsumos" to mes
         store "D" to p1
         store "I" to p2
         store " " to resp
         do pide2 with p1,p2,mes,resp
         store resp to wmodi
         if wmodi = "D"
            DIME TEXT(65)
            store .t. to MODIFICANDO
            do while MODIFICANDO
               STORE .T. TO VERPAR
               DO WHILE VERPAR
                  STORE WPARTIPO TO QTIP
                  store "TIPOS: (T)exto, (O)rdinaria, (A)dicional" to mes
                  do MENSAJE WITH MES
                  @ 9,76 GET QTIP
                  READ
                  STORE UPPER(QTIP) TO QTIP
                  IF QTIP <> "T" .AND. QTIP <> "O" .AND. QTIP <> "A"
                     STORE "Tipo invalido" to mes
                     do aviso with mes
                     ELSE
                     STORE .F. TO VERPAR
                  ENDIF
               ENDDO
               STORE QTIP TO WPARTIPO

               store "Descripcion de la partida" to mes
               do mensaje with mes
               @ 13,1 get wpardes1
               READ
               @ 14,1 get wpardes2
               READ
               @ 15,1 get wpardes3
               READ
               @ 16,1 get wpardes4
               READ
               @ 17,1 get wpardes5
               READ
               @ 18,1 get wpardes6
               READ
               STORE "Desea modificar la descripcion detallada de la partida? (S/N)" to mes
               store "S" to p1
               store "N" to p2
               store " " to resp
               do pide2 with p1,p2,mes,resp
               STORE 0 TO WMODESDE
               if resp = "S"
                  store "Use las flechas para moverse y (ESC) para salir" to mes
                  do mensaje with mes
                  STORE 1 TO WMODESDE
                  STORE 1 TO POINTER
                  do while pointer <= 60
                     store space(40) to text(pointer)
                     store pointer + 1 to pointer
                  enddo
                  STORE 1 TO POINTER
                  SAVE SCREE TO TEXTUAL
                  SELECT 5
                  USE IPPPARDE INDEX IPPPARDE
                  @ 5,0 CLEAR TO 21,42
                  @ 5,0 TO 21,42 DOUBLE
                  @ 5,10 SAY "DESCRIPCION DETALLADA"
                  STORE 1 TO XLL
                  STORE 1 TO WLAST
                  STORE WPARPRE+WPARCOD TO PPP
                  FIND &PPP
                  IF .NOT. EOF()
                     DO WHILE .NOT. EOF() .AND. PRESU = WPARPRE .AND. PARTI = WPARCOD
                        STORE TEXTO TO TEXT(POINTER)
                        STORE POINTER + 1 TO POINTER
                        SKIP
                     ENDDO
                  endif
                  STORE 0 TO ZXC
                  STORE 0 TO BLOQUE
                  DO WHILE ZXC = 0
                     STORE 1 TO AZX
                     DO WHILE AZX <= 15
                        STORE ((BLOQUE*15)+AZX) TO QWERTY
                        IF QWERTY > 60
                           STORE 60 TO QWERTY
                        ENDIF
                        @ AZX+5,2 SAY TEXT(QWERTY)
                        STORE AZX+1 TO AZX
                     ENDDO
                     @ WLAST+5,1 SAY " "
                     @ XLL+5,1 SAY ""
                     STORE XLL TO WLAST
                     CLEAR TYPEAHEAD
                     STORE 0 TO WA
                     DO WHILE WA = 0
                        WA=INKEY()
                     ENDDO
                     IF (WA <> 5) .AND. (WA <> 24) .AND. (WA <> 27)
                        IF WA >= 32  .OR. WA = 4
                           STORE (BLOQUE*15)+XLL TO INDICE
                           IF WA <> 4
                              STORE SUBSTR(TEXT(INDICE),2,39) TO TEXT(INDICE)
                              SET COLOR TO N/BG
                              @ XLL+5,2 SAY CHR(WA)
                              SET COLOR TO W+/B
                              @ XLL+5,3 GET TEXT(INDICE)
                           ELSE
                              @ XLL+5,2 GET TEXT(INDICE)
                           ENDIF
                           READ
                           IF WA <> 4
                              STORE CHR(WA)+TEXT(INDICE) TO TEXT(INDICE)
                           ENDIF
                           STORE 24 TO WA
                        ELSE
                           LOOP
                        ENDIF
                     ENDIF

                     IF WA = 27
                        STORE 1 TO ZXC
                        LOOP
                     ENDIF
                     IF WA = 5
                        STORE XLL - 1 TO XLL
                        IF XLL = 0
                           STORE 1 TO XLL
                           STORE BLOQUE - 1 TO BLOQUE
                           IF BLOQUE < 0
                              STORE 0 TO BLOQUE
                           ENDIF
                        ENDIF
                     ENDIF
                     IF WA = 24
                        STORE XLL+1 TO XLL
                        IF XLL > 15
                           STORE 1 TO XLL
                           STORE BLOQUE + 1 TO BLOQUE
                           IF BLOQUE >= 4
                              STORE 4 TO BLOQUE
                           ENDIF
                        ENDIF
                     ENDIF
                  ENDDO
                  RESTORE SCREE FROM TEXTUAL
                  SELECT 2
               endif

               if wpartipo = "T"
                  exit
               endif
               store "Unidad de medida de la Partida" to mes
               do mensaje with mes
               @ 12,42 get wparunid
               read

               store "Cantidad de unidades presupuestadas" to mes
               do MENSAJE WITH MES
               @ 12,53 get wparcant picture "########.##"
               read

               STORE .T. TO VERPAR
               DO WHILE VERPAR
                  STORE "Indique si la partida requiere Analisis (S/N)" to mes
                  do MENSAJE WITH MES
                  STORE SUBSTR(WANALISIS,1,1) TO QSN
                  @ 12,68 GET QSN
                  READ
                  STORE UPPER(QSN) TO QSN
                  IF QSN <> "S" .AND. QSN <> "N"
                     STORE "Repuesta invalida" to mes
                     do aviso with mes
                     ELSE
                     STORE .F. TO VERPAR
                  ENDIF
               ENDDO
               if QSN = "S"
                  store "SI" to wanalisis
               else
                  store "NO" to wanalisis
               endif
               @ 12,68 SAY WANALISIS

               IF WANALISIS = "SI"
                  STORE "Dividir materiales entre: (N)o dividir, (R)endimiento, (U)nidades " to mes
                  STORE .T. TO FGH
                  DO WHILE FGH
                     STORe wmaterdiv to wquest
                     DO MENSAJE WITH MES
                     @ 12,72 get wquest
                     read
                     if wquest = "N" .or. wquest = "R" .or. wquest = "U"
                        store .f. to fgh
                     endif
                  ENDDO
                  store wquest to wmaterdiv
                  if wmaterdiv = "N"
                     store "NO DIV." to wMADES
                  endif
                  if wmaterdiv = "U"
                     store "UNDS." to wMADES
                  endif
                  if wmaterdiv = "R"
                     store "RENDTO." to wMADES
                  endif
                  @ 12,72 say wMADES
               ENDIF

               store "Ingrese las Referencias de la partida" to mes
               do mensaje with mes
               @ 15,42 get wparref
               read

               if wanalisis = "NO"
                  store "Precio unitario fijado directamente (Mayor que 0)" to mes
                  do mensaje with mes
                  @ 15,53 get wparpreuni picture "#######.##"
                  read
                  exit
               endif

               store "Rendimiento diario en unidades (Mayor que 0)" to mes
               do mensaje with mes
               @ 15,68 get wparrend picture "#######.##"
               read

               store "Ingrese el Porcentaje de Ley del Trabajo, Etc." to mes
               do mensaje with mes
               @ 18,42 get wparporldt picture "###.##"
               read

               store "Porcentaje Administracion y Gastos Generales. (0 para ingresar Monto Directo)" to mes
               do mensaje with mes
               @ 18,49 get wparporadm picture "###.##"
               read
               IF WPARPORADM = 0
                  store "Monto directo de Administracion :" to mes
                  do mensaje with mes
                  @ 18,49 get wparbsadm picture "########.##"
                  read
               ENDIF

               store "Porcentaje Imprevistos, Utilidad. (0 para ingresar Monto Directo)" to mes
               do mensaje with mes
               @ 18,62 get wparporimp picture "###.##"
               read
               IF WPARPORIMP = 0
                  store "Monto directo de Imprevistos y Utilidad :" to mes
                  do mensaje with mes
                  @ 18,62 get wparbsimp picture "########.##"
                  read
               ENDIF

               store "Porcentaje Desperdicio de material" to mes
               do mensaje with mes
               @ 18,74 get wparpordes picture "##.##"
               read

               store .f. to MODIFICANDO
            enddo

            store "Opciones: (A)ceptar, (R)echazar" to mes
            store "A" to p1
            store "R" to p2
            store " " to resp
            do pide2 with p1,p2,mes,resp
            if resp = "A"
               SELECT 2
               replace parpre    with wparpre
               replace parcod    with wparcod
               replace partipo   with wpartipo
               replace pardes1   with wpardes1
               replace pardes2   with wpardes2
               replace pardes3   with wpardes3
               replace pardes4   with wpardes4
               replace pardes5   with wpardes5
               replace pardes6   with wpardes6
               replace parunid   with wparunid
               replace parcant   with wparcant
               replace paranalis with wanalisis
               replace parrend   with wparrend
               replace parref    with wparref
               replace parporldt with wparporldt
               replace parporadm with wparporadm
               replace parbsadm  with wparbsadm
               replace parporimp with wparporimp
               replace parbsimp  with wparbsimp
               replace parpordes with wparpordes
               replace parpreuni with wparpreuni
               replace materdiv  with wmaterdiv
               IF WMODESDE = 1
                  select 5
                  USE IPPPARDE INDEX IPPPARDE
                  FIND &PPP
                  IF .NOT. EOF()
                     DO WHILE .NOT. EOF() .AND. PRESU = WPARPRE .AND. PARTI = WPARCOD
                        delete
                        SKIP
                     ENDDO
                     PACK
                  endif
                  STORE 1 TO AZX
                  DO WHILE AZX <= 60
                     if text(azx) <> space(40)
                        append blank
                        replace presu with wparpre
                        replace parti with wparcod
                        replace texto with text(azx)
                     endif
                     store azx + 1 to azx
                  ENDDO
                  select 2
               ENDIF
            endif
         ****   B O R R A R   D E   M E M O R I A    L A   T A B L A  ****
         RELEASE TEXT*
         endif
         if wmodi = "I" .and. paranalis = "SI"
            do ippinmat
            do ippineqp
            do ippinmdo
         endif
      endif
      ********************************************

      IF RESP = "E"
         STORE "Advertencia: Esta operacion elimina el analisis si lo hay. Clave:" to mes
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
         select 2
         delete
*        pack
         select 3
         use ippmater index ippmater
         delete all for materpre = wparpre .and. materpar = wparcod
*        pack
         select 3
         use ippequip index ippequip
         delete all for equippre = wparpre .and. equippar = wparcod
*        pack
         select 3
         use ippmdo   index ippmdo
         delete all for mobrapre = wparpre .and. mobrapar = wparcod
*        pack
         select 1
      endif
   endif
ENDDO


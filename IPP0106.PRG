
SET EXACT OFF
select 1
use ipppresu index ipppresu alias presup
select 2
use ippparti index ipppart1,ipppart2 alias partida
store .t. to analiza
do while analiza
   @ 4,0 clear to 21,79
   @ 4,20 say "REVISION DE PRECIOS"
   @ 6,5  SAY "PRESUPUESTO:"
   @ 7,5  SAY "PARTIDA    :"
    STORE WPARPRE   TO WPRECOD
*   STORE SPACE(13)  TO WPARCOD
   @ 6,18 GET WPRECOD
   READ
   IF WPRECOD = SPACE(10)   .OR. READKEY() = 12 .OR. READKEY() = 268
      SET EXACT ON
      CLOSE DATA
      CLOSE INDEX
      RETURN
   ENDIF
   SELECT 1
   STORE UPPER(WPRECOD) TO WPRECOD
   FIND &WPRECOD
   IF EOF()
      STORE "ERROR, Codigo de presupuesto no registrado" to mes
      do aviso with mes
      loop
   endif
   STORE PREOBRA TO WOBRA
   @ 6,18 say preobra
   @ 7,18 get wparcod
   read
   if wparcod = SPACE(13)   .OR. READKEY() = 12 .OR. READKEY() = 268
      select 1
      loop
   endif
   select 2
   STORE UPPER(WPARCOD) TO WPARCOD
   store wprecod+Wparcod to clave
   find &clave
   if eof()
      store "ERROR, Codigo de partida no registrado para este Presupuesto" to mes
      do aviso with mes
      select 1
      loop
   endif
   @ 07,18  say pardes1
   @ 08,18  say pardes2
   @ 09,18  say pardes3
   @ 10,18  say pardes4
   @ 11,18  say pardes5
   @ 12,18  say pardes6

   if paranalis <> "SI"
      store "ERROR, Esta partida esta definida sin analisis (Ù)" to mes
      do aviso with mes
      loop
   endif

   store "Opciones: (C)ontinuar, (S)alir " to mes
   store "C" to p1
   store "S" to p2
   store " " to resp
   do pide2 with p1,p2,mes,resp
   if resp = "S"
      select 1
      loop
   endif

   STORE 0 TO SALIDA
   DO CHKPRINT WITH SALIDA
   if salida = 1
      loop
   endif
   SET DEVI TO PRINT
   STORE 100 TO LINE
   STORE 0 TO PAGINA
   store "REVISION DE PRECIOS" TO HEAD
   STORE "----------" TO Q
   STORE Q+Q+Q+Q+Q+Q+Q+Q TO Q
   *******  MATERIALES   ********
   SELECT 3
   USE IPPMATER INDEX IPPMATER ALIAS MATERIAL
   SELECT 4
   USE IPPTIMAT INDEX IPPTIMAT ALIAS TIPOS
   SELECT 3
   LOCATE FOR MATERPRE = WPRECOD .AND. MATERPAR = WPARCOD
   DO WHILE .NOT. EOF()
      IF LINE > 50
         STORE PAGINA + 1 TO PAGINA
         @ 1,40-(len(RTRIM(QQWW))/2) say QQWW
         @ 2,1 SAY "FECHA:"+DTOC(WFECACT)
         @ 2,70 SAY "PAGINA:"+STR(PAGINA,3)
         @ 3,40-(len(HEAD)/2) say HEAD
         @ 5,1 SAY "PRESUPUESTO: "+WOBRA
         @ 5,50 SAY "PARTIDA: "+WPARCOD
         STORE "1- M A T E R I A L E S" TO TITULO
         @ 6,1 SAY TITULO
         @ 8,1 SAY "CODIGO"
         @ 8,10 SAY "DESCRIPCION"
         @ 8,45 SAY "PRECIO ACTUAL"
         @ 8,60 SAY "PRECIO EN PARTIDA"
         STORE 09 TO LINE
      ENDIF
      STORE MATERCOD TO CLAVE
      SELECT 4
      FIND &CLAVE
      IF EOF()
         STORE "NO REGISTRADO " TO WMATDES
         STORE 0 TO WMATPRE
      ELSE
         STORE MATDES TO WMATDES
         STORE MATPRE TO WMATPRE
      ENDIF
      SELECT 3
      IF MATERPREUN <> WMATPRE
         STORE LINE+1 TO LINE
         @ LINE,1 SAY Q
         STORE LINE+1 TO LINE
         @ LINE,1 SAY CLAVE
         @ LINE,10 SAY WMATDES
         @ LINE,47 SAY WMATPRE PICTURE "########.##"
         @ LINE,66 SAY MATERPREUN PICTURE "########.##"
      ENDIF
      CONTINUE
   ENDDO
   ******   EQUIPOS    *******
   STORE 100 TO LINE
   SELECT 3
   USE IPPEQUIP INDEX IPPEQUIP ALIAS EQUIPOS
   SELECT 4
   USE IPPTIEQP INDEX IPPTIEQP ALIAS TIPOS
   SELECT 3
   LOCATE FOR EQUIPPRE = WPRECOD .AND. EQUIPPAR = WPARCOD
   DO WHILE .NOT. EOF()
      IF LINE > 50
         STORE PAGINA + 1 TO PAGINA
         @ 1,40-(len(RTRIM(QQWW))/2) say QQWW
         @ 2,1 SAY "FECHA:"+DTOC(WFECACT)
         @ 2,70 SAY "PAGINA:"+STR(PAGINA,3)
         @ 3,40-(len(HEAD)/2) say HEAD
         @ 5,1 SAY "PRESUPUESTO: "+WOBRA
         @ 5,50 SAY "PARTIDA: "+WPARCOD
         STORE "2- E Q U I P O S " TO TITULO
         @ 6,1 SAY TITULO
         @ 8,1 SAY "CODIGO"
         @ 8,10 SAY "DESCRIPCION"
         @ 8,45 SAY "PRECIO ACTUAL"
         @ 8,60 SAY "PRECIO EN PARTIDA"
         STORE 09 TO LINE
      ENDIF
      STORE EQUIPCOD TO CLAVE
      SELECT 4
      FIND &CLAVE
      IF EOF()
         STORE "NO REGISTRADO " TO WEQPDES
         STORE 0 TO WEQPPRE
      ELSE
         STORE EQPDES TO WEQPDES
         STORE EQPPRE TO WEQPPRE
      ENDIF
      SELECT 3
      IF EQUIPPREUN <> WEQPPRE
         STORE LINE+1 TO LINE
         @ LINE,1 SAY Q
         STORE LINE+1 TO LINE
         @ LINE,1 SAY CLAVE
         @ LINE,10 SAY WEQPDES
         @ LINE,47 SAY WEQPPRE PICTURE "########.##"
         @ LINE,66 SAY EQUIPPREUN PICTURE "########.##"
      ENDIF
      CONTINUE
   ENDDO
   ******   MANO DE OBRA    ******
   STORE 100 TO LINE
   SELECT 3
   USE IPPMDO   INDEX IPPMDO   ALIAS MANO
   SELECT 4
   USE IPPTIMDO INDEX IPPTIMDO ALIAS TIPOS
   SELECT 3
   LOCATE FOR MOBRAPRE = WPRECOD .AND. MOBRAPAR = WPARCOD
   DO WHILE .NOT. EOF()
      IF LINE > 50
         STORE PAGINA + 1 TO PAGINA
         @ 1,40-(len(RTRIM(QQWW))/2) say QQWW
         @ 2,1 SAY "FECHA:"+DTOC(WFECACT)
         @ 2,70 SAY "PAGINA:"+STR(PAGINA,3)
         @ 3,40-(len(HEAD)/2) say HEAD
         @ 5,1 SAY "PRESUPUESTO: "+WOBRA
         @ 5,50 SAY "PARTIDA: "+WPARCOD
         STORE "3- M A N O    D E    O B R A " TO TITULO
         @ 6,1 SAY TITULO
         @ 8,1 SAY "CODIGO"
         @ 8,10 SAY "DESCRIPCION"
         @ 8,45 SAY "JORNAL ACTUAL"
         @ 8,60 SAY "JORNAL EN PARTIDA"
         STORE 09 TO LINE
      ENDIF
      STORE MOBRACOD TO CLAVE
      SELECT 4
      FIND &CLAVE
      IF EOF()
         STORE "NO REGISTRADO " TO WMDODES
         STORE 0 TO WMDOJOR
      ELSE
         STORE MDODES TO WMDODES
         STORE MDOJOR TO WMDOJOR
      ENDIF
      SELECT 3
      IF MOBRAJOR <> WMDOJOR
         STORE LINE+1 TO LINE
         @ LINE,1 SAY Q
         STORE LINE+1 TO LINE
         @ LINE,1 SAY CLAVE
         @ LINE,10 SAY WMDODES
         @ LINE,47 SAY WMDOJOR PICTURE "########.##"
         @ LINE,66 SAY MOBRAJOR PICTURE "########.##"
      ENDIF
      CONTINUE
   ENDDO
   EJECT
   SET DEVI TO SCRE
ENDDO


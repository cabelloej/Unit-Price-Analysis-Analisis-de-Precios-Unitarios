CLOSE ALL
RELEASE ALL
CLEAR ALL
SET DEVI TO SCRE
SET COMPA TO FOXPLUS
SET TALK OFF
SET ECHO OFF
SET HELP OFF
SET SCOREBOARD OFF
SET ESCAPE OFF
SET DELIMITER OFF
SET BELL OFF
SET STATUS OFF
SET SAFETY OFF
SET DELETED ON
SET CONFIRM ON
SET EXACT ON
SET DATE ITALIAN
SET PROCEDURE TO IPPPROC
* LOAD SAVESCR
* LOAD MENUBAR

USE IPPDATE
IF DATE() = CTOD("01-01-80")
   STORE FECHASIST TO WFECACT
ELSE
   STORE DATE() TO WFECACT
ENDIF
STORE SPACE(10) TO WPARPRE
STORE SPACE(13) TO WPARCOD
STORE PORLDT TO WWPORLDT
STORE PORADM TO WWPORADM
STORE PORIMP TO WWPORIMP
store pordes to wwpordes
if falla = 1
   replace vecez with vecez+1
   do ippestru
   else
      replace falla with 1
endif
USE

STORE "Cargando sistema, favor esperar ..." to T8
@ 12,40-(len(t8)/2) say t8

STORE SPACE(26) TO QQWW
DO INFORMA
SET COLOR TO W/N/,,
CLEAR
SET COLOR TO R+/N
@ 0,0 TO 3,79 DOUBLE
@ 5,0 TO 21,79 DOUBLE
@ 22,0 TO 24,79 DOUBLE
@ 5,26 SAY "Ñ"
@ 5,53 SAY "Ñ"
@ 6,26 SAY "³"
@ 6,53 SAY "³"
@ 7,26 SAY "³"
@ 7,53 SAY "³"
@ 8,0 SAY "ÇÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¶"
@ 9,26 SAY "³"
@ 9,53 SAY "³"
@ 10,26 SAY "³"
@ 10,53 SAY "³"
@ 11,26 SAY "³"
@ 11,53 SAY "³"
@ 12,26 SAY "³"
@ 12,53 SAY "³"
@ 13,26 SAY "³"
@ 13,53 SAY "³"
@ 14,26 SAY "³"
@ 14,53 SAY "³"
@ 15,26 SAY "³"
@ 15,53 SAY "³"
@ 16,26 SAY "³"
@ 16,53 SAY "³"
@ 17,26 SAY "³"
@ 17,53 SAY "³"
@ 18,26 SAY "³"
@ 18,53 SAY "³"
@ 19,26 SAY "³"
@ 19,53 SAY "³"
@ 20,26 SAY "³"
@ 20,53 SAY "³"
@ 21,26 SAY "Ï"
@ 21,53 SAY "Ï"

SET COLOR TO G/N
STORE "Sistema: ANALISIS DE PRECIO UNITARIO" TO T1
STORE "Realizado por CONTROL INFORMATICO, C.A." TO T2
STORE "FEMACO                    "   TO T3
STORE "Fecha: "+DTOC(WFECACT) TO T4
STORE "Use las flechas para mover la barra indicadora y seleccione con ÄÙ" to T7
STORE "Cargando sistema, favor esperar ..." to T8
@ 6,5 SAY "MENU PRINCIPAL"
@ 6,35 SAY "FUNCIONES"
@ 6,61 SAY "COMENTARIOS"
@ 2,63 SAY T4
@ 2,2 SAY  T1
@ 4,58 SAY "Autor: Eduardo Cabello"
@ 4,0 SAY T2
set color to g+*/n
@ 23,40-(LEN(T8)/2) SAY T8
SET COLOR TO G+/N
@ 1,2 SAY T3

SET COLOR TO W+/B
@ 9,1 CLEAR TO 20,25

store 0 to ppp
if qqww<>t3
   store "Instalacion no Autorizada" to mes
   do aviso with mes
   store 1 to ppp
endif

********************* OPCIONES PRINCIPALES *************************
STORE " ANALISIS                " TO X_1
STORE " PLANIFICACION (N/D)     " TO X_2
STORE " CONTROL DE OBRA (N/D)   " TO X_3
STORE " VALUACIONES             " TO X_4
STORE " INFORMES                " TO X_5
STORE " ACTUALIZAR SISTEMA      " TO X_6
STORE " FIN DE OPERACIONES      " TO X_7
@ 8+1,1 SAY X_1
@ 8+2,1 SAY X_2
@ 8+3,1 SAY X_3
@ 8+4,1 SAY X_4
@ 8+5,1 SAY X_5
@ 8+6,1 SAY X_6
@ 8+7,1 SAY X_7

********************* NUMERO DE SUBOCIONES POR OPCION PRINCIPAL ******
STORE 7 TO WS1
STORE 1 TO WS2
STORE 1 TO WS3
STORE 6 TO WS4
STORE 4 TO WS5
STORE 8 TO WS6
STORE 1 TO WS7

********************* NUMERO TOTAL DE OPCIONES PRINCIPALES ***********
STORE 7 TO LINEAS

********************* INICIALIZANDO SUBOPCIONES **********************
STORE SPACE(26) TO Y1
STORE SPACE(26) TO Y2
STORE SPACE(26) TO Y3
STORE SPACE(26) TO Y4
STORE SPACE(26) TO Y5
STORE SPACE(26) TO Y6
STORE SPACE(26) TO Y7
STORE SPACE(26) TO Y8
STORE SPACE(26) TO Y9
STORE SPACE(26) TO Y10
STORE SPACE(26) TO Y11
STORE SPACE(26) TO Y12

STORE lineas TO OP
STORE lineas TO BORRAR
SET COLOR TO n/g
STORE "X_"+LTRIM(STR(OP)) TO X
@ 8+OP,1 SAY &X

STORE "WS"+LTRIM(STR(OP)) TO WS
STORE &WS TO WSO

SET COLOR TO W+/B
STORE 0 TO XSALIDA

if ppp = 1
   close all
   quit
endif

DO WHILE XSALIDA = 0
   DO mainop
   @ 23,40-(LEN(T7)/2) SAY T7
   STORE "WS"+LTRIM(STR(OP)) TO WS
   STORE &WS TO WSO

   CLEAR TYPEAHEAD
   STORE 0 TO A
   DO WHILE A = 0
      A=INKEY()
      IF (A <> 5) .AND. (A <> 24) .AND. (A <> 4) .AND. (A <> 13)
         STORE 0 TO A
      ENDIF
   ENDDO
   IF A = 5
      STORE OP TO BORRAR
      STORE OP - 1 TO OP
      IF OP = 0
         STORE LINEAS TO OP
      ENDIF
   ELSE
      IF A = 24
         STORE OP TO BORRAR
         STORE OP+1 TO OP
         IF OP > LINEAS
            STORE 1 TO OP
         ENDIF
      ELSE
         IF A = 4 .OR. A = 13
            IF OP = LINEAS
               use ippdate
               replace falla with 0
               use
               CLOSE DATA
               CLOSE INDEX
               SET COLOR TO W/N
               CLEAR
               quit
            ENDIF
            IF WSO = 1
               STORE LTRIM(STR(OP)) TO PX1
               IF LEN(PX1) = 1
                  STORE "0"+PX1 TO PX1
               ENDIF
               STORE "00" TO PX2
               STORE "IPP"+PX1+PX2 TO WFILE
               SAVE SCRE TO S1
               * CALL SAVESCR WITH "S1"
               DO &WFILE
               RESTORE SCRE FROM S1
               * CALL SAVESCR WITH "R1"
            ELSE
               STORE 1 TO OPP
               STORE 1 TO BORRARE
               STORE 0 TO SALIDA2
               STORE "Y"+LTRIM(STR(OPP)) TO Y
               SET COLOR TO N/N
               @ 8+OP,1 SAY &X
               SET COLOR TO n/g
               @ 7,27 SAY " "+&X
               SET COLOR TO n/g
               @ 8+OPP,27 SAY &Y
               SET COLOR TO W+/B
               DO WHILE SALIDA2 = 0
                  DO SUBOP
                  STORE 0 TO SUBOPCION
                  STORE 8 TO SLS
                  CLEAR TYPEAHEAD
                  STORE 0 TO AA
                  DO WHILE AA = 0
                     AA=INKEY()
                     IF (AA <> 5) .AND. (AA <> 24) .AND. (AA <> 13) .AND. (AA <> 19)
                        STORE 0 TO AA
                     ENDIF
                  ENDDO
                  IF AA = 19
                     STORE 1 TO SALIDA2
                     SET COLOR TO W/N
                     @ 7,27 SAY SPACE(26)
                     LOOP
                  ENDIF
                  IF AA = 5
                     STORE OPP TO BORRARE
                     STORE OPP - 1 TO OPP
                     IF OPP = 0
                        STORE WSO TO OPP
                     ENDIF
                  ELSE
                     IF AA = 24
                        STORE OPP TO BORRARE
                        STORE OPP+1 TO OPP
                        IF OPP > WSO
                           STORE 1 TO OPP
                        ENDIF
                     ELSE
                        IF  A = 13 .OR. A = 4
                            STORE LTRIM(STR(OP)) TO PX1
                            IF LEN(PX1) = 1
                               STORE "0"+PX1 TO PX1
                            ENDIF
                            STORE LTRIM(STR(OPP)) TO PX2
                            IF LEN(PX2) = 1
                               STORE "0"+PX2 TO PX2
                            ENDIF
                            STORE "IPP"+PX1+PX2 TO WFILE
                            SAVE SCRE TO S1
                            * CALL SAVESCR WITH "S1"
                            DO &WFILE
                            RESTORE SCRE FROM S1
                            * CALL SAVESCR WITH "R1"
                            @ 2,70 SAY DTOC(WFECACT)
                        ENDIF
                     ENDIF
                  ENDIF

                  STORE "Y"+LTRIM(STR(BORRARE)) TO Y
                  SET COLOR TO W+/B
                  @ 8+BORRARE,27 SAY &Y
                  SET COLOR TO n/g
                  STORE "Y"+LTRIM(STR(OPP)) TO Y
                  @ 8+OPP,27 SAY &Y
                  SET COLOR TO W+/B
               ENDDO
            ENDIF
         ENDIF
      ENDIF
   ENDIF
   SET COLOR TO W+/B
   STORE "X_"+LTRIM(STR(BORRAR)) TO X
   @ 8+BORRAR,1 SAY &X
   SET COLOR TO n/g
   STORE "X_"+LTRIM(STR(OP)) TO X
   @ 8+OP,1 SAY &X
   SET COLOR TO W+/B
ENDDO


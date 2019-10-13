select 1
use ipppresu index ipppresu

store .t. to varia
do while varia
   STORE "Ingrese el codigo del presupuesto a procesar" to mes
   do mensaje with mes
   store space(10) to wpresu
   @ 5,0 clear to 16,79
   @ 5,0 to 16,79 double
   @ 5,25 say "VARIACION PORCENTUAL DE INSUMOS"
   @ 7,5  SAY "PRESUPUESTO ...: "
   @ 12,5 SAY "INSUMO ........:"
   @ 14,5 SAY "PORCENTAJE ....:"
   @ 7,21 GET WPRESU
   READ
   IF WPRESU = SPACE(10)
      CLOSE DATA
      CLOSE INDEX
      RETURN
   ENDIF
   SELECT 1
   FIND &WPRESU
   IF EOF()
      store "Codigo no registrado" to mes
      do aviso with mes
      loop
   endif
   @ 7,40  say preobra
   @ 8,40  say preobra2
   @ 9,40  say preobra3
   @ 10,40 say preobra4
   store "Tipo de insumo: (M)ateriales, (E)quipos, (L)abor, (S)alir" to mes
   store "M" to p1
   store "E" to p2
   store "L" to p3
   store "S" to p4
   STORE " " TO RESP
   DO PIDE4 WITH P1,P2,P3,P4,MES,RESP
   STORE RESP TO ARCHIVO
   IF ARCHIVO = "S"
      LOOP
   ENDIF
   IF ARCHIVO = "M"
      STORE "MATERIALES" TO EJE
   ENDIF
   IF ARCHIVO = "E"
      STORE "EQUIPOS" TO EJE
   ENDIF
   IF ARCHIVO = "L"
      STORE "LABOR" TO EJE
   ENDIF
   @ 12,21 SAY EJE
   STORE 0.00 TO WPORC
   @ 14, 25 GET WPORC PICTURE "###.##"
   READ
   IF WPORC = 0
      LOOP
   ENDIF
   STORE "Opciones: (C)ontinuar, (S)alir" to mes
   store "C" to p1
   store "S" to p2
   store " " to resp
   do pide2 with p1,p2,mes,resp
   IF resp = "S"
      LOOP
   ENDIF
   IF ARCHIVO = "M"
      SELECT 2
      USE IPPMATER INDEX IPPMATER
      LOCATE FOR MATERPRE = WPRESU
      DO WHILE .NOT. EOF()
         REPLACE MATERPREUN WITH (MATERPREUN*WPORC)/100
         CONTINUE
      ENDDO
      SELECT 1
      LOOP
   ENDIF
   IF ARCHIVO = "E"
      SELECT 2
      USE IPPEQUIP INDEX IPPEQUIP
      LOCATE FOR EQUIPPRE = WPRESU
      DO WHILE .NOT. EOF()
         REPLACE EQUIPPREUN WITH (EQUIPPREUN*WPORC)/100
         CONTINUE
      ENDDO
      SELECT 1
      LOOP
   ENDIF
   IF ARCHIVO = "L"
      SELECT 2
      USE IPPMDO   INDEX IPPMDO
      LOCATE FOR MOBRAPRE = WPRESU
      DO WHILE .NOT. EOF()
         REPLACE MOBRAJOR WITH (MOBRAJOR*WPORC)/100
         REPLACE MOBRABON WITH (MOBRABON*WPORC)/100
         CONTINUE
      ENDDO
      SELECT 1
      LOOP
   ENDIF
ENDDO
CLOSE DATA
CLOSE INDEX
RETURN


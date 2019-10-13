PROCEDURE HEAD0501
IF WTOTALPRE > 0
   @ LINE+1,0 SAY Q
   @ LINE+2,0 SAY "|"
   @ LINE+2,135 SAY "|"
   @ LINE+2,5 SAY "FIRMA DEL CONTRATISTA:"
   @ LINE+2,100 SAY "VAN Bs. ="
   @ LINE+2,122 SAY STR(WTOTALPRE,11,2)
   @ LINE+3,0 SAY Q
ENDIF
STORE PAGINA + 1 TO PAGINA
@ 0,0 SAY CHR(18)
@ 0,1 SAY CHR(14)+QQWW
@ 1,0 SAY "R.I.F.  No. J-08013780-9"
@ 1,69 SAY wprecod
@ 2,0 SAY CHR(15)
@ 2,0 SAY Q
@ 3,0 SAY "|"
@ 3,135 SAY "|"
@ 3,65- (LEN(HEAD)/2) SAY HEAD
@ 3,110 SAY "PAGINA:"+STR(PAGINA,3)
@ 4,0 SAY "|"
@ 4,135 SAY "|"
@ 4,4 SAY "C L I E N T E :  "+HEAD6
@ 4,110 SAY "FECHA :"+DTOC(WFECACT)
@ 5,0 SAY Q
@ 6,0 SAY "|"
@ 6,135 SAY "|"
@ 6,21 SAY "OBJETO :"
@ 6,30 SAY HEAD2 + HEAD3
@ 7,0 SAY "|"
@ 7,135 SAY "|"
@ 7,4 SAY "O B R A :"
@ 7,30 SAY HEAD4 + HEAD5
@ 8,0 SAY "|"
@ 8,135 SAY "|"
@ 8,21 SAY "SITIO  :"
@ 8,30 SAY WDIR
@ 09,0 SAY Q
@ 10,0 SAY "|"
@ 10,16 SAY "|"
@ 10,64 SAY "|"
@ 10,76 SAY "|"
@ 10,93 SAY "|"
@ 10,112 SAY "|"
@ 10,135 SAY "|"
@ 10,1 SAY "No."
@ 10,20 SAY "DESCRIPCION"
@ 10,65 SAY "UNIDAD"
@ 10,82 SAY "CANTIDAD"
@ 10,104 SAY "PRECIO"
@ 10,129 SAY "TOTAL"
@ 11,0 SAY Q
STORE 11 TO LINE
RETURN
**************************
PROCEDURE HEAD0503
STORE PAGINA + 1 TO PAGINA
@ 0,0    SAY CHR(18)
@ 0,1    SAY CHR(14)+QQWW
@ 1,0    SAY "RESUMEN DE MATERIALES POR OBRA"
@ 1,60   SAY "PAGINA:"+STR(PAGINA,3)
@ 2,60   SAY "FECHA :"+DTOC(WFECACT)
@ 3,00   SAY "OBRA:"+WPRECOD
@ 4,00   SAY WDESCRI1+WDESCRI2
@ 5,00   SAY WDESCRI3+WDESCRI4
@ 6,00 SAY CHR(15)
@ 07,00  SAY "MATERIAL"
@ 07,55  SAY "UNIDAD"
@ 07,70  SAY "PARTIDA"
@ 07,87  SAY "CANTIDAD"
@ 07,103 SAY "   PRECIO OBRA"
@ 07,122 SAY "   PRECIO ACT."
@ 08,00  SAY "--------------------------------------------------"
@ 08,55  SAY "----------"
@ 08,70  SAY "-------------"
@ 08,85  SAY "----------"
@ 08,103 SAY "--------------"
@ 08,122 SAY "--------------"
STORE 9 TO LINEA
RETURN
**************************
PROCEDURE HEADANA
store pagina + 1 to pagina
@ 00,00 say chr(18)+" "
@ 00,1 SAY CHR(14)+QQWW
@ 01,25 SAY "ANALISIS DE PRECIOS UNITARIOS"
@ 01,25 SAY "ANALISIS DE PRECIOS UNITARIOS"
@ 02,0 SAY "+----------------------------------------+-----------+--------------+----------+"
@ 03,0 SAY "|                                        |           |              |          |"
@ 03,0 SAY "                                          PRESUPUESTO PARTIDA No.    HOJA No.   "
@ 03,0 SAY "                                          PRESUPUESTO PARTIDA No.    HOJA No.   "
@ 03,1 SAY PRESUP->PREOBRA
@ 04,0 SAY "|                                        |           |              |          |"
@ 04,1 SAY PRESUP->PREOBRA2
@ 04,42 SAY WPRECOD
@ 04,54 SAY WPARCOD
@ 04,65 SAY STR(PAGINA,5)
@ 05,0 SAY "|                                        |           |              |          |"
@ 05,1 SAY PRESUP->PREOBRA3
@ 06,0 SAY "|                                        |           |              |          |"
@ 06,1 SAY PRESUP->PREOBRA4
@ 07,0 SAY "|----------------------------------------+-----------+--------------+----------|"
@ 08,0 SAY "|                                                                              |"
@ 08,0 SAY "                          DESCRIPCION DE LA PARTIDA:                            "
@ 08,0 SAY "                          DESCRIPCION DE LA PARTIDA:                            "
@ 09,0 SAY "|                                                                              |"
@ 09,1 SAY CHR(15)+partida->PARDES1+" | "+partida->PARDES3+" | "+PARTIDA->PARDES5
@ 10,1 SAY partida->PARDES2+"  | "+partida->PARDES4+" | "+PARTIDA->PARDES6
@ 10,0 SAY CHR(18)
@ 10,0 SAY "|                                                                              |"
@ 11,0 SAY "|--------------+----------------+------------------------------+---------------|"
@ 12,0 SAY "|              |                |                              |               |"
@ 12,0 SAY " UND:           CANT:            RENDTO:                        REF.:           "
@ 12,0 SAY " UND:           CANT:            RENDTO:                        REF.:           "
@ 12,5 SAY partida->PARUNID
@ 12,22 SAY STR(partida->PARCANT,10,2)
@ 12,41 SAY STR(partida->PARREND,11,2)
@ 12,54 SAY RTRIM(PARTIDA->PARUNID)+"/Dia"
@ 12,69 SAY partida->PARREF
@ 13,0 SAY "+--------------+----------------+------------------------------+---------------+"
STORE 13 TO LINE
RETURN
**********************************
PROCEDURE PAGEMAT
DO HEADANA
DO HEADMAT
RETURN
**********************************
PROCEDURE HEADMAT
@ 15,0 SAY "1- MATERIALES:"
@ 15,0 SAY "1- MATERIALES:"
@ 16,0 SAY "+------------------------------+----------+-----------+------------+-----------+"
@ 17,0 SAY "|        DESCRIPCION           |  UNIDAD  | CANTIDAD  |PRECIO UNIT.| BOLIVARES |"
@ 17,0 SAY "         DESCRIPCION              UNIDAD    CANTIDAD   PRECIO UNIT.  BOLIVARES  "
@ 18,0 SAY "|------------------------------+----------+-----------+------------+-----------+"
store 18 to line
RETURN
**********************************
PROCEDURE PAGEEQP
DO HEADANA
*DO HEADMAT
DO HEADEQP
RETURN
**********************************
PROCEDURE HEADEQP
STORE LINE+1 TO LINE
@ LINE,0 SAY "2- EQUIPOS:"
@ LINE,0 SAY "2- EQUIPOS:"
@ LINE+1,0 SAY "+------------------------------+----------+-----------+------------+-----------+"
@ LINE+2,0 SAY "|        DESCRIPCION           |CANTIDAD  |PRECIO UNIT|DEPRECIACION| BOLIVARES |"
@ LINE+2,0 SAY "         DESCRIPCION            CANTIDAD   PRECIO UNIT DEPRECIACION  BOLIVARES  "
@ LINE+3,0 SAY "|------------------------------+----------+-----------+------------+-----------+"
store LINE+3 to line
**********************************
PROCEDURE PAGEMDO
DO HEADANA
*DO HEADMAT
*DO HEADEQP
DO HEADMDO
RETURN
**********************************
PROCEDURE HEADMDO
STORE LINE+1 TO LINE
@ LINE,0 SAY "3- MANO DE OBRA:"
@ LINE,0 SAY "3- MANO DE OBRA:"
@ LINE+1,0 SAY "+------------------------------+----------+-----------+------------+-----------+"
@ LINE+2,0 SAY "|        DESCRIPCION           | CANTIDAD |  JORNAL   |BONO COMPEN.| BOLIVARES |"
@ LINE+2,0 SAY "         DESCRIPCION             CANTIDAD    JORNAL    BONO COMPEN.  BOLIVARES  "
@ LINE+3,0 SAY "|------------------------------+----------+-----------+------------+-----------+"
store LINE+3 to line
RETURN
**********************************
PROCEDURE CHKPRINT
PARAMETERS SALTAR
store .t. to wprinting
do while wprinting
   store "Prepare la impresora y oprima (Ù) para continuar o (S)alir" to mes
   @ 23,1 say space(78)
   @ 23,40-(len(mes)/2) say mes
*  do mensaje with mes
   store " " to wstat
   @ 23,78 get wstat
   read
   if upper(wstat) = "S"
      store 1 to saltar
      store .f. to wprinting
   else
      store 0 to saltar
      if sys(13) = "READY"
         store .f. to wprinting
      endif
   endif
enddo
RETURN
*****************************************************

PROCEDURE REDONDEO
PARAMETERS VARIABLE
STORE VARIABLE - INT(VARIABLE) TO VARB
STORE VARB*1000 TO VARC
STORE VARC+.001 TO VARC
STORE INT(VARC) TO VARD
STORE (VARD/1000) TO VARE
STORE INT(VARIABLE)+VARE TO VARIABLE
RETURN
****************************************************************************
procedure ippestru
store "Estructurando base de datos debido a salida forzada del sistema..." to mes
@ 12,5 say mes
use ipppresu index ipppresu
reindex
use ippparti index ipppart1,ipppart2
reindex
use ipptimat index ipptimat
reindex
use ippmater index ippmater
reindex
use ipptieqp index ipptieqp
reindex
use ippequip index ippequip
reindex
use ipptimdo index ipptimdo
reindex
use ippmdo   index ippmdo
reindex
use ippvalge index ippvalge
reindex
use ippvalde index ippvalde
reindex
use ippparde index ippparde
reindex
clear
return
*********************************************

PROCEDURE MENSAJE
PARAMETERS MES
SET COLOR TO W+/B
@ 23,1 SAY SPACE(78)
@ 23,40-(LEN(MES)/2) SAY MES
RETURN
**************************************************
PROCEDURE AVISO
PARAMETERS MES
STORE " " TO X
SET COLOR TO W+/B
@ 23,1 SAY SPACE(78)
@ 23,40-(LEN(MES)/2) SAY MES GET X
READ
@ 23,1 SAY SPACE(78)
RETURN
**************************************************
PROCEDURE PIDE1
PARAMETERS P1,MES,RESP
SET COLOR TO W+/B
@ 23,1 SAY SPACE(78)
STORE " " TO RESP
DO WHILE RESP <> P1
   STORE " " TO RESP
   @ 23,40-(LEN(MES)/2) SAY MES GET RESP
   READ
   STORE UPPER(RESP) TO RESP
ENDDO
@ 23,1 SAY SPACE(78)
RETURN
***************************************************
PROCEDURE PIDE2
PARAMETERS P1,P2,MES,RESP
SET COLOR TO W+/B
@ 23,1 SAY SPACE(78)
STORE " " TO RESP
DO WHILE RESP <> P1 .AND. RESP <> P2
   STORE " " TO RESP
   @ 23,40-(LEN(MES)/2) SAY MES GET RESP
   READ
   STORE UPPER(RESP) TO RESP
ENDDO
@ 23,1 SAY SPACE(78)
RETURN
************************************
PROCEDURE PIDE3
PARAMETERS P1,P2,P3,MES,RESP
SET COLOR TO W+/B
@ 23,1 SAY SPACE(78)
STORE " " TO RESP
DO WHILE RESP <> P1 .AND. RESP <> P2 .AND. P3 <> RESP
   STORE " " TO RESP
   @ 23,40-(LEN(MES)/2) SAY MES GET RESP
   READ
   STORE UPPER(RESP) TO RESP
ENDDO
@ 23,1 SAY SPACE(78)
RETURN
************************************
PROCEDURE PIDE4
PARAMETERS P1,P2,P3,P4,MES,RESP
SET COLOR TO W+/B
@ 23,1 SAY SPACE(78)
STORE " " TO RESP
DO WHILE RESP <> P1 .AND. RESP <> P2 .AND. P3 <> RESP .AND. RESP <> P4
   STORE " " TO RESP
   @ 23,40-(LEN(MES)/2) SAY MES GET RESP
   READ
   STORE UPPER(RESP) TO RESP
ENDDO
@ 23,1 SAY SPACE(78)
RETURN
************************************
PROCEDURE PIDE5
PARAMETERS P1,P2,P3,P4,P5,MES,RESP
SET COLOR TO W+/B
@ 23,1 SAY SPACE(78)
STORE " " TO RESP
DO WHILE RESP <> P1 .AND. RESP <> P2 .AND. P3 <> RESP .AND. RESP <> P4 .AND. RESP <> P5
   STORE " " TO RESP
   @ 23,40-(LEN(MES)/2) SAY MES GET RESP
   READ
   STORE UPPER(RESP) TO RESP
ENDDO
@ 23,1 SAY SPACE(78)
RETURN
********************************************************************
PROCEDURE mainop
DO CASE
   CASE OP = 1
        STORE " Actualizar Analisis      " TO Y1
        STORE " Copiar Partida           " TO Y2
        STORE " Consultar Prec. Unitario " TO Y3
        STORE " Reajustar Prec. Unitario " TO Y4
        STORE " Informe de A.P.U.        " TO Y5
        STORE " Revisar Precios Presup.  " TO Y6
        STORE " Asumir Precio Unitario   " TO Y7
        STORE "                          " TO Y8
        STORE "                          " TO Y9
        STORE "                          " TO Y10
        STORE "                          " TO Y11
        STORE "                          " TO Y12

        @ 9,27  SAY Y1
        @ 10,27 SAY Y2
        @ 11,27 SAY Y3
        @ 12,27 SAY Y4
        @ 13,27 SAY Y5
        @ 14,27 SAY Y6
        @ 15,27 SAY Y7
        @ 16,27 SAY Y8
        @ 17,27 SAY Y9
        @ 18,27 SAY Y10
        @ 19,27 SAY Y11
        @ 20,27 SAY Y12
        @ 9,54  SAY "                         "
        @ 10,54 SAY "                         "
        @ 11,54 SAY "                         "
        @ 12,54 SAY "                         "
        @ 13,54 SAY "                         "
        @ 14,54 SAY "                         "
        @ 15,54 SAY "                         "
        @ 16,54 SAY "                         "
        @ 17,54 SAY "                         "
        @ 18,54 SAY "                         "
        @ 19,54 SAY "                         "
        @ 20,54 SAY "                         "


   CASE OP = 2
        STORE "                          " TO Y1
        STORE "                          " TO Y2
        STORE "                          " TO Y3
        STORE "                          " TO Y4
        STORE "                          " TO Y5
        STORE "                          " TO Y6
        STORE "                          " TO Y7
        STORE "                          " TO Y8
        STORE "                          " TO Y9
        STORE "                          " TO Y10
        STORE "                          " TO Y11
        STORE "                          " TO Y12

        @ 9,27  SAY Y1
        @ 10,27 SAY Y2
        @ 11,27 SAY Y3
        @ 12,27 SAY Y4
        @ 13,27 SAY Y5
        @ 14,27 SAY Y6
        @ 15,27 SAY Y7
        @ 16,27 SAY Y8
        @ 17,27 SAY Y9
        @ 18,27 SAY Y10
        @ 19,27 SAY Y11
        @ 20,27 SAY Y12
        @ 9,54  SAY "                         "
        @ 10,54 SAY "                         "
        @ 11,54 SAY "                         "
        @ 12,54 SAY "                         "
        @ 13,54 SAY "                         "
        @ 14,54 SAY "                         "
        @ 15,54 SAY "                         "
        @ 16,54 SAY "                         "
        @ 17,54 SAY "                         "
        @ 18,54 SAY "                         "
        @ 19,54 SAY "                         "
        @ 20,54 SAY "                         "
   CASE OP = 3

        STORE "                          " TO Y1
        STORE "                          " TO Y2
        STORE "                          " TO Y3
        STORE "                          " TO Y4
        STORE "                          " TO Y5
        STORE "                          " TO Y6
        STORE "                          " TO Y7
        STORE "                          " TO Y8
        STORE "                          " TO Y9
        STORE "                          " TO Y10
        STORE "                          " TO Y11
        STORE "                          " TO Y12

        @ 9,27  SAY Y1
        @ 10,27 SAY Y2
        @ 11,27 SAY Y3
        @ 12,27 SAY Y4
        @ 13,27 SAY Y5
        @ 14,27 SAY Y6
        @ 15,27 SAY Y7
        @ 16,27 SAY Y8
        @ 17,27 SAY Y9
        @ 18,27 SAY Y10
        @ 19,27 SAY Y11
        @ 20,27 SAY Y12
        @ 9,54  SAY "                         "
        @ 10,54 SAY "                         "
        @ 11,54 SAY "                         "
        @ 12,54 SAY "                         "
        @ 13,54 SAY "                         "
        @ 14,54 SAY "                         "
        @ 15,54 SAY "                         "
        @ 16,54 SAY "                         "
        @ 17,54 SAY "                         "
        @ 18,54 SAY "                         "
        @ 19,54 SAY "                         "
        @ 20,54 SAY "                         "
   CASE OP = 4

        STORE " Actualizar Valuacion     " TO Y1
        STORE " Imprimir Valuacion       " TO Y2
        STORE " Resumen de Partida       " TO Y3
        STORE " Resumen de Valuaciones   " TO Y4
        STORE " Avance de Obra           " TO Y5
        STORE " Aumentos y Disminuciones " TO Y6
        STORE "                          " TO Y7
        STORE "                          " TO Y8
        STORE "                          " TO Y9
        STORE "                          " TO Y10
        STORE "                          " TO Y11
        STORE "                          " TO Y12

        @ 9,27  SAY Y1
        @ 10,27 SAY Y2
        @ 11,27 SAY Y3
        @ 12,27 SAY Y4
        @ 13,27 SAY Y5
        @ 14,27 SAY Y6
        @ 15,27 SAY Y7
        @ 16,27 SAY Y8
        @ 17,27 SAY Y9
        @ 18,27 SAY Y10
        @ 19,27 SAY Y11
        @ 20,27 SAY Y12
        @ 9,54  SAY "                         "
        @ 10,54 SAY "                         "
        @ 11,54 SAY "                         "
        @ 12,54 SAY "                         "
        @ 13,54 SAY "                         "
        @ 14,54 SAY "                         "
        @ 15,54 SAY "                         "
        @ 16,54 SAY "                         "
        @ 17,54 SAY "                         "
        @ 18,54 SAY "                         "
        @ 19,54 SAY "                         "
        @ 20,54 SAY "                         "

   CASE OP = 5

        STORE " Presupuesto Con Analisis " TO Y1
        STORE " Presupuesto Sin Analisis " TO Y2
        STORE " Resumen de Materiales    " TO Y3
        STORE " Consultar Total Presup.  " TO Y4
        STORE "                          " TO Y5
        STORE "                          " TO Y6
        STORE "                          " TO Y7
        STORE "                          " TO Y8
        STORE "                          " TO Y9
        STORE "                          " TO Y10
        STORE "                          " TO Y11
        STORE "                          " TO Y12

        @ 9,27  SAY Y1
        @ 10,27 SAY Y2
        @ 11,27 SAY Y3
        @ 12,27 SAY Y4
        @ 13,27 SAY Y5
        @ 14,27 SAY Y6
        @ 15,27 SAY Y7
        @ 16,27 SAY Y8
        @ 17,27 SAY Y9
        @ 18,27 SAY Y10
        @ 19,27 SAY Y11
        @ 20,27 SAY Y12
        @ 9,54  SAY "                         "
        @ 10,54 SAY "                         "
        @ 11,54 SAY "                         "
        @ 12,54 SAY "                         "
        @ 13,54 SAY "                         "
        @ 14,54 SAY "                         "
        @ 15,54 SAY "                         "
        @ 16,54 SAY "                         "
        @ 17,54 SAY "                         "
        @ 18,54 SAY "                         "
        @ 19,54 SAY "                         "
        @ 20,54 SAY "                         "

   CASE OP = 6

        STORE " Presupuestos             " TO Y1
        STORE " Copiar Presupuesto       " TO Y2
        STORE " Materiales               " TO Y3
        STORE " Equipos                  " TO Y4
        STORE " Mano de Obra             " TO Y5
        STORE " Fecha y Porcentajes      " TO Y6
        STORE " Variacion % de Insumos   " TO Y7
        STORE " Cambiar de Empresa       " TO Y8
        STORE "                          " TO Y9
        STORE "                          " TO Y10
        STORE "                          " TO Y11
        STORE "                          " TO Y12

        @ 9,27  SAY Y1
        @ 10,27 SAY Y2
        @ 11,27 SAY Y3
        @ 12,27 SAY Y4
        @ 13,27 SAY Y5
        @ 14,27 SAY Y6
        @ 15,27 SAY Y7
        @ 16,27 SAY Y8
        @ 17,27 SAY Y9
        @ 18,27 SAY Y10
        @ 19,27 SAY Y11
        @ 20,27 SAY Y12
        @ 9,54  SAY " Esta opcion  le permite "
        @ 10,54 SAY "actualizar  la  base  de "
        @ 11,54 SAY "datos del sistema. Cual_ "
        @ 12,54 SAY "quier  error  en   estas "
        @ 13,54 SAY "operaciones puede afectar"
        @ 14,54 SAY "seriamente  su  funciona_"
        @ 15,54 SAY "miento.                  "
        @ 16,54 SAY "                         "
        @ 17,54 SAY "                         "
        @ 18,54 SAY "                         "
        @ 19,54 SAY "                         "
        @ 20,54 SAY "                         "
   CASE OP = 7
        @ 9,27  SAY "Oprima (Ù) para Confirmar"
        @ 10,27 SAY "                          "
        @ 11,27 SAY "                          "
        @ 12,27 SAY "                          "
        @ 13,27 SAY "                          "
        @ 14,27 SAY "                          "
        @ 15,27 SAY "                          "
        @ 16,27 SAY "                          "
        @ 17,27 SAY "                          "
        @ 17,27 SAY "                          "
        @ 18,27 SAY "                          "
        @ 19,27 SAY "                          "
        @ 20,27 SAY "                          "

        @ 9,54  SAY "  Mediante  esta  opcion "
        @ 10,54 SAY "usted  podra  salir  del "
        @ 11,54 SAY "sistema    de   analisis "
        @ 12,54 SAY "regresar    al   sistema "
        @ 13,54 SAY "operativo. Recuerde  que "
        @ 14,54 SAY "esta es la  unica opcion "
        @ 15,54 SAY "valida para abandonar el "
        @ 16,54 SAY "sistema.                 "
        @ 17,54 SAY "  Si el sistema es inte_ "
        @ 18,54 SAY "rumpido, este se autoes_ "
        @ 19,54 SAY "tructurara en su proxima "
        @ 20,54 SAY "ejecucion.               "
 endcase
RETURN
******************************************************************
procedure informa
store " " to qw1
store " " to qw2
store " " to qw3
store " " to qw4
store " " to qw5
store " " to qw6
store " " to qw7
store " " to qw8
store " " to qw9
store " " to qw10
store " " to qw11
store " " to qw12
store " " to qw13
store " " to qw14
store " " to qw15
store " " to qw16
store " " to qw17
store " " to qw18
store " " to qw19
store " " to qw20
store " " to qw21
store " " to qw22
store " " to qw23
store " " to qw24
store " " to qw25
store " " to qw26
store " " to qw27
store " " to qw28
store " " to qw29
store "O" to qw30
store "C" to qw31
store "A" to qw32
store "M" to qw33
store "E" to qw34
store "F" to qw35
STORE QW35+QW34+QW33+QW32+QW31+QW30+QW29+QW28+QW27+QW26+QW25+QW24+QW23+QW22+QW21 TO QQWW
STORE QQWW+QW20+QW19+QW18+QW17+QW16+QW15+QW14+QW13+QW12+QW11+QW10+QW9+QW8+QW7+QW6 TO QQWW
STORE QQWW+QW5+QW4+QW3+QW2+QW1 TO QQWW
******************************************************************
procedure subop
RETURN
**************************************
PROCEDURE COMPANY
STORE " " TO A1
STORE " " TO A2
STORE " " TO A3
STORE " " TO A4
STORE "." TO A5
STORE "A" TO A6
STORE "." TO A7
STORE "C" TO A8
STORE " " TO A9
STORE "," TO A10
STORE "E" TO A11
STORE "M" TO A12
STORE "A" TO A13
STORE "R" TO A14
STORE "F" TO A15
STORE " " TO A16
STORE "S" TO A17
STORE "E" TO A18
STORE "N" TO A19
STORE "O" TO A20
STORE "I" TO A21
STORE "C" TO A22
STORE "C" TO A23
STORE "U" TO A24
STORE "R" TO A25
STORE "T" TO A26
STORE "S" TO A27
STORE "N" TO A28
STORE "O" TO A29
STORE "C" TO A30
STORE A30+A29+A28+A27+A26+A25+A24+A23+A22+A21+A20+A19+A18+A17+A16+A15+A14 TO NAME
STORE NAME+A13+A12+A11+A10+A9+A8+A7+A6+A5+A4+A3+A2+A1  TO QQWW
RETURN
**************************************
PROCEDURE COMPANYII
STORE " " TO A1
STORE "A" TO A2
STORE "C" TO A3
STORE " " TO A4
STORE "," TO A5
STORE "O" TO A6
STORE "D" TO A7
STORE "A" TO A8
STORE "M" TO A9
STORE " " TO A10
STORE "A" TO A11
STORE "R" TO A12
STORE "O" TO A13
STORE "T" TO A14
STORE "C" TO A15
STORE "U" TO A16
STORE "R" TO A17
STORE "T" TO A18
STORE "S" TO A19
STORE "N" TO A20
STORE "O" TO A21
STORE "C" TO A22
STORE " " TO A23
STORE "A" TO A24
STORE "C" TO A25
STORE "I" TO A26
STORE "N" TO A27
STORE "C" TO A28
STORE "E" TO A29
STORE "T" TO A30
STORE A30+A29+A28+A27+A26+A25+A24+A23+A22+A21+A20+A19+A18+A17+A16+A15+A14 TO NAME
STORE NAME+A13+A12+A11+A10+A9+A8+A7+A6+A5+A4+A3+A2+A1  TO QQWW
RETURN


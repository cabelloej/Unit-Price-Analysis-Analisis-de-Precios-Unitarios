*********************************
* mantenimiento de valuaciones  *
*********************************
SELECT 1
USE IPPPRESU INDEX IPPPRESU ALIAS PRESUP
SELECT 2
USE IPPVALGE INDEX IPPVALGE
SELECT 3
USE IPPVALDE INDEX IPPVALDE
select 4
use ippparti index ipppart1
SET COLOR TO W/N
STORE .T. TO PRE
DO WHILE PRE
   SET COLOR TO W/N
   @ 04,0 CLEAR TO 21,79
   @ 04,0 SAY "+------------------------------------------------------------------------------+"
   @ 05,0 SAY "|              A C T U A L I Z A R     V A L U A C I O N E S                   |"
   @ 06,0 SAY "+---------------+--------------------+-----------------------------------------+"
   @ 07,0 SAY "|OBRA:          |VALUACION:          |LUGAR:                                   |"
   @ 08,0 SAY "+---------------+--------------------+----------------+------------------------+"
   @ 09,0 SAY "|FECHA:         |INSPECCION:         |DESDE:          |HASTA:                  |"
   @ 10,0 SAY "+---------------+--------------------+----------------+------------------------+"
   @ 11,0 SAY "|DENOMINACION DE LA OBRA:                                                      |"
   @ 12,0 SAY "|                                                                              |"
   @ 13,0 SAY "|                                                                              |"
   @ 14,0 SAY "+-------------+----------+-----------+-----------+--------------+--------------+"
   @ 15,0 SAY "|   PARTIDA   |  UNIDAD  | CANTIDAD  |PRECIO/UND.|CANT.ACUMULADA|CANT.EJECUTADA|"
   @ 16,0 SAY "+-------------+----------+-----------+-----------+--------------+--------------+"
   @ 17,0 SAY "|             |          |           |           |              |              |"
   @ 18,0 SAY "+-------------+----------+-----------+-----------+--------------+--------------+"
   @ 19,0 SAY " DESCRIPCION DE LA PARTIDA:"

   STORE WPARPRE   TO WPRECOD
   STORE "Codigo de la obra a evaluar" to mes
   do mensaje with mes
   @ 7,6 GET WPRECOD
   READ
   STORE UPPER(WPRECOD) TO WPRECOD
   if wprecod = space(10)   .OR. READKEY() = 12 .OR. READKEY() = 268
      close data
      close index 
      return
   endif
   select 1
   FIND &WPRECOD
   IF EOF()
      STORE "Codigo de presupuesto no registrado, (Ù)" to mes
      do aviso with mes
      loop
   endif
   store preobra  to wpredes1
   store preobra2 to wpredes2
   store preobra3 to wpredes3
   store preobra4 to wpredes4
   store predir   to wpredir
   @ 12,1 SAY WPREDES1+WPREDES2
   @ 13,1 SAY WPREDES3+WPREDES4
   @ 7,44 say substr(wpredir,1,35)
   select 2
   set exact off
   store space(10) to wvalua
   store space(9) to winspe
   store ctod("  -  -  ") to whasta
   store ctod("  -  -  ") to wdesde
   find &wprecod
   do while .not. eof() .and. obra = wprecod
      store valuacion to wvalua
      store inspeccion to winspe
      store hasta+1 to wdesde
      skip
   enddo
   set exact on
   store "Ingrese el codigo de la valuacion a actualizar" to mes
   do mensaje with mes
   @ 7,27 get wvalua
   read
   if wvalua = space(10)
      close data
      close index
      return
   endif
   store wprecod+wvalua to wcodval
   find &wcodval
   if eof()
      store "Valuacion no registrada, (I)ngresar, (S)alir" to mes
      store "I" to p1
      store "S" to p2
      store " " to resp
      do pide2 with p1,p2,mes,resp
      if resp = "S"
         loop
      endif
      store val(winspe)+1 to winspe
      store str(winspe,9) to winspe
      store wfecact to wfecha
      @ 09,7 get wfecha
      @ 09,28 get winspe
      @ 09,44 get wdesde
      @ 09,61 get whasta
      READ
      STORE "Opciones: (A)ceptar, (R)echazar" to mes
      store "A" to p1
      store "R" to p2
      store " " to resp
      do pide2 with p1,p2,mes,resp
      if resp = "R"
         loop
      endif
      APPEND BLANK
      REPLACE OBRA WITH WPRECOD
      REPLACE VALUACION WITH WVALUA
      REPLACE FECHA WITH WFECHA
      REPLACE INSPECCION WITH WINSPE
      REPLACE DESDE WITH WDESDE
      REPLACE HASTA WITH WHASTA
   ELSE
      STORE FECHA TO WFECHA
      STORE INSPECCION TO WINSPE
      STORE DESDE TO WDESDE
      STORE HASTA TO WHASTA
      @ 09,7 SAY wfecha
      @ 09,28 SAY winspe
      @ 09,44 SAY wdesde
      @ 09,61 SAY whasta
      STORE "Desea modificar la informacion general de la valuacion? :(S/N)" to mes
      store "S" to p1
      store "N" to p2
      store " " to resp
      do pide2 with p1,p2,mes,resp
      if resp = "S"
         @ 09,7 get wfecha
         @ 09,28 get winspe
         @ 09,44 get wdesde
         @ 09,61 get whasta
         READ
         STORE "Opciones: (A)ceptar, (R)echazar" to mes
         store "A" to p1
         store "R" to p2
         store " " to resp
         do pide2 with p1,p2,mes,resp
         if resp = "R"
            loop
         endif
         REPLACE FECHA WITH WFECHA
         REPLACE INSPECCION WITH WINSPE
         REPLACE DESDE WITH WDESDE
         REPLACE HASTA WITH WHASTA
      ENDIF
   ENDIF
   STORE .T. TO WPA
   DO WHILE WPA
      select 3
      STORE SPACE(13) TO WCODPAR
      @ 14,0 SAY "+-------------+----------+-----------+-----------+--------------+--------------+"
      @ 15,0 SAY "|   PARTIDA   |  UNIDAD  | CANTIDAD  |PRECIO/UND.|CANT.ACUMULADA|CANT.EJECUTADA|"
      @ 16,0 SAY "+-------------+----------+-----------+-----------+--------------+--------------+"
      @ 17,0 SAY "|             |          |           |           |              |              |"
      @ 18,0 SAY "+-------------+----------+-----------+-----------+--------------+--------------+"
      @ 19,0 SAY " DESCRIPCION DE LA PARTIDA:"
      @ 20,0 SAY "                                                                                "
      @ 21,0 SAY "                                                                                "
      STORE "Ingrese codigo de la partida a procesar" to mes
      do mensaje with mes
      @ 17,1 GET WCODPAR
      read
      if wcodpar = space(13)
         store .f. to wpa
         loop
      endif
      select 4
      store wprecod+wcodpar to wclave
      find &wclave
      if eof()
         store "Codigo de partida no registrado en la obra" to mes
         do aviso with mes
         loop
      endif
      if parasume > 0
         store parasume  to wparpreuni
      else
         store parpreuni to wparpreuni
      endif
      @ 20,0  say pardes1+" "+substr(pardes2,1,39)
      @ 21,0  say pardes3+" "+substr(pardes4,1,39)
      @ 17,15 say parunid
      @ 17,26 say str(parcant,11,2)
      @ 17,38 say str(wparpreuni,11,2)
      IF PARTIPO = "T"
         STORE "Esta partida es tipo texto, no se puede incluir" to mes
         do aviso with mes
         loop
      endif
      *** CALCULO DEL ACUMULADO ANTERIOR A LA VALUACION EN CURSO
      store "Calculando acumulado, favor esperar..." to mes
      do mensaje with mes
      select 3
      set exact off
      find &wprecod
      store 0 to wacumulado
      do while .not. eof() .and. obra = wprecod .and. valuacion < wvalua
         if partida = wcodpar
            store wacumulado + cantidad to wacumulado
         endif
         skip
      enddo
      set exact on
      @ 17,53 SAY STR(WACUMULADO,11,2)
      *** FIN CALCULO DEL ACUMULADO
      store wprecod+wvalua+wcodpar to wclave
      find &wclave
      store "Ingrese la cantidad de unidades de esta valuacion" to mes
      do mensaje with mes
      IF EOF()
         STORE 0 TO WCANTIDAD
         @ 17,67 GET WCANTIDAD PICTURE "#######.##"
         READ
         if WCANTIDAD = 0
            loop
         endif
      ELSE
         STORE CANTIDAD TO WCANTIDAD
         store "Para eliminar la partida de la valuacion, deje el monto en 0" to mes
         do mensaje with mes
         @ 17,67 GET WCANTIDAD PICTURE "#######.##"
         READ
      ENDIF
      STORE "Opciones: (A)ceptar, (R)echazar" to mes
      store "A" to p1
      store "R" to p2
      store " " to resp
      do pide2 with p1,p2,mes,resp
      if resp = "R"
         loop
      endif
      IF WCANTIDAD = 0
         DELETE
         LOOP
      ENDIF
      IF EOF()
         APPEND BLANK
         REPLACE OBRA WITH WPRECOD
         REPLACE VALUACION WITH WVALUA
         REPLACE PARTIDA WITH WCODPAR
      ENDIF
      REPLACE CANTIDAD WITH WCANTIDAD
     *REPLACE PRECIO   WITH WPARPREUNI
   ENDDO
ENDDO


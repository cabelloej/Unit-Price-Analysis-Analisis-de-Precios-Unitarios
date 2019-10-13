
SET EXACT OFF
store .t. to analiza
do while analiza
   select 1
   use ipppresu index ipppresu alias presup
   select 2
   use ippparti index ipppart1,ipppart2 alias partida
   @ 4,0 clear to 21,79
   @ 4,20 say "COPIAR PARTIDA DE UN PRESUPUESTO A OTRO"
   @ 6,5  SAY "PRESUPUESTO ORIGEN :"
   @ 7,5  SAY "PARTIDA ORIGEN     :"
   @ 14,5  SAY "PRESUPUESTO DESTINO:"
   @ 15,5  SAY "PARTIDA DESTINO    :"

    STORE WPARPRE   TO WPRECOD
*   STORE SPACE(13)  TO WPARCOD
   STORE SPACE(10) TO WPRECOD2
   STORE SPACE(13)  TO WPARCOD2
   @ 6,25 GET WPRECOD
   READ
   STORE UPPER(WPRECOD) TO WPRECOD
   IF WPRECOD = SPACE(10) .OR. READKEY() = 12 .OR. READKEY() = 268
      SET EXACT ON
      CLOSE DATA
      CLOSE INDEX
      RETURN
   ENDIF
   SELECT 1
   FIND &WPRECOD
   IF EOF()
      STORE "ERROR, Codigo de presupuesto no registrado" to mes
      do aviso with mes
      loop
   endif
   @ 6,25 say preobra
   @ 7,25 get wparcod
   read
   STORE UPPER(WPARCOD) TO WPARCOD
   if wparcod = SPACE(13)   .OR. READKEY() = 12 .OR. READKEY() = 268
      select 1
      loop
   endif
   select 2
   store wprecod+Wparcod to clave
   find &clave
   if eof()
      store "ERROR, Codigo de partida no registrado para este Presupuesto" to mes
      do aviso with mes
      select 1
      loop
   endif
   @ 07,25  say pardes1
   @ 08,25  say pardes2
   @ 09,25  say pardes3
   @ 10,25  say pardes4
   @ 11,25  say pardes5
   @ 12,25  say pardes6

   @ 14,25 GET WPRECOD2
   READ
   STORE UPPER(WPRECOD2) TO WPRECOD2
   IF WPRECOD2 = SPACE(10)
      SET EXACT ON
      CLOSE DATA
      CLOSE INDEX
      RETURN
   ENDIF
   SELECT 1
   FIND &WPRECOD2
   IF EOF()
      STORE "ERROR, Codigo de presupuesto no registrado" to mes
      do aviso with mes
      loop
   endif
   @ 14,25 say preobra
   @ 15,25 get wparcod2
   read
   STORE UPPER(WPARCOD2) TO WPARCOD2
   if wparcod2 = SPACE(13)
      select 1
      loop
   endif
   select 2
   store wprecod2+Wparcod2 to clave
   find &clave
   if .NOT. eof()
      store "ERROR, El codigo de partida ya esta registrado para este Presupuesto" to mes
      do aviso with mes
      select 1
      loop
   endif

   store "Opciones: (C)ontinuar, (R)echazar" to mes
   store "C" to p1
   store "R" to p2
   store " " to resp
   do pide2 with p1,p2,mes,resp
   if resp = "R"
      loop
   endif
   store "Comando en proceso, favor esperar..." to mes
   do mensaje with mes
   CLOSE DATA
   CLOSE INDEX

   select 3
   use ipptemp1
   zap
   append from ippparti for parpre = wprecod .and. parcod = wparcod
   replace ALL parpre with wprecod2
   replace ALL parcod with wparcod2
   select 3
   USE IPPPARTI INDEX IPPPART1,IPPPART2
   append from ipptemp1
   reindex

   select 3
   use ipptemp5
   zap
   append from ippparde for presu  = wprecod .and. parti  = wparcod
   replace ALL presu  with wprecod2
   replace ALL parti  with wparcod2
   select 3
   USE IPPPARDE INDEX IPPPARDE
   append from ipptemp5
   reindex


   select 3
   use ipptemp2
   zap
   append from ippmater for materpre = wprecod .and. materpar = wparcod
   replace all materpre with wprecod2
   replace all materpar with wparcod2
   select 3
   use ippmater index ippmater
   append from ipptemp2
   reindex

   select 3
   use ipptemp3
   zap
   append from ippequip for equippre = wprecod .and. equippar = wparcod
   replace all equippre with wprecod2
   replace all equippar with wparcod2
   select 3
   use ippequip index ippequip
   append from ipptemp3
   reindex

   select 3
   use ipptemp4
   zap
   append from ippmdo   for mobrapre = wprecod .and. mobrapar = wparcod
   replace all mobrapre with wprecod2
   replace all mobrapar with wparcod2
   select 3
   use ippmdo   index ippmdo
   append from ipptemp4
   reindex
   CLOSE DATA
   CLOSE INDEX
enddo


	.include "m48def.inc"
	.def temp = r16
	.def cont1 = r17
	.def cont2 = r18
	.cseg
	.org 0
	rjmp reset

	.org $012 ;Para la interrup de RecxCmp
	rjmp recibe

reset: ldi temp, $fe 
	out ddrd, temp ; Se establece D0 como entrada
;;**1 punto
	rcall delay_50ms
;; 2 function set 4 bits
	;;0010
	ldi temp, $20
	out portd, temp
	
	SBI portd, 2;mandamos enable en alto y 
	CBI portd, 2; Se le manda el flanco de bajada de enable.

	rcall delay_2Punto5ms

;; 3 Function set 8 bits, parte alta y baja
	;Parte alta:
	ldi temp, $20
	out portd, temp
	
	SBI portd, 2;mandamos enable en alto y 
	CBI portd, 2; Se le manda el flanco de bajada de enable.
	nop
	;Parte baja:
	;;Para trabajar con las 2 líneas, hay que mandar N=1 se le manda un 80, los últimos 2 bits no importan

	ldi temp, $80
	out portd, temp
	
	SBI portd, 2;mandamos enable en alto y 
	CBI portd, 2; Se le manda el flanco de bajada de enable.
	rcall delay_2Punto5ms

;; 4 display on-off
	
	ldi temp, $00
	out portd, temp
	
	SBI portd, 2;mandamos enable en alto y 
	CBI portd, 2; Se le manda el flanco de bajada de enable.
	nop
	;Parte baja:
	;;Se le manda una E, porque se apaga Blink, se enciende el cursor y no sé que más :v

	ldi temp, $e0
	out portd, temp
	
	SBI portd, 2;mandamos enable en alto y 
	CBI portd, 2; Se le manda el flanco de bajada de enable.
	rcall delay_2Punto5ms

;; 5 Mode set
	;Parte alta:	
	ldi temp, $00
	out portd, temp
	
	SBI portd, 2;mandamos enable en alto y 
	CBI portd, 2; Se le manda el flanco de bajada de enable.
	nop
	;Parte baja:
	;I/D -> 1, incremento DDRAM, empieza en 0x00, se le manda un 6

	ldi temp, $60
	out portd, temp
	
	SBI portd, 2;mandamos enable en alto y 
	CBI portd, 2; Se le manda el flanco de bajada de enable.
	rcall delay_2Punto5ms

;;5.5 Clear Display

	; Se le debe mandar 0 y 1
	;Parte alta:	
	ldi temp, $00
	out portd, temp
	
	SBI portd, 2;mandamos enable en alto y 
	CBI portd, 2; Se le manda el flanco de bajada de enable.
	nop
	;Parte baja:
	
	ldi temp, $10
	out portd, temp
	
	SBI portd, 2;mandamos enable en alto y 
	CBI portd, 2; Se le manda el flanco de bajada de enable.
	rcall delay_2Punto5ms
	

;; 6 Mensaje: ;Generalización Subrutina que formatea letra a letra.


;Para la siguiente subRutina, se necesita Parte Alta en R10 y ParteBaja en R9
formateaLetra: 
	; r10_ para la parte Alta de la Letra y r9 para la baja de la señal RS.
	;Parte alta:	
	out portd, r10
	
	SBI portd, 2;mandamos enable en alto y 
	CBI portd, 2; Se le manda el flanco de bajada de enable.
	nop
	;Parte baja:
	
	out portd, r9
	
	SBI portd, 2;mandamos enable en alto y 
	CBI portd, 2; Se le manda el flanco de bajada de enable.
	rcall delay_2Punto5ms

aqui:	rjmp aqui


delay_2Punto5ms:
	ldi cont1,250
lazo3: 
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	dec cont1
	brne lazo1
	ret


delay_50ms:
lazo2:
	ldi cont2,20
lazo1: 
	ldi cont1,50
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	dec cont1
	brne lazo1
	dec cont2
	brne lazo2
	ret


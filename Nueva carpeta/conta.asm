	.include "m48def.inc"
	.def cte = r15
	.def temp = r16
	.def uni = r17
	.def dece = r18
	.def mux = r19
	.cseg
	.org 0

	ldi temp,$7F
	out ddrb, temp ; Configuramos el puerto D como salida bit 0 a 6
	ldi temp, $03
	out ddrc, temp ; onfiguramos el puerto D como salida bit 0 y 1

	 
	;timer 0 con sobreflujo 
	ldi temp,$00
	out tccr0a,temp
	ldi temp,$02
	out tccr0b,temp
	ldi temp,$01
	sts timsk0,temp
	sei



display: .db $FE, $03, $A5
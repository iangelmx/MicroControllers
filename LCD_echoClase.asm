	.include "m48def.inc"
	.def temp = r16
	.def cte = r17
	.cseg
	.org 0
	rjmp reset

	.org $012 ;Para la interrup de RecxCmp
	rjmp recibe

reset:
	;INICIO USART
	;PDO entrada, PD1 salida
	ldi temp, $02
	out ddrd, temp ;Se configuran pines para USART
	;Reg A:
	sts ucsr0a, temp
	;Reg B:
	ldi temp, $98
	sts ucsr0b, temp ; Para el 7, 4, y 3 del Reg B

	; Al registro C no se le debe escribir nada para este ejercicio.
	
	ldi temp, 12 ; Para el tiempo 9600 al doble
	sts ubrr0l, temp 
	;FIN USART

	ldi cte, $03 ; + cte
	sei

main: rjmp main

recibe: lds temp, udr0;LDS porque es extendido, se lee el dato
	;Para sumarle 3:
	add temp, cte
	
	;Transmitimos:
	sts udr0, temp
	reti







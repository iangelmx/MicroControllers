	.include "m48def.inc"
	.def temp = r16
	.cseg
	.org 0 ; En el registro 0 tenemos al reset
	rjmp reset
	reti
	reti
	reti
	reti
	reti
	reti
	reti
	reti
	reti
	reti
	reti
	reti
	reti
	reti
	reti

	.org $010
	rjmp timer_cero ; timer0 contador de 8 bits
reset: ldi temp, $ff ; puerto B
	out ddrb, temp ; Configurando el puerto B como salida
	ldi temp, $04 ; El 04 es para el preescalamiento
	out tccr0b, temp ; Como no es un registro extendido, se puede poner la salida con OUT
	ldi temp, $01 ; 
	STS timsk0, temp ;Como timsk0 es extendido, se escribe con sts y no con out
	sei; SEI <- Global interrumpt enable

main: nop
	rjmp main


timer_cero: in temp, pinb
	com temp ; Complemento a temp 0, 1, 0, 1
	andi temp, $80
	out portb, temp
	reti
		

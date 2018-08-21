	.include "m48def.inc"
	.def temp = r16
	.def izq = r17
	.def temp2 = r18
	.def cont1 = r19
	.def cont2 = r20
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
	;sei; SEI <- Global interrumpt enable

	ldi temp, $00
	out ddrb, temp	; configura puerto B entrada
	ldi temp, $ff
	ldi temp, $01
	out portb, temp ; habilitando resistencia pull-up
	ldi temp,$ff
	out ddrd, temp	; configura puerto D como salida
	;ldi temp, $01
	ldi temp2, $01
	out portd, temp2
	ldi izq,$01
	sei

main:sbic pinb,0;in temp, pinb ;ESTA SERÍA LA MÁSCARA.
	rjmp main;andi temp,$01
	;cpi temp, $fe
	;breq kit
	;rjmp main
kit:cpi izq, $01
	breq izquierda
derecha:ldi izq, $00
		cpi temp2, $01
		breq izquierda
	lsr temp2
	out portd, temp2
	rcall delay_125ms
	rjmp main
izquierda:ldi izq, $01
		cpi temp2, $80
		breq derecha
	lsl temp2
	out portd, temp2
	rcall delay_125ms
	rjmp main

delay_125ms:ldi cont2,63 ;63 dec. ; En Gral. el delay se hace al tanteo, dependiendo el número de ms que queramos esperar
lazo2: ldi cont1, 200
lazo1: nop
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

;*** interrupciones
timer_cero: in temp, pind
	com temp ; Complemento a temp 0, 1, 0, 1
	andi temp, $80
	out portd, temp
	reti
		


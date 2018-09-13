	.include "m48def".inc
	.def temp = r16
	.def uni = r17
	.def dece = r18
	.def cent = r19
	.def uni_aux = r20
	.def dece_aux = r21
	.def cent_aux = r22

	.cseg
	
	.org 0
	rjmp reset

	.org $00B
	rjmp compa

	.org $010
	rjmp multiplexacion

reset: ldi temp, $7F
	out portb, temp

	ldi temp, $01
	out portd, temp
	
	ldi temp, $07
	out portc, temp
	
	ldi temp $00
	out tccr0a, temp ; Configuramos en OVF el timer 0
	
	ldi temp, $ob
	sts tccr1b, temp

	ldi temp, $3d
	sts ocriah, temp

	ldi temp, $09
	sts ocrial, temp

	ldi temp, $02
	sts timsk1, temp; Se configura el mask, interrupcion por comparacion
	sei
 
	ldi temp, $04
	ldi ZL, low(display*2)
	ldi ZH, high(display*2)

	ldi XL, $00
	ldi XH, $01

lazo: lpm
	st x+, r0
	adiw ZL, 1
	dec temp
	brne lazo
	nop
	nop

	ldi uni, $00
	ldi dece, $00
	ldi cen, $00
	ldi uni_aux, $00
	ldi dece_aux, $00
	ldi cen_aux, $00

main: rjmp main

multiplexacion: inc uni
	cpi uni, $0A
	brne finMux
	ldi uni, $00
	inc dec
	cpi dec, $0A
	brne finMux
	ldi dec, $00
	inc cent
	cpi cent, $0A
	brne finMux
	ldi uni ,$0A
	ldi dec ,$0A
	ldi cent ,$0A
finMux: reti





	.cseg
display: .db $FE, $03

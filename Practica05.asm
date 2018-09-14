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

	.org $01
	rjmp INT01; Es el que detectará los pulsos ascendentes

	.org $00B
	rjmp compa ;Es el que hará la interrupción cada segundo.

	.org $010
	rjmp ovf ;Es el que multiplexará

reset: ldi temp, $7F
	out ddrb, temp ;se usa ddrb cuando se configura como salida. Se usa port para que sea entrada

	ldi temp, $01
	out portd, temp
	
	ldi temp, $07
	out ddrc, temp ;onfiguramos el puerto C como salida 3 bits 0 y 1
	
	ldi temp, $ob
	sts tccr1b, temp ; COnfigura el CTC con prescalador a 64

	ldi temp, $3d
	sts ocriah, temp
	ldi temp, $09
	sts ocrial, temp

	ldi temp, $02
	sts timsk1, temp; Se configura el mask, interrupcion por comparacion

;timer0 con sobreflujo 
	ldi temp,$00
	out tccr0a,temp; Configuramos en OVF el timer 0
	ldi temp,$02
	out tccr0b,temp
	ldi temp,$01
	sts timsk0,temp
	sei

;;;;;;
pcm:
	 ldi zl,low(display*2)
	 ldi zh,high(display*2)
	 ldi XL,$00
	 ldi XH,$01
	 ldi temp,$0A
lazo:
	 lpm
	 st x+,r0
	 adiw ZL,1
	 dec temp
	 brne lazo
	 ldi uni, $00
	 ldi dece, $00
	 ldi cen, $00
	 ldi uni_aux, $00
	 ldi dece_aux, $00
	 ldi cen_aux, $00
;;;;;; FIN DEL RESET

display: .db $40,$79,$24,$30,$19,$12,$02,$78,$00,$10

	

main: rjmp main

INT01: inc uni
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


compa: mov uni_aux, uni
	mov dece_aux, dece
	mov cen_aux, cen
	ldi uni, $00
	ldi dece, $00
	ldi cen, $00
	reti
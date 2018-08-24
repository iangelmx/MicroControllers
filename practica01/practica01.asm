	; programa para puertos de entrad y salida
	.include "m48def.inc"
	.def temp = r16
	.def izq = r17
	.def temp2 = r18
	.def cont1 = r19
	.def cont2 = r20
	.cseg
	.org 0

	ldi temp, $00
	out ddrb, temp	; configura puerto D entrada
	ldi temp, $03
	out portb, temp ; habilitando resistencia pull-up

	ldi temp,$ff
	out ddrd, temp	; configura puerto B como salida
	ldi temp, $01
	out portd, temp	; habilitando resistencia pull-up

	ldi temp2, $01	
	ldi izq,$01

main:sbic pinb,1;Mascara D1
	rjmp kitmit
	rjmp kit

;;*** KIT DE LADO A LADO

kit:cpi izq, $01
	breq izquierda

derecha:ldi izq, $00
		cpi temp2, $01
		breq izquierda
	lsr temp2
	out portd, temp2
	rcall delay_62ms
	sbis pinb,0;Mascara D0 caso D1 = 0
	rcall delay_62ms
	rjmp main

izquierda:ldi izq, $01
		cpi temp2, $80
		breq derecha
	lsl temp2
	out portd, temp2
	rcall delay_62ms
	sbis pinb,0;Mascara D0 caso D1 = 0
	rcall delay_62ms
	rjmp main

;;*** KIT A LA MITAD

kitmit:sbic pinb,0;Mascara D0 caso D1 = 1
	rjmp kitfuera
	rjmp kitdentro

kitfuera: ldi temp,$18
	out portd,temp
	rcall delay_62ms
	rcall delay_62ms
	rcall delay_62ms
	rcall delay_62ms
	
	ldi temp,$24
	out portd,temp
	rcall delay_62ms
	rcall delay_62ms
	rcall delay_62ms
	rcall delay_62ms
	ldi temp,$42
	out portd,temp
	rcall delay_62ms
	rcall delay_62ms
	rcall delay_62ms
	rcall delay_62ms
	ldi temp,$81
	out portd,temp
	rcall delay_62ms
	rcall delay_62ms
	rcall delay_62ms
	rcall delay_62ms
	rjmp main
kitdentro:ldi temp,$81
	out portd,temp
	rcall delay_62ms
	rcall delay_62ms
	rcall delay_62ms
	rcall delay_62ms
	ldi temp,$42
	out portd,temp
	rcall delay_62ms
	rcall delay_62ms
	rcall delay_62ms
	rcall delay_62ms
	ldi temp,$24
	out portd,temp
	rcall delay_62ms
	rcall delay_62ms
	rcall delay_62ms
	rcall delay_62ms
	ldi temp,$18
	out portd,temp
	rcall delay_62ms
	rcall delay_62ms
	rcall delay_62ms
	rcall delay_62ms
	rjmp main

;;*** CLOCK A 1/16 SEG
delay_62ms:ldi cont2,63
lazo2: ldi cont1, 100
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
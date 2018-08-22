	; programa para puertos de entrad y salida
	.include "m48def.inc"
	.def temp = r16
	.def izq = r17
	.def temp2 = r18
	.def cont1 = r19
	.def cont2 = r20
	.def mit1 = r21
	.def mit2 = r22
	.def mres = r23
	.cseg
	.org 0

	ldi temp, $00
	out ddrd, temp	; configura puerto D entrada
	ldi temp, $03
	out portd, temp ; habilitando resistencia pull-up

	ldi temp,$ff
	out ddrb, temp	; configura puerto B como salida
	ldi temp, $01
	out portb, temp	; habilitando resistencia pull-up

	ldi temp2, $01	
	ldi izq,$01

	ldi mit1,$04
	ldi mit2,$20

main:sbic pind,1;Mascara D1
	rjmp kitmit
	rjmp kit

;;*** KIT DE LADO A LADO

kit:cpi izq, $01
	breq izquierda

derecha:ldi izq, $00
		cpi temp2, $01
		breq izquierda
	lsr temp2
	out portb, temp2
	rcall delay_62ms
	sbis pind,0;Mascara D0 caso D1 = 0
	rcall delay_62ms
	rjmp main

izquierda:ldi izq, $01
		cpi temp2, $80
		breq derecha
	lsl temp2
	out portb, temp2
	rcall delay_62ms
	sbis pind,0;Mascara D0 caso D1 = 0
	rcall delay_62ms
	rjmp main

;;*** KIT A LA MITAD

kitmit:sbic pind,0;Mascara D0 caso D1 = 1
	rjmp kitfuera
	rjmp kitdentro

kitfuera:ldi mres,$00 
	;sbrs mit1,0
	lsr mit1
	sbic pinb,0
	ldi mit1,$08
	;sbrs mit2,7
	lsl mit2
	sbic pinb,7
	ldi mit2,$10
	add mres,mit1
	add mres,mit2
	out portb,mres
	rcall delay_62ms
	rcall delay_62ms
	rcall delay_62ms
	rcall delay_62ms
	rjmp main

kitdentro:ldi mres,$00
	;sbrs mit1,3
	lsl mit1
	sbic pinb,3
	ldi mit1,$01
	
	;sbrs mit2,4
	lsr mit2
	sbic pinb,4
	ldi mit2,$80
	
	add mres,mit1
	add mres,mit2
	out portb,mres
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

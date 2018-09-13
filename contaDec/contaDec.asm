	.include "m48def.inc"
	.def cte = r15
	.def temp = r16
	.def uni = r17
	.def dece = r18
	.def mux = r19
	.def cont1 = r20
	.def cont2 = r21
	.def zero = r22
	.cseg
	.org 0
	rjmp reset

;;;;;;;;;;;;;;;;;
	.org $010
 	 rjmp ovf	
;;;;;;;;;;;;;;;;;


reset:	ldi temp,$7F
	out ddrb, temp ; Configuramos el puerto B como salida bit 0 a 6
	ldi temp, $03
	out ddrc, temp ; onfiguramos el puerto D como salida bit 0 y 1
	ldi mux, $02 ; iniciamos prendiendo unidades
	ldi uni, $00
	ldi dece, $00
	ldi zero, $03

	 
	;timer0 con sobreflujo 
	ldi temp,$00
	out tccr0a,temp
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
;;;;;;

display: .db $40,$79,$24,$30,$19,$12,$02,$78,$00,$10

	ldi temp,$7E
	out portb,temp
	rcall delay_1s


cont_uni:inc uni
	cpi uni,$0A
	breq cont_dec
	rcall delay_1s
	rjmp cont_uni

cont_dec:ldi uni,$00
	inc dece
	cpi dece,$0A
	breq cont_reset
	rcall delay_1s
	rjmp cont_uni

cont_reset:ldi dece,$00
	rcall delay_1s
	rjmp cont_uni


ovf: out portc,zero
	 cpi mux,$02
	 breq muxdos
	 mov xl,dece	 
	 ld temp,x
	 out portb,temp
	 out portc,mux
	 ldi mux,$02
	 reti

muxdos:
	 mov xl,uni
	 ld temp,x
	 out portb,temp
	 out portc,mux
	 ldi mux,$01
	 reti


delay_1s: ldi cont2,250
lazo32:		ldi cont1,200
lazo31: nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	dec cont1
	brne lazo31
	dec cont2
	brne lazo32
	ret

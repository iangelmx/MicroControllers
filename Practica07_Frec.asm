	.include "m48def.inc"
	.def temp = r16
	.def uni = r17
	.def dece = r18
	.def cent = r19
	.def uni_aux = r20
	.def dece_aux = r21
	.def cent_aux = r22
	.def mux= r23


	;///////////////
	.cseg
	.org 0
	rjmp reset
	rjmp INT01 ; Es el que detectará los pulsos ascendentes

	.org $00B
	rjmp compa ;Es el que hará la interrupción cada segundo.

	.org $010
	rjmp ovf ;Es el que multiplexará

	.org $015
	rjmp fin_conv ;Conversion 


	;///////////////

	reset: ldi temp,$FF
	out ddrb,temp ;Configuramos B6-B0 como salidas, B7 Como entrada
	ldi temp,$07
	out ddrc,temp ;Configuramos C2-C0 como salidas
	ldi temp, $08 ; Entrada C3 para el potenciometro
	out portc, temp
	ldi uni,$00
	ldi dece,$00
	ldi cent,$00
	ldi mux,$06 


	;Configurar Timer0 en OVF
	ldi temp,$00
	out tccr0a,temp
	ldi temp,$02
	out tccr0b,temp
	ldi temp,$01
	sts timsk0,temp
	sei

	;Configurar Timer1 en CTC
	ldi temp,12
	sts tccr1b,temp
	ldi temp,15
	sts ocr1ah,temp
	ldi temp,66
	sts ocr1al,temp
	ldi temp,$02
	sts timsk1,temp

	;Configurar INT0 en flancos de subida
	ldi temp, $03
	sts eicra, temp
	ldi temp,$01
	out eimsk, temp
	
	;Configurar el Timer2 en CTC

	ldi temp, $42
	sts TCCR2A, temp

	ldi temp, $02
	sts TCCR2B, temp
	
	;Config ADC
	ldi temp, $63 ; Para configurar el admux, 6 para recargarlo a la izq y 3 
	sts admux, temp  ;Se manda la configuración al ADC 	
 	ldi temp, $eb ; E para la parte Alta y B para la parte baja
	;ldi temp, $cb   ; C para la parte Alta y B para la parte baja
	sts adcsra, temp
	ldi temp, $08
	sts didr0, temp ; Ya terminamos de configurar el ADC

	sei
	


;Mover constantes de Mem. de P a MD
pcm:
	 ldi zl,low(display*2)
	 ldi zh,high(display*2)
	 ldi XL,$00
	 ldi XH,$01
	 ldi temp,$0B
lazo:
	 lpm
	 st x+,r0
	 adiw ZL,1
	 dec temp
	 brne lazo
;///////////////////


main: rjmp main


ovf: push temp
	ldi temp,$00
	out portc,temp

	cpi mux,$01
	breq muxdos

	cpi mux,$02
	breq muxtres

	mov xl,cent_aux
	ld temp,x
	out portb,temp
	out portc,mux
	ldi mux,$01
	pop temp
	reti

muxdos:
	 mov xl,uni_aux
	 ld temp,x
	 out portb,temp
	 out portc,mux
	 ldi mux,$02
	 pop temp
	 reti

muxtres:
	 mov xl,dece_aux
	 ld temp,x
	 out portb,temp
	 out portc,mux
	 ldi mux,$04
	 pop temp
	 reti


;////////////////


compa: 
	mov uni_aux, uni
	mov dece_aux, dece
	mov cent_aux, cent
	ldi uni, $00
	ldi dece, $00
	ldi cent, $00
	;ldi uni, $01 ;Prueba para prender display
	;ldi dece, $02
	;ldi cent, $03
	reti


INT01: inc uni
	ldi temp,$0A
	cpse uni,temp
	reti
	ldi uni,$00
	inc dece
	cpse dece,temp
	reti
	ldi dece,$00
	inc cent
	cpse cent,temp
	reti
	ldi uni,$0A
	ldi dece,$0A
	ldi cent,$0A
	reti

fin_conv: LDS temp, adch ; Leemos el registro de resultados del ADC
	sts OCR2A,temp
	reti


display: .db $80,$F1,$44,$60,$31, $22, $02, $F0, $00,$20
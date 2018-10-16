	.include "m48def.inc"
	
	.equ	AtBCD0	=13		;address of tBCD0
.	.equ	AtBCD2	=15		;address of tBCD1

	.def	tBCD0	=r13		;BCD value digits 1 and 0
	.def	tBCD1	=r14		;BCD value digits 3 and 2
	.def	tBCD2	=r15		;BCD value digit 4
	.def	fbinL	=r16		;binary value Low byte
	.def	fbinH	=r17		;binary value High byte
	.def	cnt16a	=r18		;loop counter
	.def	tmp16a	=r19		;temporary value

	.def temp = r20
	.def uni_aux = r21
	.def dece_aux = r22
	.def cent_aux = r23
	.def mux = r24
	.def Raux = r25
	

	;///////////////
	.cseg
	.org 0
	rjmp reset

	.org $010
	rjmp ovf ;Es el que multiplexará

	.org $015
	rjmp fin_conv ;Conversion 

	;//////////////
reset: ldi temp,$7F
	out ddrb,temp ;Configuramos B6-B0 como salidas
	ldi temp,$07
	out ddrc,temp ;Configuramos C2-C0 como salidas
	ldi temp, $08
	out portc,temp ;C3 entradas (pote)
	ldi temp, $01
	out portd, temp ;D0 boton
	ldi mux,$06
	ldi temp, $00
	mov r12, temp

	;Configurar Timer0 en OVF
	ldi temp,$00
	out tccr0a,temp
	ldi temp,$02 ;///
	out tccr0b,temp
	ldi temp,$01
	sts timsk0,temp



	;Configura ADC
	ldi temp, $63 ; Para configurar el admux, 6 para recargarlo a la izq y 3 
	sts admux, temp  ;Se manda la configuración al ADC 	
 	ldi temp, $eb ; E para la parte Alta y B para la parte baja
	;ldi temp, $cb   ; C para la parte Alta y B para la parte baja
	sts adcsra, temp
	ldi temp, $08
	sts didr0, temp ; Ya terminamos de configurar el ADC
	;sei   ;esto lo movi
		


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

	sei

main: 
	rjmp main


fin_conv: LDS temp, adch ; Leemos el registro de resultados del ADC
	mov r10,temp
	;ldi temp, $FF  ;Prueba de 255
	;mov r10, temp
	in temp, pind
	cpi temp,$00 ;cambie 1 por 0
	brne Voltaje
	rcall Porcentaje
	reti


Porcentaje:	ldi temp, $C4
	mov r11, temp
	mul r10, r11
	rcall Div
	mov fbinH, YH 
	mov fbinL, YL
	rcall bin2BCD16


	mov Raux,tBCD1

	lsl Raux	
	lsl Raux
	lsl Raux
	lsl Raux

	lsr Raux
	lsr Raux
	lsr Raux
	lsr Raux

	lsr tBCD1
	lsr tBCD1
	lsr tBCD1
	lsr tBCD1

	mov uni_aux, Raux
	mov dece_aux, tBCD1
	mov cent_aux, tBCD2	
	;out portb, temp ; Sacamos a puerto B el resultado.

	ret


Voltaje: 	ldi temp, $C4
	mov r11, temp
	mul r10, r11
	mov fbinH, r1
	mov fbinL, r0
	rcall bin2BCD16
		


	mov Raux,tBCD1

	lsl Raux	
	lsl Raux
	lsl Raux
	lsl Raux

	lsr Raux
	lsr Raux
	lsr Raux
	lsr Raux

	lsr tBCD1
	lsr tBCD1
	lsr tBCD1
	lsr tBCD1

	mov uni_aux, Raux
	mov dece_aux, tBCD1
	mov cent_aux, tBCD2	


	;out portb, temp ; Sacamos a puerto B el resultado.

	reti


bin2BCD16:
	ldi	cnt16a,16	;Init loop counter	
	clr	tBCD2		;clear result (3 bytes)
	clr	tBCD1		
	clr	tBCD0		
	clr	ZH		;clear ZH (not needed for AT90Sxx0x)

bBCDx_1:lsl	fbinL		;shift input value
	rol	fbinH		;through all bytes
	rol	tBCD0		;
	rol	tBCD1
	rol	tBCD2
	dec	cnt16a		;decrement loop counter
	brne	bBCDx_2		;if counter not zero
	ret			;   return

bBCDx_2:ldi	r30,AtBCD2+1	;Z points to result MSB + 1

bBCDx_3:
	ld	tmp16a,-Z	;get (Z) with pre-decrement
;----------------------------------------------------------------
;For AT90Sxx0x, substitute the above line with:
;
;	dec	ZL
;	ld	tmp16a,Z
;
;----------------------------------------------------------------
	subi	tmp16a,-$03	;add 0x03
	sbrc	tmp16a,3	;if bit 3 not clear
	st	Z,tmp16a	;	store back
	ld	tmp16a,Z	;get (Z)
	subi	tmp16a,-$30	;add 0x30
	sbrc	tmp16a,7	;if bit 7 not clear
	st	Z,tmp16a	;	store back
	cpi	ZL,AtBCD0	;done all three?
	brne	bBCDx_3		;loop again if not
	rjmp	bBCDx_1	


ovf: 
	push temp
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

Div: mov YL, r0
	mov YH, r1
True: sbiw YL, $05
	brmi fin
	mov temp, r12
	inc temp
	mov r12, temp
	rjmp True
fin: ret





display: .db $40,$79,$24,$30,$19,$12,$02,$78,$00,$10

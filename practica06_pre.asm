	.include "m48def.inc"
	.equ	AtBCD0	=13		;address of tBCD0
	.equ	AtBCD2	=15		;address of tBCD1

	.def	tBCD0	=r13		;BCD value digits 1 and 0
	.def	tBCD1	=r14		;BCD value digits 3 and 2
	.def	tBCD2	=r15		;BCD value digit 4
	.def	fbinL	=r16		;binary value Low byte
	.def	fbinH	=r17		;binary value High byte
	.def	cnt16a	=r18		;loop counter
	.def	tmp16a	=r19		;temporary value
	
	.def temp = r20
	.def mux = r21	
	.def auxu = r22
	.def auxd = r23
	.def auxc = r24
	.def m1 = r25
	.cseg
	.org 0
	rjmp reset
	.org 0x010
	rjmp int_disps
	.org 0x015
	rjmp int_conv
	
reset:
	ldi auxu,$00
	ldi auxd,$00
	ldi auxc,$00
	ldi mux,$01
	;puertos
	ldi temp,$07 
	out ddrc,temp
	ldi temp,$ff
	out ddrb,temp
	;timer0
	ldi temp,$02
	out tccr0b,temp
	sts timsk0,temp
	ldi temp,$01
	sts timsk0,temp
	sts tifr0,temp	
	;adc
	ldi temp,$63
	sts admux,temp
	ldi temp,$eb
	sts adcsra,temp
	ldi temp,$08
	sts didr0,temp
	;constantes
	ldi temp,$07
	ldi zl,low(disps*2)
	ldi zh,high(disps*2)
	ldi xl,$00
	ldi xh,$01
	ldi temp,$0a
	sei
ldloop: 
	lpm r25,z+ ; cargas la constante de z en r17. incrementas z
	st x+,r25 ; metes a x (empezando en 0100) lo que hay en r17. incrementas x
	dec temp ; bajas temp
	brne ldloop ; y pues brne se activa cuando z esta en 1, para que se detenga el loop
	
main:
	rjmp main
int_conv:
	;maybe
	;multiplica
	lds m1,adch
	ldi temp,196
	mul m1,temp
	;carga
	mov fbinL,r0
	mov fbinH,r1
	;conv
	rcall bin2BCD16
	;uni
	mov temp,tBCD1
	cbr temp,$f0
	mov xl,temp
	ld auxu,x
	;dec
	mov temp,tBCD1
	cbr temp,$0f
	lsr temp
	lsr temp
	lsr temp
	lsr temp
	mov xl,temp
	ld auxd,x
	;cent
	mov temp,tBCD2
	mov xl,temp
	ld auxc,x

	com auxu
	com auxd
	com auxc

	reti
	
int_disps:
	cpi mux,$01
	breq sh_dece
	cpi mux,$02
	breq sh_cente
sh_uni:	;solo queda el de centenas
	ldi mux,$01
	out portb,auxu
	out portc,mux
	rjmp end_int_disps
sh_dece:
	ldi mux,$02
	out portb,auxd
	out portc,mux
	rjmp end_int_disps
sh_cente:
	ldi mux,$04
	out portb,auxc
	out portc,mux
	rjmp end_int_disps
end_int_disps:
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

disps:
	.db $7e,$30,$6d,$79,$33,$5b,$5f,$70,$ff,$7b

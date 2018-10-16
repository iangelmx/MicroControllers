	.include "m48def.inc"
	.def temp = r16
	.def uni = r17
	.def dece = r18
	.def cent = r19
	.def mux = r20
	.def auxu = r21
	.def auxd = r22
	.def auxc = r23
	.cseg
	.org $000
	
	rjmp reset
	;timer1
	.org $00b
	rjmp int_freq
	;ext
	.org $001
	rjmp int_count
	;timer0
	.org 0x010
	rjmp int_disps
;configurar timer0 en overflow para disps

;configurar interrupcion externa para flancos de subida

;configurar timer1 a 1 segundo
reset:
	ldi uni,$00
	ldi dece,$00
	ldi cent,$00
	ldi mux,$01
;puertos
	ldi temp,$ff 
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
;timer1 (a 1Hz) en ctc
	ldi temp,$3d
	sts ocr1ah,temp
	ldi temp,$09	
	sts ocr1al,temp
	ldi temp,$00
	sts tccr1a,temp
	ldi temp,$0b
	sts tccr1b,temp
	ldi temp, $02
	sts timsk1,temp
	sts tifr1,temp
;int externa
	ldi temp,$03
	sts eicra,temp
	ldi temp,$01
	out eimsk,temp
	out eifr,temp
;constantes
	ldi temp,$07
	ldi zl,low(disps*2)
	ldi zh,high(disps*2)
	ldi xl,$00
	ldi xh,$01
	ldi temp,$0a
	sei
ldloop: 
	lpm r17,z+ ; cargas la constante de z en r17. incrementas z
	st x+,r17 ; metes a x (empezando en 0100) lo que hay en r17. incrementas x
	dec temp ; bajas temp
	brne ldloop ; y pues brne se activa cuando z esta en 1, para que se detenga el loop

main:
	rjmp main

int_count:
	inc uni
	cpi uni,$0a
	brne end_int_count
	ldi uni,$0
	inc dece
	cpi dece,$0a
	brne end_int_count
	ldi dece,$0
	inc cent
	cpi cent,$0a
	brne end_int_count
	ldi uni,$00
	ldi dece,$00
	ldi cent,$00
end_int_count:
	reti

int_freq:
	mov xl,uni
	ld auxu,x
	mov xl,dece
	ld auxd,x
	mov xl,cent
	ld auxc,x
	ldi uni,$00 ;reset
	ldi dece,$00
	ldi cent,$00
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

disps:
	.db $7e,$30,$6d,$79,$33,$5b,$5f,$70,$ff,$7b


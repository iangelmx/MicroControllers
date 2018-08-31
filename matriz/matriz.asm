	.include "m48def.inc"
	.def temp = r16
	.def cont1=r17
	.def cont2=r18
	.def selector=r19
	.cseg
	.org 0

	ldi temp,$FF
	out ddrd,temp
	ldi temp,$FF
	out ddrb,temp
	ldi temp,$FC
	out ddrc,temp
	ldi temp,$03
	out portc,temp

comprobacion: in selector,pinc
	cpi selector,03
	breq corazon
	cpi selector,02
	breq feliz
	cpi selector,01
	breq triste
	cpi selector,00
	breq equis

corazon: rcall funcion1
	rjmp comprobacion
feliz: rcall funcion2
	rjmp comprobacion
triste: rcall funcion3
	rjmp comprobacion
equis: rcall funcion4
	rjmp comprobacion

//Corazon
funcion1: nop
iniheart: ldi temp,$02
	out portd,temp
	ldi temp,$99
	out portb,temp
	rcall delay_250
	
	ldi temp,$0C
	out portd,temp
	ldi temp,$00
	out portb,temp
	rcall delay_250
	
	ldi temp,$10
	out portd,temp
	ldi temp,$81
	out portb,temp
	rcall delay_250
	
	ldi temp,$20
	out portd,temp
	ldi temp,$C3
	out portb,temp
	rcall delay_250
	
	ldi temp,$40
	out portd,temp
	ldi temp,$E7
	out portb,temp
	rcall delay_250
	
	in selector,pinc
	cpi selector,00
	brne finheart
	rjmp iniheart
finheart: ret

//Feliz
funcion2: nop
inifeliz: ldi temp,$81
	out portd,temp
	ldi temp,$C3
	out portb,temp
	rcall delay_250
	
	ldi temp,$42
	out portd,temp
	ldi temp,$BD
	out portb,temp
	rcall delay_250
	
	ldi temp,$14
	out portd,temp
	ldi temp,$5A
	out portb,temp
	rcall delay_250
	
	ldi temp,$08
	out portd,temp
	ldi temp,$7E
	out portb,temp
	rcall delay_250
	
	ldi temp,$20
	out portd,temp
	ldi temp,$66
	out portb,temp
	rcall delay_250
	
	in selector,pinc
	cpi selector,01
	brne finfeliz
	rjmp inifeliz
finfeliz: ret

//Triste
funcion3:nop
initriste: ldi temp,$81
	out portd,temp
	ldi temp,$C3
	out portb,temp
	rcall delay_250
	
	ldi temp,$42
	out portd,temp
	ldi temp,$BD
	out portb,temp
	rcall delay_250
	
	ldi temp,$24
	out portd,temp
	ldi temp,$5A
	out portb,temp
	rcall delay_250
	
	ldi temp,$08
	out portd,temp
	ldi temp,$7E
	out portb,temp
	rcall delay_250
	
	ldi temp,$10
	out portd,temp
	ldi temp,$66
	out portb,temp
	rcall delay_250
	
	in selector,pinc
	cpi selector,02
	brne fintriste
	rjmp initriste
fintriste: ret

//X
funcion4:nop
inix: ldi temp,$42
	out portd,temp
	ldi temp,$BD
	out portb,temp
	rcall delay_250
	
	ldi temp,$24
	out portd,temp
	ldi temp,$DB
	out portb,temp
	rcall delay_250
	
	ldi temp,$18
	out portd,temp
	ldi temp,$E7
	out portb,temp
	rcall delay_250
	
	in selector,pinc
	cpi selector,03
	brne finx
	rjmp inix
finx: ret


//Subrutinas
delay_250: ldi cont2,10
lazo32:		ldi cont1,50
lazo31: nop
	dec cont1
	brne lazo31
	dec cont2
	brne lazo32
	ret



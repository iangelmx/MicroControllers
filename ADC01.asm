	.include "m48def.inc"
	.def temp = r16
	.cseg
	.org 0

	rjmp reset

	.org $015
	rjmp fin_conv

reset: ldi temp, $ff
	out ddrb, temp ; Se configura  B como salida

	ldi temp, $63 ; Para configurar el admux, 6 para recargarlo a la izq y 3 
	sts admux, temp  ;Se manda la configuración al ADC 
	
	ldi temp, $eb ; E para la parte Alta y B para la parte baja
	sts adcsra, temp

	ldi temp, $08
	stws didr0, temp ; Ya terminamos de configurar el ADC

	sei

main: rjmp main


fin_conv: LDS temp, adch ; Leemos el registro de resultados del ADC
	out portb ; Sacamos a puerto B el resultado.
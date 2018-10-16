	;Se hizo con free_running
	.include "m48def.inc"
	.def temp = r16
	.def cont1 = r17
	.def cont2 = r18
	.cseg
	.org 0

	rjmp reset

	.org $015
	rjmp fin_conv

reset: ldi temp, $ff
	out ddrb, temp ; Se configura  B como salida

	ldi temp, $e3 ; Para habilitar la referencia interna
	sts admux, temp  ;Se manda la configuración al ADC 
	
	; ANTES: ldi temp, $eb ; E para la parte Alta y B para la parte baja
	ldi temp, $eb ; E para la parte Alta y B para la parte baja
	sts adcsra, temp

	ldi temp, $08
	sts didr0, temp ; Ya terminamos de configurar el ADC

	sei

main:	rjmp main


fin_conv: LDS temp, adch ; Leemos el registro de resultados del ADC
	out portb, temp ; Sacamos a puerto B el resultado.
	reti
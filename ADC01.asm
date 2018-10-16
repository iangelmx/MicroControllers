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

	ldi temp, $ff
	out portd, temp ; Se configura el puerto D para leer el pulso de activación

	ldi temp, $63 ; Para configurar el admux, 6 para recargarlo a la izq y 3 
	sts admux, temp  ;Se manda la configuración al ADC 
	
	; ANTES: ldi temp, $eb ; E para la parte Alta y B para la parte baja
	ldi temp, $cb ; C para la parte Alta y B para la parte baja
	sts adcsra, temp

	ldi temp, $08
	sts didr0, temp ; Ya terminamos de configurar el ADC

	sei

main: ;NUEVO PAR AEL EJEMPLO DEL PULSO ACTIVADOR
	in temp, pind; leemos el puerto d
	cpi temp, $fb ; restamos para comparar
	breq ini_conv
	rjmp main

ini_conv: ;NUEVO PARA EL EJEMPLO DEL PULSO
	recall delay_100ms
	ldi temp, $cb
	sts adcsra, temp
	rjmp main


fin_conv: LDS temp, adch ; Leemos el registro de resultados del ADC
	out portb, temp ; Sacamos a puerto B el resultado.
	reti

delay_100ms:
	ldi cont1, 40
lazo2:
	ldi cont2, 250
lazo1:
	nop
	nop
	nop
	nop
	nop
	nop
	nop ;7 NOPs
	dec cont2 ; 1 op
	brne lazo1 ; 2 ops
	dec cont1
	brne lazo2
	ret


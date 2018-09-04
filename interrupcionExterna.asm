	.include "m48def.inc"
	.def temp = r16
	.cseg
	.org 0

	rjmp reset
	rjmp int0

reset: ldi temp, $01
	out ddrb, temp ; Se le manda 01 a b, porque sólo se usará B0

	ldi temp, $02
	sts eicra, temp ; Le mandamos un 02 a eicra, porque requerimos el pulso de bajada.
				   ; También se escribe con sts, porque es un registro extendido
	ldi temp,$01
	out eimsk, temp ; Mandamos 01 al vector de la máscara
	
	sei

main: in temp, pinb
	cli
	andi temp, $01
	breq main
	sei
	rcall delay_10seg
	ldi temp, $00
	out portb, temp
	rjmp main
;Falta poner los registros para hacer los delays

int0: ldi temp,$01
	out portb, temp
	rcall delay_30ms ;Para quitar los rebotes del pulso ruidoso
	ldi cont1, 20
	ldi cont2, 200
	ldi cont3, 250
	ldi temp, $01
	out eifr, temp
	reti


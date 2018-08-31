;;; Programa de Fast PWM

	.include "m48def.inc"
	.def cte = r15
	.def temp = r16
	.def cont1 = r17
	.def cont2 = r18
	.def tope = r19
	.def zero = r20
	.cseg
	.org 0

	ldi temp,$40
	out ddrd, temp ; Configuramos el puerto D como salida porque se manda un 1 al bit 6 del puerto D

	ldi temp, $03
	out portc, temp ; El puerto C de entrada con 01 por que se manda un 1 al bit 1 del puerto C

	ldi temp, $83
	out tccr0a, temp ; Le mandamos la configuración 83 para los bits de configuración al registro A

	ldi temp, $01
	out tccr0b, temp ; le mandamos la configuración de 01 para el registro B

	ldi temp, 125 ; $0f
	out ocr0a, temp
	
	ldi temp, $05
	mov cte, temp ; Se podría quitar esto si cte estuviera en el r17
	;Ya terminamos de configurar las salidas y entradas

	ldi tope,$FF
	ldi zero,$00

main: in temp, pinc
	andi temp, $03 ; Si el resultado de la and, se está presionando el botón
	cpi temp,$02
	breq aumentar; Si se cumple la condición, va a AUMENTAR()
	cpi temp,$01
	breq disminuir
	rjmp main


 aumentar: in temp,ocr0a
	 cpse temp,tope
	 add temp,cte
	 out ocr0a,temp
	 rcall delay_50ms
	 rjmp main

disminuir: in temp,ocr0a
	 cpse temp,zero
	 sub temp,cte
	 out ocr0a,temp
	 rcall delay_50ms
	 rjmp main


delay_50ms: ldi cont1, 20
lazo2:	ldi cont2, 250
lazo1:	nop
	nop
	nop
	nop
	nop
	nop
	nop
	dec cont2
	brne lazo1 ;Branch si no es igual a...
	dec cont1
	brne lazo2 ; Branch si no es igual a...
	ret
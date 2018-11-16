	.include "m48def.inc"
	.def temp = r16
	.def cont1 = r17
	.def cont2 = r18
	.def cursor = r19
	;.def aux = r20
	.def linea = r20
	.def char = r21
	.def aux2 = r22
	
	.cseg
	.org 0
	rjmp reset

	.org $012 ;Para la interrup de RecxCmp
	rjmp recibe

reset:	
	;INICIO USART
	;PDO entrada, PD1 salida
	ldi temp, $02
	out ddrd, temp ;Se configuran pines para USART
	;Reg A:
	sts ucsr0a, temp
	;Reg B:
	ldi temp, $98
	sts ucsr0b, temp ; Para el 7, 4, y 3 del Reg B

	; Al registro C no se le debe escribir nada para este ejercicio.
	
	ldi temp, 12 ; Para el tiempo 9600 al doble
	sts ubrr0l, temp 
	;FIN USART
	
	ldi cursor, $00

	;Empieza config de LCD : 

	ldi temp, $ff
	out ddrd, temp

	rcall delay_100ms
	rcall delay_100ms

	;::: Function set Inicial
	ldi temp, $20
	out portd, temp
	sbi portd,2
	nop
	cbi portd,2
	nop
	rcall delay_1ms


	;::: Function set 1 o 2 lineas
	ldi temp, $20	; el 1 habilita el SRAM el 4 es la parte alta de la letra
	out portd,temp	;
	sbi portd,2		;Parte alta
	nop				;
	cbi portd,2
	nop
	;ldi temp, $00	; el 1 habilita el SRAM el 8 es la parte baja de la letra
	ldi temp, $80	; el 1 habilita el SRAM el 8 es la parte baja de la letra
	out portd,temp	;Parte baja
	sbi portd, 2	;
	nop				;
	cbi portd, 2	;
	rcall delay_1ms


	;::: Display on/off	
	ldi temp, $00	; el 1 habilita el SRAM el 4 es la parte alta de la letra
	out portd,temp	;
	sbi portd,2		;Parte alta
	nop				;
	cbi portd,2
	nop
	ldi temp, $e0	; el 1 habilita el SRAM el 8 es la parte baja de la letra
	out portd,temp	;Parte baja
	sbi portd, 2	;
	nop				;
	cbi portd, 2	;
	rcall delay_1ms

	;::: Entry mode set
	ldi temp, $00	; el 1 habilita el SRAM el 4 es la parte alta de la letra
	out portd,temp	;
	sbi portd,2		;Parte alta
	nop				;
	cbi portd,2
	nop
	ldi temp, $60	; el 1 habilita el SRAM el 8 es la parte baja de la letra
	out portd,temp	;Parte baja
	sbi portd, 2	;
	nop				;
	cbi portd, 2	;
	rcall delay_1ms
	rcall clear
	ldi linea, $00
	;rcall returnHome
	sei

main:
	rjmp main

sendChar:
	;para esta práctica se requiere que el caracter 
	;esté en la constante char
	;::: Letra H
	
	mov r10, char ;0100 1000
	lsl r10 ;1001 0000
	lsl r10 ;0010 0000
	lsl r10 ;0100 0000
	lsl r10 ;1000 0000
	; Ya tenemos parte baja en r10 convertido a low*10
				
			 ;0100 1000
	lsr char ;0010 0100
	lsr char ;0001 0010
	lsr char ;0000 1001
	lsr char ;0000 0100

	lsl char ;0000 1000
	lsl char ;0001 0000
	lsl char ;0010 0000
	lsl char ;0100 0000
	; Ya tenemos parte alta en char charH
	
	ldi aux2, $08
	add char, aux2 ; el 8 habilita el SRAM char es la parte alta de la letra
	
	mov temp, r10
	ldi aux2, $08
	add temp, aux2

	;En los anteriores 3 renglones es: char+=$08, temp=r10; temp+=$08

	;ldi temp, $48	; el 8 habilita el SRAM el 4 es la parte alta de la letra
	out portd,char	;
	sbi portd,2		;Parte alta
	nop				;
	cbi portd,2
	nop
	;ldi temp, $88	; el 8 habilita el SRAM el 8 es la parte baja de la letra
	out portd,temp	;Parte baja
	sbi portd, 2	;
	nop				;
	cbi portd, 2	;
	rcall delay_1ms
	ret


	;::: Return Home
returnHome:	ldi temp, $00	; el 1 habilita el SRAM el 4 es la parte alta de la letra
	out portd,temp	;
	sbi portd,2		;Parte alta
	nop				;
	cbi portd,2
	nop
	ldi temp, $20	; el 1 habilita el SRAM el 8 es la parte baja de la letra
	out portd,temp	;Parte baja
	sbi portd, 2	;
	nop				;
	cbi portd, 2	;
	rcall delay_1ms
	ret

	;::: Set DDRAM address
	
primeraLinea:
	ldi temp, $80	; 1er linea; 2a linea -> D7 habría que mandarle un 1
	out portd,temp	;
	sbi portd,2		;Parte alta
	nop				;
	cbi portd,2
	nop
	ldi temp, $70	; posición del cursor
	out portd,temp	;Parte baja
	sbi portd, 2	;
	nop				;
	cbi portd, 2	;
	rcall delay_1ms
	ret


	;::: Set DDRAM address
	
segundaLinea:
	ldi temp, $C0	; 1er linea; 2a linea -> D7 habría que mandarle un 1
	out portd,temp	;
	sbi portd,2		;Parte alta
	nop				;
	cbi portd,2
	nop
	ldi temp, $00	; posición del cursor
	out portd,temp	;Parte baja
	sbi portd, 2	;
	nop				;
	cbi portd, 2	;
	rcall delay_1ms
	ret

	;::: Set DDRAM address
	
clear:
	ldi temp, $00	; 1er linea; 2a linea -> D7 habría que mandarle un 1
	out portd,temp	;
	sbi portd,2		;Parte alta
	nop				;
	cbi portd,2
	nop
	ldi temp, $10	; posición del cursor
	out portd,temp	;Parte baja
	sbi portd, 2	;
	nop				;
	cbi portd, 2	;
	rcall delay_1ms
	ret

delay_1ms:
	ldi cont1, 200
lazo1:
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	dec cont1
	brne lazo1
	ret

delay_100ms:
	ldi cont2, 200
lazo3:
	ldi cont1, 100
lazo2:
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	dec cont1
	brne lazo2
	dec cont2
	brne lazo3
	ret

recibe:
	lds char, udr0
	inc cursor
	cpi linea, 1
	breq valida32
	cpi cursor, 17
	breq switchToLineTwo
	rcall sendChar
	reti

valida32:
	cpi cursor, 33
	breq switchToLineOne
	rcall sendChar
	reti

switchToLineTwo:
	ldi linea, $01
	rcall segundaLinea
	rcall sendChar
	reti

switchToLineOne:
	ldi linea, $00
	ldi cursor, $00
	rcall clear
	rcall returnHome
	rcall sendChar
	reti

/*
recibe: lds char, udr0;LDS porque es extendido, se lee el dato
	inc cursor
	mov aux, cursor
	cpi aux, 17 ;Se le resta 17
	breq valida39
	rcall sendChar
	rcall clear
	reti
valida39: 
	mov aux, cursor
	cpi aux, 33 ;aux=aux-39
	breq valida4F
	ldi cursor, $28 ; cursor=40
	rcall segundaLinea
	rcall sendChar
	reti
valida4F:
	mov aux, cursor
	cpi aux, $38 ; aux=aux-80
	breq resetCont
	rcall sendChar
	reti
resetCont:
	ldi cursor, 0 ; cursor = 40
	rcall clear
	;rcall returnHome
	rcall sendChar
	reti
	;Transmitimos: a pc
	;sts udr0, temp
	;reti

*/
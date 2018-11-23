	.include "m48def.inc"
	.def temp = r16
	.def cont1 = r17
	.def cont2 = r18
	.def cursor = r19
	.def linea = r20
	.def char = r21
	.def aux2 = r22
	.def cst = r23
	.def tecla = r24
	
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

	rcall delay_1ms
	rcall delay_1ms

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
	ldi cst, $41
	sei


main:
	rcall teclado
	rjmp main

teclado:
	
	ldi temp, $f0
	out ddrb, temp	;B3-B0 como entrada y B7-B4 salida
	ldi temp, $0f
	out portb, temp ;Resistencias pull-up B3-B0

	rcall delay_2us

	ldi tecla, $00

	in temp, pinb
	andi temp, $0f
	cpi temp, $0e
	breq fila_0
	cpi temp, $0d
	breq fila_4
	cpi temp, $0b
	breq fila_8
	cpi temp, $07
	breq fila_c

sigue:
	rcall delay_100ms
;	rcall delay_1ms
	ret

fila_0:
	ldi tecla, $00
	rjmp teclado2

fila_4:
	ldi tecla, $04
	rjmp teclado2

fila_8:
	ldi tecla, $08
	rjmp teclado2

fila_c:
	ldi tecla, $0c
	rjmp teclado2


	;:: Cambios de modo
al:
	ldi cst, $41
	rjmp sigue
mw:
	ldi cst, $4d
	rjmp sigue
xz:
	ldi cst, $58
	rjmp sigue
num:
	;rcall clear
	ldi cst, $30
	rjmp sigue

columna_0:
	ldi temp, $00
	add tecla, temp
	rjmp sigue2

columna_1:
	ldi temp, $01
	add tecla, temp
	rjmp sigue2

columna_2:
	ldi temp, $02
	add tecla, temp
	rjmp sigue2

columna_3:
	ldi temp, $03
	add tecla, temp
	rjmp sigue2
	
		 
teclado2:
	ldi temp, $0f
	out ddrb, temp	;B3-B0 como salida y B7-B4 como entrada
	ldi temp, $f0
	out portb, temp ;Resistencias pull-up B7-B4

	rcall delay_2us

	in temp, pinb
	andi temp, $f0
	cpi temp,$e0
	breq columna_0
	cpi temp,$d0
	breq columna_1
	cpi temp,$b0
	breq columna_2
	cpi temp,$70
	breq columna_3

sigue2:
	cpi tecla, $0c
	breq al
	cpi tecla, $0d
	breq mw
	cpi tecla, $0e
	breq xz
	cpi tecla, $0f
	breq num
	add tecla,cst
	mov char,tecla
	rcall delay_100ms
	rcall print
	rjmp sigue
	;reti

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

aux:
	rcall valida32
	ret

aux3:
	rcall switchToLineTwo
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
print:
	inc cursor
	cpi linea, 1
	breq valida32
	cpi cursor, 17
	breq switchToLineTwo
	sts udr0,char   ;///////////////////////////////
	rcall sendChar
	reti

valida32:
	cpi cursor, 33
	breq switchToLineOne
	sts udr0,char 
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

delay_2us:
	nop
	nop
	ret
	.include "m48def.inc"
	.def temp = r16
	.def alto = r17
	.def bajo = r18
	.def cst = r19
	.def ln2 = r20
	.def tecla = r21
	.def temp2 = r22
	.def cont1 = r24
	.def cont2 = r25

	.cseg
	.org 0

	ldi cst, $00
	ldi ln2, $00

	ldi temp, $ff
	out ddrd, temp

	rcall delay_100ms

	;::: Function set Inicial
	ldi temp, $08
	out portd, temp
	sbi portd,7
	cbi portd,7
	rcall delay_1ms

	;::: Function set
	ldi temp, $08	;
	out portd, temp	;Parte alta
	sbi portd,7		;
	nop
	cbi portd,7		;
	nop
	ldi temp, $20	;	Al pasarle un 20 se activa el modo de dos lineas
	out portd, temp	;Parte baja
	sbi portd,7		;
	nop
	cbi portd,7		;
	rcall delay_1ms	;


	;::: Display on/off	
	ldi temp, $00
	out portd, temp
	sbi portd, 7
	nop
	cbi portd, 7
	nop
	ldi temp, $38
	out portd, temp
	sbi portd,7
	nop
	cbi portd,7
	rcall delay_1ms
	
	;::: Entry mode set
	ldi temp, $00
	out portd,temp
	sbi portd,7
	nop
	cbi portd,7
	nop
	ldi temp, $18
	out portd,temp
	sbi portd, 7
	nop
	cbi portd, 7
	rcall delay_1ms

	;:: Clear
	ldi temp, $00	
	out portd,temp	
	sbi portd,7		;Parte alta
	nop
	cbi portd,7
	nop
	ldi temp, $04
	out portd,temp	;Parte baja
	sbi portd,7
	nop
	cbi portd,7
	rcall delay_1ms

/*
	;::: Return Home
	ldi temp, $00
	out portd, temp
	sbi portd,7
	nop
	cbi portd,7
	nop
	ldi temp, $0c
	sbi portd,7
	nop
	cbi portd,7
	rcall delay_1ms
*/
	

	;Carga constantes a memoria
	ldi XL, $00
	ldi XH, $01			;Ponemos a X en el registro $0100

						;Apuntamos con Z al inicio de las constantes en memoria de programa
	ldi ZL, low(display*2)
	ldi ZH, high(display*2)

carga:
	lpm					;Recuperamos constante a r0
	adiw ZL, 1			;Aumentamos apuntador Z
	st X+, r0			;Guardamos r0 en la posicion de X
	dec cont1
	brne carga			;Aqui cargaremos las constantes en memoria de datos


	;Interrupciones y lazo infinito

	;sei					;Bit de interrupcion global

	

	;:::Lazo principal
main:
	nop
	rcall teclado
	rjmp main

teclado:
	;push temp
	;ldi bandera, $01
	;ldi temp, $00
	;sts tcnt1h, temp
	;sts tcnt1l, temp
	
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
	;ldi temp, $01
	;sts pcifr, temp

	;ldi temp, $00
	;out portb, temp
	;out ddrb, temp

	;pop temp
	rcall delay_100ms
	rcall delay_100ms
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
	rcall write_lcd
	rjmp sigue
	;reti

	;:: Cambios de modo
al:
	ldi cst, $00
	rjmp sigue
mw:
	ldi cst, $0c
	rjmp sigue
xz:
	ldi cst, $18
	rjmp sigue
num:
	ldi cst, $24
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

	;:::Escribe en pantalla
write_lcd:
	
	inc ln2
	cpi ln2, $11
	breq linea_2

	cpi ln2, $20
	breq clear


continue_write:
	ldi XH, $01
	ldi XL, $00

	ldi alto, $40
	ldi bajo, $40

	mov temp, tecla

	add XL, temp

	ld temp, X

	push temp
	rcall right_shift
	lsl temp
	lsl temp
	add alto, temp
	pop temp
	andi temp, $0f
	lsl temp
	lsl temp
	add bajo, temp

	out portd, alto
	sbi portd,7
	nop
	cbi portd,7
	nop
	out portd, bajo
	sbi portd,7
	nop
	cbi portd,7
	rcall delay_1ms
	ret

	;:: En caso de usar segunda linea
linea_2:
	/*
	;::: Entry mode set con corrimientos
	ldi temp2, $00
	out portd, temp2	;Parte alta segunda linea
	sbi portd,7
	nop
	cbi portd,7
	nop
	ldi temp2, $1c
	out portd, temp2	;parte baja segunda linea
	sbi portd,7
	nop
	cbi portd,7
	nop
	rcall delay_1ms
	*/

	;::: Set DDRAM ADDRESS
	ldi temp2, $30
	out portd, temp2	;Parte alta segunda linea
	sbi portd,7
	nop
	cbi portd,7
	nop
	ldi temp2, $00
	out portd, temp2	;parte baja segunda linea
	sbi portd,7
	nop
	cbi portd,7
	nop
	rcall delay_1ms
	rcall delay_1ms
	
	rjmp continue_write

clear:

	;:: Clear
	ldi temp2, $00	
	out portd,temp2	
	sbi portd,7		;Parte alta
	nop
	cbi portd,7
	nop
	ldi temp2, $04
	out portd,temp2	;Parte baja
	sbi portd,7
	nop
	cbi portd,7
	rcall delay_1ms
	rcall delay_1ms
	rcall delay_1ms

	ldi ln2, $00

	rjmp continue_write

	;::: Corrimientos a la derecha
right_shift:
	ldi cont1, $04
lazo1:
	lsr temp
	dec cont1
	brne lazo1
	ret

left_shift:
	ldi cont1, $04
lazo2:
	lsl temp
	dec cont1
	brne lazo2
	ret

	;:::Delay
delay_200ms:
	rcall delay_100ms
	rcall delay_100ms
	ret

delay_100ms:
	ldi cont1, 50
esp1:	
	ldi cont2, 100
esp2:
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	dec cont2
	brne esp2
	dec cont1
	brne esp1
	ret

delay_1ms:
	ldi cont1, 5
esp1ms_1:
	ldi cont2, 10
esp1ms_2:
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	dec cont2
	brne esp1ms_2
	dec cont1
	brne esp1ms_1
	ret

delay_2us:
	nop
	nop
	ret

	.cseg
display:
	.db  $41, $42, $43, $44, $45, $46, $47, $48, $49, $4a, $4b, $4c, $4d, $4e, $4f, $50,$51, $52, $53, $54, $55, $56, $57, $58, $59, $5a, $30, $31, $32, $33, $34, $35, $36, $37, $38, $39
						;Valores del 0 al 9 codificados en 7 segmentos catodo comun


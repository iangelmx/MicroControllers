	.include "m48def.inc"
	.def temp = r16
	.def cont1 = r17
	.def cont2 = r18
	.cseg
	.org 0


	ldi temp, $fe 
	out ddrd, temp ; Se establece D0 como entrada
;;**1 punto
	rcall delay_50ms
;; 2 function set 4 bits
	;;0010
	ldi temp, $20
	out portd, temp
	
	SBI portd, 2;mandamos enable en alto y 
	CBI portd, 2; Se le manda el flanco de bajada de enable.

	rcall delay_2Punto5ms

;; 3 Function set 8 bits, parte alta y baja
	;Parte alta:
	ldi temp, $20
	out portd, temp
	
	SBI portd, 2;mandamos enable en alto y 
	CBI portd, 2; Se le manda el flanco de bajada de enable.
	nop
	;Parte baja:
	;;Para trabajar con las 2 l�neas, hay que mandar N=1 se le manda un 80, los �ltimos 2 bits no importan

	ldi temp, $80
	out portd, temp
	
	SBI portd, 2;mandamos enable en alto y 
	CBI portd, 2; Se le manda el flanco de bajada de enable.
	rcall delay_2Punto5ms

;; 4 display on-off
	
	ldi temp, $00
	out portd, temp
	
	SBI portd, 2;mandamos enable en alto y 
	CBI portd, 2; Se le manda el flanco de bajada de enable.
	nop
	;Parte baja:
	;;Se le manda una E, porque se apaga Blink, se enciende el cursor y no s� que m�s :v

	ldi temp, $e0
	out portd, temp
	
	SBI portd, 2;mandamos enable en alto y 
	CBI portd, 2; Se le manda el flanco de bajada de enable.
	rcall delay_2Punto5ms

;; 5 Mode set
	;Parte alta:	
	ldi temp, $00
	out portd, temp
	
	SBI portd, 2;mandamos enable en alto y 
	CBI portd, 2; Se le manda el flanco de bajada de enable.
	nop
	;Parte baja:
	;I/D -> 1, incremento DDRAM, empieza en 0x00, se le manda un 6

	ldi temp, $60
	out portd, temp
	
	SBI portd, 2;mandamos enable en alto y 
	CBI portd, 2; Se le manda el flanco de bajada de enable.
	rcall delay_2Punto5ms

;;5.5 Clear Display

	; Se le debe mandar 0 y 1
	;Parte alta:	
	ldi temp, $00
	out portd, temp
	
	SBI portd, 2;mandamos enable en alto y 
	CBI portd, 2; Se le manda el flanco de bajada de enable.
	nop
	;Parte baja:
	
	ldi temp, $10
	out portd, temp
	
	SBI portd, 2;mandamos enable en alto y 
	CBI portd, 2; Se le manda el flanco de bajada de enable.
	rcall delay_2Punto5ms
	

;; 6 Mensaje: ;Se manda un HOLA

	;; H:
	; 4_ para la H y 8 para la se�al RS.
	;Parte alta:	
	ldi temp, $48 ;Para la H
	out portd, temp
	
	SBI portd, 2;mandamos enable en alto y 
	CBI portd, 2; Se le manda el flanco de bajada de enable.
	nop
	;Parte baja:
	
	; _8 para la H y 8 para la se�al RS.
	ldi temp, $88
	out portd, temp
	
	SBI portd, 2;mandamos enable en alto y 
	CBI portd, 2; Se le manda el flanco de bajada de enable.
	rcall delay_2Punto5ms
	
	;; O:
	; 4_ para la O y 8 para la se�al RS.
	;Parte alta:	
	ldi temp, $48 ;Para la O
	out portd, temp
	
	SBI portd, 2;mandamos enable en alto y 
	CBI portd, 2; Se le manda el flanco de bajada de enable.
	nop
	;Parte baja:
	
	; _F para la O y 8 para la se�al RS.
	ldi temp, $F8
	out portd, temp
	
	SBI portd, 2;mandamos enable en alto y 
	CBI portd, 2; Se le manda el flanco de bajada de enable.
	rcall delay_2Punto5ms

	;; L:
	; 4_ para la L y 8 para la se�al RS.
	;Parte alta:	
	ldi temp, $48 ;Para la L
	out portd, temp
	
	SBI portd, 2;mandamos enable en alto y 
	CBI portd, 2; Se le manda el flanco de bajada de enable.
	nop
	;Parte baja:
	
	; _C para la L y 8 para la se�al RS.
	ldi temp, $C8
	out portd, temp
	
	SBI portd, 2;mandamos enable en alto y 
	CBI portd, 2; Se le manda el flanco de bajada de enable.
	rcall delay_2Punto5ms	


	;; A:
	; 4_ para la A y 8 para la se�al RS.
	;Parte alta:	
	ldi temp, $48 ;Para la L
	out portd, temp
	
	SBI portd, 2;mandamos enable en alto y 
	CBI portd, 2; Se le manda el flanco de bajada de enable.
	nop
	;Parte baja:
	
	; _1 para la A y 8 para la se�al RS.
	ldi temp, $18
	out portd, temp
	
	SBI portd, 2;mandamos enable en alto y 
	CBI portd, 2; Se le manda el flanco de bajada de enable.
	rcall delay_2Punto5ms	

aqui:	rjmp aqui


delay_2Punto5ms:
	ldi cont1,250
lazo3: 
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


delay_50ms:
lazo2:
	ldi cont2,20
lazo1: 
	ldi cont1,50
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	dec cont1
	brne lazo1
	dec cont2
	brne lazo2
	ret


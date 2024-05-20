;Practica entregable DLX 

;Carlos Conde VIcente		70919412Q
;Diego de Castro Merillas	71043687E

;+++++++++++++++++
;+ NO OPTIMIZADO +
;+++++++++++++++++

; 	A[0] = valor_inicial
; 	A[n] = Si A[n-1] 	es par	A[n] = A[n-1] / 2
;						es impar  A[n-1] = 3*A[n-1] + 1
;	Hasta que A[n-1] = 1


;	Declaración de directivas del ordenador
		.data

;Valor Inicial
valor_inicial: .word	10


;; VARIABLES DE SALIDA:
secuencia: 	.space 120*4
secuencia_tamanho: .word 0
secuencia_maximo: .word 0
secuencia_valor_medio: .float 0
lista: .space 9*4
lista_valor_medio: .float 0		
;; FIN VARIABLES DE ENTRADA Y SALIDA

;Comenzamos programa


		.text
		.global main

main:
	
	addi	r21, r0, 1	;	r21 = 1
	addi	r2, r0, 0	;	r2 = 0

	lw		r5, valor_inicial	; N		A[n]

	add		r3, r0, r5 			; r3 = valor secuencia_maximo
	add		r6, r0, r5			; A[n-1]
	add		r7, r0,	3			; r7 = 3
	addi	r4, r0, 0			; r4 = secuencia_valor_medio  --> se hace la suma en el loop
	addi 	r9, r0, secuencia 	; Cargar la dirección base de secuencia en r9


loop:
	; Estadisiticas

	add	r4, r4, r5		; Sumamos el valor de A[n] a r4

	sw		0(r9), r5	; Añadimos al array secuencia, el registro r5

	addi	r9, r9, 4	; Sumamos un byte para añadir el proximo valor del array
	
	addi	r2, r2, 1	; Sumamos 1 para secuencia tamaño

	;Añadimos el valor máximo	r19 es 1 si r3 > secuencia_maximo	
	;Comprobamos valor
	sgt		r19, r5, r3		; Guarda en R19, si r5 > r3, 1, caso contrario, 0
	beqz	r19, no_mayor	; si es 0 salta, si es 1 no salta (brancj if equal 0)
	add		r3, r0, r5		; Si no salta, r3 guarda el nuevo valor
	no_mayor:
	
	; Si A[n-1] es 1 finaliza
	subi	r21, r5, 1		;Guarda en r21, la resta entre el valor y 1
	beqz	r21, finish		; Si es 0 va a finish

	andi	r20, r5, 1	; ; Si A[n-1] es par	-- en r20 guarda 0 o 1 si es par impar
	beqz	r20, par
	mult	r5, r5, r7	; Si A[n-1] es impar
	addi	r6, r5, 1 
	add		r5, r6, r0	; A[n-1] = A[n]
	
	j	loop



par:
	srli	r5, r6, 1	; A[n] = A[n-1]/2
	add		r6, r5, r0	; A[n-1] = A[n]
	j	loop


finish:
	; Guardamos en memoria los registros relacionados con las variables pedidas que no se van a usar más
	sw		secuencia_tamanho, r2
	sw		secuencia_maximo, r3	


	jal		estadisticasFinales
	sf		lista_valor_medio, f15
	trap	0


estadisticasFinales:
	
	lw		r5, valor_inicial
	addi	r21, r0, 9
	
	; Copia el valor de el registro word a punto flotante
	movi2fp	f16, r21
	movi2fp f3, r4	;	suma_secuencia
	movi2fp	f2, r2	;	secuencia_tamanho vT
	movi2fp	f5, r3	;	secuencia_maximo
	movi2fp	f4, r5	;	valor inicial



	;Es la suma solo
	;Tenemos secuencia_valor_medio
	divf	f1, f3, f2		;vmed
	

	; Pasamos el valor a punto Flotante
	cvti2f	f3, f3
	cvti2f	f2, f2
	cvti2f	f5, f5
	cvti2f	f4, f4
	cvti2f	f16,f16
	
	; vamos sumandole 4 a lista y añadiendole elementos
	add		r20, r0, lista


	sf		secuencia_valor_medio, f1
	
	
	; vIni*vT	0
	multf	f6, f4, f2
	sf		0(r20), f6
	addf	f15, f15, f6
	addi	r20, r20, 4
	; vMax*vT	4
	multf	f7, f5, f2
	sf		0(r20), f7
	addf	f15, f15, f7
	addi	r20, r20, 4
	; vMed*vT	8
	multf	f8, f1, f2
	sf		0(r20), f8
	addf	f15, f15, f8
	addi	r20, r20, 4
	; (vIni/vMax)*vT	12
	divf	f9, f4, f5
	multf	f9, f9, f2
	sf		0(r20), f9
	addf	f15, f15, f9
	addi	r20, r20, 4
	; (vIni/vMed)*vT	16
	divf	f10, f4, f1
	multf	f10, f10, f2
	sf		0(r20), f10
	addf	f15, f15, f10
	addi	r20, r20, 4
	; (vMax/vIni)*vT	20
	divf 	f11, f5, f4
	multf	f11, f11, f2
	sf		0(r20), f11
	addf	f15, f15, f11
	addi	r20, r20, 4
	; (vMax/vMed)*vT	24
	divf	f12, f5, f1
	multf	f12, f12, f2
	sf		0(r20), f12
	addf	f15, f15, f12
	addi	r20, r20, 4
	; (vMed/vIni)*vT	28
	divf	f13, f1, f4
	multf	f13, f13, f2
	sf		0(r20), f13
	addf	f15, f15, f13
	addi	r20, r20, 4
	; (vMed/vMax)*vT	32
	divf	f14, f1, f5
	multf	f14, f14, f2
	sf		0(r20), f14
	addf	f15, f15, f14

	
	divf	f15, f15, f16 
	sf		lista_valor_medio, f15
	


	jalr r31 


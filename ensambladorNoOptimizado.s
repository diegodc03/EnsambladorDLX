;Practica entregable DLX 

;Carlos Conde VIcente
;Diego de Castro Merillas

; 	A[0] = valor_inicial
; 	A[n] = Si A[n-1] 	es par	A[n] = A[n-1] / 2
;						es impar  A[n-1] = 3*A[n-1] + 1
;	Hasta que A[n-1] = 1


;	Declaración de directivas del ordenador
		.data

valor_inicial: .word 97

;; VARIABLES DE SALIDA:
secuencia: 	.space 120*4
secuencia_tamanho: .word 0
secuencia_maximo: .word 0
secuencia_valor_medio: .float 0
lista: .space 9*4
lista_valor_medio: .float 0		
;; FIN VARIABLES DE ENTRADA Y SALIDA


		.text
		.global main

main:
	lw		r2, valor_inicial 	; N
	add		r3, r2, r0 			; A[n] 
	add		r4, r2, r0 			; A[n-1]
	addi	r5, r0, 3 			; 3
	addi	r16, r0, 0 			; valor medio
	add		r17, r0, r2 		; secuencia_maximo


loop:

	; Añadimos estadisticas
	
	;Sumamos el valor medio
	lf		f16, secuencia_valor_medio
	movi2fp	f3, r3
	addf	f16, f16, f3 
	sw		secuencia_tamanho, r6
	sf		secuencia_valor_medio, f16

	;Añadimos al array secuencia un valor nuevo
	;Añadimos a r11 4 para los bytes y la secuencia
	addi	r11, r0, 4
	;multiplicamos para saber justo la direccion
	mult	r10, r6, r11
	;carga registro base en r9
	add		r9, r0, secuencia
	add		r9, r9, r10
	;movemos la direccion
	sw		0(r9), r4
	

	;añadimos secuencia_tamaño
	lw		r6, secuencia_tamanho	
	addi	r6, r6, 1
	sw		secuencia_tamanho, r6

	;Añadimos el valor máximo	r12 es 1 si r3 > secuencia_maximo	
	;Bajamos a Registros el valor en memoria
	lw		r17, secuencia_maximo
	;Comprobamos valor
	sgt		r7, r3, r17
	beqz	r7, no_mayor
	add		r17, r0, r3
	; Añadimos nuevo valor a la variable
	sw		secuencia_maximo, r17
	no_mayor:
	

	subi	r7, r3, 1	; Si A[n-1] es 1 finaliza
	;jal	print
	beqz	r7, finish

	andi	r12, r3, 1	; ; Si A[n-1] es par
	beqz	r12, par
	mult	r4, r3, r5	; Si A[n-1] es impar
	addi	r4, r4, 1 
	add		r3, r4, r0	; A[n-1] = A[n]
	
	j	loop



par:
	srli	r4, r3, 1	; A[n] = A[n-1]/2
	add		r3, r4, r0	; A[n-1] = A[n]
	j	loop


finish:
	jal		estadisticasFinales
	trap	0


estadisticasFinales:
	;Tenemos que rellenar lista_valor_medio y lista con los valores.
	; Luego habrá que mostrarlos
	;vT=secuencia_tamanho, vIni=valor_inicial, vMax=secuencia_maximo y vMed=secuencia_valor_medio
	lw		r6, valor_inicial
	lw		r7, secuencia_tamanho
	lw		r8, secuencia_maximo
	
	movi2fp	f7, r7
	movi2fp	f8, r8
	movi2fp	f6, r6

	;Es la suma solo
	lf		f9, secuencia_valor_medio
	;Tenemos secuencia_valor_medio
	divf	f9, f9, f7

	cvti2f	f7, f7
	cvti2f	f8, f8
	cvti2f	f6, f6
	
	; vamos sumandole 4 a lista y añadiendole elementos
	add		r20, r0, lista

	sf		secuencia_valor_medio, f9
	
	
	; vIni*vT	0
	multf	f12, f6, f7
	sf		0(r20), f12
	addi	r20, r20, 4
	; vMax*vT	4
	multf	f13, f8, f7
	sf		0(r20), f13
	addi	r20, r20, 4
	; vMed*vT	8
	multf	f14, f9, f7
	sf		0(r20), f14
	addi	r20, r20, 4
	; (vIni/vMax)*vT	12
	divf	f15, f6, f8
	multf	f16, f15, f7
	sf		0(r20), f16
	addi	r20, r20, 4
	; (vIni/vMed)*vT	16
	divf	f17, f6, f9
	multf	f18, f17, f7
	sf		0(r20), f18
	addi	r20, r20, 4
	; (vMax/vIni)*vT	20
	divf 	f19, f8, f6
	multf	f20, f19, f7
	sf		0(r20), f20
	addi	r20, r20, 4
	; (vMax/vMed)*vT	24
	divf	f21, f8, f9
	multf	f22, f21, f7
	sf		0(r20), f22
	addi	r20, r20, 4
	; (vMed/vIni)*vT	28
	divf	f16, f9, f6
	multf	f16, f16, f7
	sf		0(r20), f16
	addi	r20, r20, 4
	; (vMed/vMax)*vT	32
	divf	f17, f9, f8
	multf	f17, f17, f7
	sf		0(r20), f17


	jalr r31 








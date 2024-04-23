;Practica entregable DLX 

;Carlos Conde VIcente
;Diego de Castro Merillas


; 	A[0] = valor_inicial
; 	A[n] = Si A[n-1] 	es par	A[n] = A[n-1] / 2
;						es impar  A[n-1] = 3*A[n-1] + 1
;	Hasta que A[n-1] = 1


;	Declaración de directivas del ordenador

.data

PrintFormat:	.asciiz		"%d\n"
		.align		2
PrintPar:	.word		PrintFormat

	

valor_inicial: .word 97

;; VARIABLES DE SALIDA:
secuencia: .space 120*4
secuencia_tamanho: .word 0
secuencia_maximo: .word 0
secuencia_valor_medio: .float 0
lista: .space 9*4
lista_valor_medio: .float 0

;; FIN VARIABLES DE ENTRADA Y SALIDA


		.text
		.global main

main:
	addi	r2, r0, valor_inicial
	add	r3, r2, r0
	add	r4, r2, r0
	addi	r5, r0, 3



loop:

	; Añadimos estadisticas
	
	;añadimos secuencia_tamaño
	add		r6, r0, secuencia_tamanho
	addi	r6, r6, 1
	add		secuencia_tamanho, r0, r6


	;Añadimos al array secuencia un valor nuevo

	;Añadimos a r8 el valor que queremos añadir
	addi	r8, r0, r3
	;Añadimos a r11 4 para los bytes y la secuencia
	addi	r11, r0, 4
	;carga registro base en r9
	la		r9, secuencia
	;multiplicamos para saber justo la direccion
	mult	r10, secuencia_tamanho, r11
	;movemos la direccion
	add		r9, r9, r10
	sw		r8, 0(r9)  
	


	;Añadimos el valor máximo	r12 es 1 si r3 > secuencia_maximo
	sgt		r12, r3, secuencia_maximo
	beqz	no_mayor
	addi	secuencia_maximo, r0, r3
	no_mayor:
	

	;Añadimos el valor mínimo
	slt		r12, r3, secuencia_minimo
	beqz	no_menor
	addi	secuencia_minimo, r0, r3
	no_menor:



	subi	r6, r3, 1	; Si A[n-1] es 1 finaliza
	jal	print
	beqz	r6, finish

	andi	r7, r3, 1	; ; Si A[n-1] es par
	beqz	r7, par
	mult	r4, r3, r5	; Si A[n-1] es impar
	addi	r4, r4, 1 
	add		r3, r4, r0	; A[n-1] = A[n]
	
	
	j	loop



par:
	srli	r4, r3, 1	; A[n] = A[n-1]/2
	add	r3, r4, r0	; A[n-1] = A[n]
	j	loop



print:
	sw	PrintValue, r4
	addi	r14, r0, PrintPar
	trap	5
	jr	r31


finish:

	trap	0

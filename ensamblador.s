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
PrintValue:	.space		4

valor_inicial: .word 10

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
	lw	r2, valor_inicial ; N
	add		r3, r2, r0 ; A[n] 
	add		r4, r2, r0 ; A[n-1]
	addi	r5, r0, 3 ; 3
	addi	r16, r0, 0 ; valor medio
	add		r17, r0, r2 ; secuencia_maximo



loop:

	; Añadimos estadisticas
	
	
	;Sumamos el valor medio
	lw		r16, secuencia_valor_medio
	add		r16, r16, r3 
	sw		secuencia_tamanho, r6
	sw		secuencia_valor_medio, r16

	
	;Añadimos al array secuencia un valor nuevo

	;Añadimos a r8 el valor que queremos añadir
	add		r8, r4, r0
	;Añadimos a r11 4 para los bytes y la secuencia
	addi	r11, r0, 4
	;multiplicamos para saber justo la direccion
	mult	r10, r6, r11
	;carga registro base en r9
	add		r9, r0, secuencia
	
	add		r9, r9, r10
	;movemos la direccion
	sw		0(r9), r8   
	
	
	
	;añadimos secuencia_tamaño
	lw		r6, secuencia_tamanho	
	addi	r6, r6, 1

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
	jal	print
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



; Para que se escriban los valores que se van calculando
print:
	sw	PrintValue, r4
	addi	r14, r0, PrintPar
	trap	5
	jr	r31


; comprobacion de los valores del array lista
print1:
	add	r20, r0, lista
	addi	r20, r20, 12
	lw		r21, 0(r20)
	sw	PrintValue, r21
	addi	r14, r0, PrintPar
	trap	5
	jr	r31


; Esto sirve para la comprobacion de los valores del array secuencia
print2:
	add	r20, r0, secuencia
	;addi	r20, r20,4
	lw		r21, 0(r20)
	sw		PrintValue, r21
	addi	r14, r0, PrintPar
	trap	5
	jr	r31



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
	;Es la suma solo
	lw		r9, secuencia_valor_medio
	;Tenemos secuencia_valor_medio
	div		r9, r9, r7


	; vamos sumandole 4 a lista y añadiendole elementos
	add		r20, r0, lista
	
	
	; vIni*vT
	mult	r10, r6, r7
	sw		0(r20), r10
	addi	r20, r20, 4
	; vMax*vT
	mult	r11, r8, r7
	sw		0(r20), r11
	addi	r20, r20, 4
	; vMed*vT
	mult	r12, r9, r7
	sw		0(r20), r12
	addi	r20, r20, 4
	; (vIni/vMax)*vT
	div		r13, r6, r8
	mult	r13, r13, r7
	sw		0(r20), r13
	addi	r20, r20, 4
	; (vIni/vMed)*vT
	div		r14, r6, r9
	mult	r14, r14, r7
	sw		0(r20), r14
	addi	r20, r20, 4
	; (vMax/vIni)*vT
	div 	r14, r8, r6
	mult	r14, r14, r7
	sw		0(r20), r15
	addi	r20, r20, 4
	; (vMax/vMed)*vT
	div		r15, r8, r9
	mult	r15, r15, r7
	sw		0(r20), r16
	addi	r20, r20, 4
	; (vMed/vIni)*vT
	div		r16, r9, r6
	mult	r16, r16, r7
	sw		0(r20), r17
	addi	r20, r20, 4
	; (vMed/vMax)*vT
	div		r17, r9, r8
	mult	r17, r17, r7
	sw		0(r20), r18
	addi	r20, r20, 4


	;Ahora tenemos todos los registros añadidos con las variables, tenemos que introducir
	;jal print1

	jalr r31 

	

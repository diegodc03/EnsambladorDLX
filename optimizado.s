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

valor_inicial: .word 97

;; VARIABLES DE SALIDA:
secuencia: .space 120*4
secuencia_tamanho: .word 0
secuencia_maximo: .word 0
secuencia_valor_medio: .float 0.0
lista: .space 9*4
lista_valor_medio: .float 0.0
;; FIN VARIABLES DE ENTRADA Y SALIDA


		.text
		.global main

main:

	lw		r5, valor_inicial 	; N
	
	addi	r2, r0, 1
	add		r3, r0, r5 ;		 secuencia_maximo
	andi	r20, r5, 1      ; r7 = A[n-1] AND 1 (comprueba paridad)
	addi r9, r0, secuencia ; Cargar la dirección base de secuencia en r10


	sw   0(r9), r5                   ; Almacenar el nuevo elemento en la secuencia
	addi  r9, r9, 4                  ; Calcular la dirección del nuevo elemento
	beqz	r20, par        ; Salta a 'par' si A[n-1] es par	

	
	
impar:	
	
	add	r4, r4, r5
	
	
	; Si A[n-1] es impar
	addi	r6, r5, 1      
	sll 	r5, r5, 1
	add 	r5, r5, r6	 ; A[n] = A[n-1] + 1
	sgt  r19, r5, r3                  ; Comparar r3 con secuencia_maximo

	sw   0(r9), r5                   ; Almacenar el nuevo elemento en la secuencia
	addi  r9, r9, 4                  ; Calcular la dirección del nuevo elemento

	beqz r19, par                 ; Saltar si r3 no es mayor que secuencia_maximo
    add  r3, r0, r5                  ; Actualizar secuencia_maximo con r3


par_mayor:

	add	r4, r4, r5
	addi r2, r2, 1                    ; Incrementar secuencia_tamanho

	; Si A[n-1] es par
	srli	r5, r5, 1      ; r4 = A[n-1] >> 1 (divide A[n-1] entre 2)
	
	andi	r20, r5, 1      ; r7 = A[n-1] AND 1 (comprueba paridad)
	sw   0(r9), r5                   ; Almacenar el nuevo elemento en la secuencia
	addi  r9, r9, 4                  ; Calcular la dirección del nuevo elemento
	
	beqz	r20, par        ; Salta a 'par' si A[n-1] es par	
	addi r2, r2, 1

	j	impar              ; Salta de vuelta al inicio del bucle


par:

	add	r4, r4, r5
	

	; Si A[n-1] es par
	srli	r5, r5, 1      ; r4 = A[n-1] >> 1 (divide A[n-1] entre 2)
	
	andi	r20, r5, 1      ; r7 = A[n-1] AND 1 (comprueba paridad)
	sw   0(r9), r5                   ; Almacenar el nuevo elemento en la secuencia
	addi  r9, r9, 4                  ; Calcular la dirección del nuevo elemento
	addi r2, r2, 1                    ; Incrementar secuencia_tamanho
	beqz	r20, par        ; Salta a 'par' si A[n-1] es par	

	snei 	r21, r5, 1      ; 1 o no 1 	
	addi r2, r2, 1                    ; Incrementar secuencia_tamanho
	beqz	r21, finish     ; Salta a 'finish' si A[n-1] es 1 (finaliza)

	j	impar              ; Salta de vuelta al inicio del bucle


finish:
	; Finaliza el programa
	
	add	r4, r4, r5
	


estadisticasFinales:
	; Cargamos los valores de entrada desde la memoria

	lf 		f4, valor_inicial		 ; Cargamos el valor inicial de la secuencia en f2

	movi2fp	f2, r2                    ; Convertimos el tamaño de la secuencia a punto flotante
	movi2fp	f3, r4                    ; Convertimos el máximo de la secuencia a punto flotante

	cvti2f	f2, f2
	cvti2f	f3, f3
	cvti2f	f4, f4
	
	divf	f1, f3, f2                 ; Dividimos el valor medio de la secuencia por el tamaño de la secuencia y lo almacenamos en f1
	
	
	multf 	f6, f4, f2 ; vIni*vT

	
	movi2fp	f5, r3                    ; Convertimos el máximo de la secuencia a punto flotante
	cvti2f	f5, f5
	addi 	r21, r0, 9                
	movi2fp	f16, r21                   
	cvti2f	f16, f16

	divf 	f9,  f6, f5 ; vIni*vT/vMax
	sf		lista, f6 ; Guardamos vIni*vT en la lista
	addf 	f15, f15, f6 ; Sumamos el valor a la suma total
	
	multf 	f7, f5, f2 ; vMax*vT
	sw		secuencia_tamanho, r2     ; Cargamos el tamaño de la secuencia desde la memoria a r6
	sw 		secuencia_maximo, r3      ; Cargamos el máximo de la secuencia desde la memoria a r3
	
	multf 	f8, f1, f2 ; vMed*vT
	sf		lista+0x4, f7 ; Guardamos vMax*vT en la lista
	
	addf 	f15, f15, f7 ; Sumamos el valor a la suma total
	divf  	f10, f6, f1 ; (vIni/vMed)*vT 
	
	
	sf		lista+0x8, f8 ; Guardamos vMed*vT en la lista
	addf 	f15, f15, f8 ; Sumamos el valor a la suma total
	
	sf		lista+0xc, f9 ; Guardamos (vi/vMax)*vT en la lista
	addf 	f15, f15, f9 ; Sumamos el valor a la suma total
	
	divf  	f11, f7, f4 ; (vMax/vIni)*vT

	sf 		lista+0x10, f10 ; Guardamos (vi/vMed)*vT en la lista
	addf 	f15, f15, f10 ; Sumamos el valor a la suma total
	
	divf  	f12, f7, f1 ; (vMax/vMed)*vT 

	sf 		lista+0x14, f11 ; Guardamos (vMax/vIni)*vT en la lista
	addf 	f15, f15, f11 				; Sumamos el valor a la suma total
	
	divf  	f13, f8, f4 				; (vMed/vIni)*vT
	
	sf 		lista+0x18, f12 			; Guardamos (vMax/vMed)*vT en la lista
	addf 	f15, f15, f12 				; Sumamos el valor a la suma total
	

	divf  	f14, f8, f5 				; (vMed/vMax)*vT 

	sf 		lista+0x1c, f13 			; Guardamos (vMed/vIni)*vT en la lista
	addf 	f15, f15, f13 				; Sumamos el valor a la suma total
	
	sf 		lista+0x20, f14 			; Guardamos (vMed/vMax)*vT en la lista
	addf 	f15, f15, f14 				; Sumamos el valor a la suma total
	

	sf 		secuencia_valor_medio, f1	; Cargamos el valor medio de la secuencia desde la memoria a f1

	divf	f17, f15, f16 ; Dividimos el valor medio de la secuencia por el tamaño de la secuencia y lo almacenamos en f1
	sf		lista_valor_medio, f15 ; Guardamos el valor medio de la secuencia en la lista

	

	trap 0
	

	; Finalizamos el programa
	;jalr	r31




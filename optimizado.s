;Practica entregable DLX 


;Carlos Conde VIcente		70919412Q
;Diego de Castro Merillas	71043687E

;++++++++++++++
;+ OPTIMIZADO +
;++++++++++++++


; 	A[0] = valor_inicial

; es par	A[n] = A[n-1] / 2
; es impar  A[n-1] = 3*A[n-1] + 1
;Hasta que A[n-1] = 1


;	Declaración de directivas del ordenador

.data

;; VARIABLES DE ENTRADA Y SALIDA: NO MODIFICAR ORDEN
; VARIABLE DE ENTRADA: (SE PODRA MODIFICAR EL VALOR ENTRE 1 Y 100)
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

	lw		r5, valor_inicial 	; Cargamos el valor inicial de la secuencia en r5
	
	addi 	r21, r0, 9 ; r21 = 9           
	
	add		r3, r0, r5 ; secuencia_maximo
	addi 	r22, r0, 1
	subi 	r23, r5, 2 ; r20 = A[n] - 2 
	add		r6, r5, r0 ; r6 = A[n-1]

	sw   secuencia(r9), r5; Almacenar el nuevo elemento en la secuencia
	addi  r9, r9, 4 ; Calcular la dirección del nuevo elemento

	
	
	andi	r20, r5, 1 ; r20 = A[n] AND 1 (comprueba paridad)
	    
	movi2fp	f16, r21  ; 9
	movi2fp	f17, r22 ; 1
	cvti2f	f16, f16; 9
	cvti2f	f17, f17 ; 1


	
	
	divf	f16, f17, f16 ; 1/9
	
	beqz	r23, par ; Salta a 'par' si A[n-1] es par
	beqz	r20, par_mayor ; Salta a 'par' si A[n-1] es par	
	
	sll 	r5, r5, 1 ; A[n] = A[n-1] * 2
	
impar:	


	; A[n] = 3*A[n-1] + 1

	add	r4, r4, r6 ; r4 = r4 + r6	      
	add 	r5, r5, r6	; A[n] = A[n-1] + A[n-2]
	addi	r5, r5, 1 ; A[n] = A[n] + 1
	sgt  r19, r5, r3 ; Comparar r3 con secuencia_maximo

	sw   secuencia(r9), r5 ; Almacenar el nuevo elemento en la secuencia
	addi  r9, r9, 4  ; Calcular la dirección del nuevo elemento

	beqz r19, par_mayor ; Saltar si r3 no es mayor que secuencia_maximo
    add  r3, r0, r5 ; Actualizar secuencia_maximo con r3


par_mayor:

	; A[n] = A[n-1] / 2

	add	r4, r4, r5 ; r4 = r4 + r5
	
	srli	r6, r5, 1 ; r6 = A[n-1] >> 1 (divide A[n-1] entre 2)
	
	andi	r20, r6, 1 ; r20 = A[n-1] AND 1 (comprueba paridad)
	sw   secuencia(r9), r6 ; Almacenar el nuevo elemento en la secuencia
	addi  r9, r9, 4 ; Calcular la dirección del nuevo elemento
	
	bnez	r20, impar ; Salta a 'par' si A[n] es impar	
	
par:

	; A[n] = A[n-1] / 2

	add	r4, r4, r6 ; r4 = r4 + r6
	srli	r6, r6, 1 ; r6 = A[n-1] >> 1 (divide A[n-1] entre 2)
	
	andi	r20, r6, 1 ; r20 = A[n-1] AND 1 (comprueba paridad
	sw   secuencia(r9), r6 ; Almacenar el nuevo elemento en la secuencia
	addi  r9, r9, 4 ; Calcular la dirección del nuevo elemento
	
	beqz	r20, par ; Salta a 'par' si A[n-1] es par	


impar_menor:	

	; A[n] = 3*A[n-1] + 1

	subi 	r21, r6, 1 ; r21 = A[n-1] - 1
	add	r4, r4, r6 ; r4 = r4 + r6
	beqz	r21, finish ; Salta a 'finish' si A[n-1] es 1
	   
	sll 	r5, r6, 2 ; A[n] = A[n-1] * 4
	sub 	r5, r5, r21	 ; A[n] = A[n] - A[n-1] -1 

	sw   secuencia(r9), r5 ; Almacenar el nuevo elemento en la secuencia
	addi  r9, r9, 4 ; Calcular la dirección del nuevo elemento

	j	par_mayor ; Salta de vuelta al inicio del bucle



finish:

	srli 	r2, r9, 2 ; r2 = r9 / 4 (tamaño de la secuencia)
	


estadisticasFinales:
	; Cargamos los valores de entrada desde la memoria

	lf 		f4, valor_inicial ; Cargamos el valor inicial de la secuencia en f4

	movi2fp	f2, r2 ; Convertimos el tamaño de la secuencia a punto flotante
	movi2fp	f3, r4 ; Convertimos el máximo de la secuencia a punto flotante

	cvti2f	f2, f2 ; Convertimos el tamaño de la secuencia a punto flotante
	cvti2f	f3, f3 ; Convertimos el máximo de la secuencia a punto flotante
	cvti2f	f4, f4; Convertimos el valor inicial de la secuencia a punto flotante
	
	divf	f1, f3, f2 ; Dividimos el valor medio de la secuencia por el tamaño de la secuencia y lo almacenamos en f1
	multf 	f6, f4, f2 ; vIni*vT

	movi2fp	f5, r3 ; Convertimos el máximo de la secuencia a punto flotante
	cvti2f	f5, f5 ; Convertimos el máximo de la secuencia a punto flotante

	sw		secuencia_tamanho, r2 ; Guardamos el tamaño de la secuencia en la memoria
	sw 		secuencia_maximo, r3 ; Guardamos el máximo de la secuencia en la memoria

	multf 	f7, f5, f2 ; vMax*vT       
	               
	
	; f3 = vmed *v t
	cvti2f	f15, f15 ; Convertimos la suma total a punto flotante
	sf		lista, f6 ; Guardamos vIni*vT en la lista
	addf 	f15, f15, f6 ; Sumamos el valor a la suma total

	sf		lista+0x4, f7 ; Guardamos vMax*vT en la lista
	addf 	f15, f15, f7 ; Sumamos el valor a la suma total

	divf  	f18, f17, f5 ; 1/vMax

	divf  	f19, f17, f4 ; 1/vIni

	multf 	f9, f18, f6 ; (1/vMax)*vIni*vT
	sf		lista+0x8, f3 ; Guardamos vMed*vT en la lista
	addf 	f15, f15, f3 ; Sumamos el valor a la suma total	
	sf 		secuencia_valor_medio, f1	; Cargamos el valor medio de la secuencia desde la memoria a f1
	
	multf 	f14, f18, f3 ; (1/vMax)*vMed*vT
	sf		lista+0xc, f9 ; Guardamos (vi/vMax)*vT en la lista
	addf 	f15, f15, f9 ; Sumamos el valor a la suma total
    

	divf  	f20, f17, f1 ; 1/vMed
	
	

	multf  	f11, f19, f7 ; (1/vIni)*vMax*vT
	sf 		lista+0x20, f14 ; Guardamos (vMed/vMax)*vT en la lista
	addf 	f15, f15, f14 ; Sumamos el valor a la suma total

	multf  	f13, f19, f3 ; (1/vIni)*vMed*vT
	sf 		lista+0x14, f11 ; Guardamos (vMax/vIni)*vT en la lista
	addf 	f15, f15, f11 ; Sumamos el valor a la suma total

	sf 		lista+0x1c, f13 ; Guardamos (vMed/vIni)*vT en la lista
	addf 	f15, f15, f13 ; Sumamos el valor a la suma total

	multf  	f10, f20, f6 ; (1/vMed)*vIni*vT
	
	
	multf  	f12, f20, f7 ; (1/vMed)*vMax*vT
	addf 	f15, f15, f10 ; Sumamos el valor a la suma total
	sf 		lista+0x10, f10 ; Guardamos (vi/vMed)*vT en la lista
	addf 	f15, f15, f12 ; Sumamos el valor a la suma total
	sf 		lista+0x18, f12 ; Guardamos (vMax/vMed)*vT en la lista
	
	
	multf	f22, f15, f16 ; Dividimos el valor medio de la secuencia por el tamaño de la secuencia y lo almacenamos en f1
	
		
	sf		lista_valor_medio, f22 ; Guardamos el valor medio de la secuencia en la lista


	trap 0
	



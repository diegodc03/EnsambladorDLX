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

valor_inicial: .word 7

;; VARIABLES DE SALIDA:
secuencia: .space 120*4
secuencia_tamanho: .word 0
secuencia_maximo: .word 0
secuencia_valor_medio: .word 0
lista: .space 9*4
lista_valor_medio: .float 0.0
;; FIN VARIABLES DE ENTRADA Y SALIDA


		.text
		.global main

main:
	lw	r2, valor_inicial ; N
	addi	r5, r0, 3 ; 3
	
	add		r3, r2, r0 ; A[n] 
	add		r4, r2, r0 ; A[n-1]
	
	addi	r16, r0, 0 ; valor medio
	add		r17, r0, r2 ; secuencia_maximo



loop:
    ; Cargar secuencia_tamanho y secuencia_valor_medio
    lw   r6, secuencia_tamanho       ; Cargar secuencia_tamanho en r6
    lw   r16, secuencia_valor_medio   ; Cargar secuencia_valor_medio en r16
    addi r11, r0, 4                  ; Cargar 4 en el registro r11
    
    ; Incrementar secuencia_tamanho
    addi r6, r6, 1                    ; Incrementar secuencia_tamanho
    sw   secuencia_tamanho, r6        ; Guardar el nuevo valor de secuencia_tamanho
    
    ; Calcular la dirección para el nuevo elemento de secuencia  y Actualizar secuencia_valor_medio
   
    mult r10, r6, r11                   ; Multiplicar secuencia_tamanho por 4 (tamaño de elemento)
    addi r9, r0, secuencia            ; Cargar la dirección base de secuencia en r9
    add  r16, r16, r3                 ; Sumar el valor actual a secuencia_valor_medio
    add  r8, r3, r0                   ; Cargar el valor a añadir en r8
   
    sw   secuencia_valor_medio, r16   ; Guardar el nuevo valor de secuencia_valor_medio
    lw   r17, secuencia_maximo        ; Cargar secuencia_maximo en r17
    add  r9, r9, r10                  ; Calcular la dirección del nuevo elemento
    
    ; Guardar el nuevo elemento en secuencia
  
    ; Comparar y actualizar secuencia_maximo si es necesario
    
    sgt  r6, r3, r17                  ; Comparar r3 con secuencia_maximo
    sw   0(r9), r8                    ; Almacenar el nuevo elemento en la secuencia
    beqz r6, no_mayor                 ; Saltar si r3 no es mayor que secuencia_maximo
    
    add  r17, r0, r3                  ; Actualizar secuencia_maximo con r3
    sw   secuencia_maximo, r17        ; Guardar el nuevo valor de secuencia_maximo
    
no_mayor:

	; Comprueba si A[n-1] es 1 para finalizar
	subi	r6, r3, 1      ; r6 = A[n-1] - 1
	jal	print          ; Llama a la función print para mostrar el valor
	andi	r7, r3, 1      ; r7 = A[n-1] AND 1 (comprueba paridad)
	beqz	r6, finish     ; Salta a 'finish' si A[n-1] es 1 (finaliza)
	beqz	r7, par        ; Salta a 'par' si A[n-1] es par
	
	; Si A[n-1] es impar
	mult	r4, r3, r5     ; r4 = A[n-1] * 3
	;addi	r4, r4, 1      ; No se usa este resultado
	addi	r3, r4, 1      ; A[n-1] = A[n] + 1
	
	j	loop              ; Salta de vuelta al inicio del bucle

par:
	; Si A[n-1] es par
	srli	r4, r3, 1      ; r4 = A[n-1] >> 1 (divide A[n-1] entre 2)
	add		r3, r4, r0     ; A[n-1] = A[n]
	j	loop              ; Salta de vuelta al inicio del bucle

print:
	; Imprime el valor en r4
	sw	PrintValue, r4   ; Almacena el valor a imprimir
	addi	r14, r0, PrintPar  ; Carga la dirección de la cadena de formato
	trap	5               ; Llama al servicio para imprimir el valor
	jr	r31              ; Vuelve de la llamada

finish:
	; Finaliza el programa
	trap	0               ; Llama al servicio de finalización del programa





	

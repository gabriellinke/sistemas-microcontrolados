; funcoes.s
; Gabriel Henrique Linke - 2126630
; Pedro Henrique Fracaro Kiche - 1661523


; -------------------------------------------------------------------------------
        THUMB                        ; Instruções do tipo Thumb-2
; -------------------------------------------------------------------------------
; Declarações EQU - Defines
;<NOME>         EQU <VALOR>
lista EQU 0x20000200
primos EQU 0x20000300
; -------------------------------------------------------------------------------
; Área de Dados - Declarações de variáveis
		AREA  DATA, ALIGN=2
; -------------------------------------------------------------------------------
; Área de Código - Tudo abaixo da diretiva a seguir será armazenado na memória de 
; código
        AREA    |.text|, CODE, READONLY, ALIGN=2

		; Se alguma função do arquivo for chamada em outro arquivo	
        EXPORT Carrega_lista 
		EXPORT Encontra_e_salva_primos			
		EXPORT Bubble_sort
									
		; Se chamar alguma função externa	
        ;IMPORT <func>              ; Permite chamar dentro deste arquivo uma 
									; função <func>

; -------------------------------------------------------------------------------
; Função para carregar a lista()
Carrega_lista

	LDR R0, =lista
	
	MOV R1, #50
	STRB R1, [R0], #2
	
	MOV R1, #65
	STRB R1, [R0], #2
	
	MOV R1, #229
	STRB R1, [R0], #2

	MOV R1, #201
	STRB R1, [R0], #2

	MOV R1, #101
	STRB R1, [R0], #2
	
	MOV R1, #43
	STRB R1, [R0], #2

	MOV R1, #27
	STRB R1, [R0], #2
	
	MOV R1, #2
	STRB R1, [R0], #2	
	
	MOV R1, #5
	STRB R1, [R0], #2	
	
	MOV R1, #210
	STRB R1, [R0], #2	
	
	MOV R1, #101
	STRB R1, [R0], #2	
	
	MOV R1, #239
	STRB R1, [R0], #2	
	
	MOV R1, #73
	STRB R1, [R0], #2	
	
	MOV R1, #29
	STRB R1, [R0], #2
		
	MOV R1, #207
	STRB R1, [R0], #2	
	
	MOV R1, #135
	STRB R1, [R0], #2	
	
	MOV R1, #33
	STRB R1, [R0], #2
	
	MOV R1, #227
	STRB R1, [R0], #2
	
	MOV R1, #13
	STRB R1, [R0], #2	
	
	MOV R1, #9
	STRB R1, [R0], #2
	
	BX LR


; -------------------------------------------------------------------------------
; Função para encontrar e salvar primos()
Encontra_e_salva_primos

	LDR R0, =lista                          
	LDR R12, =primos
	MOV R11, #0
	
	; Carrega número da RAM
	; Faz um loop
		; Verifica se é divisível por R
		; Se for, não é primo, inicia de novo
		; Se não for, adiciona 1 em R até que R seja igual a número
carrega_prox_numero
	LDRB R1, [R0], #2
	
	; Verifica se a lista acabou (próximo número é 0 ou se chegou na parte da memória em que são salvos os primos)
	CMP R1, #0
	BEQ return
	LDR R5, =0x20000302 
	CMP R0, R5
	BEQ return
	
	MOV R2, #2

verifica_primo
	CMP R1, R2
	BEQ salva_primo

	UDIV R3, R1, R2
	MLS R4, R2, R3, R1
	CMP R4, #0
	BEQ carrega_prox_numero
	
	ADD R2, #1
	B verifica_primo
		
salva_primo
	ADD R11, #1
	STRB R1, [R12], #2
	B carrega_prox_numero

return
	BX LR
	
; -------------------------------------------------------------------------------
; Bubble Sort()	
Bubble_sort
	LDR R12, =primos
	;R11 -> tamanho da lista
	MOV R10, #1

proximo_numero
	LDRB R0, [R12], #2
	LDRB R1, [R12]

	; Verifica se é necessário trocar os números de posição
	CMP R1, R0
	PUSH {LR}
	BLLO swap
	POP {LR}
	
	; Verifica se já terminou essa iteração ou se vai para o próximo número
	ADD R10, #1
	CMP R10, R11
	BNE proximo_numero
	
	; Verifica se o algoritmo já terminou ou se precisa continuar
	SUB R11, #1
	CMP R11, #1
	BXEQ LR 
	
	; Arruma os parâmetros para iniciar uma nova iteração
	MOV R10, #1
	LDR R12, =primos
	B proximo_numero		
	
swap
	STRBLO R1, [R12, #-2]
	STRBLO R0, [R12]
	BX LR
	
	NOP

    ALIGN                           ; garante que o fim da seção está alinhada 
    END                             ; fim do arquivo

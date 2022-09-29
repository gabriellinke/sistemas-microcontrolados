; main.s
; Desenvolvido para a placa EK-TM4C1294XL
; Prof. Guilherme Peron
; 24/08/2020
; Este programa espera o usu�rio apertar a chave USR_SW1.
; Caso o usu�rio pressione a chave, o LED1 piscar� a cada 0,5 segundo.

; -------------------------------------------------------------------------------
        THUMB                        ; Instru��es do tipo Thumb-2
; -------------------------------------------------------------------------------
		
; Declara��es EQU - Defines
;<NOME>         EQU <VALOR>
; ========================

; -------------------------------------------------------------------------------
; �rea de Dados - Declara��es de vari�veis
		AREA  DATA, ALIGN=2
		; Se alguma vari�vel for chamada em outro arquivo
		;EXPORT  <var> [DATA,SIZE=<tam>]   ; Permite chamar a vari�vel <var> a 
		                                   ; partir de outro arquivo
;<var>	SPACE <tam>                        ; Declara uma vari�vel de nome <var>
                                           ; de <tam> bytes a partir da primeira 
                                           ; posi��o da RAM		

; -------------------------------------------------------------------------------
; �rea de C�digo - Tudo abaixo da diretiva a seguir ser� armazenado na mem�ria de 
;                  c�digo
        AREA    |.text|, CODE, READONLY, ALIGN=2

		; Se alguma fun��o do arquivo for chamada em outro arquivo	
        EXPORT Start                ; Permite chamar a fun��o Start a partir de 
			                        ; outro arquivo. No caso startup.s
									
		; Se chamar alguma fun��o externa	
        ;IMPORT <func>              ; Permite chamar dentro deste arquivo uma 
									; fun��o <func>
		IMPORT  PLL_Init
		IMPORT  SysTick_Init
		IMPORT  SysTick_Wait1ms			
		IMPORT  GPIO_Init
        IMPORT  PortJ_Input	
		IMPORT  Liga_LED
		IMPORT Ligar_Display


; -------------------------------------------------------------------------------
; Fun��o main()
Start  		
	BL PLL_Init                  ;Chama a subrotina para alterar o clock do microcontrolador para 80MHz
	BL SysTick_Init
	BL GPIO_Init                 ;Chama a subrotina que inicializa os GPIO

MainLoop
	MOV R12, #1
	MOV R11, #1
	MOV R10, #0
	MOV R6, #50
	MOV R9, #1
	
Atualiza_Display
; inteiro d1, resto d2
	MOV R0, #10
	UDIV R8, R10, R0
	MLS R8, R8, R0, R10
	MOV R7, #0
	BL Ligar_Display
	
	MOV R0, #10
	UDIV R8, R10, R0
	MOV R7, #1
	BL Ligar_Display
	
Atualiza_LEDS
	BL Liga_LED

;R8 == 2? R12++
;R8 == 1? R11*-1
Atualiza_Input_Chaves
	BL PortJ_Input				 ;Chama a subrotina que l� o estado das chaves e coloca o resultado em R0
Compara_1	
	CMP R8, #1
	BNE Compara_2
	
	MOV R0, #500
	PUSH { LR }
	BL SysTick_Wait1ms
	POP { LR }
	
	MOV R0, #-1
	MUL R11, R0
Compara_2
	CMP R8, #2
	BNE Contador
	
	MOV R0, #500
	PUSH { LR }
	BL SysTick_Wait1ms
	POP { LR }
	
	ADD R12, #1
	CMP R12, #10
	BNE Contador
	MOV R12, #1
	
	
Contador	
	SUB R6, #1
	CMP R6, #0
	BNE pula
	MOV R6, #50
	MUL R0, R12, R11
	ADD R10, R0
	
	;(100+x+y)%100
	ADD R10, #100
	MOV R0, #100
	UDIV R1, R10, R0
	MLS R10, R0, R1, R10
	
	ADD R9, #1
	CMP R9, #9
	BNE pula
	MOV R9, #1

pula 

	B Atualiza_Display

	B MainLoop

; -------------------------------------------------------------------------------------------------------------------------
; Fim do Arquivo
; -------------------------------------------------------------------------------------------------------------------------	
    ALIGN                        ;Garante que o fim da se��o est� alinhada 
    END                          ;Fim do arquivo

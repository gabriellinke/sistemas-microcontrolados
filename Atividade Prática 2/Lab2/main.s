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
senha_cofre SPACE 5
senha_tentativa SPACE 5		
										
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
		IMPORT  GPIO_Init
		IMPORT  LCD_Init
		IMPORT	Ler_porta_L
		IMPORT	Ler_coluna
		IMPORT	Escrever_string_LCD
		IMPORT 	Reset_LCD
		IMPORT 	SysTick_Wait1ms	
		
		IMPORT Escrever_cofre_travado
		IMPORT Escrever_cofre_fechado
		IMPORT Escrever_cofre_aberto
		IMPORT Escrever_cofre_abrindo
		IMPORT Escrever_cofre_fechando
		IMPORT Escrever_caractere_senha
; -------------------------------------------------------------------------------
; Fun��o main()
Start  		
	BL PLL_Init                  ;Chama a subrotina para alterar o clock do microcontrolador para 80MHz
	BL SysTick_Init
	BL GPIO_Init                 ;Chama a subrotina que inicializa os GPIO
	BL LCD_Init
	
	;R9 = Estado cofre: 0 -> Aberto, aguardando senha
	;					1 -> Fechado, aguardando senha
	;					2 -> Abrindo
	;					3 -> Fechando
	;					4 -> Travado
	MOV R9, #0 
	MOV R8, #0
	MOV R10, #0
	MOV R11, #0
MainLoop
	CMP R9, #1 ; (R9>1) ? Estado_abrindo_ou_fechando_ou_travado : Estado_aberto_ou_fechado
	BGT Estado_abrindo_ou_fechando_ou_travado
Estado_aberto_ou_fechado
	PUSH { LR }
	BL Atualizar_teclado
	POP { LR }
	B MainLoop
Estado_abrindo_ou_fechando_ou_travado
	CMP R9, #2
	BEQ Abrindo
	CMP R9, #3
	BEQ Fechando
	CMP R9, #4
	BEQ Travado
	B MainLoop ;else

; -------------------------------------------------------------------------------
; Fun��o utilizada pelas outras fun��es quando � necess�rio dar return
return 
	BX LR

Fechando
	MOV R0, #1000
	PUSH { LR }
	BL SysTick_Wait1ms
	POP { LR }

	PUSH { LR }
	BL Escrever_cofre_fechando
	POP { LR }
	
	MOV R0, #5000
	PUSH { LR }
	BL SysTick_Wait1ms
	POP { LR }
	
	MOV R9, #1 ;Vai para estado de fechado
	PUSH { LR }
	BL Escrever_cofre_fechado
	POP { LR }
	B MainLoop
	
Abrindo
	PUSH { LR }
	BL Escrever_cofre_abrindo
	POP { LR }
	
	MOV R0, #5000
	PUSH { LR }
	BL SysTick_Wait1ms
	POP { LR }
	
	MOV R9, #0 ;Vai para estado de aberto
	PUSH { LR }
	BL Escrever_cofre_aberto
	POP { LR }
	B MainLoop
	
Travado
	MOV R0, #500
	PUSH { LR }
	BL SysTick_Wait1ms
	POP { LR }
	PUSH { LR }
	BL Escrever_cofre_travado
	POP { LR }
	
	; To-do: piscar LEDs
	
	B MainLoop

; -------------------------------------------------------------------------------
; Fun��o Atualizar_teclado - Faz a leitura do teclado e atualiza o LCD
; Par�metro de entrada: N�o tem
; Par�metro de sa�da: N�o tem
; Modifica R0, R1, R2, R11 e R12
Atualizar_teclado
	PUSH { LR }
	BL Verifica_tecla_pressionada_atualiza_LCD
	BL Leitura_teclado
	POP { LR }
	BX LR
	
; -------------------------------------------------------------------------------
; Fun��o Leitura_teclado - Faz a leitura do teclado
; Par�metro de entrada: N�o tem
; Par�metro de sa�da: R11 -> tecla que est� pressionada
Leitura_teclado
	; Bounce do teclado
	MOV R0, #300
	PUSH { LR }
	BL SysTick_Wait1ms
	POP { LR }
	;R12 -> coluna que est� sendo lida
	MOV R12, #4
Verificar_teclado
	MOV R0, R12
	PUSH { LR }
	BL Ler_coluna
	BL Ler_porta_L
	POP { LR }
	CMP R2, #0xF
	BEQ depois
tecla_pressionada
	LSL R11, R12, #4
	ORR R11, R2
	B depois
depois
	CMP R12, #7
	BEQ return
	ADD R12, #1
	B Verificar_teclado
	
; -------------------------------------------------------------------------------
; Fun��o Verifica_tecla_pressionada_atualiza_LCD - Verifica se alguma tecla foi pressionada e atualiza o LCD
; Par�metro de entrada: R11 -> tecla que est� pressionada
; Par�metro de sa�da: N�o tem
; R10 -> quantidade de digitos j� escritos da senha
Verifica_tecla_pressionada_atualiza_LCD
	; Verifica se alguma tecla est� pressionada
	CMP R11, #0
	BEQ nenhuma_pressionada
alguma_pressionada
	; Verifica o estado do cofre
	CMP R9, #0
	BEQ Aberto_aguardando_senha
	CMP R9, #1
	BEQ Fechado_aguardando_senha
	B return
	
Aberto_aguardando_senha
	CMP R10, #4
	BLT Salvar_novo_digito_senha ;Tem menos de 4 digitos salvos? Salva.
	BEQ Tentar_fechar ;Tem exatamente 4 digitos salvos? Tenta fechar o cofre
	B return

Fechado_aguardando_senha
	CMP R10, #4
	BLT Salvar_novo_digito_tentativa ;Tem menos de 4 digitos salvos? Salva.
	BEQ Tentar_abrir ;Tem exatamente 4 digitos salvos? Tenta fechar o cofre
	B return

Salvar_novo_digito_senha
	CMP R11, #0x77 ;Verifica se o d�gito � #
	ITT EQ
		MOVEQ R11, #0
		BEQ return ;Digito � #, ent�o faz leitura de novo d�gito 
	LDR R1, =senha_cofre
	STRB R11, [R1, R10]
	ADD R10, #1
	MOV R11, #0
	PUSH { LR }
	BL Escrever_caractere_senha
	POP { LR }	
	B return
	
Tentar_fechar
	CMP R11, #0x77 ;Verifica se o d�gito � #
	BEQ Fechar
	MOV R11, #0
	B return

Fechar
	MOV R8, #0; N�o foi digitada senha errada nenhuma vez
	MOV R9, #3 ;Vai para o estado de fechando
	MOV R10, #0; ;Zera o n�mero de caracteres digitados
	MOV R11, #0 ;Zera o valor do caractere lido
	B return
	
Salvar_novo_digito_tentativa
	CMP R11, #0x77 ;Verifica se o d�gito � #
	ITT EQ
		MOVEQ R11, #0
		BEQ return ;Digito � #, ent�o faz leitura de novo d�gito 
	LDR R1, =senha_tentativa
	STRB R11, [R1, R10]
	ADD R10, #1
	MOV R11, #0
	PUSH { LR }
	BL Escrever_caractere_senha
	POP { LR }	
	B return
	
Tentar_abrir
	MOV R2, #0
	LDR R0, =senha_cofre
	LDR R1, =senha_tentativa
comparar_proximo_digito
	LDRB R3, [R0, R2]
	LDRB R4, [R1, R2]
	CMP R3, R4
	BNE Senha_errada
	ADD R2, #1
	CMP R2, #4
	BEQ Abrir
	B comparar_proximo_digito
	
Abrir
	MOV R8, #0; N�o foi digitada senha errada nenhuma vez
	MOV R9, #2 ;Vai para o estado de abrindo
	MOV R10, #0; ;Zera o n�mero de caracteres digitados
	MOV R11, #0 ;Zera o valor do caractere lido
	B return
	
Senha_errada
	ADD R8, #1
	CMP R8, #3 ;Errou 3 vezes, trava o cofre
	BEQ Travar
	; Se ainda n�o errou 3 vezes, pode fazer nova tentativa
	MOV R9, #1 ;Vai para estado de fechado
	MOV R10, #0; ;Zera o n�mero de caracteres digitados
	MOV R11, #0 ;Zera o valor do caractere lido
	PUSH { LR }
	BL Escrever_cofre_fechado
	POP { LR }
	B return

Travar
	MOV R8, #0; N�o foi digitada senha errada nenhuma vez
	MOV R9, #4 ;Vai para o estado de travado
	MOV R10, #0; ;Zera o n�mero de caracteres digitados
	MOV R11, #0 ;Zera o valor do caractere lido
	B return

nenhuma_pressionada
	MOV R11, #0	
	B return

; -------------------------------------------------------------------------------------------------------------------------
; Fim do Arquivo
; -------------------------------------------------------------------------------------------------------------------------	
    ALIGN                        ;Garante que o fim da se��o est� alinhada 
    END                          ;Fim do arquivo

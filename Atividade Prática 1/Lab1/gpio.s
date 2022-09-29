; gpio.s
; Desenvolvido para a placa EK-TM4C1294XL
; Prof. Guilherme Peron
; 24/08/2020

; -------------------------------------------------------------------------------
        THUMB                        ; Instruções do tipo Thumb-2
; -------------------------------------------------------------------------------
; Declarações EQU - Defines
; ========================
; Definições de Valores
BIT0	EQU 2_0001
BIT1	EQU 2_0010
; ========================
; Definições dos Registradores Gerais
SYSCTL_RCGCGPIO_R	 EQU	0x400FE608
SYSCTL_PRGPIO_R		 EQU    0x400FEA08
; ========================
; Definições dos Ports
;PORT A
GPIO_PORTA_AHB_LOCK_R   	EQU		0x40058520
GPIO_PORTA_AHB_CR_R     	EQU 	0x40058524
GPIO_PORTA_AHB_AMSEL_R  	EQU		0x40058528
GPIO_PORTA_AHB_PCTL_R   	EQU 	0x4005852C
GPIO_PORTA_AHB_DIR_R    	EQU 	0x40058400
GPIO_PORTA_AHB_AFSEL_R  	EQU 	0x40058420
GPIO_PORTA_AHB_DEN_R    	EQU 	0x4005851C
GPIO_PORTA_AHB_PUR_R    	EQU 	0x40058510
GPIO_PORTA_AHB_DATA_R   	EQU		0x400583FC
GPIO_PORTA_AHB_DATA_BITS_R  EQU		0x40058000
GPIO_PORTA               	EQU    2_000000000000001

;PORT B
GPIO_PORTB_AHB_DATA_BITS_R EQU 0x40059000
GPIO_PORTB_AHB_DATA_R  	EQU 0x400593FC
GPIO_PORTB_AHB_DIR_R    EQU 0x40059400
GPIO_PORTB_AHB_IS_R     EQU 0x40059404
GPIO_PORTB_AHB_IBE_R    EQU 0x40059408
GPIO_PORTB_AHB_IEV_R    EQU 0x4005940C
GPIO_PORTB_AHB_IM_R     EQU 0x40059410
GPIO_PORTB_AHB_RIS_R    EQU 0x40059414
GPIO_PORTB_AHB_MIS_R    EQU 0x40059418
GPIO_PORTB_AHB_ICR_R    EQU 0x4005941C
GPIO_PORTB_AHB_AFSEL_R  EQU 0x40059420
GPIO_PORTB_AHB_DR2R_R   EQU 0x40059500
GPIO_PORTB_AHB_DR4R_R   EQU 0x40059504
GPIO_PORTB_AHB_DR8R_R   EQU 0x40059508
GPIO_PORTB_AHB_ODR_R    EQU 0x4005950C
GPIO_PORTB_AHB_PUR_R    EQU 0x40059510
GPIO_PORTB_AHB_PDR_R    EQU 0x40059514
GPIO_PORTB_AHB_SLR_R    EQU 0x40059518
GPIO_PORTB_AHB_DEN_R    EQU 0x4005951C
GPIO_PORTB_AHB_LOCK_R   EQU 0x40059520
GPIO_PORTB_AHB_CR_R     EQU 0x40059524
GPIO_PORTB_AHB_AMSEL_R  EQU 0x40059528
GPIO_PORTB_AHB_PCTL_R   EQU 0x4005952C
GPIO_PORTB_AHB_ADCCTL_R EQU 0x40059530
GPIO_PORTB_AHB_DMACTL_R EQU 0x40059534
GPIO_PORTB_AHB_SI_R     EQU 0x40059538
GPIO_PORTB_AHB_DR12R_R  EQU 0x4005953C
GPIO_PORTB               	EQU    2_000000000000010

; PORT J
GPIO_PORTJ_AHB_LOCK_R    	EQU    0x40060520
GPIO_PORTJ_AHB_CR_R      	EQU    0x40060524
GPIO_PORTJ_AHB_AMSEL_R   	EQU    0x40060528
GPIO_PORTJ_AHB_PCTL_R    	EQU    0x4006052C
GPIO_PORTJ_AHB_DIR_R     	EQU    0x40060400
GPIO_PORTJ_AHB_AFSEL_R   	EQU    0x40060420
GPIO_PORTJ_AHB_DEN_R     	EQU    0x4006051C
GPIO_PORTJ_AHB_PUR_R     	EQU    0x40060510	
GPIO_PORTJ_AHB_DATA_R    	EQU    0x400603FC
GPIO_PORTJ_AHB_DATA_BITS_R  EQU    0x40060000
GPIO_PORTJ               	EQU    2_000000100000000

; PORT P

GPIO_PORTP_DATA_BITS_R  EQU 0x40065000
GPIO_PORTP_DATA_R       EQU 0x400653FC
GPIO_PORTP_DIR_R        EQU 0x40065400
GPIO_PORTP_IS_R         EQU 0x40065404
GPIO_PORTP_IBE_R        EQU 0x40065408
GPIO_PORTP_IEV_R        EQU 0x4006540C
GPIO_PORTP_IM_R         EQU 0x40065410
GPIO_PORTP_RIS_R        EQU 0x40065414
GPIO_PORTP_MIS_R        EQU 0x40065418
GPIO_PORTP_ICR_R        EQU 0x4006541C
GPIO_PORTP_AFSEL_R      EQU 0x40065420
GPIO_PORTP_DR2R_R       EQU 0x40065500
GPIO_PORTP_DR4R_R       EQU 0x40065504
GPIO_PORTP_DR8R_R       EQU 0x40065508
GPIO_PORTP_ODR_R        EQU 0x4006550C
GPIO_PORTP_PUR_R        EQU 0x40065510
GPIO_PORTP_PDR_R        EQU 0x40065514
GPIO_PORTP_SLR_R        EQU 0x40065518
GPIO_PORTP_DEN_R        EQU 0x4006551C
GPIO_PORTP_LOCK_R       EQU 0x40065520
GPIO_PORTP_CR_R         EQU 0x40065524
GPIO_PORTP_AMSEL_R      EQU 0x40065528
GPIO_PORTP_PCTL_R       EQU 0x4006552C
GPIO_PORTP_ADCCTL_R     EQU 0x40065530
GPIO_PORTP_DMACTL_R     EQU 0x40065534
GPIO_PORTP_SI_R         EQU 0x40065538
GPIO_PORTP_DR12R_R      EQU 0x4006553C
GPIO_PORTP_WAKEPEN_R    EQU 0x40065540
GPIO_PORTP_WAKELVL_R    EQU 0x40065544
GPIO_PORTP_WAKESTAT_R   EQU 0x40065548
GPIO_PORTP_PP_R         EQU 0x40065FC0
GPIO_PORTP_PC_R         EQU 0x40065FC4
GPIO_PORTP              EQU 2_010000000000000

;PORT Q
GPIO_PORTQ_DATA_BITS_R  EQU 0x40066000
GPIO_PORTQ_DATA_R       EQU 0x400663FC
GPIO_PORTQ_DIR_R        EQU 0x40066400
GPIO_PORTQ_IS_R         EQU 0x40066404
GPIO_PORTQ_IBE_R        EQU 0x40066408
GPIO_PORTQ_IEV_R        EQU 0x4006640C
GPIO_PORTQ_IM_R         EQU 0x40066410
GPIO_PORTQ_RIS_R        EQU 0x40066414
GPIO_PORTQ_MIS_R        EQU 0x40066418
GPIO_PORTQ_ICR_R        EQU 0x4006641C
GPIO_PORTQ_AFSEL_R      EQU 0x40066420
GPIO_PORTQ_DR2R_R       EQU 0x40066500
GPIO_PORTQ_DR4R_R       EQU 0x40066504
GPIO_PORTQ_DR8R_R       EQU 0x40066508
GPIO_PORTQ_ODR_R        EQU 0x4006650C
GPIO_PORTQ_PUR_R        EQU 0x40066510
GPIO_PORTQ_PDR_R        EQU 0x40066514
GPIO_PORTQ_SLR_R        EQU 0x40066518
GPIO_PORTQ_DEN_R        EQU 0x4006651C
GPIO_PORTQ_LOCK_R       EQU 0x40066520
GPIO_PORTQ_CR_R         EQU 0x40066524
GPIO_PORTQ_AMSEL_R      EQU 0x40066528
GPIO_PORTQ_PCTL_R       EQU 0x4006652C
GPIO_PORTQ_ADCCTL_R     EQU 0x40066530
GPIO_PORTQ_DMACTL_R     EQU 0x40066534
GPIO_PORTQ_SI_R         EQU 0x40066538
GPIO_PORTQ_DR12R_R      EQU 0x4006653C
GPIO_PORTQ_WAKEPEN_R    EQU 0x40066540
GPIO_PORTQ_WAKELVL_R    EQU 0x40066544
GPIO_PORTQ_WAKESTAT_R   EQU 0x40066548
GPIO_PORTQ_PP_R         EQU 0x40066FC0
GPIO_PORTQ              EQU 2_100000000000000

; 2_A7A6A5A4Q3Q2Q1Q0
D_0_H	EQU 2_00110000
D_0_L	EQU 2_00001111
D_1_H 	EQU 2_00000000
D_1_L 	EQU 2_00000110
D_2_H 	EQU 2_01010000
D_2_L 	EQU 2_00001011
D_3_H	EQU 2_01000000
D_3_L 	EQU 2_00001111
D_4_H 	EQU 2_01100000
D_4_L 	EQU 2_00000110
D_5_H 	EQU 2_01100000
D_5_L 	EQU 2_00001101
D_6_H 	EQU 2_01110000
D_6_L 	EQU 2_00001101
D_7_H 	EQU 2_00000000
D_7_L 	EQU 2_00000111
D_8_H 	EQU 2_01110000
D_8_L 	EQU 2_00001111
D_9_H	EQU 2_01100000
D_9_L	EQU 2_00001111
	
; Sequencia LED
L_1_H EQU 2_10000000
L_1_L EQU 2_00000001
L_2_H EQU 2_01000000
L_2_L EQU 2_00000010
L_3_H EQU 2_00100000
L_3_L EQU 2_00000100
L_4_H EQU 2_00010000
L_4_L EQU 2_00001000
L_5_H EQU 2_00010000
L_5_L EQU 2_00001000
L_6_H EQU 2_00100000
L_6_L EQU 2_00000100
L_7_H EQU 2_01000000
L_7_L EQU 2_00000010
L_8_H EQU 2_10000000
L_8_L EQU 2_00000001

; -------------------------------------------------------------------------------
; Área de Código - Tudo abaixo da diretiva a seguir será armazenado na memória de 
;                  código
        AREA    |.text|, CODE, READONLY, ALIGN=2

		; Se alguma função do arquivo for chamada em outro arquivo	
        EXPORT GPIO_Init            ; Permite chamar GPIO_Init de outro arquivo
		EXPORT PortJ_Input          ; Permite chamar PortJ_Input de outro arquivo
		EXPORT Liga_LED	
		EXPORT Ligar_Display
		IMPORT SysTick_Wait1ms				

;--------------------------------------------------------------------------------
; Função GPIO_Init
; Parâmetro de entrada: Não tem
; Parâmetro de saída: Não tem
GPIO_Init
;=====================
; 1. Ativar o clock para a porta setando o bit correspondente no registrador RCGCGPIO,
; após isso verificar no PRGPIO se a porta está pronta para uso.
; enable clock to GPIOF at clock gating register
            LDR     R0, =SYSCTL_RCGCGPIO_R  		;Carrega o endereço do registrador RCGCGPIO
			MOV		R1, #GPIO_PORTA                 ;Seta o bit da porta A
			ORR     R1, #GPIO_PORTB					;Seta o bit da porta B, fazendo com OR
			ORR     R1, #GPIO_PORTJ					;Seta o bit da porta J, fazendo com OR
			ORR     R1, #GPIO_PORTP					;Seta o bit da porta P, fazendo com OR
			ORR     R1, #GPIO_PORTQ					;Seta o bit da porta Q, fazendo com OR
            STR     R1, [R0]						;Move para a memória os bits das portas no endereço do RCGCGPIO
            LDR     R0, =SYSCTL_PRGPIO_R			;Carrega o endereço do PRGPIO para esperar os GPIO ficarem prontos
EsperaGPIO  LDR     R1, [R0]						;Lê da memória o conteúdo do endereço do registrador
			MOV		R2, #GPIO_PORTA                 ;Seta o bit da porta A
			ORR     R2, #GPIO_PORTB					;Seta o bit da porta B, fazendo com OR
			ORR     R2, #GPIO_PORTJ					;Seta o bit da porta J, fazendo com OR
			ORR     R2, #GPIO_PORTP					;Seta o bit da porta P, fazendo com OR
			ORR     R2, #GPIO_PORTQ					;Seta o bit da porta Q, fazendo com OR
            TST     R1, R2							;Testa o R1 com R2 fazendo R1 & R2
            BEQ     EsperaGPIO					    ;Se o flag Z=1, volta para o laço. Senão continua executando
; 2. Limpar o AMSEL para desabilitar a analógica - Não tenho certeza se não preciso alterar o R1 pra cada porta
            MOV     R1, #0x00						;Colocar 0 no registrador para desabilitar a função analógica
            LDR     R0, =GPIO_PORTA_AHB_AMSEL_R     ;Carrega o R0 com o endereço do AMSEL para a porta A
            STR     R1, [R0]						;Guarda no registrador AMSEL da porta A da memória
			LDR     R0, =GPIO_PORTB_AHB_AMSEL_R     ;Carrega o R0 com o endereço do AMSEL para a porta B
            STR     R1, [R0]						;Guarda no registrador AMSEL da porta B da memória
            LDR     R0, =GPIO_PORTJ_AHB_AMSEL_R     ;Carrega o R0 com o endereço do AMSEL para a porta J
            STR     R1, [R0]						;Guarda no registrador AMSEL da porta J da memória
            LDR     R0, =GPIO_PORTP_AMSEL_R     ;Carrega o R0 com o endereço do AMSEL para a porta P
            STR     R1, [R0]						;Guarda no registrador AMSEL da porta P da memória
            LDR     R0, =GPIO_PORTQ_AMSEL_R     ;Carrega o R0 com o endereço do AMSEL para a porta Q
            STR     R1, [R0]						;Guarda no registrador AMSEL da porta Q da memória
; 3. Limpar PCTL para selecionar o GPIO - Não tenho certeza se não preciso alterar o R1 pra cada porta
            MOV     R1, #0x00					    ;Colocar 0 no registrador para selecionar o modo GPIO
            LDR     R0, =GPIO_PORTA_AHB_PCTL_R		;Carrega o R0 com o endereço do PCTL para a porta A
            STR     R1, [R0]                        ;Guarda no registrador PCTL da porta A da memória
            LDR     R0, =GPIO_PORTB_AHB_PCTL_R		;Carrega o R0 com o endereço do PCTL para a porta B
            STR     R1, [R0]                        ;Guarda no registrador PCTL da porta B da memória
            LDR     R0, =GPIO_PORTJ_AHB_PCTL_R		;Carrega o R0 com o endereço do PCTL para a porta J
            STR     R1, [R0]                        ;Guarda no registrador PCTL da porta J da memória
            LDR     R0, =GPIO_PORTP_PCTL_R		;Carrega o R0 com o endereço do PCTL para a porta P
            STR     R1, [R0]                        ;Guarda no registrador PCTL da porta P da memória
            LDR     R0, =GPIO_PORTQ_PCTL_R		;Carrega o R0 com o endereço do PCTL para a porta Q
            STR     R1, [R0]                        ;Guarda no registrador PCTL da porta Q da memória
; 4. DIR para 0 se for entrada, 1 se for saída
            LDR     R0, =GPIO_PORTA_AHB_DIR_R			;Carrega o R0 com o endereço do DIR para a porta A
			MOV     R1, #2_11110000					;PA4, PA5, PA6, PA7
            STR     R1, [R0]						;Guarda no registrador
            LDR     R0, =GPIO_PORTB_AHB_DIR_R			;Carrega o R0 com o endereço do DIR para a porta B
			MOV     R1, #2_00110000					;PB4, PB5
            STR     R1, [R0]						;Guarda no registrador
            LDR     R0, =GPIO_PORTJ_AHB_DIR_R		;Carrega o R0 com o endereço do DIR para a porta J
            MOV     R1, #0x00               		;Colocar 0 no registrador DIR para funcionar com saída
            STR     R1, [R0]						;Guarda no registrador PCTL da porta J da memória
			LDR     R0, =GPIO_PORTP_DIR_R			;Carrega o R0 com o endereço do DIR para a porta P
			MOV     R1, #2_00100000					;PP5
            STR     R1, [R0]						;Guarda no registrador
			LDR     R0, =GPIO_PORTQ_DIR_R			;Carrega o R0 com o endereço do DIR para a porta Q
			MOV     R1, #2_00001111					;PQ0, PQ1, PQ2, PQ3
            STR     R1, [R0]						;Guarda no registrador
; 5. Limpar os bits AFSEL para 0 para selecionar GPIO 
;    Sem função alternativa
            MOV     R1, #0x00						;Colocar o valor 0 para não setar função alternativa
            LDR     R0, =GPIO_PORTA_AHB_AFSEL_R			;Carrega o endereço do AFSEL da porta A
            STR     R1, [R0]						;Escreve na porta
			LDR     R0, =GPIO_PORTB_AHB_AFSEL_R     ;Carrega o endereço do AFSEL da porta B
            STR     R1, [R0]                        ;Escreve na porta
            LDR     R0, =GPIO_PORTJ_AHB_AFSEL_R     ;Carrega o endereço do AFSEL da porta J
            STR     R1, [R0]                        ;Escreve na porta
			LDR     R0, =GPIO_PORTP_AFSEL_R     ;Carrega o endereço do AFSEL da porta P
            STR     R1, [R0]                        ;Escreve na porta
            LDR     R0, =GPIO_PORTQ_AFSEL_R     ;Carrega o endereço do AFSEL da porta Q
            STR     R1, [R0]                        ;Escreve na porta
; 6. Setar os bits de DEN para habilitar I/O digital
            LDR     R0, =GPIO_PORTA_AHB_DEN_R			    ;Carrega o endereço do DEN
            MOV     R1, #2_11110000                     ;PA4, PA5, PA6, PA7
            STR     R1, [R0]							;Escreve no registrador da memória funcionalidade digital 
            LDR     R0, =GPIO_PORTB_AHB_DEN_R			    ;Carrega o endereço do DEN
            MOV     R1, #2_00110000                     ;PB4, PB5
            STR     R1, [R0]							;Escreve no registrador da memória funcionalidade digital 
			LDR     R0, =GPIO_PORTJ_AHB_DEN_R			;Carrega o endereço do DEN
			MOV     R1, #2_00000011                     ;J0, J1     
            STR     R1, [R0]                            ;Escreve no registrador da memória funcionalidade digital
            LDR     R0, =GPIO_PORTP_DEN_R			    ;Carrega o endereço do DEN
            MOV     R1, #2_00100000                     ;PP5
            STR     R1, [R0]							;Escreve no registrador da memória funcionalidade digital 
            LDR     R0, =GPIO_PORTQ_DEN_R			    ;Carrega o endereço do DEN
            MOV     R1, #2_00001111                     ;PQ0, PQ1, PQ2, PQ3
            STR     R1, [R0]							;Escreve no registrador da memória funcionalidade digital 
			
; 7. Para habilitar resistor de pull-up interno, setar PUR para 1
			LDR     R0, =GPIO_PORTJ_AHB_PUR_R			;Carrega o endereço do PUR para a porta J
			MOV     R1, #2_00000011						;Habilitar funcionalidade digital de resistor de pull-up 
            STR     R1, [R0]							;Escreve no registrador da memória do resistor de pull-up
			BX      LR


; -------------------------------------------------------------------------------
; Função PortJ_Input
; Parâmetro de entrada: Não tem
; Parâmetro de saída: R8 --> o valor da leitura
PortJ_Input
	LDR	R1, =GPIO_PORTJ_AHB_DATA_R		    ;Carrega o valor do offset do data register
	LDR R8, [R1]                            ;Lê no barramento de dados dos pinos [J0]
	BX LR									;Retorno

; -------------------------------------------------------------------------------
; Função Ligar Display
; Parâmetro de entrada: R8 número N, R7 Seleção do display (0 diplay da unidade, 1 display da dezena)
; Parâmetro de saída: Não tem
Ligar_Display

	CMP R8, #0
	BEQ Liga_0
	CMP R8, #1
	BEQ Liga_1
	CMP R8, #2
	BEQ Liga_2
	CMP R8, #3
	BEQ Liga_3
	CMP R8, #4
	BEQ Liga_4
	CMP R8, #5
	BEQ Liga_5
	CMP R8, #6
	BEQ Liga_6
	CMP R8, #7
	BEQ Liga_7
	CMP R8, #8
	BEQ Liga_8
	CMP R8, #9
	BEQ Liga_9
Liga_0 
	LDR	R1, =GPIO_PORTA_AHB_DATA_R		    ;Carrega o valor do offset do data register
	LDR	R2, =D_0_H
	STR R2, [R1]
	LDR	R1, =GPIO_PORTQ_DATA_R		    	;Carrega o valor do offset do data register
	LDR	R2, =D_0_L
	STR R2, [R1]
	B Liga_transistor
Liga_1
	LDR	R1, =GPIO_PORTA_AHB_DATA_R		    ;Carrega o valor do offset do data register
	LDR	R2, =D_1_H
	STR R2, [R1]
	LDR	R1, =GPIO_PORTQ_DATA_R		    	;Carrega o valor do offset do data register
	LDR	R2, =D_1_L
	STR R2, [R1]
	B Liga_transistor
Liga_2 
	LDR	R1, =GPIO_PORTA_AHB_DATA_R		    ;Carrega o valor do offset do data register
	LDR	R2, =D_2_H
	STR R2, [R1]
	LDR	R1, =GPIO_PORTQ_DATA_R		    	;Carrega o valor do offset do data register
	LDR	R2, =D_2_L
	STR R2, [R1]
	B Liga_transistor
Liga_3
	LDR	R1, =GPIO_PORTA_AHB_DATA_R		    ;Carrega o valor do offset do data register
	LDR	R2, =D_3_H
	STR R2, [R1]
	LDR	R1, =GPIO_PORTQ_DATA_R		    	;Carrega o valor do offset do data register
	LDR	R2, =D_3_L
	STR R2, [R1]
	B Liga_transistor
Liga_4 
	LDR	R1, =GPIO_PORTA_AHB_DATA_R		    ;Carrega o valor do offset do data register
	LDR	R2, =D_4_H
	STR R2, [R1]
	LDR	R1, =GPIO_PORTQ_DATA_R		    	;Carrega o valor do offset do data register
	LDR	R2, =D_4_L
	STR R2, [R1]
	B Liga_transistor
Liga_5 
	LDR	R1, =GPIO_PORTA_AHB_DATA_R		    ;Carrega o valor do offset do data register
	LDR	R2, =D_5_H
	STR R2, [R1]
	LDR	R1, =GPIO_PORTQ_DATA_R		    	;Carrega o valor do offset do data register
	LDR	R2, =D_5_L
	STR R2, [R1]
	B Liga_transistor
Liga_6 
	LDR	R1, =GPIO_PORTA_AHB_DATA_R		    ;Carrega o valor do offset do data register
	LDR	R2, =D_6_H
	STR R2, [R1]
	LDR	R1, =GPIO_PORTQ_DATA_R		    	;Carrega o valor do offset do data register
	LDR	R2, =D_6_L
	STR R2, [R1]
	B Liga_transistor
Liga_7 
	LDR	R1, =GPIO_PORTA_AHB_DATA_R		    ;Carrega o valor do offset do data register
	LDR	R2, =D_7_H
	STR R2, [R1]
	LDR	R1, =GPIO_PORTQ_DATA_R		    	;Carrega o valor do offset do data register
	LDR	R2, =D_7_L
	STR R2, [R1]
	B Liga_transistor
Liga_8 
	LDR	R1, =GPIO_PORTA_AHB_DATA_R		    ;Carrega o valor do offset do data register
	LDR	R2, =D_8_H
	STR R2, [R1]
	LDR	R1, =GPIO_PORTQ_DATA_R		    	;Carrega o valor do offset do data register
	LDR	R2, =D_8_L
	STR R2, [R1]
	B Liga_transistor
Liga_9 
	LDR	R1, =GPIO_PORTA_AHB_DATA_R		    ;Carrega o valor do offset do data register
	LDR	R2, =D_9_H
	STR R2, [R1]
	LDR	R1, =GPIO_PORTQ_DATA_R		    	;Carrega o valor do offset do data register
	LDR	R2, =D_9_L
	STR R2, [R1]

Liga_transistor
	LDR	R1, =GPIO_PORTB_AHB_DATA_R
	CMP R7, #0
	BEQ Liga_Unidade
	
Liga_Dezena
	MOV R2, #2_00010000
	LDR	R1, =GPIO_PORTB_AHB_DATA_R
	STR R2, [R1]
	
	MOV R0, #1
	PUSH { LR }
	BL SysTick_Wait1ms
	POP { LR }
	B Desliga_transistor
Liga_Unidade
	MOV R2, #2_00100000
	LDR	R1, =GPIO_PORTB_AHB_DATA_R
	STR R2, [R1]
	MOV R0, #3
	PUSH { LR }
	BL SysTick_Wait1ms
	POP { LR }
	
Desliga_transistor
	MOV R2, #2_00000000
	LDR	R1, =GPIO_PORTB_AHB_DATA_R
	STR R2, [R1]
	MOV R0, #3
	PUSH { LR }
	BL SysTick_Wait1ms
	POP { LR }
	
	BX LR									;Retorno


; -------------------------------------------------------------------------------
; Função PortJ_Input
; Parâmetro de entrada: R9 --> Sequencia de leds a ser ligada
; Parâmetro de saída: Não tem
Liga_LED
	

	CMP R9, #1
	BEQ Liga_L1
	CMP R9, #2
	BEQ Liga_L2
	CMP R9, #3
	BEQ Liga_L3
	CMP R9, #4
	BEQ Liga_L4
	CMP R9, #5
	BEQ Liga_L5
	CMP R9, #6
	BEQ Liga_L6
	CMP R9, #7
	BEQ Liga_L7
	CMP R9, #8
	BEQ Liga_L8

Liga_L1
	LDR	R1, =GPIO_PORTA_AHB_DATA_R		    ;Carrega o valor do offset do data register
	LDR	R2, =L_1_H
	STR R2, [R1]
	LDR	R1, =GPIO_PORTQ_DATA_R		    	;Carrega o valor do offset do data register
	LDR	R2, =L_1_L
	STR R2, [R1]
	B Ativa_Transistor
Liga_L2
	LDR	R1, =GPIO_PORTA_AHB_DATA_R		    ;Carrega o valor do offset do data register
	LDR	R2, =L_2_H
	STR R2, [R1]
	LDR	R1, =GPIO_PORTQ_DATA_R		    	;Carrega o valor do offset do data register
	LDR	R2, =L_2_L
	STR R2, [R1]
	B Ativa_Transistor
Liga_L3
	LDR	R1, =GPIO_PORTA_AHB_DATA_R		    ;Carrega o valor do offset do data register
	LDR	R2, =L_3_H
	STR R2, [R1]
	LDR	R1, =GPIO_PORTQ_DATA_R		    	;Carrega o valor do offset do data register
	LDR	R2, =L_3_L
	STR R2, [R1]
	B Ativa_Transistor
Liga_L4
	LDR	R1, =GPIO_PORTA_AHB_DATA_R		    ;Carrega o valor do offset do data register
	LDR	R2, =L_4_H
	STR R2, [R1]
	LDR	R1, =GPIO_PORTQ_DATA_R		    	;Carrega o valor do offset do data register
	LDR	R2, =L_4_L
	STR R2, [R1]
	B Ativa_Transistor
Liga_L5
	LDR	R1, =GPIO_PORTA_AHB_DATA_R		    ;Carrega o valor do offset do data register
	LDR	R2, =L_5_H
	STR R2, [R1]
	LDR	R1, =GPIO_PORTQ_DATA_R		    	;Carrega o valor do offset do data register
	LDR	R2, =L_5_L
	STR R2, [R1]
	B Ativa_Transistor
Liga_L6
	LDR	R1, =GPIO_PORTA_AHB_DATA_R		    ;Carrega o valor do offset do data register
	LDR	R2, =L_6_H
	STR R2, [R1]
	LDR	R1, =GPIO_PORTQ_DATA_R		    	;Carrega o valor do offset do data register
	LDR	R2, =L_6_L
	STR R2, [R1]
	B Ativa_Transistor
Liga_L7
	LDR	R1, =GPIO_PORTA_AHB_DATA_R		    ;Carrega o valor do offset do data register
	LDR	R2, =L_7_H
	STR R2, [R1]
	LDR	R1, =GPIO_PORTQ_DATA_R		    	;Carrega o valor do offset do data register
	LDR	R2, =L_7_L
	STR R2, [R1]
	B Ativa_Transistor
Liga_L8
	LDR	R1, =GPIO_PORTA_AHB_DATA_R		    ;Carrega o valor do offset do data register
	LDR	R2, =L_8_H
	STR R2, [R1]
	LDR	R1, =GPIO_PORTQ_DATA_R		    	;Carrega o valor do offset do data register
	LDR	R2, =L_8_L
	STR R2, [R1]
	B Ativa_Transistor
	

Ativa_Transistor
	LDR	R3, =GPIO_PORTP_DATA_R
	MOV R4, #2_00100000
	STR R4, [R3]
	
	MOV R0, #3
	PUSH { LR }
	BL SysTick_Wait1ms
	POP { LR }
	
	MOV R2, #2_00000000
	LDR	R3, =GPIO_PORTP_DATA_R
	STR R2, [R3]
	
	MOV R0, #3
	PUSH { LR }
	BL SysTick_Wait1ms
	POP { LR }
	
	BX LR									;Retorno

    ALIGN                           ; garante que o fim da seção está alinhada 
    END                             ; fim do arquivo
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
GPIO_PORTJ_AHB_IS_R			EQU 	0x40060404
GPIO_PORTJ_AHB_IBE_R		EQU 	0x40060408
GPIO_PORTJ_AHB_IEV_R		EQU		0x4006040C
GPIO_PORTJ_AHB_IM_R 		EQU		0x40060410
GPIO_PORTJ_AHB_RIS_R		EQU		0x40060414
GPIO_PORTJ_AHB_ICR_R		EQU 	0x4006041C

GPIO_PORTJ               	EQU    2_000000100000000

;PORT K
GPIO_PORTK_DATA_BITS_R  EQU 0x40061000
GPIO_PORTK_DATA_R       EQU 0x400613FC
GPIO_PORTK_DIR_R        EQU 0x40061400
GPIO_PORTK_IS_R         EQU 0x40061404
GPIO_PORTK_IBE_R        EQU 0x40061408
GPIO_PORTK_IEV_R        EQU 0x4006140C
GPIO_PORTK_IM_R         EQU 0x40061410
GPIO_PORTK_RIS_R        EQU 0x40061414
GPIO_PORTK_MIS_R        EQU 0x40061418
GPIO_PORTK_ICR_R        EQU 0x4006141C
GPIO_PORTK_AFSEL_R      EQU 0x40061420
GPIO_PORTK_DR2R_R       EQU 0x40061500
GPIO_PORTK_DR4R_R       EQU 0x40061504
GPIO_PORTK_DR8R_R       EQU 0x40061508
GPIO_PORTK_ODR_R        EQU 0x4006150C
GPIO_PORTK_PUR_R        EQU 0x40061510
GPIO_PORTK_PDR_R        EQU 0x40061514
GPIO_PORTK_SLR_R        EQU 0x40061518
GPIO_PORTK_DEN_R        EQU 0x4006151C
GPIO_PORTK_LOCK_R       EQU 0x40061520
GPIO_PORTK_CR_R         EQU 0x40061524
GPIO_PORTK_AMSEL_R      EQU 0x40061528
GPIO_PORTK_PCTL_R       EQU 0x4006152C
GPIO_PORTK_ADCCTL_R     EQU 0x40061530
GPIO_PORTK_DMACTL_R     EQU 0x40061534
GPIO_PORTK_SI_R         EQU 0x40061538
GPIO_PORTK_DR12R_R      EQU 0x4006153C
GPIO_PORTK_WAKEPEN_R    EQU 0x40061540
GPIO_PORTK_WAKELVL_R    EQU 0x40061544
GPIO_PORTK_WAKESTAT_R   EQU 0x40061548
GPIO_PORTK_PP_R         EQU 0x40061FC0
GPIO_PORTK_PC_R         EQU 0x40061FC4
GPIO_PORTK              EQU 2_000001000000000
	
;PORT L
GPIO_PORTL_DATA_BITS_R  EQU 0x40062000
GPIO_PORTL_DATA_R       EQU 0x400623FC
GPIO_PORTL_DIR_R        EQU 0x40062400
GPIO_PORTL_IS_R         EQU 0x40062404
GPIO_PORTL_IBE_R        EQU 0x40062408
GPIO_PORTL_IEV_R        EQU 0x4006240C
GPIO_PORTL_IM_R         EQU 0x40062410
GPIO_PORTL_RIS_R        EQU 0x40062414
GPIO_PORTL_MIS_R        EQU 0x40062418
GPIO_PORTL_ICR_R        EQU 0x4006241C
GPIO_PORTL_AFSEL_R      EQU 0x40062420
GPIO_PORTL_DR2R_R       EQU 0x40062500
GPIO_PORTL_DR4R_R       EQU 0x40062504
GPIO_PORTL_DR8R_R       EQU 0x40062508
GPIO_PORTL_ODR_R        EQU 0x4006250C
GPIO_PORTL_PUR_R        EQU 0x40062510
GPIO_PORTL_PDR_R        EQU 0x40062514
GPIO_PORTL_SLR_R        EQU 0x40062518
GPIO_PORTL_DEN_R        EQU 0x4006251C
GPIO_PORTL_LOCK_R       EQU 0x40062520
GPIO_PORTL_CR_R         EQU 0x40062524
GPIO_PORTL_AMSEL_R      EQU 0x40062528
GPIO_PORTL_PCTL_R       EQU 0x4006252C
GPIO_PORTL_ADCCTL_R     EQU 0x40062530
GPIO_PORTL_DMACTL_R     EQU 0x40062534
GPIO_PORTL_SI_R         EQU 0x40062538
GPIO_PORTL_DR12R_R      EQU 0x4006253C
GPIO_PORTL_WAKEPEN_R    EQU 0x40062540
GPIO_PORTL_WAKELVL_R    EQU 0x40062544
GPIO_PORTL_WAKESTAT_R   EQU 0x40062548
GPIO_PORTL_PP_R         EQU 0x40062FC0
GPIO_PORTL_PC_R         EQU 0x40062FC4
GPIO_PORTL              EQU 2_000010000000000

; PORT M
GPIO_PORTM_DATA_BITS_R  EQU 0x40063000
GPIO_PORTM_DATA_R       EQU 0x400633FC
GPIO_PORTM_DIR_R        EQU 0x40063400
GPIO_PORTM_IS_R         EQU 0x40063404
GPIO_PORTM_IBE_R        EQU 0x40063408
GPIO_PORTM_IEV_R        EQU 0x4006340C
GPIO_PORTM_IM_R         EQU 0x40063410
GPIO_PORTM_RIS_R        EQU 0x40063414
GPIO_PORTM_MIS_R        EQU 0x40063418
GPIO_PORTM_ICR_R        EQU 0x4006341C
GPIO_PORTM_AFSEL_R      EQU 0x40063420
GPIO_PORTM_DR2R_R       EQU 0x40063500
GPIO_PORTM_DR4R_R       EQU 0x40063504
GPIO_PORTM_DR8R_R       EQU 0x40063508
GPIO_PORTM_ODR_R        EQU 0x4006350C
GPIO_PORTM_PUR_R        EQU 0x40063510
GPIO_PORTM_PDR_R        EQU 0x40063514
GPIO_PORTM_SLR_R        EQU 0x40063518
GPIO_PORTM_DEN_R        EQU 0x4006351C
GPIO_PORTM_LOCK_R       EQU 0x40063520
GPIO_PORTM_CR_R         EQU 0x40063524
GPIO_PORTM_AMSEL_R      EQU 0x40063528
GPIO_PORTM_PCTL_R       EQU 0x4006352C
GPIO_PORTM_ADCCTL_R     EQU 0x40063530
GPIO_PORTM_DMACTL_R     EQU 0x40063534
GPIO_PORTM_SI_R         EQU 0x40063538
GPIO_PORTM_DR12R_R      EQU 0x4006353C
GPIO_PORTM_WAKEPEN_R    EQU 0x40063540
GPIO_PORTM_WAKELVL_R    EQU 0x40063544
GPIO_PORTM_WAKESTAT_R   EQU 0x40063548
GPIO_PORTM_PP_R         EQU 0x40063FC0
GPIO_PORTM_PC_R         EQU 0x40063FC4
GPIO_PORTM              EQU 2_000100000000000

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

NVIC_EN1_R				EQU 	0xE000E104
NVIC_PRI12_R			EQU 	0xE000E430


; -------------------------------------------------------------------------------
; Área de Código - Tudo abaixo da diretiva a seguir será armazenado na memória de 
;                  código
        AREA    |.text|, CODE, READONLY, ALIGN=2
		;texto_cofre_aberto			DCB   "Cofre aberto, digite nova senha para fechar o cofre ", 0
texto_cofre_aberto			DCB   "Cofre aberto", 0
texto_cofre_fechando		DCB   "Cofre fechando", 0
texto_cofre_fechado			DCB   "Cofre fechado", 0
texto_cofre_abrindo			DCB   "Cofre abrindo", 0
texto_cofre_travado			DCB   "Cofre travado", 0
texto_chave_mestra			DCB   "Chave Mestra", 0
texto_cofre_mestra			DCB   "1234", 0
caractere_senha				DCB   "*", 0					

		; Se alguma função do arquivo for chamada em outro arquivo	
        EXPORT GPIO_Init            ; Permite chamar GPIO_Init de outro arquivo
		EXPORT Pisca_LEDs
		EXPORT LCD_Init
		EXPORT Ler_porta_L
		EXPORT Ler_coluna
		EXPORT Escrever_string_LCD
		EXPORT Reset_LCD
		EXPORT Escrever_cofre_travado
		EXPORT Escrever_cofre_fechado
		EXPORT Escrever_cofre_aberto
		EXPORT Escrever_cofre_abrindo
		EXPORT Escrever_cofre_fechando
		EXPORT Escrever_caractere_senha	
		EXPORT Escreve_chave_mestra
		EXPORT GPIOPortJ_Handler
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
			ORR     R1, #GPIO_PORTJ					;Seta o bit da porta J, fazendo com OR
			ORR		R1, #GPIO_PORTK                 ;Seta o bit da porta K, fazendo com OR
			ORR     R1, #GPIO_PORTL					;Seta o bit da porta L, fazendo com OR
			ORR     R1, #GPIO_PORTM					;Seta o bit da porta M, fazendo com OR
			ORR     R1, #GPIO_PORTP					;Seta o bit da porta P, fazendo com OR
			ORR     R1, #GPIO_PORTQ					;Seta o bit da porta Q, fazendo com OR
            STR     R1, [R0]						;Move para a memória os bits das portas no endereço do RCGCGPIO
            LDR     R0, =SYSCTL_PRGPIO_R			;Carrega o endereço do PRGPIO para esperar os GPIO ficarem prontos
EsperaGPIO  LDR     R1, [R0]						;Lê da memória o conteúdo do endereço do registrador
			MOV		R2, #GPIO_PORTA                 ;Seta o bit da porta A
			ORR     R2, #GPIO_PORTJ					;Seta o bit da porta J, fazendo com OR
			ORR		R2, #GPIO_PORTK                 ;Seta o bit da porta K, fazendo com OR
			ORR     R2, #GPIO_PORTL					;Seta o bit da porta L, fazendo com OR
			ORR     R2, #GPIO_PORTM					;Seta o bit da porta M, fazendo com OR
			ORR     R2, #GPIO_PORTP					;Seta o bit da porta P, fazendo com OR
			ORR     R2, #GPIO_PORTQ					;Seta o bit da porta Q, fazendo com OR
            TST     R1, R2							;Testa o R1 com R2 fazendo R1 & R2
            BEQ     EsperaGPIO					    ;Se o flag Z=1, volta para o laço. Senão continua executando
; 2. Limpar o AMSEL para desabilitar a analógica - Não tenho certeza se não preciso alterar o R1 pra cada porta
            MOV     R1, #0x00						;Colocar 0 no registrador para desabilitar a função analógica
            LDR     R0, =GPIO_PORTA_AHB_AMSEL_R     ;Carrega o R0 com o endereço do AMSEL para a porta A
            STR     R1, [R0]						;Guarda no registrador AMSEL da porta A da memória
            LDR     R0, =GPIO_PORTJ_AHB_AMSEL_R     ;Carrega o R0 com o endereço do AMSEL para a porta J
            STR     R1, [R0]						;Guarda no registrador AMSEL da porta J da memória
			LDR     R0, =GPIO_PORTK_AMSEL_R     ;Carrega o R0 com o endereço do AMSEL para a porta K
            STR     R1, [R0]						;Guarda no registrador AMSEL da porta P da memória
            LDR     R0, =GPIO_PORTL_AMSEL_R     ;Carrega o R0 com o endereço do AMSEL para a porta L
			STR     R1, [R0]						;Guarda no registrador AMSEL da porta P da memória
            LDR     R0, =GPIO_PORTM_AMSEL_R     ;Carrega o R0 com o endereço do AMSEL para a porta M
			STR     R1, [R0]						;Guarda no registrador AMSEL da porta P da memória
            LDR     R0, =GPIO_PORTP_AMSEL_R     ;Carrega o R0 com o endereço do AMSEL para a porta P
            STR     R1, [R0]						;Guarda no registrador AMSEL da porta P da memória
            LDR     R0, =GPIO_PORTQ_AMSEL_R     ;Carrega o R0 com o endereço do AMSEL para a porta Q
            STR     R1, [R0]						;Guarda no registrador AMSEL da porta Q da memória
; 3. Limpar PCTL para selecionar o GPIO - Não tenho certeza se não preciso alterar o R1 pra cada porta
            MOV     R1, #0x00					    ;Colocar 0 no registrador para selecionar o modo GPIO
            LDR     R0, =GPIO_PORTA_AHB_PCTL_R		;Carrega o R0 com o endereço do PCTL para a porta A
            STR     R1, [R0]                        ;Guarda no registrador PCTL da porta A da memória
            LDR     R0, =GPIO_PORTJ_AHB_PCTL_R		;Carrega o R0 com o endereço do PCTL para a porta J
            STR     R1, [R0]                        ;Guarda no registrador PCTL da porta J da memória
			LDR     R0, =GPIO_PORTK_PCTL_R		;Carrega o R0 com o endereço do PCTL para a porta K
            STR     R1, [R0]                        ;Guarda no registrador PCTL da porta P da memória
            LDR     R0, =GPIO_PORTL_PCTL_R		;Carrega o R0 com o endereço do PCTL para a porta L
            STR     R1, [R0]                        ;Guarda no registrador PCTL da porta Q da memória
            LDR     R0, =GPIO_PORTM_PCTL_R		;Carrega o R0 com o endereço do PCTL para a porta M
            STR     R1, [R0]                        ;Guarda no registrador PCTL da porta Q da memória
            LDR     R0, =GPIO_PORTP_PCTL_R		;Carrega o R0 com o endereço do PCTL para a porta P
            STR     R1, [R0]                        ;Guarda no registrador PCTL da porta P da memória
            LDR     R0, =GPIO_PORTQ_PCTL_R		;Carrega o R0 com o endereço do PCTL para a porta Q
            STR     R1, [R0]                        ;Guarda no registrador PCTL da porta Q da memória
; 4. DIR para 0 se for entrada, 1 se for saída
            LDR     R0, =GPIO_PORTA_AHB_DIR_R			;Carrega o R0 com o endereço do DIR para a porta A
			MOV     R1, #2_11110000					;PA4, PA5, PA6, PA7
            STR     R1, [R0]						;Guarda no registrador
            LDR     R0, =GPIO_PORTJ_AHB_DIR_R		;Carrega o R0 com o endereço do DIR para a porta J
            MOV     R1, #0x00               		;Colocar 0 no registrador DIR para funcionar com saída
            STR     R1, [R0]						;Guarda no registrador PCTL da porta J da memória
			LDR     R0, =GPIO_PORTK_DIR_R			;Carrega o R0 com o endereço do DIR para a porta K
			MOV     R1, #2_11111111					;PK7-PK0 - saída
            STR     R1, [R0]						;Guarda no registrador
			LDR     R0, =GPIO_PORTL_DIR_R			;Carrega o R0 com o endereço do DIR para a porta L
			MOV     R1, #0x00						;PL0, PL1, PL2, PL3 - entradas
            STR     R1, [R0]						;Guarda no registrador
			LDR     R0, =GPIO_PORTM_DIR_R			;Carrega o R0 com o endereço do DIR para a porta M
			MOV     R1, #2_11110111					;PM0, PM1, PM2, PM4, PM5, PM6, PM7 - saída
            STR     R1, [R0]						;Guarda no registrador
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
            LDR     R0, =GPIO_PORTJ_AHB_AFSEL_R     ;Carrega o endereço do AFSEL da porta J
            STR     R1, [R0]                        ;Escreve na porta
			LDR     R0, =GPIO_PORTK_AFSEL_R     	;Carrega o endereço do AFSEL da porta K
            STR     R1, [R0]                    	;Escreve na porta
            LDR     R0, =GPIO_PORTL_AFSEL_R     	;Carrega o endereço do AFSEL da porta L
            STR     R1, [R0]                    	;Escreve na porta
            LDR     R0, =GPIO_PORTM_AFSEL_R     	;Carrega o endereço do AFSEL da porta M
            STR     R1, [R0]                    	;Escreve na porta
			LDR     R0, =GPIO_PORTP_AFSEL_R     	;Carrega o endereço do AFSEL da porta P
            STR     R1, [R0]                        ;Escreve na porta
            LDR     R0, =GPIO_PORTQ_AFSEL_R     	;Carrega o endereço do AFSEL da porta Q
            STR     R1, [R0]                        ;Escreve na porta
; 6. Setar os bits de DEN para habilitar I/O digital
            LDR     R0, =GPIO_PORTA_AHB_DEN_R			    ;Carrega o endereço do DEN
            MOV     R1, #2_11110000                     ;PA4, PA5, PA6, PA7
            STR     R1, [R0]							;Escreve no registrador da memória funcionalidade digital 						;Escreve no registrador da memória funcionalidade digital 
			LDR     R0, =GPIO_PORTJ_AHB_DEN_R			;Carrega o endereço do DEN
			MOV     R1, #2_00000011                     ;J0, J1     
            STR     R1, [R0]                            ;Escreve no registrador da memória funcionalidade digital
			LDR     R0, =GPIO_PORTK_DEN_R			    ;Carrega o endereço do DEN
            MOV     R1, #2_11111111	                    ;PK7-PK0
            STR     R1, [R0]							;Escreve no registrador da memória funcionalidade digital 
            LDR     R0, =GPIO_PORTL_DEN_R			    ;Carrega o endereço do DEN
            MOV     R1, #2_00001111                		;PL0, PL1, PL2, PL3
            STR     R1, [R0]							;Escreve no registrador da memória funcionalidade digital 
            LDR     R0, =GPIO_PORTM_DEN_R			    ;Carrega o endereço do DEN
            MOV     R1, #2_11110111                    	;PM0, PM1, PM2, PM4, PM5, PM6, PM7
            STR     R1, [R0]							;Escreve no registrador da memória funcionalidade digital 
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
			LDR     R0, =GPIO_PORTL_PUR_R				;Carrega o endereço do PUR para a porta L
			MOV     R1, #2_00001111						;Habilitar funcionalidade digital de resistor de pull-up 
            STR     R1, [R0]							;Escreve no registrador da memória do resistor de pull-up

;Interrupção
			LDR R0, =GPIO_PORTJ_AHB_IM_R
			MOV R1, #0x00
			STR R1, [R0]
			LDR R0, =GPIO_PORTJ_AHB_IS_R
			MOV R1, #0x00
			STR R1, [R0]
			LDR R0, =GPIO_PORTJ_AHB_IBE_R
			MOV R1, #0x00
			STR R1, [R0]
			LDR R0, =GPIO_PORTJ_AHB_IEV_R
			MOV R1, #0x00
			STR R1, [R0]
			LDR R0, =GPIO_PORTJ_AHB_ICR_R
			MOV R1, #0x01
			STR R1, [R0]
			LDR R0, =GPIO_PORTJ_AHB_IM_R
			MOV R1, #0x01
			STR R1, [R0]
			LDR R0, =NVIC_EN1_R
			MOV R1, #0x80000
			STR R1, [R0]
			LDR R0, =NVIC_PRI12_R
			MOV R1, #5
			LSL R1, #29
			STR R1, [R0]
			
			BX      LR
;; -------------------------------------------------------------------------------
;; Função PortJ_Input
;; Parâmetro de entrada: Não tem
;; Parâmetro de saída: R8 --> o valor da leitura
;PortJ_Input
;	LDR	R1, =GPIO_PORTJ_AHB_DATA_R		    ;Carrega o valor do offset do data register
;	LDR R8, [R1]                            ;Lê no barramento de dados dos pinos [J0]
;	BX LR									;Retorno

;; -------------------------------------------------------------------------------
GPIOPortJ_Handler
		MOV R9, #5
	
		LDR R0, =GPIO_PORTJ_AHB_ICR_R
		MOV R1, #0x01
		STR R1, [R0]
		BX LR
; -------------------------------------------------------------------------------
; Função Ler_coluna
; Parâmetro de entrada: R0 -> número da coluna que se quer ler - de 4 a 7
; Parâmetro de saída: Não tem
Ler_coluna
	LDR R1, =GPIO_PORTM_DIR_R
	LDR R2, [R1] ; Lê para carregar o valor anterior da porta inteira
	
	; R3 vai ter como bit 1 o bit na posição R0
	MOV R3, #1
	LSL R3, R0

	; Seta todas as colunas como entrada
	BIC R2, #0xF0
	; Seta a coluna passada por parâmetro como saída
	ORR R2, R3
	STR R2, [R1] ; Escreve o novo valor da porta
	
	; Escreve 0 na coluna escolhida
	LDR R1, =GPIO_PORTM_DATA_R
	LDR R2, [R1]
	BIC R2, R3 ; Faz o AND negado bit a bit para manter os valores anteriores e limpar somente PM7
	STR R2, [R1]
	
	BX LR

; -------------------------------------------------------------------------------
; Função Ler_porta_L - Lê o valor de PL3-PL0
; Parâmetro de entrada: Não tem
; Parâmetro de saída: Não tem
Ler_porta_L
	LDR R1, =GPIO_PORTL_DATA_R
	LDR R2, [R1] ; 
	AND R2, #0x0F
	
	BX LR

; -------------------------------------------------------------------------------
; Função LCD_enable_and_wait - Dá um enable no LCD, espera por 2ms e dá um disable e espera 2ms
; Parâmetro de entrada: Não tem
; Parâmetro de saída: Não tem
LCD_enable_and_wait ;Depois dividir a função em wait 40us e wait 1,64ms
	;EN como 1 para habilitar - EN -> PM2
	LDR R1, =GPIO_PORTM_DATA_R ;Carrega-se o endereço
	LDR R0, [R1] ; Lê para carregar o valor anterior da porta inteira
	ORR R0, R0, #2_00000100 ; Faz o OR bit a bit para manter os valores anteriores e setar somente o bit
	STR R0, [R1] ; Escreve o novo valor da porta
	
	PUSH { LR }
	MOV R0, #2
	BL SysTick_Wait1ms
	POP { LR }
	
	;EN como 0 para desabilitar - EN -> PM2
	LDR R1, =GPIO_PORTM_DATA_R ;Carrega-se o endereço
	LDR R0, [R1] ; Lê para carregar o valor anterior da porta inteira
	BIC R0, R0, #2_00000100 ; Faz o AND negado bit a bit para manter os valores anteriores e limpar somente o bit 0
	STR R0, [R1] ; Escreve o novo valor da porta
	
	PUSH { LR }
	MOV R0, #2
	BL SysTick_Wait1ms
	POP { LR }
	
	BX LR

; -------------------------------------------------------------------------------
; Função Set_RS_0 - Seta o RS do LCD como 0
; Parâmetro de entrada: Não tem
; Parâmetro de saída: Não tem
Set_RS_0
	;RS como 0 para enviar instrução - RS -> PM0	
	LDR R1, =GPIO_PORTM_DATA_R ;Carrega-se o endereço
	LDR R0, [R1] ; Lê para carregar o valor anterior da porta inteira
	BIC R0, R0, #2_00000001 ; Faz o AND negado bit a bit para manter os valores anteriores e limpar somente o bit 0
	STR R0, [R1] ; Escreve o novo valor da porta
	
	BX LR

; -------------------------------------------------------------------------------
; Função Set_RS_1 - Seta o RS do LCD como 1
; Parâmetro de entrada: Não tem
; Parâmetro de saída: Não tem
Set_RS_1
	;RS como 1 para enviar dados - RS -> PM0	
	LDR R1, =GPIO_PORTM_DATA_R ;Carrega-se o endereço
	LDR R0, [R1] ; Lê para carregar o valor anterior da porta inteira
	ORR R0, R0, #2_00000001 ; Faz o OR bit a bit para manter os valores anteriores e setar somente o bit
	STR R0, [R1] ; Escreve o novo valor da porta
	
	BX LR

; -------------------------------------------------------------------------------
; Função Envia_comando_LCD - Envia um comando para o LCD
; Parâmetro de entrada: R0 -> Comando a ser enviado
; Parâmetro de saída: Não tem 
Envia_comando_LCD
	LDR R1, =GPIO_PORTK_DATA_R
	STR R0, [R1]
	
	PUSH { LR }
	BL Set_RS_0
	POP { LR }
	
	PUSH { LR }
	BL LCD_enable_and_wait
	POP { LR }
	
	BX LR

; -------------------------------------------------------------------------------
; Função Envia_dado_LCD - Envia um dado para o LCD
; Parâmetro de entrada: R0 -> Dado a ser enviado
; Parâmetro de saída: Não tem 
Envia_dado_LCD
	LDR R1, =GPIO_PORTK_DATA_R
	STR R0, [R1]
	
	PUSH { LR }
	BL Set_RS_1
	POP { LR }
	
	PUSH { LR }
	BL LCD_enable_and_wait
	POP { LR }
	
	BX LR

; -------------------------------------------------------------------------------
; Função Escrever_string_LCD - Escreve uma string no LCD
; Parâmetro de entrada: R1 -> Endereço de memória de início da string
; Parâmetro de saída: Não tem 
Escrever_string_LCD
Escrever_proximo
	LDRB R0, [R1], #1
	CMP R0, #0
	BEQ return
	PUSH { LR, R1 }
	BL Envia_dado_LCD
	POP { R1, LR }
	B Escrever_proximo
return
	BX LR

; -------------------------------------------------------------------------------
; Função Reset_LCD - Reseta o LCD
; Parâmetro de entrada: Não tem
; Parâmetro de saída: Não tem 
Reset_LCD
	; Reset LCD
	MOV R0, #0x01
	PUSH { LR, R1 }
	BL Envia_comando_LCD
	POP { R1, LR }
	BX LR
	
; -------------------------------------------------------------------------------
; Função Pula_cursor_segunda_linha - Manda o cursor para a segunda linha do LCD
; Parâmetro de entrada: Não tem
; Parâmetro de saída: Não tem 
Pula_cursor_segunda_linha
	; Reset LCD
	MOV R0, #0xC0
	PUSH { LR, R1 }
	BL Envia_comando_LCD
	POP { R1, LR }
	BX LR

; -------------------------------------------------------------------------------
; Função Escrever_cofre_aberto
; Parâmetro de entrada: Não tem
; Parâmetro de saída: Não tem 
Escrever_cofre_aberto
	; Reset no LCD -----------------------------------------------
	PUSH { LR }
	BL Reset_LCD
	POP { LR }
	
	LDR R1, =texto_cofre_aberto
	PUSH { LR }
	BL Escrever_string_LCD
	BL Pula_cursor_segunda_linha
	POP { LR }
	
	BX LR
	
Escreve_chave_mestra
	; Reset no LCD -----------------------------------------------
	PUSH { LR }
	BL Reset_LCD
	POP { LR }
	
	LDR R1, =texto_chave_mestra
	PUSH { LR }
	BL Escrever_string_LCD
	BL Pula_cursor_segunda_linha
	POP { LR }
	
	BX LR
	
; -------------------------------------------------------------------------------
; Função Escrever_cofre_fechado
; Parâmetro de entrada: Não tem
; Parâmetro de saída: Não tem 
Escrever_cofre_fechado
	; Reset no LCD -----------------------------------------------
	PUSH { LR }
	BL Reset_LCD
	POP { LR }
	
	LDR R1, =texto_cofre_fechado
	PUSH { LR }
	BL Escrever_string_LCD
	BL Pula_cursor_segunda_linha
	POP { LR }
	
	BX LR

; -------------------------------------------------------------------------------
; Função Escrever_cofre_fechando
; Parâmetro de entrada: Não tem
; Parâmetro de saída: Não tem 
Escrever_cofre_fechando
	; Reset no LCD -----------------------------------------------
	PUSH { LR }
	BL Reset_LCD
	POP { LR }
	
	LDR R1, =texto_cofre_fechando
	PUSH { LR }
	BL Escrever_string_LCD
	POP { LR }
	
	BX LR
	
; -------------------------------------------------------------------------------
; Função Escrever_cofre_abrindo
; Parâmetro de entrada: Não tem
; Parâmetro de saída: Não tem 
Escrever_cofre_abrindo
	; Reset no LCD -----------------------------------------------
	PUSH { LR }
	BL Reset_LCD
	POP { LR }
	
	LDR R1, =texto_cofre_abrindo
	PUSH { LR }
	BL Escrever_string_LCD
	POP { LR }
	
	BX LR

; -------------------------------------------------------------------------------
; Função Escrever_cofre_travado
; Parâmetro de entrada: Não tem
; Parâmetro de saída: Não tem 
Escrever_cofre_travado
	; Reset no LCD -----------------------------------------------
	PUSH { LR }
	BL Reset_LCD
	POP { LR }
	
	LDR R1, =texto_cofre_travado
	PUSH { LR }
	BL Escrever_string_LCD
	POP { LR }
	
	BX LR
	
; -------------------------------------------------------------------------------
; Função Escrever_cofre_travado
; Parâmetro de entrada: Não tem
; Parâmetro de saída: Não tem 
Escrever_caractere_senha
	LDR R1, =caractere_senha
	PUSH { LR }
	BL Escrever_string_LCD
	POP { LR }
	
	BX LR


; -------------------------------------------------------------------------------
; Função LCD_Init - Inicializa o LCD
; Parâmetro de entrada: Não tem
; Parâmetro de saída: Não tem 
LCD_Init
	; Reset no LCD -----------------------------------------------
	PUSH { LR }
	BL Reset_LCD
	POP { LR }
	
	; Inicializa configuração do LCD -----------------------------------------------
	MOV R0, #0x38
	PUSH { LR }
	BL Envia_comando_LCD
	POP { LR }
	
	; Inicializa configuração do LCD -----------------------------------------------
	MOV R0, #0xF
	PUSH { LR }
	BL Envia_comando_LCD
	POP { LR }
	
	PUSH { LR }
	BL Escrever_cofre_aberto
	POP { LR }

	BX LR


; -------------------------------------------------------------------------------
; Função Pisca_LED
; Parâmetro de entrada: R5 --> Liga ou Desliga LEDs
; Parâmetro de saída: Não tem
Pisca_LEDs
	CMP R5,#-1
	BEQ Apaga_Leds
Liga_LEDs
	LDR	R1, =GPIO_PORTA_AHB_DATA_R		    ;Carrega o valor do offset do data register
	LDR	R2, =2_11110000
	STR R2, [R1]
	LDR	R1, =GPIO_PORTQ_DATA_R		    	;Carrega o valor do offset do data register
	LDR	R2, =2_00001111
	STR R2, [R1]
	B Ativa_Transistor
Apaga_Leds
	LDR	R1, =GPIO_PORTA_AHB_DATA_R		    ;Carrega o valor do offset do data register
	LDR	R2, =2_00000000
	STR R2, [R1]
	LDR	R1, =GPIO_PORTQ_DATA_R		    	;Carrega o valor do offset do data register
	LDR	R2, =2_00000000
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
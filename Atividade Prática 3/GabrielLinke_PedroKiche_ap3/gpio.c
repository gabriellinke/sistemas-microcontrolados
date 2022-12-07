// gpio.c
// Desenvolvido para a placa EK-TM4C1294XL
// Inicializa as portas J e N
// Prof. Guilherme Peron


#include <stdint.h>

#include "tm4c1294ncpdt.h"

void SysTick_Wait1ms(uint32_t delay);
void Enviar_Comando_LCD(uint32_t comando);
uint32_t Converte_Tecla(void);


uint32_t tecla_pressionada =  0x00;
uint32_t coluna = 0x04;
uint32_t linha = 0x00;

#define GPIO_PORTA  (0x0001) //bit 0
#define GPIO_PORTH  (0x0080) //bit 7
#define GPIO_PORTJ  (0x0100) //bit 8
#define GPIO_PORTK  (0x0200) //bit 9
#define GPIO_PORTL  (0x0400) //bit 10
#define GPIO_PORTM  (0x0800) //bit 11
#define GPIO_PORTN  (0x1000) //bit 12
#define GPIO_PORTP  (0x2000) //bit 13
#define GPIO_PORTQ  (0x4000) //bit 14



// -------------------------------------------------------------------------------
// Função GPIO_Init
// Inicializa os ports A, J, K, L , M, N, P, Q
// Parâmetro de entrada: Não tem
// Parâmetro de saída: Não tem
void GPIO_Init(void)
{
	//1a. Ativar o clock para a porta setando o bit correspondente no registrador RCGCGPIO
	SYSCTL_RCGCGPIO_R = (GPIO_PORTA |GPIO_PORTH | GPIO_PORTJ | GPIO_PORTK | GPIO_PORTL | GPIO_PORTM | GPIO_PORTN | GPIO_PORTP | GPIO_PORTQ);
	//1b.   após isso verificar no PRGPIO se a porta está pronta para uso.
  while((SYSCTL_PRGPIO_R & 
				(GPIO_PORTA |GPIO_PORTH | GPIO_PORTJ | GPIO_PORTK | GPIO_PORTL | GPIO_PORTM | GPIO_PORTN | GPIO_PORTP | GPIO_PORTQ) ) != 
				(GPIO_PORTA |GPIO_PORTH | GPIO_PORTJ | GPIO_PORTK | GPIO_PORTL | GPIO_PORTM | GPIO_PORTN | GPIO_PORTP | GPIO_PORTQ) ){};
	
	// 2. Limpar o AMSEL para desabilitar a analógica
	GPIO_PORTA_AHB_AMSEL_R = 0x00;
	GPIO_PORTH_AHB_AMSEL_R = 0x00;
	GPIO_PORTJ_AHB_AMSEL_R = 0x00;
	GPIO_PORTK_AMSEL_R = 0x00;
	GPIO_PORTL_AMSEL_R = 0x00;
	GPIO_PORTM_AMSEL_R = 0x00;
	GPIO_PORTN_AMSEL_R = 0x00;
	GPIO_PORTN_AMSEL_R = 0x00;
	GPIO_PORTP_AMSEL_R = 0x00;
	GPIO_PORTQ_AMSEL_R = 0x00;
		
	// 3. Limpar PCTL para selecionar o GPIO
	GPIO_PORTA_AHB_PCTL_R = 0x00;
	GPIO_PORTH_AHB_PCTL_R = 0x00;
	GPIO_PORTJ_AHB_PCTL_R = 0x00;
	GPIO_PORTK_PCTL_R = 0x00;
	GPIO_PORTL_PCTL_R = 0x00;
	GPIO_PORTM_PCTL_R = 0x00;
	GPIO_PORTN_PCTL_R = 0x00;
	GPIO_PORTP_PCTL_R = 0x00;
	GPIO_PORTQ_PCTL_R = 0x00;

	// 4. DIR para 0 se for entrada, 1 se for saída
	GPIO_PORTA_AHB_DIR_R = 0xF0;
	GPIO_PORTH_AHB_DIR_R = 0x0F;
	GPIO_PORTJ_AHB_DIR_R = 0x00;
	GPIO_PORTK_DIR_R = 0xFF;
	GPIO_PORTL_DIR_R = 0x00;
	GPIO_PORTM_DIR_R = 0xF7; //PM3 - Saída
	GPIO_PORTN_DIR_R = 0x03; //BIT0 | BIT1
	GPIO_PORTP_DIR_R = 0x20; //PP5 - Saída
	GPIO_PORTQ_DIR_R = 0x0F;


	// 5. Limpar os bits AFSEL para 0 para selecionar GPIO sem função alternativa	
	GPIO_PORTA_AHB_AFSEL_R = 0x00;
	GPIO_PORTH_AHB_AFSEL_R = 0x00;
	GPIO_PORTJ_AHB_AFSEL_R = 0x00;
	GPIO_PORTK_AFSEL_R = 0x00; 
	GPIO_PORTL_AFSEL_R = 0x00; 
	GPIO_PORTM_AFSEL_R = 0x00; 
	GPIO_PORTN_AFSEL_R = 0x00; 
	GPIO_PORTP_AFSEL_R = 0x00; 
	GPIO_PORTQ_AFSEL_R = 0x00; 
	
		
	// 6. Setar os bits de DEN para habilitar I/O digital	
	GPIO_PORTA_AHB_DEN_R = 0xF0;
	GPIO_PORTH_AHB_DEN_R = 0x0F;
	GPIO_PORTJ_AHB_DEN_R = 0x03;
	GPIO_PORTK_DEN_R = 0xFF;
	GPIO_PORTL_DEN_R = 0x0F;
	GPIO_PORTM_DEN_R = 0xF7; //menos PM3
	GPIO_PORTN_DEN_R = 0x03; //BIT0 | BIT1
	GPIO_PORTP_DEN_R = 0x20; //PP5 - Saída
	GPIO_PORTQ_DEN_R = 0x0F;

	
	// 7. Habilitar resistor de pull-up interno, setar PUR para 1
	GPIO_PORTJ_AHB_PUR_R = 0x03;   //Bit0 e bit1	
	GPIO_PORTL_PUR_R = 0x0F; 
	
	//INTERRUPÇÃO
	GPIO_PORTJ_AHB_IM_R = 0x00;
	GPIO_PORTJ_AHB_IS_R = 0x00;
	GPIO_PORTJ_AHB_IBE_R = 0x00;
	GPIO_PORTJ_AHB_IEV_R = 0x00;
	GPIO_PORTJ_AHB_ICR_R = 0x01;
	NVIC_EN1_R = 0x80000;
	NVIC_PRI12_R = (5<<29);
	GPIO_PORTJ_AHB_IM_R = 0x1;
	
	//TIMER 
	SYSCTL_RCGCTIMER_R |= 0x04;
	while ((SYSCTL_PRTIMER_R & 0x04) == 0) {	
		
	}
	TIMER2_CTL_R &= ~(0x01u);
	TIMER2_CFG_R &= ~(0x07u);
	TIMER2_TAMR_R = (TIMER2_TAMR_R & ~(0x03u)) | 0x02;
	TIMER2_TAILR_R = 3999999;
	TIMER2_TAPR_R = 0;
	TIMER2_ICR_R |= 0x01;
	TIMER2_IMR_R |= 0x01;
	NVIC_PRI5_R = 4u << 29;
	NVIC_EN0_R = 1u << 23;
	TIMER2_CTL_R |= 0x01;
}	

// -------------------------------------------------------------------------------
// Função PortJ_Input
// Lê os valores de entrada do port J
// Parâmetro de entrada: Não tem
// Parâmetro de saída: o valor da leitura do port
uint32_t PortJ_Input(void)
{
	return GPIO_PORTJ_AHB_DATA_R;
}

// -------------------------------------------------------------------------------
// Função PortN_Output
// Escreve os valores no port N
// Parâmetro de entrada: Valor a ser escrito
// Parâmetro de saída: não tem
void PortN_Output(uint32_t valor)
{
    uint32_t temp;
    //vamos zerar somente os bits menos significativos
    //para uma escrita amigável nos bits 0 e 1
    temp = GPIO_PORTN_DATA_R & 0xFC;
    //agora vamos fazer o OR com o valor recebido na função
    temp = temp | valor;
    GPIO_PORTN_DATA_R = temp; 
}

void PortA_Output(uint32_t valor)
{
    uint32_t temp;
    //vamos zerar somente os bits mais significativos
    //para uma escrita amigável nos bits 7,6,5,4
    temp = GPIO_PORTA_AHB_DATA_R & 0x0F;
    //agora vamos fazer o OR com o valor recebido na função
    temp = temp | valor;
    GPIO_PORTA_AHB_DATA_R = temp; 
}

void PortH_Output(uint32_t valor)
{
    uint32_t temp;
    //vamos zerar somente os bits mais significativos
    //para uma escrita amigável nos bits 0,1,2,3
    temp = GPIO_PORTH_AHB_DATA_R & 0xF0;
    //agora vamos fazer o OR com o valor recebido na função
    temp = temp | valor;
    GPIO_PORTH_AHB_DATA_R = temp; 
}


void PortQ_Output(uint32_t valor)
{
    uint32_t temp;
    //vamos zerar somente os bits mais significativos
    //para uma escrita amigável nos bits 0,1,2,3
    temp = GPIO_PORTQ_DATA_R & 0xF0;
    //agora vamos fazer o OR com o valor recebido na função
    temp = temp | valor;
    GPIO_PORTQ_DATA_R = temp; 
}

void PortP_Output(uint32_t valor)
{
    uint32_t temp;
    //vamos zerar somente os bits mais significativos
    //para uma escrita amigável nos bits 5
    temp = GPIO_PORTP_DATA_R & 0xDF;
    //agora vamos fazer o OR com o valor recebido na função
    temp = temp | valor;
    GPIO_PORTP_DATA_R = temp; 
}

void LCD_init()
{
	Enviar_Comando_LCD(0x01);
	
	Enviar_Comando_LCD(0x38);
	
	Enviar_Comando_LCD(0xF);
}

void Enviar_Comando_LCD(uint32_t comando)
{
	GPIO_PORTK_DATA_R = comando;
	
	//Set_RS_0
	uint32_t tempM = GPIO_PORTM_DATA_R;
	GPIO_PORTM_DATA_R = (tempM & ~(0x01));
	
	//LCD_enalble_and_wait
	//EN = 1
	tempM = GPIO_PORTM_DATA_R;
	GPIO_PORTM_DATA_R = (tempM | (0x04));

	SysTick_Wait1ms(2);
	
	//EN = 0
	tempM = GPIO_PORTM_DATA_R;
	GPIO_PORTM_DATA_R = (tempM & ~(0x04));
	
	SysTick_Wait1ms(2);
	
	return;
}

void Escreve_no_LCD(uint8_t texto[16])
{
	for(uint8_t i = 0; i<16; i++)
	{
		GPIO_PORTK_DATA_R = texto[i];
		
	//SET_RS_1
	uint32_t tempM = GPIO_PORTM_DATA_R;
	GPIO_PORTM_DATA_R = (tempM | (0x01));
		
		//LCD_enalble_and_wait
	//EN = 1
	tempM = GPIO_PORTM_DATA_R;
	GPIO_PORTM_DATA_R = (tempM | (0x04));

	SysTick_Wait1ms(2);
	
	//EN = 0
	tempM = GPIO_PORTM_DATA_R;
	GPIO_PORTM_DATA_R = (tempM & ~(0x04));
	
	SysTick_Wait1ms(2);
	}
}

void Ler_coluna(uint32_t colunax)
{
	uint32_t tempM = GPIO_PORTM_DIR_R;
	uint32_t sel_coluna = 0x01;
	
	sel_coluna <<= colunax;
	
	tempM = (tempM & ~(0xF0));
	GPIO_PORTM_DIR_R = (tempM | sel_coluna);
	
	tempM = GPIO_PORTM_DATA_R;
	GPIO_PORTM_DATA_R = (tempM & ~(sel_coluna));
	
	return;
}

uint32_t Ler_portaL(void)
{
	return (GPIO_PORTL_DATA_R);
}

uint32_t Leitura_Teclado(void)
{
	tecla_pressionada =  0x00;
	SysTick_Wait1ms(300);
	coluna = 0x04;
	linha = 0x00;
	while(coluna < 8)
	{
		Ler_coluna(coluna);
		linha = Ler_portaL();
		uint32_t aux = ~linha;
		linha = aux & 0x0F;
		if(linha != 0x00){
			tecla_pressionada = 0x01 << (coluna-1);
			tecla_pressionada = tecla_pressionada | linha;
			break;
		}
		coluna++;
	}
	return Converte_Tecla();
}

uint32_t Converte_Tecla(void)
{
	switch(tecla_pressionada)
	{
		case 0x11:
			return 1;
			break;
		case 0x21:
			return 2;
			break;
		case 0x41:
			return 3;
			break;
		case 0x81:
			return 10;
			break;
		case 0x12:
			return 4;
			break;
		case 0x22:
			return 5;
			break;
		case 0x42:
			return 6;
			break;
		case 0x82:
			return 11;
			break;
		case 0x14:
			return 7;
			break;
		case 0x24:
			return 8;
			break;
		case 0x44:
			return 9;
			break;
		case 0x84:
			return 12;
			break;
		case 0x18:
			return 13;
			break;
		case 0x28:
			return 0;
			break;
		case 0x48:
			return 10;
			break;
		case 0x88:
			return 15;
			break;
		default:
			return 0;
			break;
	}
}


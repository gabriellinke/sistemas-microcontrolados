// main.c
// Desenvolvido para a placa EK-TM4C1294XL
// Verifica o estado das chaves USR_SW1 e USR_SW2, acende os LEDs 1 e 2 caso estejam pressionadas independentemente
// Caso as duas chaves estejam pressionadas ao mesmo tempo pisca os LEDs alternadamente a cada 500ms.
// Prof. Guilherme Peron

#include <stdint.h>
#include "tm4c1294ncpdt.h"

void PLL_Init(void);
void SysTick_Init(void);
void SysTick_Wait1ms(uint32_t delay);
void GPIO_Init(void);
uint32_t PortJ_Input(void);
void PortN_Output(uint32_t leds);
void PortA_Output(uint32_t leds);
void PortH_Output(uint32_t leds);
void PortQ_Output(uint32_t leds);
void PortP_Output(uint32_t leds);
void GPIOPortJ_Handler(void);
void Rotaciona(void);
void Liga_led(uint16_t led_aceso);
void LCD_init();
void Escreve_no_LCD(uint8_t texto[16]);
void Enviar_Comando_LCD(uint32_t comando);
void InverteLed(void);
void Inicializa(void);
void recebeVoltas();
void recebeSentido();
void recebeVelocidade();
void ImprimeDados();
void Bobina();

uint32_t Leitura_Teclado(void);
uint32_t tecla;
int32_t passo = 0;
uint32_t velocidade = 0;
int32_t led_timer = -1;
uint32_t voltas = 0;
uint32_t passo_completo[4] = { 0x03, 0x06, 0x0C, 0x09 };
uint32_t meio_passo[8] = { 0x01, 0x03, 0x02, 0x06, 0x04, 0x0C, 0x08, 0x09 };
uint32_t cont_passos = 0;
int32_t sentido = -1; // 1 = horário, -1 = anti-horário
uint16_t led_aceso = 0;
uint8_t velocidade1[16]= {"1-passo-completo"};
uint8_t velocidade2[16]= {"2-meio-passo    "};
uint8_t horario[16]= {"1-horario       "};
uint8_t antihorario[16]= {"2-anti-horario  "};
uint8_t voltas1[16]= {"Digite o numero "};
uint8_t voltas2[16]= {"   de voltas    "};
uint8_t imprimeanti[16]= {"anti-horario    "};
uint8_t imprimemeio[16]= {"meio-passo      "};
uint8_t imprimehora[16]= {"horario         "};
uint8_t imprimecomp[16]= {"passo-completo  "};
uint8_t fim[16] = {"       FIM      "};

typedef enum estados{
	Inicial,
	MenuVoltas,
	MenuSentido,
	MenuPasso,
	RotacionaMotor,
	Final,
}EstadosBobina;

EstadosBobina estado_atual;


int main(void)
{
	PLL_Init();
	SysTick_Init();
	GPIO_Init();
	LCD_init();
	while (1)
	{
		switch(estado_atual)
		{
			case Inicial:
				Inicializa();
				if(tecla == 13)
					estado_atual = MenuVoltas;
				break;
			case MenuVoltas:
				recebeVoltas();
				estado_atual = MenuSentido;
				break;
			case MenuSentido:
				recebeSentido();
				estado_atual = MenuPasso;
			case MenuPasso:
				recebeVelocidade();	
				estado_atual = RotacionaMotor;
				break;
			case RotacionaMotor:
				ImprimeDados();
				Bobina();
				estado_atual = Final;
				break;
			case Final:
				Enviar_Comando_LCD(0x01);
				Escreve_no_LCD(fim);
			  estado_atual = Inicial;
				break;
			default:
				break;
		}      
	}
}

void Liga_led(uint16_t led_aceso)
{
	switch(led_aceso)
	{
		case 0:
			PortA_Output(0x00);
			PortQ_Output(0x01);
			break;
		case 1:
			PortA_Output(0x00);
			PortQ_Output(0x02);
			break;
		case 2:
			PortA_Output(0x00);
			PortQ_Output(0x04);
			break;		
		case 3:
			PortA_Output(0x00);
			PortQ_Output(0x08);
			break;		
		case 4:
			PortA_Output(0x10);
			PortQ_Output(0x00);
			break;		
		case 5:
			PortA_Output(0x20);
			PortQ_Output(0x00);
			break;		
		case 6:
			PortA_Output(0x40);
			PortQ_Output(0x00);
			break;		
		case 7:
			PortA_Output(0x80);
			PortQ_Output(0x00);
			break;		
		default:
			PortA_Output(0x00);
			PortQ_Output(0x00);
			break;
	}
	PortP_Output(0x20); //aciona transistor
	return;
}

void Rotaciona(void)
{
	SysTick_Wait1ms(2);
	if(velocidade == 2)
		PortH_Output(meio_passo[passo]);
	else 
		PortH_Output(passo_completo[passo]);
	
	if(sentido == 1)
	{
		passo++;
		if(passo >= (4*velocidade))
				passo = 0;
	}
	else
	{
		passo--;
		if (passo < 0)
			passo = 4*velocidade - 1;
	}
	cont_passos++;
}

void GPIOPortJ_Handler()
{
	GPIO_PORTJ_AHB_ICR_R = 0x01;
	voltas=0;
	//estado_atual = Interrupcao;
}

void Timer2A_Handler()
{
	TIMER2_ICR_R = 1;
	InverteLed();
}

void InverteLed()
{
	if (estado_atual == RotacionaMotor){
		led_timer *=-1;
		if(led_timer == 1)
		{
			PortN_Output(0x1);
		}
		else if (led_timer == -1)
		{
			PortN_Output(0x0);
		}
		//TIMER2_CTL_R |= 0x01;
	}else 
	{
		PortN_Output(0x0);
	}
}

void Inicializa()
{
	tecla = 0;
	cont_passos = 0;
	passo = 0;
	voltas = 0;
	led_aceso = 0;
	tecla = Leitura_Teclado();
}

void recebeVoltas()
{
	tecla = 0;
	Enviar_Comando_LCD(0x01);
	Escreve_no_LCD(voltas1);
	Enviar_Comando_LCD(0xC0);
	Escreve_no_LCD(voltas2);
	while(tecla == 0 || tecla > 11)
	{
		tecla = Leitura_Teclado();
	}
	voltas = tecla;
	tecla = 0;
}

void recebeSentido()
{
	Enviar_Comando_LCD(0x01);
	Escreve_no_LCD(horario);
	Enviar_Comando_LCD(0xC0);
	Escreve_no_LCD(antihorario);
	//tecla = Leitura_Teclado();
	while(tecla > 2 || tecla ==0)
	{
		tecla = Leitura_Teclado();
	}
	sentido = tecla == 2 ? -1 : tecla;
	tecla = 0;
}

void recebeVelocidade()
{
	Enviar_Comando_LCD(0x01);
	Escreve_no_LCD(velocidade1);
	Enviar_Comando_LCD(0xC0);
	Escreve_no_LCD(velocidade2);
	while(tecla > 2 || tecla ==0)
	{
		tecla = Leitura_Teclado();
	}
	velocidade = tecla;
	tecla = 0;
}

void ImprimeDados()
{
	Enviar_Comando_LCD(0x01);
	if(velocidade == 1)
		Escreve_no_LCD(imprimecomp);
	else
		Escreve_no_LCD(imprimemeio);
	if(voltas == 10)
	{
		imprimehora[14] = '1';
		imprimeanti[14] = '1';
		imprimehora[15] = '0';
		imprimeanti[15] = '0';
	}
	else
	{
		imprimehora[15] = voltas+48;
		imprimeanti[15] = voltas+48;
	}
	Enviar_Comando_LCD(0xC0);
	if(sentido == 1)
		Escreve_no_LCD(imprimehora);
	else
		Escreve_no_LCD(imprimeanti);
}

void Bobina()
{
	while(voltas>0){
		Rotaciona();
		if(cont_passos%(255*velocidade)==0)
		{
			if(led_aceso == 0 && sentido == -1)
				led_aceso = 7;
			else if (led_aceso == 7 && sentido == 1)
				led_aceso = 0;
			else 
				led_aceso += sentido;
		}
		if (cont_passos >= (2048*velocidade)){
			cont_passos = 0;
			voltas--;
			imprimehora[14] = ' ';
			imprimeanti[14] = ' ';			
			imprimehora[15] = voltas+48;
			imprimeanti[15] = voltas+48;
			Enviar_Comando_LCD(0xC0);
				if(sentido == 1)
					Escreve_no_LCD(imprimehora);
				else
					Escreve_no_LCD(imprimeanti);
		}
		Liga_led(led_aceso);
	}
	Liga_led(10);
}

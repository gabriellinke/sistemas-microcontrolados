// main.c
// Desenvolvido para a placa EK-TM4C1294XL
// LAB04
// Autores: Gabriel Linke e Pedro Kiche

#include <stdint.h>
#include <stdlib.h>
#include "tm4c1294ncpdt.h"

#define CLOCKS_POR_PERIODO 80000
#define CLOCKS_POR_PORCENTO_DE_PERIODO (CLOCKS_POR_PERIODO/100)

// funções do utils.s
void PLL_Init(void);
void SysTick_Init(void);
void SysTick_Wait1ms(uint32_t delay);
void SysTick_Wait1us(uint32_t delay);

void GPIO_Init(void);
void escrevePortE(uint32_t entrada);
void escrevePortF(uint32_t entrada);
void Timer_Init(void);
void Timer1A_Handler(void);

void UART_Init(void);
void limpaTelaUart(void);
void moveCursorInicioUart(void);
void verificaCaractereUart(void);
void escreveCaractereUart(uint32_t data);
void escrevePalavraUart(const char *palavra);
void escreveNumeroUart(uint32_t numero);

void ADC_Init(void);
void atualizaValorPotenciometro(void);

void estadoAguardandoSentido(void);
void estadoAguardandoEscolhaControle(void);
void estadoVelocidadeTerminal(void);
void estadoVelocidadePotenciometro(void);

void verificaSentido(void);
void verificaControle(void);
void verificaVelocidadeTerminal(void);
void atualizaVelocidadePotenciometro(void);
void ativaMotor(void);
void desativaMotor(void);

typedef enum estados{
	AguardandoSentido,
	AguardandoEscolhaControle,
	VelocidadeTerminal,
	VelocidadePotenciometro,
} Estados;

typedef enum sentido{
	horario, 
	antiHorario,
	aguardandoSentido,
} Sentido;

typedef enum controle{
	terminal, 
	potenciometro,
	aguardandoControle,
} Controle;

typedef enum estadoPwm{
	semicicloPositivo = 1, 
	semicicloNegativo = 0,
} EstadoPwm;


Estados estadoAtual = AguardandoSentido;
Sentido sentidoMotor = aguardandoSentido;
Controle tipoControle = aguardandoControle;
EstadoPwm estadoPwm = semicicloNegativo;

uint16_t valorPotenciometro = 0; // Valor entre 0 e 4095
char caractereLidoUart = '\0';
uint32_t velocidadePercentual = 0; // Velocidade de 0 a 100%

int main(void)
{
	PLL_Init();
	SysTick_Init();
	GPIO_Init();
	UART_Init();
	ADC_Init();
	Timer_Init();
	
	while (1) {
		limpaTelaUart();
		moveCursorInicioUart();
		verificaCaractereUart();
		atualizaValorPotenciometro();
		verificaSentido();
		switch(estadoAtual) {
			case AguardandoSentido:
				estadoAguardandoSentido();
				break;
			case AguardandoEscolhaControle:
				estadoAguardandoEscolhaControle();
				break;
			case VelocidadeTerminal:
				estadoVelocidadeTerminal();
				break;
			case VelocidadePotenciometro:
				estadoVelocidadePotenciometro();
				break;
			default:
				escrevePalavraUart("Estado invalido\n");
				estadoAguardandoSentido();
				break;
		}
		SysTick_Wait1ms(250);
	}
}

// -------------------------------------------------------------------------------
// Função estadoAguardandoSentido
// Mostra as opções para o usuário escolher o sentido de rotação
void estadoAguardandoSentido(void) {
	escrevePalavraUart("Motor parado\n");
	escrevePalavraUart("Indique o sentido da rotacao: horario (h) ou anti-horario (a)\n");
	if(sentidoMotor != aguardandoSentido)
		estadoAtual = AguardandoEscolhaControle;
}

// -------------------------------------------------------------------------------
// Função estadoAguardandoEscolhaControle
// Mostra o sentido de rotação e mostra as opções para o usuário escolher
// controlar a velocidade pelo terminal ou pelo potenciômetro
void estadoAguardandoEscolhaControle(void) {
	escrevePalavraUart("Motor parado\n");
	if(sentidoMotor == horario)
		escrevePalavraUart("Sentido horario (h)\n");
	else
		escrevePalavraUart("Sentido anti-horario (a)\n");
	escrevePalavraUart("Deseja controlar a velocidade pelo terminal (t) ou potenciometro (p)?\n");
	verificaControle();
	if(tipoControle == terminal) {
		estadoAtual = VelocidadeTerminal;
		ativaMotor();
	}
	else if(tipoControle == potenciometro) {
		estadoAtual = VelocidadePotenciometro;
		ativaMotor();
	}
}

// -------------------------------------------------------------------------------
// Função estadoVelocidadeTerminal
// Mostra o sentido de rotação e a velocidade e mostra as opções de 
// configuração de velocidade do motor
void estadoVelocidadeTerminal(void) {
	verificaVelocidadeTerminal();
	if(sentidoMotor == horario)
		escrevePalavraUart("Sentido horario (h)\n");
	else
		escrevePalavraUart("Sentido anti-horario (a)\n");
	escrevePalavraUart("Controle pelo terminal. Motor girando a ");
	escreveNumeroUart(velocidadePercentual);
	escrevePalavraUart("% da velocidade maxima.\n");
	escrevePalavraUart("Escolha a velocidade da rotacao do motor: \n");
	escrevePalavraUart("0 - Parar motor (0%)\n");
	escrevePalavraUart("1 - 50% da velocidade\n");
	escrevePalavraUart("2 - 60% da velocidade\n");
	escrevePalavraUart("3 - 70% da velocidade\n");
	escrevePalavraUart("4 - 80% da velocidade\n");
	escrevePalavraUart("5 - 90% da velocidade\n");
	escrevePalavraUart("6 - 100% da velocidade\n");
}


// -------------------------------------------------------------------------------
// Função estadoVelocidadePotenciometro
// Mostra o sentido de rotação, calcula a velocidade de acordo com a leitura 
// do potenciômetro e mostra a velocidade
void estadoVelocidadePotenciometro(void) {
	if(sentidoMotor == horario)
		escrevePalavraUart("Sentido horario (h)\n");
	else
		escrevePalavraUart("Sentido anti-horario (a)\n");
	atualizaVelocidadePotenciometro();
	escrevePalavraUart("Controle pelo potenciometro. Motor girando a ");
	escreveNumeroUart(velocidadePercentual);
	escrevePalavraUart("% da velocidade maxima.\n");
}

// -------------------------------------------------------------------------------
// Função verificaSentido
// Verifica o caractere lido e altera o sentido do motor se necessário
void verificaSentido(void) {
	if(caractereLidoUart == 'h')
		sentidoMotor = horario;
	else if(caractereLidoUart == 'a')
		sentidoMotor = antiHorario;
}

// -------------------------------------------------------------------------------
// Função verificaControle
// Verifica o caractere lido e altera o tipo do controle se necessário
void verificaControle(void) {
	if(caractereLidoUart == 't')
		tipoControle = terminal;
	else if(caractereLidoUart == 'p')
		tipoControle = potenciometro;
}

// -------------------------------------------------------------------------------
// Função verificaVelocidadeTerminal
// Verifica o caractere lido e altera a velocidade do motor se necessário
void verificaVelocidadeTerminal(void) {
	if(caractereLidoUart == '0')
		velocidadePercentual = 0;
	else if(caractereLidoUart == '1')
		velocidadePercentual = 50;
	else if(caractereLidoUart == '2')
		velocidadePercentual = 60;
	else if(caractereLidoUart == '3')
		velocidadePercentual = 70;
	else if(caractereLidoUart == '4')
		velocidadePercentual = 80;
	else if(caractereLidoUart == '5')
		velocidadePercentual = 90;
	else if(caractereLidoUart == '6')
		velocidadePercentual = 100;
}

// -------------------------------------------------------------------------------
// Função atualizaVelocidadePotenciometro
// Atualiza a velocidade de acordo com o valor lido do potenciometro
void atualizaVelocidadePotenciometro(void) {
		velocidadePercentual = 100*valorPotenciometro/4095;
}

// -------------------------------------------------------------------------------
// Função ativaMotor
// Ativa o enable do motor e ativa a interrupção do timer
void ativaMotor(void) {
	// ativa enable do motor (PF2)
	escrevePortF(0x04);

	// começa parado
	estadoPwm = semicicloNegativo;
	escrevePortE(0x00);

	// ativa interrupção do PWM
	TIMER1_TAILR_R = 100 * CLOCKS_POR_PORCENTO_DE_PERIODO;
	TIMER1_ICR_R |= 0x01;
	TIMER1_CTL_R |= 0x01;
}

// -------------------------------------------------------------------------------
// Função desativaMotor
// Ativa o enable do motor e ativa a interrupção do timer
void desativaMotor(void) {
	// desativa enable do motor (PF2)
	escrevePortF(0x00);

	// para o motor
	estadoPwm = semicicloNegativo;
	escrevePortE(0x00);

	// desativa interrupção do PWM
	TIMER1_CTL_R &= (~0x01u);
}

// -------------------------------------------------------------------------------
// Função UART_Init
// Faz todas as configurações necessárias para utilização de comunicação serial entre a placa e um computador
void UART_Init(void) {
	// 1. Ativar o clock para o UART0
	uint32_t UART0 = SYSCTL_RCGCUART_R0;
	SYSCTL_RCGCUART_R = UART0;
	while ( (SYSCTL_RCGCUART_R & UART0) != UART0 ) {
		
	}
	
	UART0_CTL_R = 0;
	UART0_IBRD_R = 260;
	UART0_FBRD_R = 27;
	UART0_LCRH_R = 0x72;
	UART0_CC_R = 0;
	UART0_CTL_R = 0x301;

}

// -------------------------------------------------------------------------------
// Função leCaractereUart
// Informa que um caractere foi lido e armazena o caractere em uma variável global
void verificaCaractereUart(void) {
	if ((UART0_FR_R & 0x10) == 0x10) {
		// não há caractere para ser lido
		return;
	}
	
	caractereLidoUart = UART0_DR_R;
}

// -------------------------------------------------------------------------------
// Função escreveCaractereUart
// Imprime na tela um caractere
void escreveCaractereUart(uint32_t data) {

	while ((UART0_FR_R & 0x20) == 0x20) {
		
	}
	
	UART0_DR_R = data;
}

// -------------------------------------------------------------------------------
// Função limpaTelaUart
// limpa a tela
void limpaTelaUart(void) {
	// envia Esc[2J
	escreveCaractereUart(0x1B);
	escreveCaractereUart('[');
	escreveCaractereUart('2');
	escreveCaractereUart('J');
}

// -------------------------------------------------------------------------------
// Função moveCursorInicioUart
// move o cursor para o início da tela
void moveCursorInicioUart(void) {
	// envia Esc[;H
	escreveCaractereUart(0x1B);
	escreveCaractereUart('[');
	escreveCaractereUart(';');
	escreveCaractereUart('H');
}

// -------------------------------------------------------------------------------
// Função escrevePalavraUart
// Escreve na tela a string recebida
void escrevePalavraUart(const char *palavra) {
	while (*palavra != '\0') {
		escreveCaractereUart(*palavra);
		++palavra;
	}
}

// -------------------------------------------------------------------------------
// Função escreveNumeroUart
// Escreve o número enviado no argumento, supondo que tem no máximo 16 dígitos
void escreveNumeroUart(uint32_t numero) {
	char digitos_invertidos[16] = {'0'};
	uint32_t numero_digitos = 0;
	
	while (numero > 0) {
		digitos_invertidos[numero_digitos] = '0' + numero % 10;
		numero /= 10;
		++numero_digitos;
	}
	if (numero_digitos == 0) {
		// isso significa que é um zero
		numero_digitos = 1;
	}
	
	while (numero_digitos > 0) {
		--numero_digitos;
		escreveCaractereUart(digitos_invertidos[numero_digitos]);
	}
}

// -------------------------------------------------------------------------------
// Função ADC_Init
// Faz a inicialização do conversor AD
void ADC_Init(void) {
	// 1. Ativar o clock para o ADC
	uint32_t adc0 = SYSCTL_RCGCADC_R0;
	SYSCTL_RCGCADC_R = adc0;
	while ( (SYSCTL_PRADC_R & adc0) != adc0 ) {
		
	}
	
	ADC0_PC_R = 0x07;
	ADC0_SSPRI_R = (0 << 12) | (1 << 8) | (2 << 4) | 3;
	ADC0_ACTSS_R = 0;
	ADC0_EMUX_R = 0;
	ADC0_SSMUX3_R = 9;
	ADC0_SSCTL3_R = 6;
	ADC0_ACTSS_R = 8;
}

// -------------------------------------------------------------------------------
// Função atualizaValorPotenciometro
void atualizaValorPotenciometro(void) {
	ADC0_PSSI_R = 8;

	if (ADC0_RIS_R != 8) {
		// resultado ainda não está pronto
		// retorna sem alterar tensaoPot
		return;
	}
	
	uint32_t novoValor = ADC0_SSFIFO3_R;
	ADC0_ISC_R = 8;
	if (novoValor - valorPotenciometro < 20) {
		// se o novo valor não é muito diferente, não é escrito
		return;
	}
	valorPotenciometro = novoValor;
}

// -------------------------------------------------------------------------------
// Função Timer_Init
// Configura interrupção de estouro do timer 1 com 32 bits no modo periódico
void Timer_Init(void) {
	SYSCTL_RCGCTIMER_R |= 0x02;
	while ((SYSCTL_PRTIMER_R & 0x02) == 0) {
		
	}

	TIMER1_CTL_R &= ~(0x01u);
	TIMER1_CFG_R &= ~(0x07u);
	TIMER1_TAMR_R = (TIMER1_TAMR_R & ~(0x03u)) | 0x02;
	TIMER1_TAILR_R = 100 * CLOCKS_POR_PORCENTO_DE_PERIODO;
	TIMER1_TAPR_R = 0;
	TIMER1_ICR_R |= 0x01;
	TIMER1_IMR_R |= 0x01;
	NVIC_PRI5_R = 4u << 13;
	NVIC_EN0_R = 1u << 21;
	// não ativa até que entremos em um dos estados girando
	//TIMER1_CTL_R |= 0x01;
}

// -------------------------------------------------------------------------------
// Função Timer1A_Handler
// Faz o PWM do motor
void Timer1A_Handler(void) {
	// Se der problema, tratar diferente 0% e 100%
	uint32_t tempo = 0;
	if (velocidadePercentual == 0) {
		estadoPwm = semicicloNegativo;
		tempo = 100 * CLOCKS_POR_PORCENTO_DE_PERIODO;
	} else if (velocidadePercentual == 100) {
		estadoPwm = semicicloPositivo;
		tempo = 100 * CLOCKS_POR_PORCENTO_DE_PERIODO;
	} else {
		if (estadoPwm == semicicloNegativo) {
			estadoPwm = semicicloPositivo;
			tempo = velocidadePercentual * CLOCKS_POR_PORCENTO_DE_PERIODO;
		} else {
			estadoPwm = semicicloNegativo;
			tempo = (100 - velocidadePercentual) * CLOCKS_POR_PORCENTO_DE_PERIODO;
		}
	}

	if(sentidoMotor == horario) {
		// Escreve o PWM no bit_0 e deixa o bit_1 zerado
		escrevePortE((unsigned) estadoPwm);
	} else {
		// Escreve o PWM no bit_1 e deixa o bit_0 zerado
		escrevePortE((unsigned) estadoPwm << 1);
	}

	TIMER1_TAILR_R = tempo;
	TIMER1_ICR_R |= 0x01;
}
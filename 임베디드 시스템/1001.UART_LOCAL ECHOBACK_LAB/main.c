#include "device_driver.h"
#include <stdio.h>

static void Sys_Init(int baud) 
{
	SCB->CPACR |= (0x3 << 10*2)|(0x3 << 11*2); 
	Clock_Init();
	Uart2_Init(baud);
	setvbuf(stdout, NULL, _IONBF, 0);
	LED_Init();
}

void Main(void)
{
	Sys_Init(115200);
	printf("\nUART Echo-Back Test\n");

	Uart1_Init(115200);

	char x, y;

	for(x = 'A'; x <= 'Z'; x++)
	{
		// 송신 버퍼가 비면 x의 글자를 출력
		while(!Macro_Check_Bit_Set(USART1->SR,7));
		// Uart1_Send_Byte('Z');
		USART1->DR = x;
		// 수신 버퍼에 글자가 입력되면 y에 글자를 수신

		while(!Macro_Check_Bit_Set(USART1->SR,5));
		y = USART1->DR;
		printf("%c ", y);
	}
}

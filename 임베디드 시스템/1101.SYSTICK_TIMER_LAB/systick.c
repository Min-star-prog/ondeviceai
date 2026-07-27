#include "device_driver.h"

void SysTick_Run(unsigned int msec)
{
	// Timer 설정 : 
Macro_Clear_Bit(SysTick->CTRL,1);	//인터럽트 발생 안함, 
Macro_Clear_Bit(SysTick->CTRL,2); 
//clock source는 HCLK/8 = 1초에 HCLK/8 pulse가 만들어진다는 거임
Macro_Clear_Bit(SysTick->CTRL,0); //Timer 정지
	// 주어진 msec 값 만큼의 msec를 count하는 초기값 설정 (LOAD)
Macro_Write_Block(SysTick->LOAD,0xffffff,(HCLK / 8 / 1000 * msec) - 1,0);
	// VAL 레지스터 값 초기화(0) 및 COUNTFLAG Clear
SysTick->VAL= 0;
	// Timer Start (시작이 되면 자동으로 LOAD의 값을 VAL로 가져간다)
Macro_Set_Bit(SysTick->CTRL,0);
}

int SysTick_Check_Timeout(void)
{
	// Timer의 Timeout이 발생하면 참(1)리턴, 아니면 거짓(0) 리턴
	return Macro_Check_Bit_Set(SysTick->CTRL,16);	//COUNTFLAG
}

unsigned int SysTick_Get_Time(void)
{
	// Timer의 현재 count 값 리턴
	return Macro_Extract_Area(SysTick->VAL,0xffffff,0);

}

unsigned int SysTick_Get_Load_Time(void)
{
	// Timer에 설정된 초기값을 리턴
	return Macro_Extract_Area(SysTick->LOAD,0xffffff,0);

}

void SysTick_Stop(void)
{
	// Timer Stop
	Macro_Clear_Bit(SysTick->CTRL,0);
}


// #include "device_driver.h"
// #include <stdio.h>

// static void Sys_Init(int baud)
// {
// 	SCB->CPACR |= (0x3 << 10 * 2) | (0x3 << 11 * 2);
// 	Clock_Init();
// 	Uart2_Init(baud);
// 	setvbuf(stdout, NULL, _IONBF, 0);
// 	LED_Init();
// }

// void Main(void)
// {
// 	Sys_Init(115200);
// 	printf("SysTick 시간 측정 test\n");
// 	// Uart1_Init(115200);	// UART 초기화

// 	volatile int i, j;
// 	unsigned int cnt;
// 	int arr = 500;
// 	char rx;
// 	int led_state = 0;
// 	SysTick_Run(arr);

// 	for (;;)
// 	{
// 		if (Macro_Check_Bit_Set(USART2->SR, 5)) // rx
// 		{
// 			rx = USART2->DR;
// 			if (rx == 'u')
// 			{
// 				arr = arr - 100;
// 				SysTick_Run(arr);
// 			}
// 			else if (rx == 'd')
// 			{
// 				arr = arr + 100;
// 				SysTick_Run(arr);
// 			}
// 			else if (rx == 's')
// 			{
// 				Macro_Invert_Bit(SysTick->CTRL, 0);
// 			}
// 		}
// 		if (Macro_Check_Bit_Set(SysTick->CTRL, 16))
// 		{
			
// 			switch (led_state)
// 			{
// 				/* LED 반전 및 Delay, */
// 				//  초기화
// 			case 0:
// 				Macro_Clear_Bit(GPIOA->ODR, 5);
// 				Macro_Clear_Bit(GPIOA->ODR, 6);
// 				Macro_Clear_Bit(GPIOA->ODR, 7);
// 				break;

// 			case 1:
// 				Macro_Invert_Bit(GPIOA->ODR, 5);
// 				break;

// 			case 2:
// 				Macro_Invert_Bit(GPIOA->ODR, 5);
// 				Macro_Invert_Bit(GPIOA->ODR, 6);
// 				break;

// 			case 3:
// 				Macro_Invert_Bit(GPIOA->ODR, 7);
// 				Macro_Invert_Bit(GPIOA->ODR, 6);
// 				printf("PING");
// 				break;
// 			case 4:
// 				Macro_Invert_Bit(GPIOA->ODR, 7);
// 				Macro_Invert_Bit(GPIOA->ODR, 6);
// 				break;

// 			case 5:
// 				Macro_Invert_Bit(GPIOA->ODR, 5);
// 				Macro_Invert_Bit(GPIOA->ODR, 6);
// 				printf("PONG");
// 				break;
// 			}
// 			led_state++;

// 			if(led_state >= 6) {led_state=0;}
// 		}
// 	}
// }

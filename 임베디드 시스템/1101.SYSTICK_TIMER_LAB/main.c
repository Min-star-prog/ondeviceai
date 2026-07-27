#include "device_driver.h"
#include <stdio.h>
#include <string.h>

static void Sys_Init(int baud)
{
	SCB->CPACR |= (0x3 << 10 * 2) | (0x3 << 11 * 2);
	Clock_Init();
	Uart2_Init(baud);
	setvbuf(stdout, NULL, _IONBF, 0);
	LED_Init();
}

// //과제 1번
// void Main(void)
// {
// 	Sys_Init(115200);
// 	printf("SysTick 시간 측정 test\n");
// 	// Uart1_Init(115200);	// UART 초기화

// 	volatile int i, j;
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

// 과제 2번

// 과제 2번

void Main(void)
{
	Sys_Init(115200);
	printf("SysTick 시간 측정 test\n");
	// Uart1_Init(115200);	// UART 초기화

	volatile int i, j;
	unsigned int start_flag;
	int arr = 500;
	int current_time = 0;
	char rx;
	Macro_Set_Bit(RCC->AHB1ENR, 2);
	Macro_Write_Block(GPIOC->MODER, 0x3, 0x0, 14);
	Macro_Write_Block(GPIOC->PUPDR, 0x3, 0x1, 14);
	Macro_Write_Block(GPIOC->MODER, 0x3, 0x0, 26);
	Macro_Write_Block(GPIOC->PUPDR, 0x3, 0x1, 26);

	for (;;)
	{
		printf("Press Key 1 to Start!\n");
		// 1. 게임 대기
		SysTick_Run(500);
		while (Macro_Check_Bit_Set(GPIOC->IDR, 7))
		{
			if (SysTick_Check_Timeout())
			{
				Macro_Invert_Bit(GPIOA->ODR, 5);
				Macro_Invert_Bit(GPIOA->ODR, 6);
				Macro_Invert_Bit(GPIOA->ODR, 7);
				SysTick_Run(500);
			}
		}
		arr = 500 + (SysTick_Get_Time() % 501);

		SysTick_Stop();
		// 2. 게임 시작
		Macro_Set_Bit(GPIOA->ODR, 5);
		Macro_Set_Bit(GPIOA->ODR, 6);
		Macro_Set_Bit(GPIOA->ODR, 7);
		start_flag = 0;
		SysTick_Run(arr); // 무작위 시간 대기로 바꿔야됨

		while (!SysTick_Check_Timeout())
		{
			if (Macro_Check_Bit_Clear(GPIOC->IDR, 13))
			{
				SysTick_Stop();
				printf("Foul Play!");
				start_flag = 1;
				break;
			}
		}

		SysTick_Stop();
		if (start_flag == 1)
		{
			continue;
		}
		// 3. 신호 빌셍
		Macro_Clear_Bit(GPIOA->ODR, 5);
		Macro_Clear_Bit(GPIOA->ODR, 6);
		Macro_Clear_Bit(GPIOA->ODR, 7);
		printf("Press KEY NOW!\n");
		current_time = 0;
		SysTick_Run(1000);

		// 4. 입력 및 기록 측정
		while (Macro_Check_Bit_Set(GPIOC->IDR, 13))
		{
			if (SysTick_Check_Timeout())
			{
				current_time += 1000;

				SysTick_Run(1000);
			}
		}

		SysTick_Stop();
		current_time +=
			(SysTick_Get_Load_Time() - SysTick_Get_Time()) / (HCLK / 8 / 1000);

		// 5. 결과 출력
		printf("Your reaction time : %d ms!\n", current_time);
	}
}

// 과제 3번

// 글자가 입력될 때마다 버퍼에 저장하고,

// void Main(void)
// {
// 	Sys_Init(115200);
// 	printf("UART CLI Controller\n");

// 	volatile int i;
// 	int arr = 500;
// 	int index = 0;
// 	char rx;
// 	char rx_buffer[20];
// 	// char tx_buffer[20];
// 	int sec;
// 	int led_num;
// 	int led_key_state[5] = {0,0,0,0,0};
// 	int sec_state = 0;
	
// 	Macro_Set_Bit(RCC->AHB1ENR, 2);
// 	Macro_Write_Block(GPIOC->MODER, 0x3, 0x0, 14);
// 	Macro_Write_Block(GPIOC->PUPDR, 0x3, 0x1, 14);
// 	Macro_Write_Block(GPIOC->MODER, 0x3, 0x0, 26);
// 	Macro_Write_Block(GPIOC->PUPDR, 0x3, 0x1, 26);



// 	for(;;){
// 		rx = 0;
// 		index = 0;
// 		sec_state =0;
// 		for(;;){
// 	while ((rx != '\n') && (rx != '\r'))
// 	{
// 		if (Macro_Check_Bit_Set(USART2->SR, 5)) // rx
// 		{
// 			rx = USART2->DR;
// 			rx_buffer[index] = rx;
// 			index++;
// 		}
// 	}
// 	break;
// }
// 	// 엔터 키(\r 또는 \n)가 입력되면 명령어를 해석(Parsing)합니다
// 	rx_buffer[index-1] = '\0';

// 	if (strcmp(rx_buffer, "help") == 0)
// 	{
// 		printf("led on [번호], led off [번호], status, timer [초]");
// 	}
// 	// led on
// 	else if (sscanf(rx_buffer, "led on %d", &led_num) == 1)
// 	{
// 		Macro_Set_Bit(GPIOA->ODR, led_num + 4);
// 		led_key_state[led_num - 1] = 1;
// 	}
// 	// led off
// 	else if (sscanf(rx_buffer, "led off %d", &led_num) == 1)
// 	{
// 		Macro_Clear_Bit(GPIOA->ODR, led_num + 4);
// 		led_key_state[led_num - 1] = 0;
// 	}
// 	// status
// 	else if (strcmp(rx_buffer, "status") == 0)
// 	{
// 		led_key_state[3] = Macro_Check_Bit_Clear(GPIOC->IDR, 7);
// 		led_key_state[4] = Macro_Check_Bit_Clear(GPIOC->IDR, 13);
// 		printf("LED 1 : %s\n", led_key_state[0] ? "ON" : "OFF");
// 		printf("LED 2 : %s\n", led_key_state[1] ? "ON" : "OFF");
// 		printf("LED 3 : %s\n", led_key_state[2] ? "ON" : "OFF");
// 		printf("Key 1 : %s\n", led_key_state[3] ? "ON" : "OFF");
// 		printf("Key 2 : %s\n", led_key_state[4] ? "ON" : "OFF");
// 	}
// 	// timer
// 	else if (sscanf(rx_buffer, "timer %d", &sec) == 1)
// 	{
// 		SysTick_Run(1000);
// 		while (sec_state != sec)
// 		{
// 			if (SysTick_Check_Timeout())
// 			{
// 				sec_state++;
// 			}
// 		}
// 		for (i = 0; i < 6; i++)
// 		{
// 			SysTick_Run(100);
// 			while (!SysTick_Check_Timeout());
// 			SysTick_Stop();
// 				Macro_Invert_Bit(GPIOA->ODR, 5);
// 				Macro_Invert_Bit(GPIOA->ODR, 6);
// 				Macro_Invert_Bit(GPIOA->ODR, 7);
// 		}
// 	}
// }
// }
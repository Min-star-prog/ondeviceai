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

volatile int Key_Pressed = 0;
volatile int Uart_Data_In = 0;
volatile unsigned char Uart_Data = 0;
volatile int TIM4_Expired = 0;

// void Main(void)
// {
// 	Sys_Init(115200);
// 	printf("\nTimer 4 Interrupt Test\n");

// 	Key_ISR_Enable(1);
// 	Uart2_RX_Interrupt_Enable(1);
// 	TIM4_Repeat_Interrupt_Enable(1, 200);

// 	int d = 0;

// 	for(;;)
// 	{
// 		if(Key_Pressed)
// 		{
// 			printf("KEY Pressed!!!\n");
// 			Key_Pressed = 0;
// 		}

// 		if(Uart_Data_In)
// 		{
// 			printf("RX Data = %c\n", Uart_Data);
// 			Uart_Data_In = 0;
// 		}

// 		if(TIM4_Expired)
// 	    {
// 			(d ^= 1) ? LED_On() : LED_Off();
// 			TIM4_Expired = 0;
// 	    }
// 	}
// }

// //과제 1번
// void Main(void)
// {
// 	Sys_Init(115200);
// 	printf("SysTick 시간 측정 test\n");
// 	// Uart1_Init(115200);	// UART 초기화

// 	// Key_ISR_Enable(1);
// 	Uart2_RX_Interrupt_Enable(1);
// 	TIM4_Repeat_Interrupt_Enable(1, 200);

// 	int led_state = 0;

// 	for (;;)
// 	{
// 		if (Uart_Data_In) // rx
// 		{
// 			Uart_Data_In=0;
// 			if (Uart_Data  == 'u')
// 			{
// 				TIM4->ARR = TIM4->ARR - 10000;

// 			}
// 			else if (Uart_Data  == 'd')
// 			{
// 				TIM4->ARR = TIM4->ARR + 10000;
// 			}
// 			else if (Uart_Data  == 's')
// 			{
// 				Macro_Invert_Bit(TIM4->CR1, 0);
// 			}
// 		}
// 		if (TIM4_Expired)
// 		{
// 			TIM4_Expired = 0;

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

// 			if(led_state >= 6) {
// 				led_state=0;
// 			}
// 		}
// 	}
// }

// 과제 2번

// void Main(void)
// {
// 	Sys_Init(115200);
// 	printf("SysTick 시간 측정 test를 interrupt로\n");
// 	// Uart1_Init(115200);	// UART 초기화

// 	int arr = 500;

// 	Key_ISR_Enable(1);
// 	Uart2_RX_Interrupt_Enable(1);

// 	volatile int i, j;
// 	unsigned int start_flag;
// 	int current_time = 0;
// 	Macro_Set_Bit(RCC->AHB1ENR, 2);
// 	Macro_Write_Block(GPIOC->MODER, 0x3, 0x0, 14);
// 	Macro_Write_Block(GPIOC->PUPDR, 0x3, 0x1, 14);
// 	Macro_Write_Block(GPIOC->MODER, 0x3, 0x0, 26);
// 	Macro_Write_Block(GPIOC->PUPDR, 0x3, 0x1, 26);

// 	for (;;)
// 	{
// 		printf("Press Key 1 to Start!\n");
// 		// 1. 게임 대기
// 		// SysTick_Run(500);
// 		Key_Pressed = 0;
// 		TIM4_Expired = 0;
// 		TIM4_Repeat_Interrupt_Enable(1, 200);
// 		while (Macro_Check_Bit_Set(GPIOC->IDR, 7))
// 		{
// 			if (TIM4_Expired)
// 			{
// 				TIM4_Expired = 0;
// 				Macro_Invert_Bit(GPIOA->ODR, 5);
// 				Macro_Invert_Bit(GPIOA->ODR, 6);
// 				Macro_Invert_Bit(GPIOA->ODR, 7);
// 			}
// 		}
// 		arr = 500 + (TIM4->CNT % 501);


// 		//  * 200ms 반복 타이머 종료/
// 		TIM4_Repeat_Interrupt_Enable(0, 0);
// 		// 2. 게임 시작
// 		Macro_Set_Bit(GPIOA->ODR, 5);
// 		Macro_Set_Bit(GPIOA->ODR, 6);
// 		Macro_Set_Bit(GPIOA->ODR, 7);
// 		start_flag = 0;
// 		Key_Pressed = 0;
// 		TIM4_Expired = 0;

// 		TIM4_Repeat_Interrupt_Enable(1, arr);
// 		while (!TIM4_Expired)
// 		{
// 			if (Key_Pressed)
// 			{
// 				TIM4_Stop();
// 				printf("Foul Play!");
// 				start_flag = 1;
// 				break;
// 			}
// 		}

// 		//TIMER 초기화 + stop
// 		TIM4_Repeat_Interrupt_Enable(0,0);
// 		TIM4_Expired = 0;

// 		if (start_flag == 1)
// 		{
// 			continue;
// 		}
// 		// 3. 신호 빌셍
// 		Macro_Clear_Bit(GPIOA->ODR, 5);
// 		Macro_Clear_Bit(GPIOA->ODR, 6);
// 		Macro_Clear_Bit(GPIOA->ODR, 7);
// 		printf("Press KEY NOW!\n");
// 		current_time = 0;

// 		TIM4_Expired = 0;
// 		TIM4_Repeat_Interrupt_Enable(1, 1000);
// 		Macro_Set_Bit(TIM4->CR1, 0);

// 		Key_Pressed = 0;
// 		// 4. 입력 및 기록 측정
// 		while (!Key_Pressed)
// 		{
// 			if (TIM4_Expired)
// 			{
// 				TIM4_Expired = 0;
// 				current_time += 1000;
// 			}
// 		}
// 		current_time +=
// 			(TIM4->ARR - TIM4->CNT) / 50;

// 		// 5. 결과 출력
// 		printf("Your reaction time : %d ms!\n", current_time);
// 	}
// }

// 과제 3번

// 글자가 입력될 때마다 버퍼에 저장하고,

// void Main(void)
// {
// 	Sys_Init(115200);
// 	printf("UART CLI Controller\n");
// volatile int i;
// int index = 0;
// char rx;
// char rx_buffer[20];
// int sec;
// int led_num;
// int led_key_state[5] = {0, 0, 0, 0, 0};
// int sec_state = 0;
// int led_save;

// /* PC7, PC13 입력 설정 */
// Macro_Set_Bit(RCC->AHB1ENR, 2);

// Macro_Write_Block(GPIOC->MODER, 0x3, 0x0, 14);
// Macro_Write_Block(GPIOC->PUPDR, 0x3, 0x1, 14);

// Macro_Write_Block(GPIOC->MODER, 0x3, 0x0, 26);
// Macro_Write_Block(GPIOC->PUPDR, 0x3, 0x1, 26);

// /*
//  * Key 인터럽트는 필요 없음.
//  * status 명령이 들어왔을 때 IDR을 직접 읽으면 됨.
//  */
// Uart2_RX_Interrupt_Enable(1);

// for (;;)
// {
// 	rx = 0;
// 	index = 0;
// 	sec_state = 0;

// 	/* UART 인터럽트로 받은 문자를 명령어 버퍼에 저장 */
// 	while (1)
// 	{
// 		if (Uart_Data_In)
// 		{
// 			Uart_Data_In = 0;

// 			/* 반드시 Uart_Data를 rx에 저장해야 함 */
// 			rx = (char)Uart_Data;

// 			/* Enter 입력 */
// 			if ((rx == '\r') || (rx == '\n'))
// 			{
// 				/*
// 				 * 터미널이 \r\n을 연속으로 보낼 경우
// 				 * 빈 명령어는 무시
// 				 */
// 				if (index == 0)
// 				{
// 					continue;
// 				}

// 				break;
// 			}

// 			/* 버퍼 범위를 넘지 않을 때만 저장 */
// 			if (index < (sizeof(rx_buffer) - 1))
// 			{
// 				rx_buffer[index] = rx;
// 				index++;
// 			}
// 		}
// 	}

// 	/* 문자열 마지막에 NULL 저장 */
// 	rx_buffer[index] = '\0';

// 	/* help */
// 	if (strcmp(rx_buffer, "help") == 0)
// 	{
// 		printf("led on [1-3]\n");
// 		printf("led off [1-3]\n");
// 		printf("status\n");
// 		printf("timer [sec]\n");
// 	}

// 	/* led on */
// 	else if (sscanf(rx_buffer, "led on %d", &led_num) == 1)
// 	{
// 		if ((led_num >= 1) && (led_num <= 3))
// 		{
// 			/*
// 			 * LED Active Low
// 			 * ODR = 0이면 LED ON
// 			 */
// 			Macro_Clear_Bit(GPIOA->ODR, led_num + 4);

// 			printf("LED %d ON\n", led_num);
// 		}
// 		else
// 		{
// 			printf("LED number must be 1 ~ 3\n");
// 		}
// 	}

// 	/* led off */
// 	else if (sscanf(rx_buffer, "led off %d", &led_num) == 1)
// 	{
// 		if ((led_num >= 1) && (led_num <= 3))
// 		{
// 			/*
// 			 * LED Active Low
// 			 * ODR = 1이면 LED OFF
// 			 */
// 			Macro_Set_Bit(GPIOA->ODR, led_num + 4);

// 			printf("LED %d OFF\n", led_num);
// 		}
// 		else
// 		{
// 			printf("LED number must be 1 ~ 3\n");
// 		}
// 	}

// 	/* status */
// 	else if (strcmp(rx_buffer, "status") == 0)
// 	{
// 		/*
// 		 * 배열에 저장된 과거 상태가 아니라
// 		 * 실제 GPIO 레지스터 상태를 읽음
// 		 */
// 		led_key_state[0] =
// 			Macro_Check_Bit_Clear(GPIOA->ODR, 5);

// 		led_key_state[1] =
// 			Macro_Check_Bit_Clear(GPIOA->ODR, 6);

// 		led_key_state[2] =
// 			Macro_Check_Bit_Clear(GPIOA->ODR, 7);

// 		/* Key는 Pull-up이므로 0이면 눌림 */
// 		led_key_state[3] =
// 			Macro_Check_Bit_Clear(GPIOC->IDR, 7);

// 		led_key_state[4] =
// 			Macro_Check_Bit_Clear(GPIOC->IDR, 13);

// 		printf("LED 1 : %s\n",
// 			   led_key_state[0] ? "ON" : "OFF");

// 		printf("LED 2 : %s\n",
// 			   led_key_state[1] ? "ON" : "OFF");

// 		printf("LED 3 : %s\n",
// 			   led_key_state[2] ? "ON" : "OFF");

// 		printf("Key 1 : %s\n",
// 			   led_key_state[3] ? "PRESSED" : "RELEASED");

// 		printf("Key 2 : %s\n",
// 			   led_key_state[4] ? "PRESSED" : "RELEASED");
// 	}

// 	/* timer */
// 	else if (sscanf(rx_buffer, "timer %d", &sec) == 1)
// 	{
// 		if (sec < 0)
// 		{
// 			printf("Timer value must be 0 or greater\n");
// 		}
// 		else
// 		{
// 			/*
// 			 * 입력한 시간만큼 대기
// 			 * TIM4 인터럽트가 1000ms마다 발생
// 			 */
// 			TIM4_Expired = 0;
// 			sec_state = 0;

// 			TIM4_Repeat_Interrupt_Enable(1, 1000);

// 			while (sec_state < sec)
// 			{
// 				if (TIM4_Expired)
// 				{
// 					TIM4_Expired = 0;
// 					sec_state++;
// 				}
// 			}

// 			/* 1초 타이머 중지 */
// 			TIM4_Repeat_Interrupt_Enable(0, 0);
// 			TIM4_Expired = 0;

// 			/*
// 			 * 깜빡이기 전 PA5~PA7 상태 저장
// 			 */
// 			led_save =
// 				Macro_Extract_Area(GPIOA->ODR, 0x7, 5);

// 			/*
// 			 * Active Low이므로 모두 1로 만들어
// 			 * LED 3개를 먼저 OFF 상태로 맞춤
// 			 */
// 			Macro_Set_Area(GPIOA->ODR, 0x7, 5);

// 			/*
// 			 * 100ms마다 LED 상태 변경
// 			 */
// 			TIM4_Repeat_Interrupt_Enable(1, 100);

// 			for (i = 0; i < 6; i++)
// 			{
// 				/* 인터럽트 발생할 때까지 대기 */
// 				while (!TIM4_Expired);

// 				TIM4_Expired = 0;

// 				/*
// 				 * PA5, PA6, PA7을 한 번에 반전
// 				 * ON/OFF 6회 = 3번 깜빡임
// 				 */
// 				Macro_Invert_Area(GPIOA->ODR, 0x7, 5);
// 			}

// 			/* 타이머 중지 */
// 			TIM4_Repeat_Interrupt_Enable(0, 0);
// 			TIM4_Expired = 0;

// 			/* 깜빡이기 전 LED 상태로 복구 */
// 			Macro_Write_Block(GPIOA->ODR,
// 							  0x7,
// 							  led_save,
// 							  5);

// 			printf("Timer completed\n");
// 		}
// 	}

// 	else
// 	{
// 		printf("Unknown command\n");
// 	}
// }
// }
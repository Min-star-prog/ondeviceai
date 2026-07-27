#ifndef DEVICE_DRIVER_H
#define DEVICE_DRIVER_H

#include "stm32f4xx.h"
#include "option.h"
#include "macro.h"
#include "malloc.h"

/* UART */
extern void Uart2_Init(int baud);
extern void Uart2_Send_Byte(char data);
extern void Uart2_RX_Interrupt_Enable(int en);

extern void Uart1_Init(int baud);
extern void Uart1_Send_Byte(char data);
extern void Uart1_Send_String(char *pt);
extern void Uart1_Printf(char *fmt, ...);
extern char Uart1_Get_Char(void);
extern char Uart1_Get_Pressed(void);

/* SysTick */
extern void SysTick_Run(unsigned int msec);
extern int SysTick_Check_Timeout(void);
extern unsigned int SysTick_Get_Time(void);
extern unsigned int SysTick_Get_Load_Time(void);
extern void SysTick_Stop(void);

/* LED: PA5 green, PA6 yellow, PA7 red, active high */
extern void LED_Init(void);
extern void LED_On(void);
extern void LED_Off(void);
extern void Green_LED_On(void);
extern void Green_LED_Off(void);
extern void Yellow_LED_On(void);
extern void Yellow_LED_Off(void);
extern void Red_LED_On(void);
extern void Red_LED_Off(void);

/* Clock */
extern void Clock_Init(void);

/* Key: external active-low button on PC13 */
extern void Key_Poll_Init(void);
extern int Key_Get_Pressed(void);
extern void Key_Wait_Key_Released(void);
extern void Key_Wait_Key_Pressed(void);
extern void Key_ISR_Enable(int en);

/* Existing timer driver */
extern void TIM2_Delay(int time);
extern void TIM2_Stopwatch_Start(void);
extern unsigned int TIM2_Stopwatch_Stop(void);
extern void TIM4_Repeat(int time);
extern int TIM4_Check_Timeout(void);
extern void TIM4_Stop(void);
extern void TIM4_Change_Value(int time);
extern void TIM4_Repeat_Interrupt_Enable(int en, int time);
extern void TIM3_Out_Init(void);
extern void TIM3_Out_Freq_Generation(unsigned short freq);
extern void TIM3_Out_Stop(void);

/* ADC: light sensor analog output on PA4 = ADC1_IN4 */
extern void ADC1_IN4_Init(void);
extern void ADC1_IN6_Init(void); /* retained for old exercises */
extern void ADC1_Start(void);
extern void ADC1_Stop(void);
extern int ADC1_Get_Status(void);
extern int ADC1_Get_Data(void);

/* HC-SR04: TRIG PA8, ECHO PA0 */
extern void Ultrasonic_Init(void);
extern int Ultrasonic_Read_DistanceCm(void);

/* 28BYJ-48 + ULN2003: IN1 PC0, IN2 PC1, IN3 PC4, IN4 PC5 */
extern void StepMotor_Init(void);
extern void StepMotor_Open(void);
extern void StepMotor_Close(void);
extern void StepMotor_Stop(void);
extern int StepMotor_IsBusy(void);
extern int StepMotor_IsOpen(void);
extern int StepMotor_IsClosed(void);
extern int StepMotor_Get_Position(void);
extern int StepMotor_Get_Target(void);
extern void StepMotor_Timer_Handler(void);

/* Existing I2C/SPI functions */
#define SC16IS752_IODIR     0x0A
#define SC16IS752_IOSTATE   0x0B
extern void I2C1_SC16IS752_Init(unsigned int freq);
extern void I2C1_SC16IS752_Write_Reg(unsigned int addr, unsigned int data);
extern void I2C1_SC16IS752_Config_GPIO(unsigned int config);
extern void I2C1_SC16IS752_Write_GPIO(unsigned int data);
extern void SPI1_SC16IS752_Init(unsigned int div);
extern void SPI1_SC16IS752_Write_Reg(unsigned int addr, unsigned int data);
extern void SPI1_SC16IS752_Config_GPIO(unsigned int config);
extern void SPI1_SC16IS752_Write_GPIO(unsigned int data);

#endif

/*
 * StopWatch.c
 *
 *  Created on: 2026. 6. 24.
 *      Author: kccistc
 */


#include "StopWatch.h"

typedef struct {
	uint8_t hour;
	uint8_t min;
	uint8_t sec;
	uint8_t ms;
} StopWatch_t;
StopWatch_e StopWatchState;
uint32_t counter;
uint32_t StopWatchLed;
uint32_t StopWatchStateLed;
StopWatch_t StopWatchTimeData;


uint8_t rx_data;

void StopWatch_Init()
{

	LED_Init();
	FND_Init();
	Button_Init();

	StopWatchState = STOP;
	StopWatchStateLed = 0;
	counter =0;
	StopWatchLed = 0x01;   // LED[0]부터 시작
	rx_data = 0;


	StopWatchTimeData.hour = 0;
	StopWatchTimeData.min = 0;
	StopWatchTimeData.sec = 0;
	StopWatchTimeData.ms = 0;
}


void StopWatch_Execute()
{
	StopWatch_RunTime();
	StopWatch_ControlState();
	StopWatch_DispWatch();
}

void StopWatch_DispWatch()
{

	if(StopWatchTimeData.ms%10 < 5) {
		FND_SetDP(FND_DIGIT_1,FND_DP_ON);
	}
	else {

		FND_SetDP(FND_DIGIT_1,FND_DP_OFF);
	}
	if(StopWatchTimeData.ms < 50) {
		FND_SetDP(FND_DIGIT_3,FND_DP_ON);
	}
	else {

		FND_SetDP(FND_DIGIT_3,FND_DP_OFF);
	}
	FND_SetNum(
			(StopWatchTimeData.min%10 *1000)+
			(StopWatchTimeData.sec *10)+
			(StopWatchTimeData.ms/10%10)
	);
	StopWatch_ControlLed();
}

void StopWatch_ControlState()
{
	switch (StopWatchState)	{
	case STOP:
		if(Button_GetState(&hbtnRunStop) == ACT_PUSHED)
		{
			StopWatchState = RUN;
		}
		else if(Button_GetState(&hbtnClear) == ACT_PUSHED)
		{
			StopWatchState = CLEAR;
		}
		else if(rx_data == 'r') {
			rx_data =0;
			StopWatchState = RUN;
		}
		else if(rx_data == 'c') {
			rx_data =0;
			StopWatchState = CLEAR;
		}
		break;
	case RUN:
		if(Button_GetState(&hbtnRunStop) == ACT_PUSHED)
		{
			StopWatchState = STOP;
		}
		else if(rx_data == 'r') {
			rx_data =0;
			StopWatchState = STOP;
		}
		break;
	case CLEAR:
		StopWatchState = STOP;
		StopWatch_ClearTime();
		break;
	default:
		StopWatchState = STOP;
		break;
	}
}

void StopWatch_ClearTime()
{

	StopWatchTimeData.ms =0;
	StopWatchTimeData.sec =0;
	StopWatchTimeData.min =0;
	StopWatchTimeData.hour =0;
}

void StopWatch_IncTime()
{
	if (StopWatchTimeData.ms == 99){
		StopWatchTimeData.ms =0;
	}
	else{
		StopWatchTimeData.ms++;
		return;
	}

	if (StopWatchTimeData.sec == 59){
		StopWatchTimeData.sec =0;
	}
	else{
		StopWatchTimeData.sec++;
		return;
	}

	if (StopWatchTimeData.min == 59){
		StopWatchTimeData.min =0;
	}
	else{
		StopWatchTimeData.min++;
		return;
	}

	if (StopWatchTimeData.hour == 23){
		StopWatchTimeData.hour =0;
	}
	else{
		StopWatchTimeData.hour++;
		return;
	}
}


void StopWatch_RunTime()
{
	static uint32_t prevTime = 0;
	uint32_t curTime = millis();

	if(curTime - prevTime <10) return;
	prevTime = curTime;

	if(StopWatchState == RUN)	{
		counter++;
		StopWatch_IncTime();
	}
}




void StopWatch_ControlLed()
{
	switch (StopWatchState)	{
	case STOP:
		StopWatch_StopLed();
		break;
	case RUN:
		StopWatch_RunLed();
		break;
	case CLEAR:
		StopWatch_ClearLed();
		break;
	default:
		break;
	}

}


void StopWatch_RunLed()
{
	static uint32_t prevTime = 0;
	uint32_t curTime = millis();


	StopWatchStateLed |= (1 << RUN_STATE_LED);
	StopWatchStateLed &= ~(1 << STOP_STATE_LED);
	LED_WritePort8(LED_HI_GPIO, StopWatchStateLed);

	if(curTime - prevTime <100) return;
	prevTime = curTime;

	StopWatchLed = (StopWatchLed << 1) | (StopWatchLed >> 7);
	LED_WritePort8(LED_LOW_GPIO, StopWatchLed);
}

void StopWatch_StopLed()
{
	StopWatchStateLed |= (1 << STOP_STATE_LED);
	StopWatchStateLed &= ~(1 << RUN_STATE_LED);
	LED_WritePort8(LED_HI_GPIO, StopWatchStateLed);
}

void StopWatch_ClearLed()
{
	StopWatchLed = 0x01;
	LED_WritePort8(LED_LOW_GPIO, StopWatchLed);
}


///*
// * StopWatch.c
// *
// *  Created on: 2026. 6. 24.
// *      Author: kccistc
// */
//
//
//#include "StopWatch_ex.h"
//#define STOP_STATE_LED 	5
//#define RUN_STATE_LED 	7
//
//
//StopWatch_e StopWatchState;
//uint32_t counter;
//uint32_t StopWatchLed;
//uint32_t StopWatchStateLed;
//uint32_t hour;
//uint32_t min;
//uint32_t sec;
//
//
//
//void StopWatch_Init()
//{
//
//	LED_Init();
//	FND_Init();
//	Button_Init();
//	StopWatchState = STOP;
//	StopWatchStateLed = 0;
//	counter =0;
//	hour = 0;
//	min = 0;
//	sec = 0;
//	StopWatchLed = 0x01;   // LED[0]부터 시작
//}
//
//
//void StopWatch_Execute()
//{
//	StopWatch_ControlState();
//	StopWatch_RunTime();
//	StopWatch_UpdateDot();
//	FND_SetNum(StopWatch_GetFndNumber());
//	StopWatch_ControlLed();
//}
//
//void StopWatch_ControlState()
//{
//	switch (StopWatchState)	{
//	case STOP:
//		if(Button_GetState(&hbtnRunStop) == ACT_PUSHED)
//		{
//			StopWatchState = RUN;
//		}
//		else if(Button_GetState(&hbtnClear) == ACT_PUSHED)
//		{
//			StopWatchState = CLEAR;
//		}
//		break;
//	case RUN:
//		if(Button_GetState(&hbtnRunStop) == ACT_PUSHED)
//		{
//			StopWatchState = STOP;
//		}
//		break;
//	case CLEAR:
//		StopWatchState = STOP;
//		counter =0;
//		hour = 0;
//		min = 0;
//		sec = 0;
//		StopWatchLed = 0x01;
//		break;
//	default:
//		StopWatchState = STOP;
//		break;
//	}
//
//}
//void StopWatch_ControlLed()
//{
//	switch (StopWatchState)	{
//	case STOP:
//		StopWatch_StopLed();
//		break;
//	case RUN:
//		StopWatch_RunLed();
//		break;
//	case CLEAR:
//		StopWatch_ClearLed();
//		break;
//	default:
//		break;
//	}
//
//}
//
//
//void StopWatch_RunLed()
//{
//	static uint32_t prevTime = 0;
//	uint32_t curTime = millis();
//
//
//	StopWatchStateLed |= (1 << STOP_STATE_LED);
//	StopWatchStateLed &= ~(1 << RUN_STATE_LED);
//	LED_WritePort8(LED_HI_GPIO, StopWatchStateLed);
//
//	if(curTime - prevTime <100) return;
//	prevTime = curTime;
//
//	StopWatchLed = (StopWatchLed << 1) | (StopWatchLed >> 7);
//	LED_WritePort8(LED_LOW_GPIO, StopWatchLed);
//}
//
//void StopWatch_StopLed()
//{
//	StopWatchStateLed |= (1 << RUN_STATE_LED);
//	StopWatchStateLed &= ~(1 << STOP_STATE_LED);
//	LED_WritePort8(LED_HI_GPIO, StopWatchStateLed);
//}
//
//void StopWatch_ClearLed()
//{
//	StopWatchLed = 0x01;
//	LED_WritePort8(LED_LOW_GPIO, StopWatchLed);
//}
//
//void StopWatch_RunTime()
//{
//	static uint32_t prevTime = 0;
//	uint32_t curTime = millis();
//
//
//	if(StopWatchState != RUN) {
//	prevTime = curTime;
//	return;
//	}
//	while(curTime - prevTime >= 100){
//		prevTime += 100;
//		counter++;
//	if(counter >= 10) {
//		counter = 0;
//		sec++;
//		if(sec >= 60) {
//			sec = 0;
//			min++;
//			if(min>=60) {
//				min = 0;
//				hour++;
//				if(hour>=24){
//					hour = 0;
//				}
//			}
//		}
//	}
//
//	}
//}
//
//
//uint32_t StopWatch_GetFndNumber()
//{
//	uint32_t fndNumber;
//	fndNumber = counter;
//	fndNumber += (sec % 10) * 10;
//	fndNumber += (sec / 10) * 100;
//	fndNumber += (min % 10) * 1000;
//
//
//	return fndNumber;
//}
//
//void StopWatch_UpdateDot()
//{
//    static uint32_t prevLeftDotTime = 0;
//    static uint32_t prevThirdDotTime = 0;
//
//    static uint8_t leftDotOn = 0;
//    static uint8_t thirdDotOn = 0;
//
//    uint32_t curTime = millis();
//    uint8_t dotMask = 0;
//
//    // 왼쪽 첫 번째 dot: 0.5초마다 반전
//    while (curTime - prevLeftDotTime >= 500) {
//        prevLeftDotTime += 500;
//        leftDotOn = !leftDotOn;
//    }
//
//    // 왼쪽 세 번째 dot: 0.05초마다 반전
//    while (curTime - prevThirdDotTime >= 50) {
//        prevThirdDotTime += 50;
//        thirdDotOn = !thirdDotOn;
//    }
//
//    // Digit3 = 왼쪽 첫 번째 dot
//    if (leftDotOn) {
//        dotMask |= (1 << FND_DIGIT_3);
//    }
//
//    // Digit1 = 왼쪽에서 세 번째 dot
//    if (thirdDotOn) {
//        dotMask |= (1 << FND_DIGIT_1);
//    }
//
//    FND_SetDotMask(dotMask);
//}
//

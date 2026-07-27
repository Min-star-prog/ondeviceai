#ifndef PARKING_H
#define PARKING_H

#include "device_driver.h"

/*
 * Parking project shared interrupt variables.
 * g_ms_ticks is incremented every 1 ms by TIM4_IRQHandler().
 * g_emergency_request is set by the PC13 EXTI interrupt.
 */
extern volatile unsigned int g_ms_ticks;
extern volatile int g_emergency_request;

/* Called once per 1 ms from TIM4_IRQHandler(). */
void StepMotor_Timer_Handler(void);

#endif

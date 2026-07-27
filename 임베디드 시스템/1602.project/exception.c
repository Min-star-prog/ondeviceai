#include "device_driver.h"
#include "parking.h"
#include <stdio.h>

/*
 * crt0.s defines Invalid_ISR and all unused handlers as weak symbols.
 * Invalid_ISR branches here when an interrupt has no strong C handler.
 */
void _Invalid_ISR(void)
{
    unsigned int exception_number;

    exception_number = Macro_Extract_Area(SCB->ICSR, 0x1FF, 0);

    printf("\nInvalid_Exception: %u!\n", exception_number);

    if (exception_number >= 16u)
    {
        printf("Invalid_ISR: %u!\n", exception_number - 16u);
    }

    for (;;)
    {
    }
}

/*
 * Strong C definition for the weak EXTI15_10_IRQHandler symbol in crt0.s.
 * PC13 falling edge only sets an event flag. Motor operation is done in Main().
 */
void EXTI15_10_IRQHandler(void)
{
    if (Macro_Check_Bit_Set(EXTI->PR, 13))
    {
        EXTI->PR = 1u << 13;      /* Write 1 to clear EXTI13 pending flag. */
        g_emergency_request = 1;
    }

    NVIC_ClearPendingIRQ(EXTI15_10_IRQn);
}

/*
 * Strong C definition for the weak TIM4_IRQHandler symbol in crt0.s.
 * TIM4 generates the 1 ms project time base and services one motor step task.
 */
void TIM4_IRQHandler(void)
{
    if (Macro_Check_Bit_Set(TIM4->SR, 0))
    {
        Macro_Clear_Bit(TIM4->SR, 0);  /* Clear TIM4 update interrupt flag. */

        g_ms_ticks++;
        StepMotor_Timer_Handler();
    }

    NVIC_ClearPendingIRQ(TIM4_IRQn);
}

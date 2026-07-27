#include "device_driver.h"

#define KEY_PIN 13

void Key_Poll_Init(void)
{
    Macro_Set_Bit(RCC->AHB1ENR, 2);                 /* GPIOC clock */
    Macro_Write_Block(GPIOC->MODER, 0x3, 0x0, KEY_PIN * 2);
    Macro_Write_Block(GPIOC->PUPDR, 0x3, 0x1, KEY_PIN * 2); /* Pull-up */
}

int Key_Get_Pressed(void)
{
    return Macro_Check_Bit_Clear(GPIOC->IDR, KEY_PIN);
}

void Key_Wait_Key_Pressed(void)
{
    while (!Macro_Check_Bit_Clear(GPIOC->IDR, KEY_PIN));
}

void Key_Wait_Key_Released(void)
{
    while (!Macro_Check_Bit_Set(GPIOC->IDR, KEY_PIN));
}

void Key_ISR_Enable(int en)
{
    if (en)
    {
        Key_Poll_Init();

        Macro_Set_Bit(RCC->APB2ENR, 14);             /* SYSCFG clock */
        Macro_Write_Block(SYSCFG->EXTICR[3], 0xF, 0x2, 4); /* EXTI13 <- PC13 */

        Macro_Clear_Bit(EXTI->RTSR, KEY_PIN);
        Macro_Set_Bit(EXTI->FTSR, KEY_PIN);          /* Active-low falling edge */
        EXTI->PR = 1u << KEY_PIN;

        NVIC_ClearPendingIRQ(EXTI15_10_IRQn);
        Macro_Set_Bit(EXTI->IMR, KEY_PIN);
        NVIC_EnableIRQ(EXTI15_10_IRQn);
    }
    else
    {
        Macro_Clear_Bit(EXTI->IMR, KEY_PIN);
        NVIC_DisableIRQ(EXTI15_10_IRQn);
    }
}

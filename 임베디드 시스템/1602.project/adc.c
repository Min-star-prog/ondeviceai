#include "device_driver.h"

static void ADC1_Channel_Init(unsigned int channel, unsigned int pin)
{
    Macro_Set_Bit(RCC->AHB1ENR, 0);                 /* GPIOA clock */
    Macro_Write_Block(GPIOA->MODER, 0x3, 0x3, pin * 2); /* Analog mode */
    Macro_Write_Block(GPIOA->PUPDR, 0x3, 0x0, pin * 2); /* No pull */

    Macro_Set_Bit(RCC->APB2ENR, 8);                 /* ADC1 clock */

    /* One conversion, long sample time, selected channel first. */
    Macro_Write_Block(ADC1->SQR1, 0xF, 0x0, 20);
    Macro_Write_Block(ADC1->SQR3, 0x1F, channel, 0);

    if (channel <= 9)
    {
        Macro_Write_Block(ADC1->SMPR2, 0x7, 0x7, channel * 3);
    }
    else
    {
        Macro_Write_Block(ADC1->SMPR1, 0x7, 0x7, (channel - 10) * 3);
    }

    /* ADC clock = PCLK2 / 6 = 16 MHz when PCLK2 is 96 MHz. */
    Macro_Write_Block(ADC->CCR, 0x3, 0x2, 16);
    Macro_Set_Bit(ADC1->CR2, 0);                    /* ADC ON */
}

/* PA4 = ADC1_IN4: used by the light sensor in this project. */
void ADC1_IN4_Init(void)
{
    ADC1_Channel_Init(4, 4);
}

/* Kept so the previous ADC exercise still builds. PA6 conflicts with yellow LED. */
void ADC1_IN6_Init(void)
{
    ADC1_Channel_Init(6, 6);
}

void ADC1_Start(void)
{
    Macro_Set_Bit(ADC1->CR2, 30);
}

void ADC1_Stop(void)
{
    Macro_Clear_Bit(ADC1->CR2, 30);
    Macro_Clear_Bit(ADC1->CR2, 0);
}

int ADC1_Get_Status(void)
{
    return Macro_Check_Bit_Set(ADC1->SR, 1);
}

int ADC1_Get_Data(void)
{
    /* Reading DR clears EOC. */
    return Macro_Extract_Area(ADC1->DR, 0xFFF, 0);
}

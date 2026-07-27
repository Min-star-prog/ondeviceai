#include "device_driver.h"

#define HC_TRIG_PIN             8u   /* PA8 */
#define HC_ECHO_PIN             0u   /* PA0 */
#define HC_WAIT_RISE_TIMEOUT_US 30000u
#define HC_HIGH_TIMEOUT_US      30000u

static void TIM2_1MHz_FreeRun_Init(void)
{
    Macro_Set_Bit(RCC->APB1ENR, 0);                  /* TIM2 clock */

    Macro_Clear_Bit(TIM2->CR1, 0);
    TIM2->PSC = (unsigned int)(TIMXCLK / 1000000u) - 1u;
    TIM2->ARR = 0xFFFFFFFFu;
    TIM2->CNT = 0u;
    TIM2->EGR = 1u;
    TIM2->SR = 0u;
    TIM2->CR1 = 1u;                                  /* Up-count, continuous */
}

static unsigned int Micros(void)
{
    return TIM2->CNT;
}

static void Delay_Us(unsigned int us)
{
    unsigned int start = Micros();
    while ((unsigned int)(Micros() - start) < us)
    {
        /* Busy wait only for very short trigger timing. */
    }
}

void Ultrasonic_Init(void)
{
    Macro_Set_Bit(RCC->AHB1ENR, 0);                  /* GPIOA clock */

    /* PA8 TRIG: output, push-pull, initially low. */
    Macro_Write_Block(GPIOA->MODER, 0x3, 0x1, HC_TRIG_PIN * 2);
    Macro_Clear_Bit(GPIOA->OTYPER, HC_TRIG_PIN);
    Macro_Write_Block(GPIOA->PUPDR, 0x3, 0x0, HC_TRIG_PIN * 2);
    Macro_Clear_Bit(GPIOA->ODR, HC_TRIG_PIN);

    /* PA0 ECHO: input, no pull. Use a resistor divider from HC-SR04 ECHO. */
    Macro_Write_Block(GPIOA->MODER, 0x3, 0x0, HC_ECHO_PIN * 2);
    Macro_Write_Block(GPIOA->PUPDR, 0x3, 0x0, HC_ECHO_PIN * 2);

    TIM2_1MHz_FreeRun_Init();
}

int Ultrasonic_Read_DistanceCm(void)
{
    unsigned int wait_start;
    unsigned int echo_start;
    unsigned int pulse_us;

    /* Trigger pulse 생성: low 2 us, high 10 us, low. */
    Macro_Clear_Bit(GPIOA->ODR, HC_TRIG_PIN);
    Delay_Us(2u);
    Macro_Set_Bit(GPIOA->ODR, HC_TRIG_PIN);
    Delay_Us(10u);
    Macro_Clear_Bit(GPIOA->ODR, HC_TRIG_PIN);

    /* ECHO rising edge 기다림. */
    wait_start = Micros();
    while (Macro_Check_Bit_Clear(GPIOA->IDR, HC_ECHO_PIN))
    {
        if ((unsigned int)(Micros() - wait_start) >= HC_WAIT_RISE_TIMEOUT_US)
        {
            return -1;
        }
    }

    /* Measure the ECHO high pulse 시간 측정. */
    echo_start = Micros();
    while (Macro_Check_Bit_Set(GPIOA->IDR, HC_ECHO_PIN))
    {
        if ((unsigned int)(Micros() - echo_start) >= HC_HIGH_TIMEOUT_US)
        {
            return -1;
        }
    }
    // 거리 계산
    pulse_us = (unsigned int)(Micros() - echo_start);
    return (int)((pulse_us + 29u) / 58u);            /* Rounded centimeters */
}

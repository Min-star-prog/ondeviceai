#include "device_driver.h"

#define GREEN_LED_PIN   5
#define YELLOW_LED_PIN  6
#define RED_LED_PIN     7

void LED_Init(void)
{
    Macro_Set_Bit(RCC->AHB1ENR, 0);  /* GPIOA clock */

    /* PA5, PA6, PA7: general-purpose output */
    Macro_Write_Block(GPIOA->MODER, 0x3, 0x1, GREEN_LED_PIN * 2);
    Macro_Write_Block(GPIOA->MODER, 0x3, 0x1, YELLOW_LED_PIN * 2);
    Macro_Write_Block(GPIOA->MODER, 0x3, 0x1, RED_LED_PIN * 2);

    /* Push-pull, low speed, no pull-up/down */
    Macro_Clear_Bit(GPIOA->OTYPER, GREEN_LED_PIN);
    Macro_Clear_Bit(GPIOA->OTYPER, YELLOW_LED_PIN);
    Macro_Clear_Bit(GPIOA->OTYPER, RED_LED_PIN);
    Macro_Write_Block(GPIOA->OSPEEDR, 0x3, 0x0, GREEN_LED_PIN * 2);
    Macro_Write_Block(GPIOA->OSPEEDR, 0x3, 0x0, YELLOW_LED_PIN * 2);
    Macro_Write_Block(GPIOA->OSPEEDR, 0x3, 0x0, RED_LED_PIN * 2);
    Macro_Write_Block(GPIOA->PUPDR, 0x3, 0x0, GREEN_LED_PIN * 2);
    Macro_Write_Block(GPIOA->PUPDR, 0x3, 0x0, YELLOW_LED_PIN * 2);
    Macro_Write_Block(GPIOA->PUPDR, 0x3, 0x0, RED_LED_PIN * 2);

    LED_Off();
}

void Green_LED_On(void)   { Macro_Set_Bit(GPIOA->ODR, GREEN_LED_PIN); }
void Green_LED_Off(void)  { Macro_Clear_Bit(GPIOA->ODR, GREEN_LED_PIN); }
void Yellow_LED_On(void)  { Macro_Set_Bit(GPIOA->ODR, YELLOW_LED_PIN); }
void Yellow_LED_Off(void) { Macro_Clear_Bit(GPIOA->ODR, YELLOW_LED_PIN); }
void Red_LED_On(void)     { Macro_Set_Bit(GPIOA->ODR, RED_LED_PIN); }
void Red_LED_Off(void)    { Macro_Clear_Bit(GPIOA->ODR, RED_LED_PIN); }

/* Compatibility with the original class driver: control all three LEDs. */
void LED_On(void)
{
    Green_LED_On();
    Yellow_LED_On();
    Red_LED_On();
}

void LED_Off(void)
{
    Green_LED_Off();
    Yellow_LED_Off();
    Red_LED_Off();
}

#include "LED.h"

void LED_Init(void)
{
    GPIO_SetMode(LED_LOW_GPIO, 0xFFU);
    GPIO_SetMode(LED_HI_GPIO, 0xFFU);
}

void LED_WritePort8(GPIO_TypeDef *LedGPIOx, uint16_t led)
{
    GPIO_WritePort(LedGPIOx, (uint32_t)led);
}

void LED_WritePort16(uint16_t led)
{
    GPIO_WritePort(GPIOC, (uint32_t)(led & 0x00FFU));
    GPIO_WritePort(GPIOD, (uint32_t)((led >> 8U) & 0x00FFU));
}

void LED_PinOn(uint16_t ledPin)
{
    uint16_t mask = (uint16_t)(1U << ledPin);
    uint32_t port;

    port = GPIO_GetODR(LED_LOW_GPIO);
    GPIO_WritePort(LED_LOW_GPIO, port | (uint32_t)(mask & 0x00FFU));

    port = GPIO_GetODR(LED_HI_GPIO);
    GPIO_WritePort(LED_HI_GPIO, port | (uint32_t)((mask >> 8U) & 0x00FFU));
}

void LED_PinOff(uint16_t ledPin)
{
    uint16_t mask = (uint16_t)(1U << ledPin);
    uint32_t port;

    port = GPIO_GetODR(LED_LOW_GPIO);
    GPIO_WritePort(LED_LOW_GPIO, port & ~(uint32_t)(mask & 0x00FFU));

    port = GPIO_GetODR(LED_HI_GPIO);
    GPIO_WritePort(LED_HI_GPIO, port & ~(uint32_t)((mask >> 8U) & 0x00FFU));
}

void LED_PinToggle(uint16_t ledPin)
{
    uint16_t mask = (uint16_t)(1U << ledPin);
    uint32_t port;

    port = GPIO_GetODR(LED_LOW_GPIO);
    GPIO_WritePort(LED_LOW_GPIO, port ^ (uint32_t)(mask & 0x00FFU));

    port = GPIO_GetODR(LED_HI_GPIO);
    GPIO_WritePort(LED_HI_GPIO, port ^ (uint32_t)((mask >> 8U) & 0x00FFU));
}

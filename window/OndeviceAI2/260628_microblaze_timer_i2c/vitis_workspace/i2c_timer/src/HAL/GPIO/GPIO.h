#ifndef SRC_HAL_GPIO_GPIO_H_
#define SRC_HAL_GPIO_GPIO_H_

#include "xparameters.h"
#include <stdint.h>

typedef struct {
    volatile uint32_t CR;
    volatile uint32_t IDR;
    volatile uint32_t ODR;
} GPIO_TypeDef;

#define GPIOA_BASEADDR XPAR_GPIO_0_S00_AXI_BASEADDR
#define GPIOB_BASEADDR XPAR_GPIO_1_S00_AXI_BASEADDR
#define GPIOC_BASEADDR XPAR_GPIO_2_S00_AXI_BASEADDR
#define GPIOD_BASEADDR XPAR_GPIO_3_S00_AXI_BASEADDR

#define GPIOA ((GPIO_TypeDef *)GPIOA_BASEADDR)
#define GPIOB ((GPIO_TypeDef *)GPIOB_BASEADDR)
#define GPIOC ((GPIO_TypeDef *)GPIOC_BASEADDR)
#define GPIOD ((GPIO_TypeDef *)GPIOD_BASEADDR)

#define GPIO_INPUT  0U
#define GPIO_OUTPUT 1U

#define GPIO_PIN_0  0x01U
#define GPIO_PIN_1  0x02U
#define GPIO_PIN_2  0x04U
#define GPIO_PIN_3  0x08U
#define GPIO_PIN_4  0x10U
#define GPIO_PIN_5  0x20U
#define GPIO_PIN_6  0x40U
#define GPIO_PIN_7  0x80U

#define GPIO_RESET 0U
#define GPIO_SET   1U

void GPIO_SetMode(GPIO_TypeDef *GPIOx, uint32_t mode);
uint32_t GPIO_GetODR(GPIO_TypeDef *GPIOx);
uint32_t GPIO_GetCR(GPIO_TypeDef *GPIOx);
void GPIO_WritePort(GPIO_TypeDef *GPIOx, uint32_t data);
void GPIO_WritePin(GPIO_TypeDef *GPIOx, uint32_t gpio_pin, uint32_t gpio_pin_state);
uint32_t GPIO_ReadPort(GPIO_TypeDef *GPIOx);
uint32_t GPIO_ReadPin(GPIO_TypeDef *GPIOx, uint32_t gpio_pin);

#endif /* SRC_HAL_GPIO_GPIO_H_ */

#ifndef SRC_DRIVER_FND_FND_H_
#define SRC_DRIVER_FND_FND_H_

#include "../../HAL/GPIO/GPIO.h"
#include <stdint.h>

#define FND_DATA_GPIO GPIOA
#define FND_COM_GPIO  GPIOB

#define FND_DIGIT_0 0U
#define FND_DIGIT_1 1U
#define FND_DIGIT_2 2U
#define FND_DIGIT_3 3U

#define FND_DP_ON  1U
#define FND_DP_OFF 0U

void FND_Init(void);
void FND_SetNum(uint32_t num);
void FND_Execute(void);
void FND_SelDigit(uint32_t digit);
void FND_SetDP(uint32_t fndDigitSel, uint32_t fndDpState);
void FND_DispDigit(uint32_t num, uint32_t fndDP);
void FND_DispAllOff(void);
void FND_DispNum(uint32_t num);

#endif /* SRC_DRIVER_FND_FND_H_ */

#ifndef SRC_COMMON_INTERRUPT_INTERRUPT_H_
#define SRC_COMMON_INTERRUPT_INTERRUPT_H_

#include "xparameters.h"
#include "xintc.h"
#include "xstatus.h"
#include "xil_exception.h"
#include "../../config/platform_config.h"

#define INTC_DEV_ID XPAR_INTC_0_DEVICE_ID
#define TMR_VEC_ID  XPAR_INTC_0_TIMER_0_VEC_ID
#define I2C_VEC_ID  XPAR_INTC_0_I2C_0_VEC_ID

void TMR_ISR(void *CallbackRef);
void I2C_ISR(void *CallbackRef);
int SetupInterruptSystem(void);

#endif /* SRC_COMMON_INTERRUPT_INTERRUPT_H_ */

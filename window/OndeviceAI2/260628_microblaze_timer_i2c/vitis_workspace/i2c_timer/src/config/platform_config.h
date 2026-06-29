#ifndef PROJECT_PLATFORM_CONFIG_H_
#define PROJECT_PLATFORM_CONFIG_H_

#include "xparameters.h"

/*
 * The actual macro name depends on the Vivado IP instance name.
 * This header absorbs common generated names. If compilation stops at #error,
 * open xparameters.h and add the exact macro name here only.
 */
#ifndef I2C0_BASEADDR
# if defined(XPAR_I2C_0_S00_AXI_BASEADDR)
#  define I2C0_BASEADDR XPAR_I2C_0_S00_AXI_BASEADDR
# elif defined(XPAR_AXI_I2C_0_S00_AXI_BASEADDR)
#  define I2C0_BASEADDR XPAR_AXI_I2C_0_S00_AXI_BASEADDR
# elif defined(XPAR_I2C_V1_0_0_S00_AXI_BASEADDR)
#  define I2C0_BASEADDR XPAR_I2C_V1_0_0_S00_AXI_BASEADDR
# else
#  error "I2C0_BASEADDR not found. Check xparameters.h and update config/platform_config.h."
# endif
#endif

#ifndef I2C_VEC_ID
# if defined(XPAR_INTC_0_I2C_0_VEC_ID)
#  define I2C_VEC_ID XPAR_INTC_0_I2C_0_VEC_ID
# elif defined(XPAR_INTC_0_AXI_I2C_0_VEC_ID)
#  define I2C_VEC_ID XPAR_INTC_0_AXI_I2C_0_VEC_ID
# elif defined(XPAR_INTC_0_I2C_V1_0_0_VEC_ID)
#  define I2C_VEC_ID XPAR_INTC_0_I2C_V1_0_0_VEC_ID
# elif defined(XPAR_AXI_INTC_0_I2C_0_VEC_ID)
#  define I2C_VEC_ID XPAR_AXI_INTC_0_I2C_0_VEC_ID
# else
#  error "I2C_VEC_ID not found. Connect i2c_v1_0.intr to axi_intc, regenerate BSP, then update config/platform_config.h."
# endif
#endif

#endif /* PROJECT_PLATFORM_CONFIG_H_ */

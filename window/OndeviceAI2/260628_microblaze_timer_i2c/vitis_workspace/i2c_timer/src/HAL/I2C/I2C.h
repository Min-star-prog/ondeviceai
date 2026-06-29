#ifndef SRC_HAL_I2C_I2C_H_
#define SRC_HAL_I2C_I2C_H_

#include <stdint.h>
#include "../../config/platform_config.h"

/*
 * Register map derived directly from axi_i2c.sv.
 *
 * 0x00 CR : [0]START [1]WRITE [2]READ [3]STOP [8]ACK_IN
 *           [16]IRQ_CLEAR [17]IRQ_EN_SET [18]IRQ_EN_CLR
 * 0x04 TDR: [7:0] TX_DATA
 * 0x08 RDR: [7:0] RX_DATA
 * 0x0C SR : [0]busy [1]done_flag [2]ack_out [3]rx_valid
 *           [4]irq_pending [5]irq_enable
 */
typedef struct {
    volatile uint32_t CR;    /* 0x00 */
    volatile uint32_t TDR;   /* 0x04 */
    volatile uint32_t RDR;   /* 0x08 */
    volatile uint32_t SR;    /* 0x0C */
} I2C_TypeDef_t;

#define I2C0 ((I2C_TypeDef_t *)I2C0_BASEADDR)

/* CR */
#define I2C_CR_START          (1UL << 0)
#define I2C_CR_WRITE          (1UL << 1)
#define I2C_CR_READ           (1UL << 2)
#define I2C_CR_STOP           (1UL << 3)
#define I2C_CR_ACK_IN         (1UL << 8)
#define I2C_CR_IRQ_CLEAR      (1UL << 16)
#define I2C_CR_IRQ_ENABLE_SET (1UL << 17)
#define I2C_CR_IRQ_ENABLE_CLR (1UL << 18)

/* SR */
#define I2C_SR_BUSY            (1UL << 0)
#define I2C_SR_DONE_FLAG       (1UL << 1)
#define I2C_SR_ACK_OUT         (1UL << 2) /* 0=ACK, 1=NACK */
#define I2C_SR_RX_VALID        (1UL << 3)
#define I2C_SR_IRQ_PENDING     (1UL << 4)
#define I2C_SR_IRQ_ENABLE      (1UL << 5)

#define I2C_WAIT_TIMEOUT_MS  20U

typedef enum {
    I2C_OK       = 0,
    I2C_NACK     = -1,
    I2C_TIMEOUT  = -2,
    I2C_BUS_BUSY = -3,
    I2C_BAD_ARG   = -4,
    I2C_NOT_READY = -5
} I2C_Status_t;

void I2C_Init(I2C_TypeDef_t *i2c);
void I2C_EnableInterrupt(I2C_TypeDef_t *i2c);
void I2C_DisableInterrupt(I2C_TypeDef_t *i2c);
void I2C_ClearInterrupt(I2C_TypeDef_t *i2c);

/* Call only from I2C_ISR(). It records completion and clears CR[16]. */
void I2C_InterruptHandler(void *CallbackRef);
uint32_t I2C_GetInterruptCount(void);

I2C_Status_t I2C_BusWaitIdle(I2C_TypeDef_t *i2c, uint32_t timeout_ms);
I2C_Status_t I2C_Start(I2C_TypeDef_t *i2c);
I2C_Status_t I2C_WriteByte(I2C_TypeDef_t *i2c, uint8_t data);
I2C_Status_t I2C_ReadByte(I2C_TypeDef_t *i2c,
                          uint8_t *data,
                          uint8_t nack_after_read);
I2C_Status_t I2C_Stop(I2C_TypeDef_t *i2c);

#endif /* SRC_HAL_I2C_I2C_H_ */

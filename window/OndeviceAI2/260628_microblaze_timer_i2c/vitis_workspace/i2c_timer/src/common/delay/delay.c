#include "delay.h"

/* Written by TMR_ISR and read in foreground / I2C command waits. */
static volatile uint32_t m_tick = 0U;

uint32_t millis(void)
{
    return m_tick;
}

void incTick(void)
{
    m_tick++;
}

void delay_sec(uint32_t seconds)
{
    sleep(seconds);
}

void delay_ms(uint32_t msec)
{
    usleep(msec * 1000U);
}

void delay_us(uint32_t usec)
{
    usleep(usec);
}

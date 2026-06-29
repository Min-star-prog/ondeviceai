#include "delay.h"

uint32_t m_tick =0;

uint32_t millis()	//millis나 tick나 똑같은데 뒤는 아두이노에서 사용하는거임
{

	return m_tick;
}

void incTick()
{

	m_tick++;
}

void delay_sec(uint32_t seconds)		//u32 : uint32_t가 정석인데 이것도 xilinx에서 제공함
{
	sleep(seconds);

}
void delay_ms(uint32_t msec)
{
	uint32_t mseconds = msec * 1000;
	usleep(mseconds);

}
void delay_us(uint32_t usec)
{
	usleep(usec);

}

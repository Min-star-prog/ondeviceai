#include "device_driver.h"

void Clock_Init(void)
{
    RCC->CR |= (1 << 0); //HSI ready
    while(!Macro_Check_Bit_Set(RCC->CR, 1));    //HSI ready = 0될때까지 계속 됨.

    FLASH->ACR = (1<<12)|(1<<11);       //D-cache, I-cache reset
    FLASH->ACR = (1<<10)|(1<<9)|(1<<8)|(0x3 << 0);      //cache enable | wait cycle 3

    RCC->PLLCFGR = (8<<24)|(0<<22)|(1<<16)|(192<<6)|(8<<0);     //pll 설정

    Macro_Set_Bit(RCC->CR, 24);             //PLL on 
    while(!Macro_Check_Bit_Set(RCC->CR, 25));   //lock time 대기

    RCC->CFGR = (0<<13)|(4<<10)|(0<<4); //PCLK2(PPRE2) = 96/1 = 96MHz, // PCLK1(PPRE1) = 96/2(100) = 48MHz, //HPRE(AHB) =  96MHz

    Macro_Write_Block(RCC->CFGR, 0x3, 0x2, 0);  //0x3으로 초기화 하고 0x2로 sysclk를 PLL 선택
    while(Macro_Extract_Area(RCC->CFGR, 0x3, 2) != 0x2);    //PLL로 바뀌면 SWS(sysclk 바뀌었는지 확인하는 거)가 10으로 바뀜
}

#include "FND.h"

static uint32_t fndNumber = 0U;
static uint32_t fndDPData = 0U;

void FND_Init(void)
{
    uint32_t fndComTemp = GPIO_GetCR(GPIOB);

    fndComTemp |= 0x0FU;
    GPIO_SetMode(GPIOB, fndComTemp);
    GPIO_SetMode(GPIOA, 0xFFU);
}

void FND_SetNum(uint32_t num)
{
    fndNumber = num;
}

void FND_Execute(void)
{
    FND_DispNum(fndNumber);
}

void FND_SelDigit(uint32_t digit)
{
    uint32_t digitPos = GPIO_GetODR(FND_COM_GPIO);

    digitPos = (digitPos | 0x0FU) & ~(1U << digit);
    GPIO_WritePort(FND_COM_GPIO, digitPos);
}

void FND_SetDP(uint32_t fndDigitSel, uint32_t fndDpState)
{
    if (fndDpState == FND_DP_ON) {
        fndDPData |= (1U << fndDigitSel);
    } else {
        fndDPData &= ~(1U << fndDigitSel);
    }
}

void FND_DispDigit(uint32_t num, uint32_t fndDP)
{
    static const uint8_t fndFont[16] = {
        0xC0U, 0xF9U, 0xA4U, 0xB0U,
        0x99U, 0x92U, 0x82U, 0xF8U,
        0x80U, 0x90U, 0x88U, 0x83U,
        0xC6U, 0xA1U, 0x86U, 0x8EU
    };
    uint8_t fndData;

    num &= 0x0FU;
    fndData = fndFont[num];

    /* active-low decimal-point */
    if (fndDP != 0U) {
        fndData &= (uint8_t)~0x80U;
    } else {
        fndData |= 0x80U;
    }

    GPIO_WritePort(FND_DATA_GPIO, fndData);
}

void FND_DispAllOff(void)
{
    uint32_t digitPos = GPIO_GetODR(FND_COM_GPIO);
    GPIO_WritePort(FND_COM_GPIO, digitPos | 0x0FU);
}

void FND_DispNum(uint32_t num)
{
    static uint32_t fndDigitState = 0U;

    fndDigitState = (fndDigitState + 1U) % 4U;
    FND_DispAllOff();

    switch (fndDigitState) {
    case 0U:
        FND_DispDigit(num % 10U, fndDPData & 0x01U);
        FND_SelDigit(FND_DIGIT_0);
        break;
    case 1U:
        FND_DispDigit((num / 10U) % 10U, fndDPData & 0x02U);
        FND_SelDigit(FND_DIGIT_1);
        break;
    case 2U:
        FND_DispDigit((num / 100U) % 10U, fndDPData & 0x04U);
        FND_SelDigit(FND_DIGIT_2);
        break;
    default:
        FND_DispDigit((num / 1000U) % 10U, fndDPData & 0x08U);
        FND_SelDigit(FND_DIGIT_3);
        break;
    }
}

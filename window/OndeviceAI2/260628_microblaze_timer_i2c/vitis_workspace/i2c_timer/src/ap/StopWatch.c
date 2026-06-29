#include "StopWatch.h"
#include "../common/delay/delay.h"

typedef struct {
    uint8_t hour;
    uint8_t min;
    uint8_t sec;
    uint8_t ms;   /* 0..99, one increment every 10 ms */
} StopWatch_t;

static StopWatch_e StopWatchState;
static uint32_t StopWatchLed;
static uint32_t StopWatchStateLed;
static StopWatch_t StopWatchTimeData;

void StopWatch_Init(void)
{
    LED_Init();
    FND_Init();
    Button_Init();

    StopWatchState = STOP;
    StopWatchStateLed = 0U;
    StopWatchLed = 0x01U;
    StopWatch_ClearTime();
}

void StopWatch_Execute(void)
{
    StopWatch_RunTime();
    StopWatch_ControlState();
    StopWatch_DispWatch();
}

void StopWatch_DispWatch(void)
{
    if ((StopWatchTimeData.ms % 10U) < 5U) {
        FND_SetDP(FND_DIGIT_1, FND_DP_ON);
    } else {
        FND_SetDP(FND_DIGIT_1, FND_DP_OFF);
    }

    if (StopWatchTimeData.ms < 50U) {
        FND_SetDP(FND_DIGIT_3, FND_DP_ON);
    } else {
        FND_SetDP(FND_DIGIT_3, FND_DP_OFF);
    }

    FND_SetNum((StopWatchTimeData.min % 10U * 1000U) +
               (StopWatchTimeData.sec * 10U) +
               ((StopWatchTimeData.ms / 10U) % 10U));

    StopWatch_ControlLed();
}

void StopWatch_ControlState(void)
{
    switch (StopWatchState) {
    case STOP:
        if (Button_GetState(&hbtnRunStop) == ACT_PUSHED) {
            StopWatchState = RUN;
        } else if (Button_GetState(&hbtnClear) == ACT_PUSHED) {
            StopWatchState = CLEAR;
        }
        break;

    case RUN:
        if (Button_GetState(&hbtnRunStop) == ACT_PUSHED) {
            StopWatchState = STOP;
        }
        break;

    case CLEAR:
        StopWatch_ClearTime();
        StopWatchState = STOP;
        break;

    default:
        StopWatchState = STOP;
        break;
    }
}

void StopWatch_ClearTime(void)
{
    StopWatchTimeData.ms = 0U;
    StopWatchTimeData.sec = 0U;
    StopWatchTimeData.min = 0U;
    StopWatchTimeData.hour = 0U;
}

void StopWatch_IncTime(void)
{
    if (StopWatchTimeData.ms == 99U) {
        StopWatchTimeData.ms = 0U;
    } else {
        StopWatchTimeData.ms++;
        return;
    }

    if (StopWatchTimeData.sec == 59U) {
        StopWatchTimeData.sec = 0U;
    } else {
        StopWatchTimeData.sec++;
        return;
    }

    if (StopWatchTimeData.min == 59U) {
        StopWatchTimeData.min = 0U;
    } else {
        StopWatchTimeData.min++;
        return;
    }

    if (StopWatchTimeData.hour == 23U) {
        StopWatchTimeData.hour = 0U;
    } else {
        StopWatchTimeData.hour++;
    }
}

void StopWatch_RunTime(void)
{
    static uint32_t prevTime = 0U;
    uint32_t curTime = millis();

    if ((curTime - prevTime) < 10U) {
        return;
    }
    prevTime = curTime;

    if (StopWatchState == RUN) {
        StopWatch_IncTime();
    }
}

void StopWatch_ControlLed(void)
{
    switch (StopWatchState) {
    case STOP:
        StopWatch_StopLed();
        break;
    case RUN:
        StopWatch_RunLed();
        break;
    case CLEAR:
        StopWatch_ClearLed();
        break;
    default:
        break;
    }
}

void StopWatch_RunLed(void)
{
    static uint32_t prevTime = 0U;
    uint32_t curTime = millis();

    StopWatchStateLed |= (1U << RUN_STATE_LED);
    StopWatchStateLed &= ~(1U << STOP_STATE_LED);
    LED_WritePort8(LED_HI_GPIO, (uint16_t)StopWatchStateLed);

    if ((curTime - prevTime) < 100U) {
        return;
    }
    prevTime = curTime;

    StopWatchLed = (StopWatchLed << 1U) | (StopWatchLed >> 7U);
    LED_WritePort8(LED_LOW_GPIO, (uint16_t)StopWatchLed);
}

void StopWatch_StopLed(void)
{
    StopWatchStateLed |= (1U << STOP_STATE_LED);
    StopWatchStateLed &= ~(1U << RUN_STATE_LED);
    LED_WritePort8(LED_HI_GPIO, (uint16_t)StopWatchStateLed);
}

void StopWatch_ClearLed(void)
{
    StopWatchLed = 0x01U;
    LED_WritePort8(LED_LOW_GPIO, (uint16_t)StopWatchLed);
}

void StopWatch_GetTime(uint8_t *hour,
                       uint8_t *min,
                       uint8_t *sec,
                       uint8_t *centisecond)
{
    *hour = StopWatchTimeData.hour;
    *min = StopWatchTimeData.min;
    *sec = StopWatchTimeData.sec;
    *centisecond = StopWatchTimeData.ms;
}

StopWatch_e StopWatch_GetState(void)
{
    return StopWatchState;
}

#ifndef SRC_AP_STOPWATCH_H_
#define SRC_AP_STOPWATCH_H_

#include <stdint.h>
#include "../driver/Button/Button.h"
#include "../driver/FND/FND.h"
#include "../driver/LED/LED.h"

#define STOP_STATE_LED 5U
#define RUN_STATE_LED  7U

typedef enum {
    STOP = 0,
    RUN,
    CLEAR
} StopWatch_e;

void StopWatch_Init(void);
void StopWatch_Execute(void);
void StopWatch_ControlState(void);
void StopWatch_RunTime(void);
void StopWatch_DispWatch(void);
void StopWatch_ClearLed(void);
void StopWatch_StopLed(void);
void StopWatch_RunLed(void);
void StopWatch_ControlLed(void);
void StopWatch_ClearTime(void);
void StopWatch_IncTime(void);

void StopWatch_GetTime(uint8_t *hour,
                       uint8_t *min,
                       uint8_t *sec,
                       uint8_t *centisecond);
StopWatch_e StopWatch_GetState(void);

#endif /* SRC_AP_STOPWATCH_H_ */

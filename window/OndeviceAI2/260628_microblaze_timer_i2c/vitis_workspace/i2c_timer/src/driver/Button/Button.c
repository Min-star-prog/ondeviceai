#include "Button.h"

hbutton hbtnRunStop;
hbutton hbtnClear;
hbutton hbtnLeft;
hbutton hbtnRight;

void Button_Init(void)
{
    uint32_t btnPort = GPIO_GetCR(GPIOB);

    /* GPIOB[3:0]: FND common outputs / GPIOB[7:4]: button inputs */
    btnPort &= ~(GPIO_PIN_4 | GPIO_PIN_5 | GPIO_PIN_6 | GPIO_PIN_7);
    GPIO_SetMode(GPIOB, btnPort);

    Button_SetInit(&hbtnRunStop, GPIOB, GPIO_PIN_4);
    Button_SetInit(&hbtnClear,   GPIOB, GPIO_PIN_5);
    Button_SetInit(&hbtnLeft,    GPIOB, GPIO_PIN_6);
    Button_SetInit(&hbtnRight,   GPIOB, GPIO_PIN_7);
}

void Button_SetInit(hbutton *hbtn, GPIO_TypeDef *GPIOx, uint32_t gpio_pin)
{
    hbtn->GPIOx = GPIOx;
    hbtn->gpio_pin = gpio_pin;
    hbtn->prevState = RELEASED;
}

button_Status_e Button_GetState(hbutton *hbtn)
{
    button_state_e curState = GPIO_ReadPin(hbtn->GPIOx, hbtn->gpio_pin)
                              ? PUSHED : RELEASED;

    if ((hbtn->prevState == RELEASED) && (curState == PUSHED)) {
        hbtn->prevState = curState;
        delay_ms(5U);
        return ACT_PUSHED;
    }

    if ((hbtn->prevState == PUSHED) && (curState == RELEASED)) {
        hbtn->prevState = curState;
        delay_ms(5U);
        return ACT_RELEASED;
    }

    return NO_ACT;
}

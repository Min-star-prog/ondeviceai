#include "device_driver.h"

/* ULN2003 inputs */
#define MOTOR_IN1_PIN  0u   /* PC0 */
#define MOTOR_IN2_PIN  1u   /* PC1 */
#define MOTOR_IN3_PIN  4u   /* PC4 */
#define MOTOR_IN4_PIN  5u   /* PC5 */

/* 28BYJ-48 half-step: about 4096 steps/revolution, so 1024 is about 90 degrees. */
#define GATE_OPEN_STEPS          1024
#define MOTOR_STEP_INTERVAL_MS   2u
#define MOTOR_HOLD_WHEN_STOPPED  0

static const unsigned char half_step_table[8] =
{
    0x1, 0x3, 0x2, 0x6, 0x4, 0xC, 0x8, 0x9
};

static volatile int motor_position = 0;
static volatile int motor_target = 0;
static volatile int motor_phase = 0;
static volatile unsigned int motor_ms_divider = 0;

static void Motor_Write_Phase(unsigned char phase)
{
    if (phase & 0x1) Macro_Set_Bit(GPIOC->ODR, MOTOR_IN1_PIN);
    else             Macro_Clear_Bit(GPIOC->ODR, MOTOR_IN1_PIN);

    if (phase & 0x2) Macro_Set_Bit(GPIOC->ODR, MOTOR_IN2_PIN);
    else             Macro_Clear_Bit(GPIOC->ODR, MOTOR_IN2_PIN);

    if (phase & 0x4) Macro_Set_Bit(GPIOC->ODR, MOTOR_IN3_PIN);
    else             Macro_Clear_Bit(GPIOC->ODR, MOTOR_IN3_PIN);

    if (phase & 0x8) Macro_Set_Bit(GPIOC->ODR, MOTOR_IN4_PIN);
    else             Macro_Clear_Bit(GPIOC->ODR, MOTOR_IN4_PIN);
}

static void Motor_All_Off(void)
{
    Macro_Clear_Bit(GPIOC->ODR, MOTOR_IN1_PIN);
    Macro_Clear_Bit(GPIOC->ODR, MOTOR_IN2_PIN);
    Macro_Clear_Bit(GPIOC->ODR, MOTOR_IN3_PIN);
    Macro_Clear_Bit(GPIOC->ODR, MOTOR_IN4_PIN);
}

void StepMotor_Init(void)
{
    Macro_Set_Bit(RCC->AHB1ENR, 2);                  /* GPIOC clock */

    Macro_Write_Block(GPIOC->MODER, 0x3, 0x1, MOTOR_IN1_PIN * 2);
    Macro_Write_Block(GPIOC->MODER, 0x3, 0x1, MOTOR_IN2_PIN * 2);
    Macro_Write_Block(GPIOC->MODER, 0x3, 0x1, MOTOR_IN3_PIN * 2);
    Macro_Write_Block(GPIOC->MODER, 0x3, 0x1, MOTOR_IN4_PIN * 2);

    Macro_Clear_Bit(GPIOC->OTYPER, MOTOR_IN1_PIN);
    Macro_Clear_Bit(GPIOC->OTYPER, MOTOR_IN2_PIN);
    Macro_Clear_Bit(GPIOC->OTYPER, MOTOR_IN3_PIN);
    Macro_Clear_Bit(GPIOC->OTYPER, MOTOR_IN4_PIN);

    Macro_Write_Block(GPIOC->PUPDR, 0x3, 0x0, MOTOR_IN1_PIN * 2);
    Macro_Write_Block(GPIOC->PUPDR, 0x3, 0x0, MOTOR_IN2_PIN * 2);
    Macro_Write_Block(GPIOC->PUPDR, 0x3, 0x0, MOTOR_IN3_PIN * 2);
    Macro_Write_Block(GPIOC->PUPDR, 0x3, 0x0, MOTOR_IN4_PIN * 2);

    motor_position = 0;  /* Power-on assumption: gate is physically closed. */
    motor_target = 0;
    motor_phase = 0;
    motor_ms_divider = 0;
    Motor_All_Off();
}

void StepMotor_Open(void)
{
    motor_target = GATE_OPEN_STEPS;
}

void StepMotor_Close(void)
{
    motor_target = 0;
}

void StepMotor_Stop(void)
{
    motor_target = motor_position;
#if !MOTOR_HOLD_WHEN_STOPPED
    Motor_All_Off();
#endif
}

int StepMotor_IsBusy(void)
{
    return motor_position != motor_target;
}

int StepMotor_IsOpen(void)
{
    return motor_position >= GATE_OPEN_STEPS;
}

int StepMotor_IsClosed(void)
{
    return motor_position <= 0;
}

int StepMotor_Get_Position(void)
{
    return motor_position;
}

int StepMotor_Get_Target(void)
{
    return motor_target;
}

/* Called every 1 ms by TIM4_IRQHandler(). One actual step every 2 ms. */
void StepMotor_Timer_Handler(void)
{
    if (motor_position == motor_target)
    {
        motor_ms_divider = 0;
#if !MOTOR_HOLD_WHEN_STOPPED
        Motor_All_Off();
#endif
        return;
    }

    motor_ms_divider++;
    if (motor_ms_divider < MOTOR_STEP_INTERVAL_MS)
    {
        return;
    }
    motor_ms_divider = 0;

    if (motor_position < motor_target)
    {
        motor_phase = (motor_phase + 1) & 0x7;
        Motor_Write_Phase(half_step_table[motor_phase]);
        motor_position++;
    }
    else
    {
        motor_phase = (motor_phase + 7) & 0x7;
        Motor_Write_Phase(half_step_table[motor_phase]);
        motor_position--;
    }
}

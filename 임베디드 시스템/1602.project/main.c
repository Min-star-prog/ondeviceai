#include "device_driver.h"
#include "parking.h"
#include <stdio.h>

/* ------------------------------ Tunable values ----------------------------- */
#define CAR_DETECT_CM             25
#define CAR_RELEASE_CM            32
#define CAR_CLEAR_HOLD_MS         500u
#define ULTRASONIC_PERIOD_MS      60u

/* LDR wiring assumed: 3.3 V -- LDR -- PA4 -- 10 kOhm -- GND.
 * Therefore darkness produces a smaller ADC value.
 */
#define DARK_ON_ADC               800
#define DARK_OFF_ADC              1000
#define LIGHT_SAMPLE_PERIOD_MS    100u
#define STATUS_PRINT_PERIOD_MS    1000u
#define BUTTON_DEBOUNCE_MS        200u

volatile unsigned int g_ms_ticks = 0;
volatile int g_emergency_request = 0;

typedef enum
{
    PARK_IDLE_CLOSED = 0,
    PARK_OPENING,
    PARK_PASSING,
    PARK_CLOSING,
    PARK_MANUAL
} Parking_State;

static Parking_State parking_state = PARK_IDLE_CLOSED;
static int manual_mode = 0;
static int car_detected = 0;
static int distance_cm = -1;
static int light_adc = 0;
static int dark_state = 0;
static unsigned int last_car_seen_ms = 0;

static void Sys_Init(int baud)
{
    SCB->CPACR |= (0x3 << (10 * 2)) | (0x3 << (11 * 2));
    Clock_Init();
    Uart2_Init(baud);
    setvbuf(stdout, NULL, _IONBF, 0);
}

static unsigned int Millis(void)
{
    return g_ms_ticks;
}

static int Time_Elapsed(unsigned int now, unsigned int old, unsigned int interval)
{
    return (unsigned int)(now - old) >= interval;
}

static const char *State_Name(Parking_State state)
{
    switch (state)
    {
    case PARK_IDLE_CLOSED: return "IDLE_CLOSED";
    case PARK_OPENING:     return "OPENING";
    case PARK_PASSING:     return "PASSING";
    case PARK_CLOSING:     return "CLOSING";
    case PARK_MANUAL:      return "MANUAL";
    default:               return "UNKNOWN";
    }
}

static void Gate_LED_Update(void)
{
    /* Yellow LED is independent and indicates darkness. */
    if (dark_state) Yellow_LED_On();
    else            Yellow_LED_Off();

    /* Green means gate safely closed and automatic standby. */
    if (!manual_mode && parking_state == PARK_IDLE_CLOSED && StepMotor_IsClosed())
    {
        Green_LED_On();
        Red_LED_Off();
    }
    else
    {
        Green_LED_Off();
        Red_LED_On();
    }
}

static void Light_Sensor_Task(void)
{
    static unsigned int previous_ms = 0;
    unsigned int now = Millis();

    if (!Time_Elapsed(now, previous_ms, LIGHT_SAMPLE_PERIOD_MS))
    {
        return;
    }
    previous_ms = now;

    ADC1_Start();
    while (!ADC1_Get_Status())
    {
    }
    light_adc = ADC1_Get_Data();

    /* Hysteresis prevents flickering near the threshold. */
    if (!dark_state && light_adc <= DARK_ON_ADC)
    {
        dark_state = 1;
    }
    else if (dark_state && light_adc >= DARK_OFF_ADC)
    {
        dark_state = 0;
    }
}

static void Ultrasonic_Task(void)
{
    static unsigned int previous_ms = 0;
    unsigned int now = Millis();

    if (!Time_Elapsed(now, previous_ms, ULTRASONIC_PERIOD_MS))
    {
        return;
    }
    previous_ms = now;

    distance_cm = Ultrasonic_Read_DistanceCm();

    if (distance_cm >= 0)
    {
        if (!car_detected && distance_cm <= CAR_DETECT_CM)
        {
            car_detected = 1;
            last_car_seen_ms = now;
        }
        else if (car_detected)
        {
            if (distance_cm <= CAR_RELEASE_CM)
            {
                last_car_seen_ms = now;
            }
            else
            {
                car_detected = 0;
            }
        }
    }
    else
    {
        /* No echo is treated as no vehicle. The closing delay still applies. */
        car_detected = 0;
    }

    if (car_detected)
    {
        last_car_seen_ms = now;
    }
}

static void Emergency_Button_Task(void)
{
    static unsigned int last_button_ms = 0;
    unsigned int now;

    if (!g_emergency_request)
    {
        return;
    }
    g_emergency_request = 0;
    now = Millis();

    if (!Time_Elapsed(now, last_button_ms, BUTTON_DEBOUNCE_MS))
    {
        return;
    }
    last_button_ms = now;

    manual_mode = 1;
    parking_state = PARK_MANUAL;

    /* Each valid press toggles the requested gate direction. */
    if (StepMotor_Get_Target() > 0 || StepMotor_IsOpen())
    {
        StepMotor_Close();
        printf("[EMERGENCY] Gate close request\n");
    }
    else
    {
        StepMotor_Open();
        printf("[EMERGENCY] Gate open request\n");
    }
}

static void Automatic_Gate_Task(void)
{
    unsigned int now = Millis();

    if (manual_mode)
    {
        /* Manual opening remains open until the button is pressed again.
         * After a manual close finishes, return to automatic standby.
         */
        if (!StepMotor_IsBusy() && StepMotor_IsClosed())
        {
            manual_mode = 0;
            parking_state = PARK_IDLE_CLOSED;
            last_car_seen_ms = now;
            printf("[EMERGENCY] Manual mode finished\n");
        }
        return;
    }

    switch (parking_state)
    {
    case PARK_IDLE_CLOSED:
        if (car_detected)
        {
            StepMotor_Open();
            parking_state = PARK_OPENING;
            last_car_seen_ms = now;
            printf("[AUTO] Vehicle detected -> gate opening\n");
        }
        break;

    case PARK_OPENING:
        if (car_detected)
        {
            last_car_seen_ms = now;
        }

        if (!StepMotor_IsBusy() && StepMotor_IsOpen())
        {
            parking_state = PARK_PASSING;
            printf("[AUTO] Gate open -> vehicle passing\n");
        }
        break;

    case PARK_PASSING:
        if (car_detected)
        {
            last_car_seen_ms = now;
        }
        else if (Time_Elapsed(now, last_car_seen_ms, CAR_CLEAR_HOLD_MS))
        {
            StepMotor_Close();
            parking_state = PARK_CLOSING;
            printf("[AUTO] Vehicle cleared -> gate closing\n");
        }
        break;

    case PARK_CLOSING:
        /* Safety reopen if a vehicle is detected while closing. */
        if (car_detected)
        {
            StepMotor_Open();
            parking_state = PARK_OPENING;
            last_car_seen_ms = now;
            printf("[SAFETY] Vehicle detected while closing -> reopen\n");
        }
        else if (!StepMotor_IsBusy() && StepMotor_IsClosed())
        {
            parking_state = PARK_IDLE_CLOSED;
            printf("[AUTO] Gate closed -> standby\n");
        }
        break;

    case PARK_MANUAL:
    default:
        break;
    }
}

static void Status_Print_Task(void)
{
    static unsigned int previous_ms = 0;
    unsigned int now = Millis();

    if (!Time_Elapsed(now, previous_ms, STATUS_PRINT_PERIOD_MS))
    {
        return;
    }
    previous_ms = now;

    printf("state=%s manual=%d distance=%dcm car=%d light=%d dark=%d gate=%d/%d\n",
           State_Name(parking_state),
           manual_mode,
           distance_cm,
           car_detected,
           light_adc,
           dark_state,
           StepMotor_Get_Position(),
           StepMotor_Get_Target());
}

void Main(void)
{
    Sys_Init(115200);

    LED_Init();
    ADC1_IN4_Init();
    Ultrasonic_Init();
    StepMotor_Init();
    Key_ISR_Enable(1);

    /* 1 ms system tick and non-blocking step-motor service. */
    TIM4_Repeat_Interrupt_Enable(1, 1);

    parking_state = PARK_IDLE_CLOSED;
    manual_mode = 0;
    last_car_seen_ms = Millis();
    Gate_LED_Update();

    printf("\nSTM32F411 Parking Gate Start\n");
    printf("LED: PA5 green, PA6 yellow, PA7 red\n");
    printf("HC-SR04: TRIG PA8, ECHO PA0 (use 5V-to-3.3V divider)\n");
    printf("LDR analog: PA4/ADC1_IN4\n");
    printf("ULN2003: IN1 PC0, IN2 PC1, IN3 PC4, IN4 PC5\n");
    printf("Emergency active-low button: PC13\n\n");

    for (;;)
    {
        Emergency_Button_Task();
        Light_Sensor_Task();

        if (!manual_mode)
        {
            Ultrasonic_Task();
        }

        Automatic_Gate_Task();
        Gate_LED_Update();
        Status_Print_Task();
    }
}

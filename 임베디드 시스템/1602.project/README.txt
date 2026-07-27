STM32F411 Parking Gate Project
==============================

Assumption
----------
- MCU/board: STM32F411xE, typically NUCLEO-F411RE
- System clock: existing project Clock_Init(), HCLK 96 MHz
- Motor: 28BYJ-48 5 V stepper + ULN2003 board
- LEDs are active high, matching the uploaded led.c
- The gate must be physically CLOSED when power is applied because no limit switch is used.

Pin map
-------
PC13 : external emergency button, active low (button between PC13 and GND)
PA5  : green LED
PA6  : yellow LED
PA7  : red LED
PA8  : HC-SR04 TRIG
PA0  : HC-SR04 ECHO through a 5 V -> 3.3 V resistor divider
PA4  : LDR analog voltage, ADC1_IN4
PC0  : ULN2003 IN1
PC1  : ULN2003 IN2
PC4  : ULN2003 IN3
PC5  : ULN2003 IN4

Power and safety
----------------
- HC-SR04 VCC: 5 V, GND common with STM32.
- Do not connect 5 V ECHO directly to a 3.3 V-only MCU input. Example divider:
  ECHO -- 1 kOhm -- PA0 -- 2 kOhm -- GND
- Power the 28BYJ-48/ULN2003 from an external regulated 5 V supply.
- Connect external 5 V supply GND, ULN2003 GND, and STM32 GND together.

LDR example
-----------
3.3 V -- LDR -- PA4 -- 10 kOhm -- GND
With this wiring, darkness gives a lower ADC value.
Tune DARK_ON_ADC and DARK_OFF_ADC in main.c after observing UART values.

Files to replace/add
--------------------
Replace: main.c, exception.c, device_driver.h, led.c, adc.c, key.c, timer.c
Add:     parking.h, ultrasonic.c, step_motor.c
Keep:    clock.c, uart.c, runtime.c, macro.h, option.h, CMSIS/startup files

Important tuning
----------------
- step_motor.c: GATE_OPEN_STEPS (default 1024, about 90 degrees)
- step_motor.c: MOTOR_STEP_INTERVAL_MS (default 2 ms)
- main.c: CAR_DETECT_CM, CAR_RELEASE_CM, CAR_CLEAR_HOLD_MS
- main.c: DARK_ON_ADC, DARK_OFF_ADC

If the motor rotates in the opposite direction
-----------------------------------------------
Swap the StepMotor_Open() and StepMotor_Close() target meanings, or reverse the
ULN2003 IN1..IN4 connector order. Do only one of these, not both.

crt0.s / interrupt-vector compatibility
---------------------------------------
- Keep the provided crt0.s unchanged.
- crt0.s calls Main(), so this project intentionally defines void Main(void), not main().
- crt0.s contains weak aliases for TIM4_IRQHandler and EXTI15_10_IRQHandler.
- exception.c provides strong C definitions with exactly those names, so the linker
  automatically replaces the weak Invalid_ISR aliases with the project handlers.
- crt0.s Invalid_ISR branches to _Invalid_ISR(), which is also defined in exception.c.
- Use the existing class-project linker script because crt0.s requires these symbols:
  __RO_LIMIT__, __RW_BASE__, __ZI_BASE__, and __ZI_LIMIT__.

Power-current setting
---------------------
- step_motor.c sets MOTOR_HOLD_WHEN_STOPPED to 0.
- The motor coils are turned off after opening/closing finishes, reducing 5 V current.

#include "LCD_I2C.h"
#include "../../common/delay/delay.h"
#include <stdio.h>

/* Common PCF8574 -> HD44780 mapping: P0=RS, P2=EN, P3=Backlight, P4..7=D4..7 */
#define LCD_RS        (1U << 0)
#define LCD_EN        (1U << 2)
#define LCD_BACKLIGHT (1U << 3)

#define LCD_CMD_CLEAR        0x01U
#define LCD_CMD_ENTRY_MODE   0x06U
#define LCD_CMD_DISPLAY_ON   0x0CU
#define LCD_CMD_FUNCTION_SET 0x28U
#define LCD_CMD_SET_DDRAM    0x80U

static I2C_TypeDef_t *lcd_i2c = 0;
static uint8_t lcd_backlight = LCD_BACKLIGHT;

void LCD_I2C_Init(I2C_TypeDef_t *i2c)
{
    lcd_i2c = i2c;
}

static I2C_Status_t LCD_BeginTransaction(void)
{
    I2C_Status_t status = I2C_Start(lcd_i2c);

    if (status != I2C_OK) {
        return status;
    }

    status = I2C_WriteByte(lcd_i2c, (uint8_t)(LCD_I2C_ADDR << 1U));
    if (status != I2C_OK) {
        (void)I2C_Stop(lcd_i2c);
    }

    return status;
}

static I2C_Status_t LCD_EndTransaction(I2C_Status_t previous_status)
{
    I2C_Status_t stop_status = I2C_Stop(lcd_i2c);
    return (previous_status != I2C_OK) ? previous_status : stop_status;
}

static I2C_Status_t LCD_ExpanderWrite(uint8_t value)
{
    return I2C_WriteByte(lcd_i2c, value);
}

static I2C_Status_t LCD_Write4BitsRaw(uint8_t nibble, uint8_t rs)
{
    I2C_Status_t status;
    uint8_t data = (uint8_t)((nibble << 4U) | lcd_backlight |
                             ((rs != 0U) ? LCD_RS : 0U));

    status = LCD_ExpanderWrite(data);
    if (status != I2C_OK) {
        return status;
    }

    status = LCD_ExpanderWrite((uint8_t)(data | LCD_EN));
    if (status != I2C_OK) {
        return status;
    }

    delay_us(1U);
    status = LCD_ExpanderWrite((uint8_t)(data & (uint8_t)~LCD_EN));
    delay_us(50U);
    return status;
}

static I2C_Status_t LCD_WriteByteRaw(uint8_t value, uint8_t rs)
{
    I2C_Status_t status;

    status = LCD_Write4BitsRaw((uint8_t)(value >> 4U), rs);
    if (status != I2C_OK) {
        return status;
    }

    return LCD_Write4BitsRaw((uint8_t)(value & 0x0FU), rs);
}

static I2C_Status_t LCD_WriteNibble(uint8_t nibble)
{
    I2C_Status_t status = LCD_BeginTransaction();

    if (status == I2C_OK) {
        status = LCD_Write4BitsRaw(nibble, 0U);
    }

    return LCD_EndTransaction(status);
}

static I2C_Status_t LCD_Command(uint8_t command)
{
    I2C_Status_t status = LCD_BeginTransaction();

    if (status == I2C_OK) {
        status = LCD_WriteByteRaw(command, 0U);
    }

    return LCD_EndTransaction(status);
}

I2C_Status_t LCD_Init(void)
{
    I2C_Status_t status;

    if (lcd_i2c == 0) {
        return I2C_NOT_READY;
    }

    delay_ms(50U);

    /* HD44780 4-bit startup sequence */
    status = LCD_WriteNibble(0x03U);
    if (status != I2C_OK) return status;
    delay_ms(5U);

    status = LCD_WriteNibble(0x03U);
    if (status != I2C_OK) return status;
    delay_us(200U);

    status = LCD_WriteNibble(0x03U);
    if (status != I2C_OK) return status;
    delay_us(200U);

    status = LCD_WriteNibble(0x02U);
    if (status != I2C_OK) return status;

    status = LCD_Command(LCD_CMD_FUNCTION_SET);
    if (status != I2C_OK) return status;

    status = LCD_Command(LCD_CMD_DISPLAY_ON);
    if (status != I2C_OK) return status;

    status = LCD_Clear();
    if (status != I2C_OK) return status;

    return LCD_Command(LCD_CMD_ENTRY_MODE);
}

I2C_Status_t LCD_Clear(void)
{
    I2C_Status_t status = LCD_Command(LCD_CMD_CLEAR);
    delay_ms(2U);
    return status;
}

I2C_Status_t LCD_SetCursor(uint8_t row, uint8_t column)
{
    uint8_t address;

    if (row > 1U) row = 1U;
    if (column > 15U) column = 15U;

    address = (uint8_t)((row == 0U ? 0x00U : 0x40U) + column);
    return LCD_Command((uint8_t)(LCD_CMD_SET_DDRAM | address));
}

I2C_Status_t LCD_Print(const char *text)
{
    I2C_Status_t status;

    if (text == 0) {
        return I2C_NOT_READY;
    }

    status = LCD_BeginTransaction();
    if (status != I2C_OK) {
        return status;
    }

    while (*text != '\0') {
        status = LCD_WriteByteRaw((uint8_t)*text, 1U);
        if (status != I2C_OK) {
            break;
        }
        text++;
    }

    return LCD_EndTransaction(status);
}

I2C_Status_t LCD_WriteLine(uint8_t row, const char *text)
{
    I2C_Status_t status;
    uint8_t i;

    if (text == 0) {
        return I2C_NOT_READY;
    }

    status = LCD_SetCursor(row, 0U);
    if (status != I2C_OK) {
        return status;
    }

    status = LCD_BeginTransaction();
    if (status != I2C_OK) {
        return status;
    }

    for (i = 0U; i < 16U; i++) {
        uint8_t ch = (*text != '\0') ? (uint8_t)*text++ : (uint8_t)' ';

        status = LCD_WriteByteRaw(ch, 1U);
        if (status != I2C_OK) {
            break;
        }
    }

    return LCD_EndTransaction(status);
}

I2C_Status_t LCD_ShowStopWatch(uint8_t hour,
                               uint8_t min,
                               uint8_t sec,
                               uint8_t centisecond,
                               uint8_t is_running)
{
    char time_line[17];
    char state_line[17];
    I2C_Status_t status;

    (void)snprintf(time_line, sizeof(time_line),
                   "T %02u:%02u:%02u.%02u",
                   (unsigned int)hour,
                   (unsigned int)min,
                   (unsigned int)sec,
                   (unsigned int)centisecond);

    (void)snprintf(state_line, sizeof(state_line),
                   "STATE: %s", (is_running != 0U) ? "RUN" : "STOP");

    status = LCD_WriteLine(0U, time_line);
    if (status != I2C_OK) {
        return status;
    }

    return LCD_WriteLine(1U, state_line);
}

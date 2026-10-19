#include <assert.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>

#include "integration/input_pose.h"
#include "integration/uart_pose_app.h"
#include "uart_pose/uart_pose_protocol.h"

static uint8_t rx_bytes[128];
static unsigned rx_count;
static unsigned rx_index;
static HumanPose2D received;
static unsigned published;

int xil_printf(const char *format, ...)
{
    (void)format;
    return 0;
}

int platform_uart_read_byte(void)
{
    if (rx_index == rx_count) return -1;
    return rx_bytes[rx_index++];
}

int input_pose_ready(void) { return 0; }
int input_pose_uart_publish(const HumanPose2D *pose)
{
    received = *pose;
    ++published;
    return 1;
}

static void add_byte(uint8_t byte) { rx_bytes[rx_count++] = byte; }

int main(void)
{
    uint8_t packet[POSE_UART_PACKET_SIZE] = {0};
    uint16_t crc;
    CnnAppEvent event;
    unsigned i;

    packet[0] = POSE_UART_SYNC0;
    packet[1] = POSE_UART_SYNC1;
    packet[2] = POSE_UART_VERSION;
    packet[3] = POSE_UART_PAYLOAD_SIZE;
    packet[4] = 7U;
    packet[8] = 1U;
    packet[9] = POSE_UART_VALID_FINGER1;
    packet[10] = 'R'; /* payload byte must not toggle RECORD */
    packet[11] = 1U;
    packet[12] = 'P'; /* payload byte must not toggle PLAY */
    crc = pose_uart_crc16_ccitt(&packet[2], 32U);
    packet[34] = (uint8_t)crc;
    packet[35] = (uint8_t)(crc >> 8);

    uart_pose_app_init();
    add_byte('R');
    for (i = 0; i < sizeof(packet); ++i) add_byte(packet[i]);
    uart_pose_app_service();
    assert(uart_pose_app_take_control_event(&event));
    assert(event == CNN_APP_EVENT_RECORD_TOGGLE);
    assert(!uart_pose_app_take_control_event(&event));
    assert(published == 1U && received.frame_id == 7U);
    assert(received.finger1.valid && received.finger1.x == 338.0f);
    assert(received.finger1.y == 80.0f);

    rx_count = rx_index = 0U;
    add_byte('R');
    add_byte('P');
    uart_pose_app_service();
    assert(uart_pose_app_take_control_event(&event));
    assert(event == CNN_APP_EVENT_RECORD_TOGGLE);
    assert(!uart_pose_app_take_control_event(&event));
    rx_count = rx_index = 0U;
    add_byte('P');
    uart_pose_app_service();
    assert(uart_pose_app_take_control_event(&event));
    assert(event == CNN_APP_EVENT_PLAY_TOGGLE);
    puts("test_uart_pose_app: PASS");
    return 0;
}

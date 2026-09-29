#include "integration/uart_pose_app.h"

#include "integration/input_pose.h"
#include "integration/platform.h"
#include "uart_pose/uart_pose_protocol.h"
#include "xil_printf.h"

static PoseUartParser s_parser;
static CnnAppEvent s_event;
static unsigned long s_overwritten;

int uart_pose_app_init(void)
{
    pose_uart_parser_init(&s_parser);
    s_event = CNN_APP_EVENT_NONE;
    s_overwritten = 0UL;
    xil_printf("[UART] pose input ready; 36-byte packets, R=record, P=play\r\n");
    return 0;
}

void uart_pose_app_service(void)
{
    unsigned count;
    for (count = 0U; count < 128U; ++count) {
        HumanPose2D pose;
        int byte = platform_uart_read_byte();
        int result;
        if (byte < 0) break;

        /* Commands are recognized only between packets, never in a payload. */
        if (s_parser.state == POSE_UART_WAIT_SYNC0 &&
            (byte == CNN_APP_UART_CMD_RECORD || byte == CNN_APP_UART_CMD_PLAY)) {
            if (s_event == CNN_APP_EVENT_NONE)
                s_event = byte == CNN_APP_UART_CMD_RECORD
                    ? CNN_APP_EVENT_RECORD_TOGGLE : CNN_APP_EVENT_PLAY_TOGGLE;
            continue;
        }
        result = pose_uart_parser_push(&s_parser, (uint8_t)byte, &pose);
        if (result == 1) {
            if (input_pose_ready()) ++s_overwritten;
            input_pose_uart_publish(&pose);
            if ((s_parser.packets_ok % 100U) == 0U)
                xil_printf("[UART] packets=%lu crc=%lu format=%lu range=%lu pending_overwrite=%lu\r\n",
                           (unsigned long)s_parser.packets_ok,
                           (unsigned long)s_parser.crc_errors,
                           (unsigned long)s_parser.format_errors,
                           (unsigned long)s_parser.range_errors,
                           s_overwritten);
        }
    }
}

int uart_pose_app_take_control_event(CnnAppEvent *event)
{
    if (event == 0 || s_event == CNN_APP_EVENT_NONE) return 0;
    *event = s_event;
    s_event = CNN_APP_EVENT_NONE;
    return 1;
}

void uart_pose_app_report_control_result(CnnAppEvent event, int accepted,
                                         const char *mode, const char *reason,
                                         unsigned long record_count,
                                         unsigned long replay_count,
                                         const char *record_source,
                                         const char *replay_source)
{
    xil_printf("[RR] %s %s: mode=%s reason=%s record=%lu(%s) replay=%lu(%s)\r\n",
               event == CNN_APP_EVENT_RECORD_TOGGLE ? "RECORD" : "PLAY",
               accepted ? "accepted" : "rejected", mode, reason,
               record_count, record_source, replay_count, replay_source);
}

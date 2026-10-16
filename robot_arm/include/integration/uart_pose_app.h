#ifndef INTEGRATION_UART_POSE_APP_H
#define INTEGRATION_UART_POSE_APP_H

#include "integration/cnn_app.h"

/* UART-only input for the integrated Agent1/2/3 record/replay app. */
int uart_pose_app_init(void);
void uart_pose_app_service(void);
int uart_pose_app_take_control_event(CnnAppEvent *event);
void uart_pose_app_report_control_result(CnnAppEvent event, int accepted,
                                         const char *mode, const char *reason,
                                         unsigned long record_count,
                                         unsigned long replay_count,
                                         const char *record_source,
                                         const char *replay_source);

#endif

#ifdef ROBOT_UART_POSE_INPUT
#include "integration/input_pose.h"

#include <string.h>
#include "xtime_l.h"

static HumanPose2D s_pose;
static float s_dt_sec;
static XTime s_last_time;
static int s_have_last;
static int s_ready;

void input_pose_init(void)
{
    memset(&s_pose, 0, sizeof(s_pose));
    s_dt_sec = 0.05f;
    s_last_time = 0U;
    s_have_last = 0;
    s_ready = 0;
}

int input_pose_uart_publish(const HumanPose2D *pose)
{
    XTime now;
    if (pose == 0) return 0;
    XTime_GetTime(&now);
    if (s_have_last)
        s_dt_sec = (float)((double)(now - s_last_time) /
                           (double)COUNTS_PER_SECOND);
    else
        s_dt_sec = 0.05f;
    s_last_time = now;
    s_have_last = 1;
    s_pose = *pose;
    s_ready = 1;
    return 1;
}

int input_pose_ready(void)
{
    return s_ready;
}

int input_pose_take(HumanPose2D *pose, float *dt_sec)
{
    if (!s_ready || pose == 0 || dt_sec == 0) return 0;
    *pose = s_pose;
    *dt_sec = s_dt_sec;
    s_ready = 0;
    return 1;
}
#else
typedef char input_pose_uart_excluded_in_cnn_mode;
#endif /* ROBOT_UART_POSE_INPUT */

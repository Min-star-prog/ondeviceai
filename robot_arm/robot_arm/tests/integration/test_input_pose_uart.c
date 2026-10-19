#include <assert.h>
#include <math.h>
#include <stdio.h>
#include <string.h>
#include "xtime_l.h"
#include "integration/input_pose.h"

static XTime fake_time;
void XTime_GetTime(XTime *time) { *time = fake_time; }

int main(void)
{
    HumanPose2D source;
    HumanPose2D received;
    float dt;
    memset(&source, 0, sizeof(source));
    input_pose_init();
    assert(!input_pose_ready());
    source.frame_id = 10U;
    source.valid = 1U;
    fake_time = 1000000U;
    assert(input_pose_uart_publish(&source));
    assert(input_pose_take(&received, &dt));
    assert(received.frame_id == 10U && received.valid);
    assert(fabsf(dt - 0.05f) < 0.00001f);
    assert(!input_pose_ready());
    source.frame_id = 11U;
    fake_time = 1020000U;
    assert(input_pose_uart_publish(&source));
    assert(input_pose_take(&received, &dt));
    assert(received.frame_id == 11U);
    assert(fabsf(dt - 0.02f) < 0.00001f);
    puts("test_input_pose_uart: PASS");
    return 0;
}

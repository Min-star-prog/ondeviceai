#include "platform.h"
#include "xparameters.h"
#include "xil_io.h"
#include "sleep.h"
#include <stdint.h>

#define GPIOA_BASEADDR  XPAR_GPIO_0_S00_AXI_BASEADDR
#define GPIOB_BASEADDR  XPAR_GPIO_1_S00_AXI_BASEADDR

#define GPIO_CR_OFFSET   0x00U
#define GPIO_ODR_OFFSET  0x08U

int main()
{
    uint16_t led_data = 0x0001;
    int direction = 1;

    init_platform();

    /*
     * GPIOA[7:0] : LED[0]  ~ LED[7]
     * GPIOB[7:0] : LED[8]  ~ LED[15]
     *
     * 현재 GPIO RTL에서 CR=1이 output 설정이라는 기준
     */
    Xil_Out32(GPIOA_BASEADDR + GPIO_CR_OFFSET, 0x000000FF);
    Xil_Out32(GPIOB_BASEADDR + GPIO_CR_OFFSET, 0x000000FF);

    while (1) {
        /* LED[0] ~ LED[7] */
        Xil_Out32(GPIOA_BASEADDR + GPIO_ODR_OFFSET,
                  (uint32_t)(led_data & 0x00FF));

        /* LED[8] ~ LED[15] */
        Xil_Out32(GPIOB_BASEADDR + GPIO_ODR_OFFSET,
                  (uint32_t)((led_data >> 8) & 0x00FF));

        usleep(150000);

        /* LED[15]에서 오른쪽 방향으로 전환 */
        if (led_data == 0x8000) {
            direction = -1;
        }
        /* LED[0]에서 왼쪽 방향으로 전환 */
        else if (led_data == 0x0001) {
            direction = 1;
        }

        if (direction == 1) {
            led_data <<= 1;
        }
        else {
            led_data >>= 1;
        }
    }

    cleanup_platform();
    return 0;
}

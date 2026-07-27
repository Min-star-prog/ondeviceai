// 여기에 사용자 임의의 define을 작성하시오
#define GPIOA_MODE   (*(int *)0x40020000)
#define GPIOA_OTYPER (*(int *)0x40020004)   
#define GPIOA_ODR    (*(int *)0x40020014)   

// void Main(void)
// {
//    // LED GPA[5]를 출력(General Push Pull) 모드로 설정하시오

//    GPIOA_MODE = 0x400;
//    GPIOA_OTYPER = 0;

//    // GPA[5] LED를 ON 시키도록 설정하시오

//    GPIOA_ODR = 0x20;
// }



void Main(void)
{
   GPIOA_MODE = 0x4000;
   GPIOA_OTYPER = 1<<7;
   GPIOA_ODR = 0x80;
}




#include "msp.h"
volatile uint32_t c=0;
/**
 * main.c
 */
__interrupt void TA0_0_IRQHandler (void)
{      c++;
       if(c==21000)
       {
           P1OUT ^= BIT0 | BIT5;                          // Toggle P1.0
           c=0;
       }
}
void main(void)
{

	P1DIR=0x01;
	P1OUT=0x01;
	TA0CTL=0X02C2;
	TIMER_A0->CCTL[0]=TIMER_A_CCTLN_CCIE;
	TIMER_A0->CTL=TIMER_A_CTL_SSEL__SMCLK | TIMER_A_CTL_MC__CONTINUOUS | TIMER_A_CTL_ID__8;
	SCB->SCR|=SCB_SCR_SLEEPONEXIT_Msk;
	__enable_irq();
	__DSB();
	NVIC->ISER[0]=1<<((TA0_0_IRQn)&31);
	while(1)
	{   __sleep();
	    __no_operation();
	}

}

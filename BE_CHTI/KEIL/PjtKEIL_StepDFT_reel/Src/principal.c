

#include "DriverJeuLaser.h"
#include "DFT.h"
#include "Affichage_valise.h"

//extern int DFT_ModuleAuCarre( short int * Signal64ech, char k) ;
short dma_buf[64]; 
int dft_tab[64];

void CallbackSystick(void){
		//utilisation
	Start_DMA1(64);
	Wait_On_End_Of_DMA1();
	Stop_DMA1;
	for (int i=0;i<64;i++){
		dft_tab[i]=DFT_ModuleAuCarre(dma_buf,i);
	}
}

void CallbackTimer(void);

int main(void)
{

// ===========================================================================
// ============= INIT PERIPH (faites qu'une seule fois)  =====================
// ===========================================================================

// Après exécution : le coeur CPU est clocké à 72MHz ainsi que tous les timers
CLOCK_Configure();
Timer_1234_Init_ff( TIM2, 225);
//Active_IT_Debordement_Timer( TIM2, 1, CallbackTimer );
//Timer_1234_Init_ff( TIM1, 57600);
//Active_IT_Debordement_Timer( TIM1, 8, Mise_A_Jour_Afficheurs_LED );
//GPIOA_Set('2');
	//Initialisation du systick
Systick_Period_ff( 360000 );
Systick_Prio_IT( 0,CallbackSystick );
SysTick_On ;
SysTick_Enable_IT ;

	//config
Init_TimingADC_ActiveADC_ff( ADC1, 72 );
Single_Channel_ADC( ADC1, 2 );
Init_Conversion_On_Trig_Timer_ff( ADC1, TIM2_CC2, 225 );
Init_ADC1_DMA1( 0, dma_buf );



//============================================================================	
	
	
while	(1)
	{
	}
}


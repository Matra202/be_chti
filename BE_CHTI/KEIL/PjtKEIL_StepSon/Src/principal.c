

#include "DriverJeuLaser.h"
#include "GestionSon.h"

extern short indice;
void startson(){
	indice=0;
	
}

int main(void)
{

// ===========================================================================
// ============= INIT PERIPH (faites qu'une seule fois)  =====================
// ===========================================================================

// Apr?s ex?cution : le coeur CPU est clock? ? 72MHz ainsi que tous les timers


// Activation des interruptions issues du Timer 4
// Association de la fonction ? ex?cuter lors de l'interruption : timer_callback
// cette fonction (si ?crite en ASM) doit ?tre conforme ? l'AAPCS
	
//Active_IT_Debordement_Timer( TIM4, 2, CallbackSon );	
	
	
// configuration de PortB.1 (PB1) en sortie push-pull
//GPIO_Configure(GPIOB, 1, OUTPUT, OUTPUT_PPULL);
	
	
	
	startson();
	CLOCK_Configure();
	Timer_1234_Init_ff( TIM4, 6552  );
	Active_IT_Debordement_Timer( TIM4, 2, CallbackSon );
		
	PWM_Init_ff(TIM3,3,720);
	GPIO_Configure(GPIOB, 0, OUTPUT, ALT_PPULL);
//============================================================================	
	
	
while	(1)
	{
	}
}


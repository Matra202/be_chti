

#include "DriverJeuLaser.h"
#include "DFT.h"

//extern int DFT_ModuleAuCarre( short int * Signal64ech, char k) ;


int main(void)
{

// ===========================================================================
// ============= INIT PERIPH (faites qu'une seule fois)  =====================
// ===========================================================================

// Apr�s ex�cution : le coeur CPU est clock� � 72MHz ainsi que tous les timers
CLOCK_Configure();



//============================================================================	
	
	
while	(1)
	{
		//test 1ere �tape
		char k1=1;
		
		DFT_ModuleAuCarre(&LeSignal[0],k1);
		//Partie1(&LeSignal[0],k1);
	}
}


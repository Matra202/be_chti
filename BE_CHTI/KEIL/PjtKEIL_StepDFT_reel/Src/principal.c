

#include "DriverJeuLaser.h"
#include "DFT.h"
#include "Affichage_Valise.h"
#include "GestionSon.h"

extern short indiceson;

//extern int DFT_ModuleAuCarre( short int * Signal64ech, char k) ;
short dma_buf[64]; 
int dft_tab[64];
int tab_score[4];
int compteur[4];
void check_cible(void);
int capteur = 1;


void startson(){
	indiceson=0;
	
}

void CallbackSystick(void){
		//utilisation
	Start_DMA1(64);
	Wait_On_End_Of_DMA1();
	Stop_DMA1;
	for (int i=0;i<64;i++){
		dft_tab[i]=DFT_ModuleAuCarre(dma_buf,i);
	}
	check_cible();
}

void CallbackTimer(void);

void initialisation(void){
	Init_Affichage();
	Prepare_Set_LED(0);
	Choix_Capteur(capteur);
	for (int i =1;i<5;i++){
		//Prepare_Clear_Point_Unite(i);
		Prepare_Afficheur(i, 0);
		tab_score[i-1]=0;
		compteur[i-1]=0;
	}
	Mise_A_Jour_Afficheurs_LED();
}

void check_cible(){ 
	for (int  i =17;i<21;i++){
		if (dft_tab[i]>3000) {
			compteur[i-17]++;
			if (compteur[i-17]>=11){
				tab_score[i-17]++;
				startson();
				Prepare_Afficheur(i-16,tab_score[i-17]);
				for (int j =0;j<4;j++){
					Prepare_Clear_LED(j);
				}	
				capteur=dft_tab[0]%4 +1;
				Prepare_Set_LED((capteur)%4);
				if (capteur==4){
					capteur=1;
				}
				else{
					capteur+=1;
				}
				capteur=(capteur);
				Choix_Capteur(capteur);
				Mise_A_Jour_Afficheurs_LED();
				compteur[i-17]=0;
			}
		}
		else {
			compteur[i-17]=0;
		}
	}
}


int main(void)
{

// ===========================================================================
// ============= INIT PERIPH (faites qu'une seule fois)  =====================
// ===========================================================================

// Après exécution : le coeur CPU est clocké à 72MHz ainsi que tous les timers
initialisation();
CLOCK_Configure();
Timer_1234_Init_ff( TIM2, 225);
//Active_IT_Debordement_Timer( TIM2, 1, CallbackTimer );
Timer_1234_Init_ff( TIM1, 57600);
//probleme en dessous qui casse tout
	//Active_IT_Debordement_Timer( TIM1, 8, Mise_A_Jour_Afficheurs_LED );
//GPIOA_Set('2');
	//Initialisation du systick
Systick_Period_ff( 360000 );
Systick_Prio_IT( 10,CallbackSystick );
SysTick_On ;
SysTick_Enable_IT ;

	//config
Init_TimingADC_ActiveADC_ff( ADC1, 72 );
Single_Channel_ADC( ADC1, 2 );
Init_Conversion_On_Trig_Timer_ff( ADC1, TIM2_CC2, 225 );
Init_ADC1_DMA1( 0, dma_buf );

Timer_1234_Init_ff( TIM4, 6552  );
Active_IT_Debordement_Timer( TIM4, 5, CallbackSon );
		
PWM_Init_ff(TIM3,3,720);
GPIO_Configure(GPIOB, 0, OUTPUT, ALT_PPULL);






//============================================================================	
	
	
while	(1)
	{
		
	}
}


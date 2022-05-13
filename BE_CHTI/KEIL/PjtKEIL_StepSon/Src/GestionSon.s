	PRESERVE8
	THUMB   
		

; ====================== zone de réservation de données,  ======================================
;Section RAM (read only) :
	area    mesdata,data,readonly
;Te =  PeriodeSonMicroSec en µs 

;Section RAM (read write):
	area    maram,data,readwrite
				
				
	IMPORT Son
	IMPORT LongueurSon
	
SortieSon dcd 0
indiceson dcw 5512 ;on ne lance pas le son au début 
	EXPORT SortieSon
	EXPORT indiceson
; ===============================================================================================
	
	EXPORT CallbackSon
		
;Section ROM code (read only) :		
	area    moncode,code,readonly
; écrire le code ici		
	include DriverJeuLaser.inc

CallbackSon proc
	push{r4-r10}
	ldr r1,=indiceson
	ldr r0,[r1]
	ldr r3,=LongueurSon
	ldr r4,[r3]
	cmp r0,r4
	beq echantilloncomplet
;on créer un "for" de i allant de 1 a 5512 (Longueur Son)
				;cmp indice,#5512
				;bne échantillon pas complet on envoie 
				;sinon échantillon complet on ne lit plus
	ldr r3,=Son
	ldrsh r2,[r3,r0,lsl#1]
	mov r4,#32768
	add r2,r4
	mov r4,#91
	sdiv r2,r4

;accéder au tableauson à l'indice i
;ajouter 32768 à la valeur 
;diviser cette valeur par 65 535
;multiplier par 719
;on a bien une valeur dans [0;719] sur sortieSon
;il faut store la valeur au bon endroit du tableau[indice]
	ldr r4,=SortieSon
	str r2,[r4]
	mov r3,r0
	mov r0,r2
    push {r3,r1,lr}
	bl PWM_Set_Value_TIM3_Ch3
	pop {r3,r1,lr}
	mov r0,r3
	add r0,#1
	str r0,[r1]
;i++
echantilloncomplet
	pop{r4-r10}
	bx lr 
	endp	
		 
	END	
	PRESERVE8
	THUMB   
		

; ====================== zone de r�servation de donn�es,  ======================================
;Section RAM (read only) :
	area    mesdata,data,readonly
;Te =  PeriodeSonMicroSec en �s 

;Section RAM (read write):
	area    maram,data,readwrite
		
SortieSon dcw 0
indice dcw 0
	EXPORT SortieSon
	EXPORT indice
; ===============================================================================================
	
	EXPORT CallbackSon

		
;Section ROM code (read only) :		
	area    moncode,code,readonly
; �crire le code ici		
	include DriverJeuLaser.inc

CallbackSon proc

	ldr r0,=indice
	mov r0,#0xAABB
	strh r0,[r1]
	cmp r1,#5512
	beq echantilloncomplet
;on cr�er un "for" de i allant de 1 a 5512 
				;cmp indice,#5512
				;bne �chantillon pas complet on envoie 
				;sinon �chantillon complet on ne lit plus
	ldr r2,=Son
;acc�der au tableauson � l'indice i
;ajouter 32768 � la valeur 
;diviser cette valeur par 65 535
;multiplier par 719
;on a bien une valeur dans [0;719] sur sortieSon
;il faut store la valeur au bon endroit du tableau[indice]
;i++
echantilloncomplet
	bx lr 
	endp	
		;cmp i a 5512,bne, algo,i++, 
	END	
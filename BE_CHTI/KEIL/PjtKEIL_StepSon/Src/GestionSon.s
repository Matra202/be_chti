	PRESERVE8
	THUMB   
		

; ====================== zone de réservation de données,  ======================================
;Section RAM (read only) :
	area    mesdata,data,readonly
;Te =  PeriodeSonMicroSec en µs 

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
; écrire le code ici		
	include DriverJeuLaser.inc

CallbackSon proc

	ldr r0,=indice
	mov r0,#0xAABB
	strh r0,[r1]
	cmp r1,#5512
	beq echantilloncomplet
;on créer un "for" de i allant de 1 a 5512 
				;cmp indice,#5512
				;bne échantillon pas complet on envoie 
				;sinon échantillon complet on ne lit plus
	ldr r2,=Son
;accéder au tableauson à l'indice i
;ajouter 32768 à la valeur 
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
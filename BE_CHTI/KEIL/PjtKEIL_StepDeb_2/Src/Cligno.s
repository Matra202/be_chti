	PRESERVE8
	THUMB   
	




; ====================== zone de réservation de données,  ======================================
;Section RAM (read only) :
	area    mesdata,data,readonly


;Section RAM (read write):
	area    maram,data,readwrite
		
FlagCligno dcb 0
	
	EXPORT FlagCligno
; ===============================================================================================
	


		
;Section ROM code (read only) :		
	area    moncode,code,readonly
; écrire le code ici		

	include DriverJeuLaser.inc
	
timer_callback proc

	;if (FlagCligno==1)
	ldr r0,=FlagCligno
	ldr r1,[r0]
	cmp r1,#1
	bne pasegala1
	;{
	;	FlagCligno=0;
	mov r1,#0
	str r1,[r0]
	mov r0,#1
	push{lr}
	bl GPIOB_Set;
	pop{lr}
	bx lr
	;}
	;else	
pasegala1
;	{
;		FlagCligno=1;
	mov r1,#1
	str r1,[r0]
	push{lr}
	mov r0,#1
	bl GPIOB_Clear;
	
	pop{lr}
	bx lr
;	}



	endp
			
	EXPORT timer_callback

	END	
	PRESERVE8
	THUMB   
		

; ====================== zone de r�servation de donn�es,  ======================================
;Section RAM (read only) :
	area    mesdata,data,readonly

	IMPORT LeSignal	

;Section RAM (read write):
	area    maram,data,readwrite
	
indice dcw 0
sortie dcd 0
	EXPORT sortie
	EXPORT indice

	
; ===============================================================================================
	
	
	EXPORT DFT_ModuleAuCarre
	EXPORT Partie1
	EXPORT Partie2
;Section ROM code (read only) :		
	area    moncode,code,readonly
; �crire le code ici		

Partie1 proc 
; partie 1 (r�elle) :
	
debut
	ldr r3,=indice
	ldr r2,[r3]
	cmp r2,#64
	beq finboucle
	;pour i de 0 a M-1 = 0 � 63{
	ldrh r4,[r0,r2,lsl#1]
	;on accede a la valeur du tableau a n : xn=x(n) (r4)
	;nk=n*k(mod)64 (r5)
	mul r5,r2,r1
	and r5,#0x003F
	;on fait le modulo 64 de n*k avec un masque 6 bits
	;c=cos(2*pi*nk/M)
	ldr r6,=TabCos
	ldrsh r6,[r6,r5,lsl#1]
	mul r6,r6,r4
	ldr r7,=sortie
	ldr r8,[r7]
	add r8,r6
	str r8,[r7]
	;on mutliplie et on l'additionne � la somme des valeurs d�ja trouv�es
	;sum=c*xn+sum}
	add r2,#1
	str r2,[r3]
	b debut
	;incr�ment de l'indice 
	;fin pour}
finboucle
	ldr r7,=sortie
	ldr r0,[r7]
	mov r4,#0
	str r4,[r3]
	str r4,[r7]
	bx lr
	;� la fin de la boucle on retourne la somme 
	;return sum
	endp

Partie2 proc 
; partie 2 (im) :
debut2
	ldr r3,=indice
	ldr r2,[r3]
	cmp r2,#64
	beq finboucle2
	;pour i de 0 a M-1 = 0 � 63{
	ldrh r4,[r0,r2,lsl#1]
	;on accede a la valeur du tableau a n : xn=x(n) (r4)
	;nk=n*k(mod)64 (r5)
	mul r5,r2,r1
	and r5,#0x003F
	;on fait le modulo 64 de n*k avec un masque 6 bits
	;c=cos(2*pi*nk/M)
	ldr r6,=TabSin
	ldrsh r6,[r6,r5,lsl#1]
	mul r6,r6,r4
	ldr r7,=sortie
	ldr r8,[r7]
	add r8,r6
	str r8,[r7]
	;on mutliplie et on l'additionne � la somme des valeurs d�ja trouv�es
	;sum=c*xn+sum}
	add r2,#1
	str r2,[r3]
	b debut2
	;incr�ment de l'indice 
	;fin pour}
finboucle2
	ldr r7,=sortie
	ldr r0,[r7]
	bx lr
	;� la fin de la boucle on retourne la somme 
	;return sum
	endp


DFT_ModuleAuCarre proc 

	;partie 3
	push{lr}
	push{r0,r1}
	bl Partie1
	mov r2,r0
	pop{r0,r1}
	push{r2}
	bl Partie2
	pop{r2}
	mov r3,r0
	pop{lr}
	;reste a module au carr� r2+r3 (cos + sin)
	mov r4,#0
	smlal r7,r4,r2,r2 ;carr� des cos 10.22 sur les bits de poids fort
	smlal r7,r4,r3,r3 ;carr� des sin 10.22 sur les bits de poids fort
	;add r4,r5 ;10.22 sur les bits de poids fort
	mov r0,r4
	;il faut mettre sur r0 et r1 car 64 bits
	bx lr;on a un r�sultat en 10.54 car on multiplie des 5.27 pour les carr�s et on les sommes
	;� la fin de la boucle on retourne la somme 
	;return sum
	endp
;Section ROM code (read only) :		
	AREA Trigo, DATA, READONLY
; codage fractionnaire 1.15

TabCos
	DCW	32767	;  0 0x7fff  0.99997
	DCW	32610	;  1 0x7f62  0.99518
	DCW	32138	;  2 0x7d8a  0.98077
	DCW	31357	;  3 0x7a7d  0.95694
	DCW	30274	;  4 0x7642  0.92389
	DCW	28899	;  5 0x70e3  0.88193
	DCW	27246	;  6 0x6a6e  0.83148
	DCW	25330	;  7 0x62f2  0.77301
	DCW	23170	;  8 0x5a82  0.70709
	DCW	20788	;  9 0x5134  0.63440
	DCW	18205	; 10 0x471d  0.55557
	DCW	15447	; 11 0x3c57  0.47141
	DCW	12540	; 12 0x30fc  0.38269
	DCW	 9512	; 13 0x2528  0.29028
	DCW	 6393	; 14 0x18f9  0.19510
	DCW	 3212	; 15 0x0c8c  0.09802
	DCW	    0	; 16 0x0000  0.00000
	DCW	-3212	; 17 0xf374 -0.09802
	DCW	-6393	; 18 0xe707 -0.19510
	DCW	-9512	; 19 0xdad8 -0.29028
	DCW	-12540	; 20 0xcf04 -0.38269
	DCW	-15447	; 21 0xc3a9 -0.47141
	DCW	-18205	; 22 0xb8e3 -0.55557
	DCW	-20788	; 23 0xaecc -0.63440
	DCW	-23170	; 24 0xa57e -0.70709
	DCW	-25330	; 25 0x9d0e -0.77301
	DCW	-27246	; 26 0x9592 -0.83148
	DCW	-28899	; 27 0x8f1d -0.88193
	DCW	-30274	; 28 0x89be -0.92389
	DCW	-31357	; 29 0x8583 -0.95694
	DCW	-32138	; 30 0x8276 -0.98077
	DCW	-32610	; 31 0x809e -0.99518
	DCW	-32768	; 32 0x8000 -1.00000
	DCW	-32610	; 33 0x809e -0.99518
	DCW	-32138	; 34 0x8276 -0.98077
	DCW	-31357	; 35 0x8583 -0.95694
	DCW	-30274	; 36 0x89be -0.92389
	DCW	-28899	; 37 0x8f1d -0.88193
	DCW	-27246	; 38 0x9592 -0.83148
	DCW	-25330	; 39 0x9d0e -0.77301
	DCW	-23170	; 40 0xa57e -0.70709
	DCW	-20788	; 41 0xaecc -0.63440
	DCW	-18205	; 42 0xb8e3 -0.55557
	DCW	-15447	; 43 0xc3a9 -0.47141
	DCW	-12540	; 44 0xcf04 -0.38269
	DCW	-9512	; 45 0xdad8 -0.29028
	DCW	-6393	; 46 0xe707 -0.19510
	DCW	-3212	; 47 0xf374 -0.09802
	DCW	    0	; 48 0x0000  0.00000
	DCW	 3212	; 49 0x0c8c  0.09802
	DCW	 6393	; 50 0x18f9  0.19510
	DCW	 9512	; 51 0x2528  0.29028
	DCW	12540	; 52 0x30fc  0.38269
	DCW	15447	; 53 0x3c57  0.47141
	DCW	18205	; 54 0x471d  0.55557
	DCW	20788	; 55 0x5134  0.63440
	DCW	23170	; 56 0x5a82  0.70709
	DCW	25330	; 57 0x62f2  0.77301
	DCW	27246	; 58 0x6a6e  0.83148
	DCW	28899	; 59 0x70e3  0.88193
	DCW	30274	; 60 0x7642  0.92389
	DCW	31357	; 61 0x7a7d  0.95694
	DCW	32138	; 62 0x7d8a  0.98077
	DCW	32610	; 63 0x7f62  0.99518
TabSin 
	DCW	    0	;  0 0x0000  0.00000
	DCW	 3212	;  1 0x0c8c  0.09802
	DCW	 6393	;  2 0x18f9  0.19510
	DCW	 9512	;  3 0x2528  0.29028
	DCW	12540	;  4 0x30fc  0.38269
	DCW	15447	;  5 0x3c57  0.47141
	DCW	18205	;  6 0x471d  0.55557
	DCW	20788	;  7 0x5134  0.63440
	DCW	23170	;  8 0x5a82  0.70709
	DCW	25330	;  9 0x62f2  0.77301
	DCW	27246	; 10 0x6a6e  0.83148
	DCW	28899	; 11 0x70e3  0.88193
	DCW	30274	; 12 0x7642  0.92389
	DCW	31357	; 13 0x7a7d  0.95694
	DCW	32138	; 14 0x7d8a  0.98077
	DCW	32610	; 15 0x7f62  0.99518
	DCW	32767	; 16 0x7fff  0.99997
	DCW	32610	; 17 0x7f62  0.99518
	DCW	32138	; 18 0x7d8a  0.98077
	DCW	31357	; 19 0x7a7d  0.95694
	DCW	30274	; 20 0x7642  0.92389
	DCW	28899	; 21 0x70e3  0.88193
	DCW	27246	; 22 0x6a6e  0.83148
	DCW	25330	; 23 0x62f2  0.77301
	DCW	23170	; 24 0x5a82  0.70709
	DCW	20788	; 25 0x5134  0.63440
	DCW	18205	; 26 0x471d  0.55557
	DCW	15447	; 27 0x3c57  0.47141
	DCW	12540	; 28 0x30fc  0.38269
	DCW	 9512	; 29 0x2528  0.29028
	DCW	 6393	; 30 0x18f9  0.19510
	DCW	 3212	; 31 0x0c8c  0.09802
	DCW	    0	; 32 0x0000  0.00000
	DCW	-3212	; 33 0xf374 -0.09802
	DCW	-6393	; 34 0xe707 -0.19510
	DCW	-9512	; 35 0xdad8 -0.29028
	DCW	-12540	; 36 0xcf04 -0.38269
	DCW	-15447	; 37 0xc3a9 -0.47141
	DCW	-18205	; 38 0xb8e3 -0.55557
	DCW	-20788	; 39 0xaecc -0.63440
	DCW	-23170	; 40 0xa57e -0.70709
	DCW	-25330	; 41 0x9d0e -0.77301
	DCW	-27246	; 42 0x9592 -0.83148
	DCW	-28899	; 43 0x8f1d -0.88193
	DCW	-30274	; 44 0x89be -0.92389
	DCW	-31357	; 45 0x8583 -0.95694
	DCW	-32138	; 46 0x8276 -0.98077
	DCW	-32610	; 47 0x809e -0.99518
	DCW	-32768	; 48 0x8000 -1.00000
	DCW	-32610	; 49 0x809e -0.99518
	DCW	-32138	; 50 0x8276 -0.98077
	DCW	-31357	; 51 0x8583 -0.95694
	DCW	-30274	; 52 0x89be -0.92389
	DCW	-28899	; 53 0x8f1d -0.88193
	DCW	-27246	; 54 0x9592 -0.83148
	DCW	-25330	; 55 0x9d0e -0.77301
	DCW	-23170	; 56 0xa57e -0.70709
	DCW	-20788	; 57 0xaecc -0.63440
	DCW	-18205	; 58 0xb8e3 -0.55557
	DCW	-15447	; 59 0xc3a9 -0.47141
	DCW	-12540	; 60 0xcf04 -0.38269
	DCW	-9512	; 61 0xdad8 -0.29028
	DCW	-6393	; 62 0xe707 -0.19510
	DCW	-3212	; 63 0xf374 -0.09802


		
		
	END	
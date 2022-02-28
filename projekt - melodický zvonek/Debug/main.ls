   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.12.6 - 16 Dec 2021
   3                     ; Generator (Limited) V4.5.4 - 16 Dec 2021
  15                     .const:	section	.text
  16  0000               _tabulka_tonu:
  17  0000 0bb8          	dc.w	3000
  18  0002 07d0          	dc.w	2000
  19  0004 03e8          	dc.w	1000
  54                     ; 37 void main(void){
  56                     	switch	.text
  57  0000               _main:
  61                     ; 38 CLK_HSIPrescalerConfig(CLK_PRESCALER_HSIDIV1); // 16MHz z internÌho RC oscil·toru
  63  0000 4f            	clr	a
  64  0001 cd0000        	call	_CLK_HSIPrescalerConfig
  66                     ; 39 init_milis(); // spustit ËasovaË millis
  68  0004 cd0000        	call	_init_milis
  70                     ; 40 init_tim(); // nastavit a spustit timer
  72  0007 cd015a        	call	_init_tim
  74                     ; 41 swspi_init(); // SPI
  76  000a cd0000        	call	_swspi_init
  78                     ; 44 GPIO_Init(GPIOE,GPIO_PIN_5,GPIO_MODE_IN_FL_NO_IT); 
  80  000d 4b00          	push	#0
  81  000f 4b20          	push	#32
  82  0011 ae5014        	ldw	x,#20500
  83  0014 cd0000        	call	_GPIO_Init
  85  0017 85            	popw	x
  86                     ; 45 GPIO_Init(GPIOC,GPIO_PIN_2,GPIO_MODE_OUT_PP_LOW_SLOW); 
  88  0018 4bc0          	push	#192
  89  001a 4b04          	push	#4
  90  001c ae500a        	ldw	x,#20490
  91  001f cd0000        	call	_GPIO_Init
  93  0022 85            	popw	x
  94                     ; 46 GPIO_Init(GPIOC,GPIO_PIN_3,GPIO_MODE_OUT_PP_LOW_SLOW); 
  96  0023 4bc0          	push	#192
  97  0025 4b08          	push	#8
  98  0027 ae500a        	ldw	x,#20490
  99  002a cd0000        	call	_GPIO_Init
 101  002d 85            	popw	x
 102                     ; 47 GPIO_Init(GPIOC,GPIO_PIN_4,GPIO_MODE_OUT_PP_LOW_SLOW); 
 104  002e 4bc0          	push	#192
 105  0030 4b10          	push	#16
 106  0032 ae500a        	ldw	x,#20490
 107  0035 cd0000        	call	_GPIO_Init
 109  0038 85            	popw	x
 110  0039               L12:
 111                     ; 51 		ovladani_a_led();
 113  0039 ad02          	call	_ovladani_a_led
 116  003b 20fc          	jra	L12
 119                     	bsct
 120  0000               L52_x:
 121  0000 00            	dc.b	0
 122  0001               L72_y:
 123  0001 00            	dc.b	0
 124  0002               L13_z:
 125  0002 00            	dc.b	0
 126  0003               L33_i:
 127  0003 00            	dc.b	0
 128  0004               L53_minuly_cas:
 129  0004 0000          	dc.w	0
 205                     ; 55 void ovladani_a_led(void){
 206                     	switch	.text
 207  003d               _ovladani_a_led:
 211                     ; 63 if(GPIO_ReadInputPin(GPIOE,GPIO_PIN_5)==RESET && y==0){
 213  003d 4b20          	push	#32
 214  003f ae5014        	ldw	x,#20500
 215  0042 cd0000        	call	_GPIO_ReadInputPin
 217  0045 5b01          	addw	sp,#1
 218  0047 4d            	tnz	a
 219  0048 260c          	jrne	L57
 221  004a 3d01          	tnz	L72_y
 222  004c 2608          	jrne	L57
 223                     ; 64 	y=1;
 225  004e 35010001      	mov	L72_y,#1
 226                     ; 65 	x=1;
 228  0052 35010000      	mov	L52_x,#1
 229  0056               L57:
 230                     ; 68 if(GPIO_ReadInputPin(GPIOE,GPIO_PIN_5)!=RESET && y==1){
 232  0056 4b20          	push	#32
 233  0058 ae5014        	ldw	x,#20500
 234  005b cd0000        	call	_GPIO_ReadInputPin
 236  005e 5b01          	addw	sp,#1
 237  0060 4d            	tnz	a
 238  0061 2708          	jreq	L77
 240  0063 b601          	ld	a,L72_y
 241  0065 a101          	cp	a,#1
 242  0067 2602          	jrne	L77
 243                     ; 69 	y=0;
 245  0069 3f01          	clr	L72_y
 246  006b               L77:
 247                     ; 73 if(x==1){
 249  006b b600          	ld	a,L52_x
 250  006d a101          	cp	a,#1
 251  006f 2638          	jrne	L101
 252                     ; 74 	if(milis() - minuly_cas >= 1500){
 254  0071 cd0000        	call	_milis
 256  0074 72b00004      	subw	x,L53_minuly_cas
 257  0078 a305dc        	cpw	x,#1500
 258  007b 2530          	jrult	L701
 259                     ; 75 		z=223;
 261  007d 35df0002      	mov	L13_z,#223
 262                     ; 76 		minuly_cas = milis();
 264  0081 cd0000        	call	_milis
 266  0084 bf04          	ldw	L53_minuly_cas,x
 267                     ; 77 		TIM2_Cmd(ENABLE); //ËasovaË aktivnÌ
 269  0086 a601          	ld	a,#1
 270  0088 cd0000        	call	_TIM2_Cmd
 272                     ; 78 		TIM2_SetAutoreload(tabulka_tonu[i]); //nastavenÌ urËitÈho tÛnu podle tabulky 
 274  008b b603          	ld	a,L33_i
 275  008d 5f            	clrw	x
 276  008e 97            	ld	xl,a
 277  008f 58            	sllw	x
 278  0090 de0000        	ldw	x,(_tabulka_tonu,x)
 279  0093 cd0000        	call	_TIM2_SetAutoreload
 281                     ; 79 		i++;
 283  0096 3c03          	inc	L33_i
 284                     ; 80 		if(i > (sizeof(tabulka_tonu)/sizeof(tabulka_tonu[0]))){ //kdyû tabulka dojde na konec, zaËne znovu 
 286  0098 b603          	ld	a,L33_i
 287  009a a104          	cp	a,#4
 288  009c 250f          	jrult	L701
 289                     ; 81 			x=0;
 291  009e 3f00          	clr	L52_x
 292                     ; 82 			z=0;
 294  00a0 3f02          	clr	L13_z
 295                     ; 83 			i=0;
 297  00a2 3f03          	clr	L33_i
 298                     ; 84 			minuly_cas=0;
 300  00a4 5f            	clrw	x
 301  00a5 bf04          	ldw	L53_minuly_cas,x
 302  00a7 2004          	jra	L701
 303  00a9               L101:
 304                     ; 88 	TIM2_Cmd(DISABLE); //ËasovaË neaktivnÌ
 306  00a9 4f            	clr	a
 307  00aa cd0000        	call	_TIM2_Cmd
 309  00ad               L701:
 310                     ; 92 if(i==1){
 312  00ad b603          	ld	a,L33_i
 313  00af a101          	cp	a,#1
 314  00b1 260b          	jrne	L111
 315                     ; 93 		GPIO_WriteHigh(GPIOC,GPIO_PIN_2);
 317  00b3 4b04          	push	#4
 318  00b5 ae500a        	ldw	x,#20490
 319  00b8 cd0000        	call	_GPIO_WriteHigh
 321  00bb 84            	pop	a
 323  00bc 2009          	jra	L311
 324  00be               L111:
 325                     ; 95 		GPIO_WriteLow(GPIOC,GPIO_PIN_2);
 327  00be 4b04          	push	#4
 328  00c0 ae500a        	ldw	x,#20490
 329  00c3 cd0000        	call	_GPIO_WriteLow
 331  00c6 84            	pop	a
 332  00c7               L311:
 333                     ; 97 	if(i==2){
 335  00c7 b603          	ld	a,L33_i
 336  00c9 a102          	cp	a,#2
 337  00cb 260b          	jrne	L511
 338                     ; 98 		GPIO_WriteHigh(GPIOC,GPIO_PIN_3);
 340  00cd 4b08          	push	#8
 341  00cf ae500a        	ldw	x,#20490
 342  00d2 cd0000        	call	_GPIO_WriteHigh
 344  00d5 84            	pop	a
 346  00d6 2009          	jra	L711
 347  00d8               L511:
 348                     ; 100 		GPIO_WriteLow(GPIOC,GPIO_PIN_3);
 350  00d8 4b08          	push	#8
 351  00da ae500a        	ldw	x,#20490
 352  00dd cd0000        	call	_GPIO_WriteLow
 354  00e0 84            	pop	a
 355  00e1               L711:
 356                     ; 102 	if(i==3){
 358  00e1 b603          	ld	a,L33_i
 359  00e3 a103          	cp	a,#3
 360  00e5 260b          	jrne	L121
 361                     ; 103 		GPIO_WriteHigh(GPIOC,GPIO_PIN_4);
 363  00e7 4b10          	push	#16
 364  00e9 ae500a        	ldw	x,#20490
 365  00ec cd0000        	call	_GPIO_WriteHigh
 367  00ef 84            	pop	a
 369  00f0 2009          	jra	L321
 370  00f2               L121:
 371                     ; 105 		GPIO_WriteLow(GPIOC,GPIO_PIN_4);
 373  00f2 4b10          	push	#16
 374  00f4 ae500a        	ldw	x,#20490
 375  00f7 cd0000        	call	_GPIO_WriteLow
 377  00fa 84            	pop	a
 378  00fb               L321:
 379                     ; 109 	swspi_tx16(MAX7219_DECMODE | 0x00);
 381  00fb ae0900        	ldw	x,#2304
 382  00fe cd0000        	call	_swspi_tx16
 384                     ; 110 	swspi_tx16(MAX7219_TEST | 0x00); 
 386  0101 ae0f00        	ldw	x,#3840
 387  0104 cd0000        	call	_swspi_tx16
 389                     ; 111 	swspi_tx16(MAX7219_SHTDWN | 0x01);
 391  0107 ae0c01        	ldw	x,#3073
 392  010a cd0000        	call	_swspi_tx16
 394                     ; 112 	swspi_tx16(MAX7219_SCANLIM | 0x07);
 396  010d ae0b07        	ldw	x,#2823
 397  0110 cd0000        	call	_swspi_tx16
 399                     ; 113 	swspi_tx16(MAX7219_INTENSITY | 0x01);
 401  0113 ae0a01        	ldw	x,#2561
 402  0116 cd0000        	call	_swspi_tx16
 404                     ; 115 	swspi_tx16(MAX7219_DIG0 | 0); 
 406  0119 ae0100        	ldw	x,#256
 407  011c cd0000        	call	_swspi_tx16
 409                     ; 116 	swspi_tx16(MAX7219_DIG1 | 0); 
 411  011f ae0200        	ldw	x,#512
 412  0122 cd0000        	call	_swspi_tx16
 414                     ; 117 	swspi_tx16(MAX7219_DIG2 | 0); 
 416  0125 ae0300        	ldw	x,#768
 417  0128 cd0000        	call	_swspi_tx16
 419                     ; 118 	swspi_tx16(MAX7219_DIG3 | z); 
 421  012b b602          	ld	a,L13_z
 422  012d 5f            	clrw	x
 423  012e 97            	ld	xl,a
 424  012f 01            	rrwa	x,a
 425  0130 aa00          	or	a,#0
 426  0132 01            	rrwa	x,a
 427  0133 aa04          	or	a,#4
 428  0135 01            	rrwa	x,a
 429  0136 cd0000        	call	_swspi_tx16
 431                     ; 119 	swspi_tx16(MAX7219_DIG4 | z); 
 433  0139 b602          	ld	a,L13_z
 434  013b 5f            	clrw	x
 435  013c 97            	ld	xl,a
 436  013d 01            	rrwa	x,a
 437  013e aa00          	or	a,#0
 438  0140 01            	rrwa	x,a
 439  0141 aa05          	or	a,#5
 440  0143 01            	rrwa	x,a
 441  0144 cd0000        	call	_swspi_tx16
 443                     ; 120 	swspi_tx16(MAX7219_DIG5 | 0); 
 445  0147 ae0600        	ldw	x,#1536
 446  014a cd0000        	call	_swspi_tx16
 448                     ; 121 	swspi_tx16(MAX7219_DIG6 | 0); 
 450  014d ae0700        	ldw	x,#1792
 451  0150 cd0000        	call	_swspi_tx16
 453                     ; 122 	swspi_tx16(MAX7219_DIG7 | 0); 
 455  0153 ae0800        	ldw	x,#2048
 456  0156 cd0000        	call	_swspi_tx16
 458                     ; 124 }
 461  0159 81            	ret
 488                     ; 126 void init_tim(void){
 489                     	switch	.text
 490  015a               _init_tim:
 494                     ; 127 GPIO_Init(GPIOD, GPIO_PIN_4, GPIO_MODE_OUT_PP_LOW_SLOW); // v˝stup TIM2_CH3 na PD4
 496  015a 4bc0          	push	#192
 497  015c 4b10          	push	#16
 498  015e ae500f        	ldw	x,#20495
 499  0161 cd0000        	call	_GPIO_Init
 501  0164 85            	popw	x
 502                     ; 128 TIM2_TimeBaseInit(TIM2_PRESCALER_16,1); // nastavÌme poË·teËnÌ p˘lperiodu
 504  0165 ae0001        	ldw	x,#1
 505  0168 89            	pushw	x
 506  0169 a604          	ld	a,#4
 507  016b cd0000        	call	_TIM2_TimeBaseInit
 509  016e 85            	popw	x
 510                     ; 130 TIM2_OC1Init( 	
 510                     ; 131 TIM2_OCMODE_TOGGLE,  // p¯epÌn·nÌ v˝stupu - obdÈlnÌkov˝ pr˘bÏh				
 510                     ; 132 TIM2_OUTPUTSTATE_ENABLE,	// povolit timeru ovl·dat v˝stup 
 510                     ; 133 1,	// okamûik kdy doch·zÌ k "toggle" v˝stupu							
 510                     ; 134 TIM2_OCPOLARITY_LOW	//v˝stupnÌ ˙roveÚ LOW
 510                     ; 135 );
 512  016f 4b22          	push	#34
 513  0171 ae0001        	ldw	x,#1
 514  0174 89            	pushw	x
 515  0175 ae3011        	ldw	x,#12305
 516  0178 cd0000        	call	_TIM2_OC1Init
 518  017b 5b03          	addw	sp,#3
 519                     ; 136 TIM2_ARRPreloadConfig(ENABLE); // aktivuji preload (zajiöùuje zmÏnu st¯Ìdy bez neû·doucÌch efekt˘)
 521  017d a601          	ld	a,#1
 522  017f cd0000        	call	_TIM2_ARRPreloadConfig
 524                     ; 137 }
 527  0182 81            	ret
 562                     ; 148 void assert_failed(u8* file, u32 line)
 562                     ; 149 { 
 563                     	switch	.text
 564  0183               _assert_failed:
 568  0183               L351:
 569  0183 20fe          	jra	L351
 594                     	xdef	_main
 595                     	xdef	_tabulka_tonu
 596                     	xdef	_ovladani_a_led
 597                     	xdef	_init_tim
 598                     	xref	_swspi_tx16
 599                     	xref	_swspi_init
 600                     	xref	_init_milis
 601                     	xref	_milis
 602                     	xdef	_assert_failed
 603                     	xref	_TIM2_SetAutoreload
 604                     	xref	_TIM2_ARRPreloadConfig
 605                     	xref	_TIM2_Cmd
 606                     	xref	_TIM2_OC1Init
 607                     	xref	_TIM2_TimeBaseInit
 608                     	xref	_GPIO_ReadInputPin
 609                     	xref	_GPIO_WriteLow
 610                     	xref	_GPIO_WriteHigh
 611                     	xref	_GPIO_Init
 612                     	xref	_CLK_HSIPrescalerConfig
 631                     	end

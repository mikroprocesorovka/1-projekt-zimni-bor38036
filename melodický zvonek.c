/*
Program melodick� zvonek:
Po stisknut� tla�itka se rozezn� p�edem nastaven� melodie.
B�hem melodie se zobraz� obr�zek na dotmatrixu.
P�i ka�d�m zazn�n� t�nu se rozsv�t� jin� LEDka.
*/

#include "stm8s.h"
#include "milis.h"
#include "swspi.h"

#define MAX7219_NOP		0x0000
#define MAX7219_DIG0	0x0100
#define MAX7219_DIG1	0x0200
#define MAX7219_DIG2	0x0300
#define MAX7219_DIG3	0x0400
#define MAX7219_DIG4	0x0500
#define MAX7219_DIG5	0x0600
#define MAX7219_DIG6	0x0700
#define MAX7219_DIG7	0x0800

#define MAX7219_DECMODE		0x0900
#define MAX7219_INTENSITY	0x0A00 
#define MAX7219_SCANLIM		0x0B00
#define MAX7219_SHTDWN		0x0C00 
#define MAX7219_TEST			0x0F00


void init_tim(void);
void ovladani_a_led(void);


const uint16_t tabulka_tonu[]={ 
3000,2000,1000
};

void main(void){
CLK_HSIPrescalerConfig(CLK_PRESCALER_HSIDIV1); // 16MHz z intern�ho RC oscil�toru
init_milis(); // spustit �asova� millis
init_tim(); // nastavit a spustit timer
swspi_init(); // SPI

//inicializace pin�
GPIO_Init(GPIOE,GPIO_PIN_5,GPIO_MODE_IN_FL_NO_IT); 
GPIO_Init(GPIOC,GPIO_PIN_2,GPIO_MODE_OUT_PP_LOW_SLOW); 
GPIO_Init(GPIOC,GPIO_PIN_3,GPIO_MODE_OUT_PP_LOW_SLOW); 
GPIO_Init(GPIOC,GPIO_PIN_4,GPIO_MODE_OUT_PP_LOW_SLOW); 


  while (1){
		ovladani_a_led();
  }
}

void ovladani_a_led(void){
static uint8_t x=0;
static uint8_t y=0;
static uint8_t z=0;
static uint8_t i=0; 
static uint16_t minuly_cas=0; 
	
//odchycen� stisku tla��tka
if(GPIO_ReadInputPin(GPIOE,GPIO_PIN_5)==RESET && y==0){
	y=1;
	x=1;
}
	
if(GPIO_ReadInputPin(GPIOE,GPIO_PIN_5)!=RESET && y==1){
	y=0;
}

//�asov� ovl�d�n� pieza
if(x==1){
	if(milis() - minuly_cas >= 1500){
		z=24;
		minuly_cas = milis();
		TIM2_Cmd(ENABLE); //�asova� aktivn�
		TIM2_SetAutoreload(tabulka_tonu[i]); //nastaven� ur�it�ho t�nu podle tabulky 
		i++;
		if(i > (sizeof(tabulka_tonu)/sizeof(tabulka_tonu[0]))){ //kdy� tabulka dojde na konec, za�ne znovu 
			x=0;
			z=0;
			i=0;
			minuly_cas=0;
		}
	}
}else{
	TIM2_Cmd(DISABLE); //�asova� neaktivn�
}

//ovl�d�n� ur�it� led p�i ur�it�m t�nu
if(i==1){
		GPIO_WriteHigh(GPIOC,GPIO_PIN_2);
	}else{
		GPIO_WriteLow(GPIOC,GPIO_PIN_2);
	}
	if(i==2){
		GPIO_WriteHigh(GPIOC,GPIO_PIN_3);
	}else{
		GPIO_WriteLow(GPIOC,GPIO_PIN_3);
	}
	if(i==3){
		GPIO_WriteHigh(GPIOC,GPIO_PIN_4);
	}else{
		GPIO_WriteLow(GPIOC,GPIO_PIN_4);
	}
	
	//zobrazen� obr�zku na dotmatrixu
	swspi_tx16(MAX7219_DECMODE | 0x00);
	swspi_tx16(MAX7219_TEST | 0x00); 
	swspi_tx16(MAX7219_SHTDWN | 0x01);
	swspi_tx16(MAX7219_SCANLIM | 0x07);
	swspi_tx16(MAX7219_INTENSITY | 0x01);

	swspi_tx16(MAX7219_DIG0 | z); 
	swspi_tx16(MAX7219_DIG1 | z); 
	swspi_tx16(MAX7219_DIG2 | z); 
	swspi_tx16(MAX7219_DIG3 | z); 
	swspi_tx16(MAX7219_DIG4 | 0); 
	swspi_tx16(MAX7219_DIG5 | 0); 
	swspi_tx16(MAX7219_DIG6 | z); 
	swspi_tx16(MAX7219_DIG7 | z); 
	
}

void init_tim(void){
GPIO_Init(GPIOD, GPIO_PIN_4, GPIO_MODE_OUT_PP_LOW_SLOW); // v�stup TIM2_CH3 na PD4
TIM2_TimeBaseInit(TIM2_PRESCALER_16,1); // nastav�me po��te�n� p�lperiodu
// nastav�me OC re�im TOGGLE (p�epnout stav v�stupu s "compare" ud�lost�)
TIM2_OC1Init( 	
TIM2_OCMODE_TOGGLE,  // p�ep�n�n� v�stupu - obd�ln�kov� pr�b�h				
TIM2_OUTPUTSTATE_ENABLE,	// povolit timeru ovl�dat v�stup 
1,	// okam�ik kdy doch�z� k "toggle" v�stupu							
TIM2_OCPOLARITY_LOW	//v�stupn� �rove� LOW
);
TIM2_ARRPreloadConfig(ENABLE); // aktivuji preload (zaji��uje zm�nu st��dy bez ne��douc�ch efekt�)
}

#ifdef USE_FULL_ASSERT

/**
  * @brief  Reports the name of the source file and the source line number
  *   where the assert_param error has occurred.
  * @param file: pointer to the source file name
  * @param line: assert_param error line source number
  * @retval : None
  */
void assert_failed(u8* file, u32 line)
{ 
  /* User can add his own implementation to report the file name and line number,
     ex: printf("Wrong parameters value: file %s on line %d\r\n", file, line) */

  /* Infinite loop */
  while (1)
  {
  }
}
#endif


/************************ (C) COPYRIGHT STMicroelectronics *****END OF FILE****/

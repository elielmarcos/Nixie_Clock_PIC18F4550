#line 1 "C:/NIXIE/soft/Nixie/Nixie.c"
#line 1 "c:/nixie/soft/nixie/eeprom.h"
#line 11 "c:/nixie/soft/nixie/eeprom.h"
unsigned char ler_eeprom(unsigned char address);

void escrever_eeprom(unsigned char address, unsigned char DADO_EEPROM);
#line 1 "c:/nixie/soft/nixie/ds1307.h"



typedef struct DateTime {
 unsigned char second;
 unsigned char minute;
 unsigned char hour;
 unsigned char PM;
 unsigned char mode12h;
 unsigned char day;
 unsigned char week;
 unsigned char month;
 unsigned char year;
}DateTime;


DateTime Read_RTC();
void Write_RTC(DateTime Data);
#line 1 "c:/nixie/soft/nixie/ws2812.h"



typedef struct {
 unsigned char r;
 unsigned char b;
 unsigned char g;
} ws2812Led;


void ws2812_send(ws2812Led* led);
#line 1 "c:/nixie/soft/nixie/adc.h"



unsigned int VALOR_ADC(unsigned char CH);

void VREF_NEGATIVA(unsigned char LD);

void VREF_POSITIVA(unsigned char LD);
#line 58 "C:/NIXIE/soft/Nixie/Nixie.c"
DateTime Data, old_Data, temp_Data;
ws2812Led Led, LedOFF, LedTemp, Led_Week[10];

 bit old_Button;
 bit enc_F;
 bit INC;
 bit DEC;
 bit refresh_RTC;
 bit reset_RTC;
 bit HourBeep;
 bit SecondBeep;
 bit ButtonBeep;
 bit Mode12h;
 bit LDR_Auto;
 bit Presence;
 bit PresenceAuto;
 bit Cathode;
 bit AutoOffOn;
 bit Alarm;
 bit awake;
unsigned char debounce = 0;
unsigned char PresenceTime = 0;
unsigned char persistence_timer = 0;
unsigned char EffectMode = 1;
unsigned char BackLight = 0;
unsigned char CathodeTime = 0;
unsigned char ShowMode = 0;
unsigned char CountShowMode = 0;
unsigned int MENU = 1;
unsigned char ACESO = 50;
unsigned char APAGADO = 50;
unsigned char Cathode_Poisoning = 0;
unsigned char Fading = 0;
unsigned char Scroll = 0;
unsigned char Set = 0;
 bit Flag_Fading;
 bit Flag_Cathode_Poisoning;
 bit Flag_Scroll;
 bit toggle_Fading;
 bit toggle_Point;
 bit toggle_Set;
unsigned int Temp_Celsius = 0;
 signed char Ajust_Temp = 0;
unsigned int Light_Sensor = 0;
unsigned int High_Voltage = 0;
unsigned char Display_On_Hour = 0;
unsigned char Display_On_Minute = 0;
unsigned char Display_On_PM = 0;
unsigned char Display_Off_Hour = 0;
unsigned char Display_Off_Minute = 0;
unsigned char Display_Off_PM = 0;
unsigned char Alarm_Hour = 0;
unsigned char Alarm_Minute = 0;
unsigned char Alarm_PM = 0;


unsigned char INDICE_MM = 0;
unsigned int INDICE_MM_TEMP = 0;
unsigned long int MEDIA_LDR = 0;
unsigned long int MM_LDR[ 10 ];
unsigned long int MEDIA_TEMP = 0;
unsigned long int MM_TEMP[ 300 ];
unsigned long int MEDIA_HIGH_VOLT = 0;
unsigned long int MM_HIGH_VOLT[ 10 ];

unsigned char unidade = 0;
unsigned char dezena = 0;
unsigned char centena = 0;
unsigned char unidade_m = 0;


void WriteDisplay(unsigned char D5, unsigned char D5_L_P, unsigned char D5_R_P, unsigned char D4, unsigned char D4_L_P, unsigned char D4_R_P, unsigned char D3, unsigned char D3_L_P, unsigned char D3_R_P, unsigned char D2, unsigned char D2_L_P, unsigned char D2_R_P, unsigned char D1, unsigned char D1_L_P, unsigned char D1_R_P, unsigned char D0, unsigned char D0_L_P, unsigned char D0_R_P, unsigned char N0, unsigned char N1);
void WriteDisplay_Fading(unsigned char D5, unsigned char D5_L_P, unsigned char D5_R_P, char F5, unsigned char D4, unsigned char D4_L_P, unsigned char D4_R_P, char F4, unsigned char D3, unsigned char D3_L_P, unsigned char D3_R_P, char F3, unsigned char D2, unsigned char D2_L_P, unsigned char D2_R_P, char F2, unsigned char D1, unsigned char D1_L_P, unsigned char D1_R_P, char F1, unsigned char D0, unsigned char D0_L_P, unsigned char D0_R_P, char F0, unsigned char N0, char F_N0, unsigned char N1, char F_N1, unsigned char ON, unsigned char OFF);
void Number(unsigned char digit);
void DELAY(unsigned char L);
void Hour(unsigned char Point);
void Hour_Cathode(void);
void Hour_Fading(void);
void Hour_FadingFull(void);
void Hour_Scroll(void);
void Date(void);
void Temp(void);
void High_Volt(void);
void BackLightRGB(ws2812Led* ledRGB);
void SeparaUnidade(unsigned long int Numero);
void CathodePoisoning(void);
unsigned char Botao_DEC(void);
unsigned char Botao_INC(void);
unsigned char Botao_ENT(void);
void BEEP_1(void);
void BEEP_2(void);
void BEEP_HOUR(void);
void BEEP_ALARM(void);





void interrupt() {

 RC7_bit = 0;

 if (INT2IF_bit && INT2IE_bit) {
 INT2IF_bit = 0;
 TMR0H = TMR0L = 0x00;
 refresh_RTC = 1;
 }

 if (TMR0IF_bit && TMR0IE_bit) {
 TMR0IF_bit = 0;
 reset_RTC = 1;
 }

 if (TMR1IF_bit && TMR1IE_bit) {
 TMR1IF_bit = 0;
 TMR1H = 0xE2;
 TMR1L = 0xB4;

 if (Flag_Cathode_Poisoning) Cathode_Poisoning++; else Cathode_Poisoning = 0;
 if (Flag_Fading) Fading++; else Fading = 0;
 if (Flag_Scroll) Scroll++; else Scroll = 0;
 Set++;

 if (Set >= 40) {Set = 0; toggle_Set = !toggle_Set;}
 }

 if (RBIF_bit && RBIE_bit) {

 debounce = 50;

 while(debounce--){;}

 if ( !RB5_bit  != enc_F) {
 if ( !RB5_bit  !=  !RB4_bit ) {INC = 1; DEC = 0;}
 else {INC = 0; DEC = 1;}
 enc_F =  !RB5_bit ;
 }










 RBIF_bit = 0;

 }

}





void Start() {

 unsigned int i, LDR_Start, High_Volt_Start, Temp_Start, n_cathode;

 BEEP_HOUR();

 LDR_Start = VALOR_ADC(1);
 High_Volt_Start = VALOR_ADC(2);

 MEDIA_LDR = LDR_Start *  10 ;
 MEDIA_HIGH_VOLT = High_Volt_Start *  10 ;

 for (i = 0; i <  10 ; i++)
 {MM_LDR[i] = LDR_Start; MM_HIGH_VOLT[i] = High_Volt_Start;}

 Temp_Start = VALOR_ADC(0);

 MEDIA_TEMP = Temp_Start *  300 ;

 for (i = 0; i <  300 ; i++)
 MM_TEMP[i] = Temp_Start;


 refresh_RTC = 0;
 reset_RTC = 0;
 toggle_Fading = 0;
 toggle_Point = 0;
 toggle_Set = 0;
 old_Button = 0;
 enc_F =  !RB5_bit ;
 INC = 0;
 DEC = 0;
 Flag_Fading = 0;
 Flag_Cathode_Poisoning = 0;
 Flag_Scroll = 0;
 awake = 0;

 Led_Week[0].r = 0;
 Led_Week[0].g = 0;
 Led_Week[0].b = 50;

 Led_Week[1].r = 70;
 Led_Week[1].g = 50;
 Led_Week[1].b = 0;

 Led_Week[2].r = 40;
 Led_Week[2].g = 0;
 Led_Week[2].b = 100;

 Led_Week[3].r = 80;
 Led_Week[3].g = 140;
 Led_Week[3].b = 40;

 Led_Week[4].r = 140;
 Led_Week[4].g = 0;
 Led_Week[4].b = 120;

 Led_Week[5].r = 0;
 Led_Week[5].g = 60;
 Led_Week[5].b = 50;

 Led_Week[6].r = 20;
 Led_Week[6].g = 180;
 Led_Week[6].b = 10;

 Led_Week[7].r = 170;
 Led_Week[7].g = 24;
 Led_Week[7].b = 0;

 Led_Week[8].r = 120;
 Led_Week[8].g = 0;
 Led_Week[8].b = 0;

 Led_Week[9].r = 120;
 Led_Week[9].g = 120;
 Led_Week[9].b = 120;

 Mode12h = ler_eeprom(0x00);
 HourBeep = ler_eeprom(0x01);
 BackLight = ler_eeprom(0x02);
 Led.r = ler_eeprom(0x03);
 Led.g = ler_eeprom(0x04);
 Led.b = ler_eeprom(0x05);
 LDR_Auto = ler_eeprom(0x06);
 ACESO = ler_eeprom(0x07);
 APAGADO = 100 - ACESO;
 Presence = ler_eeprom(0x08);
 PresenceTime = ler_eeprom(0x09);
 PresenceAuto = ler_eeprom(0x0A);
 EffectMode = ler_eeprom(0x0B);
 Cathode = ler_eeprom(0x0C);
 CathodeTime = ler_eeprom(0x0D);
 AutoOffOn = ler_eeprom(0x0E);
 Display_Off_Hour = ler_eeprom(0x0F);
 Display_Off_Minute = ler_eeprom(0x10);
 Display_Off_PM = ler_eeprom(0x11);
 Display_On_Hour = ler_eeprom(0x12);
 Display_On_Minute = ler_eeprom(0x13);
 Display_On_PM = ler_eeprom(0x14);
 Alarm = ler_eeprom(0x15);
 Alarm_Hour = ler_eeprom(0x16);
 Alarm_Minute = ler_eeprom(0x17);
 Alarm_PM = ler_eeprom(0x18);
 Ajust_Temp = ler_eeprom(0x19);
 SecondBeep = ler_eeprom(0x1A);
 ButtonBeep = ler_eeprom(0x1B);


 if (Mode12h) Data.hour = old_Data.hour = 0x12;
 else Data.hour = old_Data.hour = 0x00;
 Data.second = old_Data.second = 0x00;
 Data.minute = old_Data.minute = 0x00;
 Data.PM = old_Data.PM = 0;
 Data.mode12h = old_Data.mode12h = Mode12h;
 Data.day = old_Data.day = 0x01;
 Data.week = old_Data.week = 0x01;
 Data.month = old_Data.month = 0x01;
 Data.year = old_Data.year = 0x19;

 I2C1_Init(400000);

 asm CLRWDT;

 Delay_ms(1500);

 if (reset_RTC) {
 Write_RTC(Data);
 reset_RTC = 0;
 }



 LedOFF.r = 255;
 LedOFF.g = 0;
 LedOFF.b = 0;

 BackLightRGB(&LedOFF);

 Delay_ms(300);

 LedOFF.r = 0;
 LedOFF.g = 255;
 LedOFF.b = 0;

 BackLightRGB(&LedOFF);

 Delay_ms(300);

 LedOFF.r = 0;
 LedOFF.g = 0;
 LedOFF.b = 255;

 BackLightRGB(&LedOFF);

 Delay_ms(300);

 LedOFF.r = 0;
 LedOFF.g = 0;
 LedOFF.b = 0;

 BackLightRGB(&LedOFF);

 Delay_ms(100);

 i=0;
 while(i<17) {

 Flag_Cathode_Poisoning = 1;

 if (Cathode_Poisoning >= 0x50) {
 Flag_Cathode_Poisoning = 0;
 Cathode_Poisoning = 0;
 i++;
 asm CLRWDT;
 }

 Data = Read_RTC();
 n_cathode = Cathode_Poisoning / 8;

 if (i < 3) {
 WriteDisplay(0x0F,1,1,0x0F,1,1,0x0F,1,1,0x0F,1,1,0x0F,1,1,0x0F,1,1,1,1);
 } else
 WriteDisplay((i-3) >= 12 ? (Data.hour >> 4) : n_cathode,0,0,(i-3) >= 10 ? (Data.hour & 0x0F) : n_cathode,0,0,(i-3) >= 8 ? (Data.minute >> 4) : n_cathode,0,0,(i-3) >= 6 ? (Data.minute & 0x0F) : n_cathode,0,0,(i-3) >= 4 ? (Data.second >> 4) : n_cathode,0,0,(i-3) >= 2 ? (Data.second & 0x0F) : n_cathode,0,0,0,0);
 }

 if (BackLight == 1) BackLightRGB(&Led);
 else if (BackLight == 2) BackLightRGB(&Led_Week[Data.week]);

}





void Setup() {

 ADCON1 = 0x0F;
 CMCON |= 7;
 RBPU_bit = 0;
 TRISA = 0x07;
 TRISB = 0x3C;
 TRISC = 0x40;
 TRISD = 0x00;
 TRISE = 0x00;

 PORTA = 0x00;
 PORTB = 0x00;
 PORTC = 0x00;
 PORTD = 0x00;
 PORTE = 0x00;

 LATA = 0x00;
 LATB = 0x00;
 LATC = 0x00;
 LATD = 0x00;
 LATE = 0x00;

 GIE_bit = 0;
 PEIE_bit = 0;



 T08BIT_bit = 0;
 T0CS_bit = 0;
 T0SE_bit = 0;
 PSA_bit = 0;
 T0PS2_bit = 1;
 T0PS1_bit = 1;
 T0PS0_bit = 1;

 TMR0H = 0x00;
 TMR0L = 0x00;
 TMR0IF_bit = 0;
 TMR0ON_bit = 0;
 TMR0IE_bit = 1;
 TMR0IP_bit = 1;



 RD16_T1CON_bit = 1;
 T1RUN_bit = 0;
 T1OSCEN_bit = 0;
 TMR1CS_bit = 0;
 T1CKPS1_bit = 1;
 T1CKPS0_bit = 1;

 TMR1H = 0xE2;
 TMR1L = 0xB4;
 TMR1IF_bit = 0;
 TMR1ON_bit = 1;
 TMR1IE_bit = 1;
 TMR1IP_bit = 1;



 INT2IP_bit = 1;
 INTEDG2_bit = 1;
 INT2IF_bit = 0;
 INT2IE_bit = 1;




 ADCON0 = 0b00000001;
 ADCON1 = 0b00001100;
 ADCON2 = 0b10001110;

 ADIF_bit = 0;
 ADIE_bit = 0;




 RBIE_bit = 1;
 RBIF_bit = 0;
 RBIP_bit = 1;


 IPEN_bit = 0;

 GIE_bit = 1;
 PEIE_bit = 1;

 TMR0ON_bit = 1;
}





void BEEP_1() {

 int i;

 for (i=0;i<80;i++) if (ButtonBeep)  (RC7_bit = 1),(Delay_us(10)),(RC7_bit = 0),(Delay_us(500)) ; else  Delay_us(500) ;

}





void BEEP_2() {
 int i;

 for (i=0;i<80;i++) if (ButtonBeep)  (RC7_bit = 1),(Delay_us(10)),(RC7_bit = 0),(Delay_us(430)) ; else  Delay_us(500) ;
 Delay_ms(100);
 for (i=0;i<80;i++) if (ButtonBeep)  (RC7_bit = 1),(Delay_us(10)),(RC7_bit = 0),(Delay_us(430)) ; else  Delay_us(500) ;

}





void BEEP_HOUR() {
 int i;

 for (i=0;i<200;i++)  (RC7_bit = 1),(Delay_us(10)),(RC7_bit = 0),(Delay_us(600)) ;
 Delay_ms(150);
 for (i=0;i<200;i++)  (RC7_bit = 1),(Delay_us(10)),(RC7_bit = 0),(Delay_us(600)) ;

}





void BEEP_ALARM() {
 int i;

 for (i=0;i<200;i++)  (RC7_bit = 1),(Delay_us(100)),(RC7_bit = 0),(Delay_us(450)) ;
 Delay_ms(100);
 for (i=0;i<200;i++)  (RC7_bit = 1),(Delay_us(100)),(RC7_bit = 0),(Delay_us(450)) ;
 Delay_ms(100);
 for (i=0;i<270;i++)  (RC7_bit = 1),(Delay_us(100)),(RC7_bit = 0),(Delay_us(450)) ;

}






unsigned char Botao_INC() {

 if (INC) {
 BEEP_1();
 INC = 0;
 return 1;
 }

 return 0;
}





unsigned char Botao_DEC() {

 if (DEC) {
 BEEP_1();
 DEC = 0;
 return 1;
 }

 return 0;
}





unsigned char Botao_ENT() {

 if ( ( !RB3_bit  && (!old_Button)) || ((! !RB3_bit ) && old_Button) ){
 if (  !RB3_bit  && (!old_Button) ) {
 old_Button =  !RB3_bit ;
 BEEP_2();
 return 1;
 }
 old_Button =  !RB3_bit ;
 }
 return 0;

}





void Menu_Show() {

 if (awake) {
 if (Botao_INC() || Botao_DEC() || Botao_ENT()) awake = 0;
 Hour(1);
 old_Data = Data;
 } else {

 if (Botao_INC() && ShowMode<2) {ShowMode++; CountShowMode = 0;}
 else
 if (Botao_DEC() && ShowMode>0) {ShowMode--; CountShowMode = 0;}
 if(Botao_ENT()){ MENU = 11;}


 if (ShowMode == 1 && CountShowMode <= 14) Date();
 else
 if (ShowMode == 2 && CountShowMode <= 14) Temp();
 else
 if (EffectMode == 1) Hour(toggle_Point);
 else
 if (EffectMode == 2) Hour_Fading();
 else
 if (EffectMode == 3) Hour_FadingFull();
 else
 if (EffectMode == 4) Hour_Cathode();
 else
 if (EffectMode == 5) Hour_Scroll();
 }
}






void Menu_Exit() {

 WriteDisplay(0x00,0,0,0x00,1,0,0x0F,0,0,0x0F,0,0,0x0F,0,0,0x0F,0,0,0,0);

}





void Menu_TimeFormat() {

 WriteDisplay(0x01,0,0,0x01,1,0,0x0F,0,0,0x0F,0,0,0x02-Mode12h,0,0,0x04-(2*Mode12h),0,0,0,0);

}





void Menu_SetTime() {

 WriteDisplay(0x01,0,0,0x02,1,0,0x0F,0,0,0x0F,0,0,0x0F,0,0,0x0F,0,0,toggle_Point,toggle_Point);

}





void Menu_SetDate() {

 WriteDisplay(0x02,0,0,0x01,1,0,0x0F,toggle_Point,0,0x0F,0,toggle_Point,0x0F,toggle_Point,0,0x0F,0,toggle_Point,0,0);

}





void Menu_SetWeek() {

 WriteDisplay(0x02,0,0,0x02,1,0,0x0F,0,0,0x0F,0,0,0x0F,0,0,Data.week,0,0,0,0);

}





void Menu_SetBackLight() {

 WriteDisplay(0x03,0,0,0x01,1,0,0x0F,0,0,0x0F,0,0,0x0F,0,0,BackLight,0,0,0,0);
}





void Menu_SetR() {

 SeparaUnidade(Led.r / 2);

 WriteDisplay(0x03,0,0,0x02,1,0,0x0F,0,0,0x0F,0,0,dezena,0,0,unidade,0,0,0,0);

}





void Menu_SetG() {

 SeparaUnidade(Led.g / 2);

 WriteDisplay(0x03,0,0,0x03,1,0,0x0F,0,0,0x0F,0,0,dezena,0,0,unidade,0,0,0,0);

}





void Menu_SetB() {

 SeparaUnidade(Led.b / 2);

 WriteDisplay(0x03,0,0,0x04,1,0,0x0F,0,0,0x0F,0,0,dezena,0,0,unidade,0,0,0,0);

}





void Menu_LDR() {

 WriteDisplay(0x04,0,0,0x01,1,0,0x0F,0,0,0x0F,0,0,0x0F,0,0,(unsigned char)LDR_Auto,0,0,0,0);

}





void Menu_SetBright() {

 SeparaUnidade(ACESO);

 WriteDisplay(0x04,0,0,0x02,1,0,0x0F,0,0,0x0F,0,0,dezena,0,0,unidade,0,0,0,0);

}





void Menu_Presence() {

 WriteDisplay(0x05,0,0,0x01,1,0,0x0F,0,0,0x0F,0,0,0x0F,0,0,(unsigned char)Presence,0,0,0,0);

}





void Menu_TimePresence() {

 SeparaUnidade(PresenceTime);

 WriteDisplay(0x05,0,0,0x02,1,0,0x0F,0,0,0x0F,0,0,dezena,0,0,unidade,0,0,0,0);

}





void Menu_AutoPresence() {

 WriteDisplay(0x05,0,0,0x03,1,0,0x0F,0,0,0x0F,0,0,0x0F,0,0,(unsigned char)PresenceAuto,0,0,0,0);

}





void Menu_SetDisplayEffect() {

 WriteDisplay(0x06,0,0,0x01,1,0,0x0F,0,0,0x0F,0,0,0x0F,0,0,EffectMode,0,0,0,0);

}





void Menu_CathodePoisoning() {

 WriteDisplay(0x06,0,0,0x02,1,0,0x0F,0,0,0x0F,0,0,0x0F,0,0,(unsigned char)Cathode,0,0,0,0);

}





void Menu_TimeCathodePoisoning() {

 SeparaUnidade(CathodeTime);

 WriteDisplay(0x06,0,0,0x03,1,0,0x0F,0,0,0x0F,0,0,dezena,0,0,unidade,0,0,0,0);

}





void Menu_SetAutoOFFON() {

 WriteDisplay(0x07,0,0,0x01,1,0,0x0F,0,0,0x0F,0,0,0x0F,0,0,(unsigned char)AutoOffOn,0,0,0,0);

}





void Menu_SetAutoOFF() {

 WriteDisplay(0x07,0,0,0x02,1,0,(Display_Off_Hour >> 4),Display_Off_PM,0,(Display_Off_Hour & 0x0F),0,0,(Display_Off_Minute >> 4),0,0,(Display_Off_Minute & 0x0F),0,0,1,0);

}





void Menu_SetAutoON() {

 WriteDisplay(0x07,0,0,0x03,1,0,(Display_On_Hour >> 4),Display_On_PM,0,(Display_On_Hour & 0x0F),0,0,(Display_On_Minute >> 4),0,0,(Display_On_Minute & 0x0F),0,0,1,0);

}





void Menu_SetAlarm() {

 WriteDisplay(0x08,0,0,0x01,1,0,0x0F,0,0,0x0F,0,0,0x0F,0,0,(unsigned char)Alarm,0,0,0,0);

}





void Menu_HourAlarm() {

 WriteDisplay(0x08,0,0,0x02,1,0,(Alarm_Hour >> 4),Alarm_PM,0,(Alarm_Hour & 0x0F),0,0,(Alarm_Minute >> 4),0,0,(Alarm_Minute & 0x0F),0,0,1,0);

}





void Menu_HourBeep() {

 WriteDisplay(0x09,0,0,0x01,1,0,0x0F,0,0,0x0F,0,0,0x0F,0,0,(unsigned char)HourBeep,0,0,0,0);

}





void Menu_SecondBeep() {

 WriteDisplay(0x09,0,0,0x02,1,0,0x0F,0,0,0x0F,0,0,0x0F,0,0,(unsigned char)SecondBeep,0,0,0,0);

}





void Menu_ButtonBeep() {

 WriteDisplay(0x09,0,0,0x03,1,0,0x0F,0,0,0x0F,0,0,0x0F,0,0,(unsigned char)ButtonBeep,0,0,0,0);

}





void Menu_AjustTemp() {

 SeparaUnidade(Temp_Celsius);

 WriteDisplay(0x09,0,0,0x04,1,0,0x0F,0,0,0x0F,0,0,centena,0,0,dezena,0,0,0,0);

}





void Menu_HighVoltage() {

 SeparaUnidade(High_Voltage);

 WriteDisplay(0x09,0,0,0x05,1,0,0x0F,0,0,unidade_m,0,0,centena,0,0,dezena,0,0,0,0);

}










void Menu_11() {

 if (Botao_INC()) Mode12h = 0;
 if (Botao_DEC()) Mode12h = 1;
 if (Botao_ENT()) {

 if (Data.mode12h && !Mode12h) {
 if (Data.PM) Data.hour = Data.hour == 0x12 ? 0x12 : Dec2Bcd(12 + Bcd2Dec(Data.hour));
 else Data.hour = Data.hour == 0x12 ? 0x00 : Data.hour;
 Data.PM = 0;

 if (Display_Off_PM) Display_Off_Hour = Display_Off_Hour == 0x12 ? 0x12 : Dec2Bcd(12 + Bcd2Dec(Display_Off_Hour));
 else Display_Off_Hour = Display_Off_Hour == 0x12 ? 0x00 : Display_Off_Hour;
 Display_Off_PM = 0;

 if (Display_On_PM) Display_On_Hour = Display_On_Hour == 0x12 ? 0x12 : Dec2Bcd(12 + Bcd2Dec(Display_On_Hour));
 else Display_On_Hour = Display_On_Hour == 0x12 ? 0x00 : Display_On_Hour;
 Display_On_PM = 0;

 if (Alarm_PM) Alarm_Hour = Alarm_Hour == 0x12 ? 0x12 : Dec2Bcd(12 + Bcd2Dec(Alarm_Hour));
 else Alarm_Hour = Alarm_Hour == 0x12 ? 0x00 : Alarm_Hour;
 Alarm_PM = 0;

 } else
 if (!Data.mode12h && Mode12h) {
 if (Data.hour >= 0x12) {Data.hour = Data.hour == 0x12 ? 0x12 : Dec2Bcd(Bcd2Dec(Data.hour) - 12); Data.PM = 1;}
 else {Data.hour = Data.hour == 0x00 ? 0x12 : Data.hour; Data.PM = 0;}

 if (Display_Off_Hour >= 0x12) {Display_Off_Hour = Display_Off_Hour == 0x12 ? 0x12 : Dec2Bcd(Bcd2Dec(Display_Off_Hour) - 12); Display_Off_PM = 1;}
 else {Display_Off_Hour = Display_Off_Hour == 0x00 ? 0x12 : Display_Off_Hour; Display_Off_PM = 0;}

 if (Display_On_Hour >= 0x12) {Display_On_Hour = Display_On_Hour == 0x12 ? 0x12 : Dec2Bcd(Bcd2Dec(Display_On_Hour) - 12); Display_On_PM = 1;}
 else {Display_On_Hour = Display_On_Hour == 0x00 ? 0x12 : Display_On_Hour; Display_On_PM = 0;}

 if (Alarm_Hour >= 0x12) {Alarm_Hour = Alarm_Hour == 0x12 ? 0x12 : Dec2Bcd(Bcd2Dec(Alarm_Hour) - 12); Alarm_PM = 1;}
 else {Alarm_Hour = Alarm_Hour == 0x00 ? 0x12 : Alarm_Hour; Alarm_PM = 0;}
 }

 Data.mode12h = Mode12h;
 Write_RTC(Data);
 escrever_eeprom(0x00,Mode12h);

 escrever_eeprom(0x0F,Display_Off_Hour);
 escrever_eeprom(0x10,Display_Off_Minute);
 escrever_eeprom(0x11,Display_Off_PM);
 escrever_eeprom(0x12,Display_On_Hour);
 escrever_eeprom(0x13,Display_On_Minute);
 escrever_eeprom(0x14,Display_On_PM);

 escrever_eeprom(0x16,Alarm_Hour);
 escrever_eeprom(0x17,Alarm_Minute);
 escrever_eeprom(0x18,Alarm_PM);

 MENU = 11;

 }

 WriteDisplay(0x01,0,0,0x01,1,0,0x0F,0,0,0x0F,0,0,toggle_Set == 1 ? 0x02-Mode12h : 0x0F,0,0,toggle_Set == 1 ? 0x04-(2*Mode12h) : 0x0F,0,0,0,0);

}





void Menu_12_SEG() {

 if (Botao_INC()) {temp_Data.second = Dec2Bcd(Bcd2Dec(temp_Data.second)+1); if (temp_Data.second == 0x60) temp_Data.second = 0x00;}
 if (Botao_DEC()) {temp_Data.second = Dec2Bcd(Bcd2Dec(temp_Data.second)-1); if (temp_Data.second == Dec2Bcd(-1)) temp_Data.second = 0x59;}
 if (Botao_ENT()) {MENU = 121;}

 WriteDisplay((temp_Data.hour >> 4),temp_Data.PM,0,(temp_Data.hour & 0x0F),0,0,(temp_Data.minute >> 4),0,0,(temp_Data.minute & 0x0F),0,0,toggle_Set == 1 ? (temp_Data.second >> 4) : 0x0F,0,0,toggle_Set == 1 ? (temp_Data.second & 0x0F) : 0x0F,0,0,1,1);

}





void Menu_12_MIN() {

 if (Botao_INC()) {temp_Data.minute = Dec2Bcd(Bcd2Dec(temp_Data.minute)+1); if (temp_Data.minute == 0x60) temp_Data.minute = 0x00;}
 if (Botao_DEC()) {temp_Data.minute = Dec2Bcd(Bcd2Dec(temp_Data.minute)-1); if (temp_Data.minute == Dec2Bcd(-1)) temp_Data.minute = 0x59;}
 if (Botao_ENT()) {MENU = 122;}

 WriteDisplay((temp_Data.hour >> 4),temp_Data.PM,0,(temp_Data.hour & 0x0F),0,0,toggle_Set == 1 ? (temp_Data.minute >> 4) : 0x0F,0,0,toggle_Set == 1 ? (temp_Data.minute & 0x0F) : 0x0F,0,0,(temp_Data.second >> 4),0,0,(temp_Data.second & 0x0F),0,0,1,1);

}





void Menu_12_HOUR() {

 if (Mode12h) {
 if (Botao_INC()) {temp_Data.hour = Dec2Bcd(Bcd2Dec(temp_Data.hour)+1); if (temp_Data.hour == 0x12) temp_Data.PM = !temp_Data.PM; if (temp_Data.hour == 0x13) temp_Data.hour = 0x01;}
 if (Botao_DEC()) {temp_Data.hour = Dec2Bcd(Bcd2Dec(temp_Data.hour)-1); if (temp_Data.hour == 0x11) temp_Data.PM = !temp_Data.PM; if (temp_Data.hour == 0x00) temp_Data.hour = 0x12;}

 } else {
 if (Botao_INC()) {temp_Data.hour = Dec2Bcd(Bcd2Dec(temp_Data.hour)+1); if (temp_Data.hour == 0x24) temp_Data.hour = 0x00;}
 if (Botao_DEC()) {temp_Data.hour = Dec2Bcd(Bcd2Dec(temp_Data.hour)-1); if (temp_Data.hour == Dec2Bcd(-1)) temp_Data.hour = 0x23;}
 }
 if (Botao_ENT()) {Data.hour = temp_Data.hour; Data.minute = temp_Data.minute; Data.second = temp_Data.second; Data.PM = temp_Data.PM; Write_RTC(Data); MENU = 12;}

 WriteDisplay(toggle_Set == 1 ? (temp_Data.hour >> 4) : 0x0F,toggle_Set == 1 ? temp_Data.PM : 0,0,toggle_Set == 1 ? (temp_Data.hour & 0x0F) : 0x0F,0,0,(temp_Data.minute >> 4),0,0,(temp_Data.minute & 0x0F),0,0,(temp_Data.second >> 4),0,0,(temp_Data.second & 0x0F),0,0,1,1);

}





void Menu_21_DAY() {

 if (Botao_INC()) {temp_Data.day = Dec2Bcd(Bcd2Dec(temp_Data.day)+1); if (temp_Data.day == 0x32) temp_Data.day = 0x01;}
 if (Botao_DEC()) {temp_Data.day = Dec2Bcd(Bcd2Dec(temp_Data.day)-1); if (temp_Data.day == 0x00) temp_Data.day = 0x31;}
 if (Botao_ENT()) {MENU = 211;}

 WriteDisplay(toggle_Set == 1 ? (temp_Data.day >> 4) : 0x0F,toggle_Set,0,toggle_Set == 1 ? (temp_Data.day & 0x0F) : 0x0F,0,toggle_Set,(temp_Data.month >> 4),1,0,(temp_Data.month & 0x0F),0,1,(temp_Data.year >> 4),1,0,(temp_Data.year & 0x0F),0,1,0,0);

}





void Menu_21_MON() {

 if (Botao_INC()) {temp_Data.month = Dec2Bcd(Bcd2Dec(temp_Data.month)+1); if (temp_Data.month == 0x13) temp_Data.month = 0x01;}
 if (Botao_DEC()) {temp_Data.month = Dec2Bcd(Bcd2Dec(temp_Data.month)-1); if (temp_Data.month == 0x00) temp_Data.month = 0x12;}
 if (Botao_ENT()) {MENU = 212;}

 WriteDisplay((temp_Data.day >> 4),1,0,(temp_Data.day & 0x0F),0,1,toggle_Set == 1 ? (temp_Data.month >> 4) : 0x0F,toggle_Set,0,toggle_Set == 1 ? (temp_Data.month & 0x0F) : 0x0F,0,toggle_Set,(temp_Data.year >> 4),1,0,(temp_Data.year & 0x0F),0,1,0,0);

}





void Menu_21_YEAR() {

 if (Botao_INC()) {temp_Data.year = Dec2Bcd(Bcd2Dec(temp_Data.year)+1); if (temp_Data.year == Dec2Bcd(100)) temp_Data.hour = 0x00;}
 if (Botao_DEC()) {temp_Data.year = Dec2Bcd(Bcd2Dec(temp_Data.year)-1); if (temp_Data.year == Dec2Bcd(-1)) temp_Data.hour = 0x99;}
 if (Botao_ENT()) {Data.day = temp_Data.day; Data.month = temp_Data.month; Data.year = temp_Data.year; Write_RTC(Data); MENU = 21;}

 WriteDisplay((temp_Data.day >> 4),1,0,(temp_Data.day & 0x0F),0,1,(temp_Data.month >> 4),1,0,(temp_Data.month & 0x0F),0,1,toggle_Set == 1 ? (temp_Data.year >> 4) : 0x0F,toggle_Set,0,toggle_Set == 1 ? (temp_Data.year & 0x0F) : 0x0F,0,toggle_Set,0,0);
}





void Menu_22() {

 if (Botao_INC() && temp_Data.week<7) temp_Data.week++;
 if (Botao_DEC() && temp_Data.week>1) temp_Data.week--;
 if (Botao_ENT()) {Data.week = temp_Data.week; Write_RTC(Data); MENU = 22;}

 WriteDisplay(0x02,0,0,0x02,1,0,0x0F,0,0,0x0F,0,0,0x0F,0,0,toggle_Set == 1 ? temp_Data.week : 0x0F,0,0,0,0);

}





void Menu_31() {

 if (Botao_INC() && (BackLight<3)) { BackLight++; if (BackLight == 1) BackLightRGB(&Led); else if (BackLight == 2) BackLightRGB(&Led_Week[Data.week]); else BackLightRGB(&LedOFF);}
 if (Botao_DEC() && (BackLight>0)) { BackLight--; if (BackLight == 1) BackLightRGB(&Led); else if (BackLight == 2) BackLightRGB(&Led_Week[Data.week]); else BackLightRGB(&LedOFF);}
 if (Botao_ENT()) { escrever_eeprom(0x02,BackLight); MENU = 31;}

 WriteDisplay(0x03,0,0,0x01,1,0,0x0F,0,0,0x0F,0,0,0x0F,0,0,toggle_Set == 1 ? BackLight : 0x0F,0,0,0,0);

}





void Menu_32() {

 if (Botao_INC() && Led.r<198) {Led.r += 2; BackLightRGB(&Led);}
 if (Botao_DEC() && Led.r>0) {Led.r -= 2; BackLightRGB(&Led);}
 if (Botao_ENT()) { escrever_eeprom(0x03,Led.r); if (BackLight == 0) BackLightRGB(&LedOFF); else if (BackLight == 2) BackLightRGB(&Led_Week[Data.week]); MENU = 32;}

 SeparaUnidade(Led.r / 2);

 WriteDisplay(0x03,0,0,0x02,1,0,0x0F,0,0,0x0F,0,0,toggle_Set == 1 ? dezena : 0x0F,0,0,toggle_Set == 1 ? unidade : 0x0F,0,0,0,0);

}





void Menu_33() {

 if (Botao_INC() && Led.g<198) {Led.g += 2; BackLightRGB(&Led);}
 if (Botao_DEC() && Led.g>0) {Led.g -= 2; BackLightRGB(&Led);}
 if (Botao_ENT()) { escrever_eeprom(0x04,Led.g); if (BackLight == 0) BackLightRGB(&LedOFF); else if (BackLight == 2) BackLightRGB(&Led_Week[Data.week]); MENU = 33;}

 SeparaUnidade(Led.g / 2);

 WriteDisplay(0x03,0,0,0x03,1,0,0x0F,0,0,0x0F,0,0,toggle_Set == 1 ? dezena : 0x0F,0,0,toggle_Set == 1 ? unidade : 0x0F,0,0,0,0);

}





void Menu_34() {

 if (Botao_INC() && Led.b<198) {Led.b += 2; BackLightRGB(&Led);}
 if (Botao_DEC() && Led.b>0) {Led.b -= 2; BackLightRGB(&Led);}
 if (Botao_ENT()) { escrever_eeprom(0x05,Led.b); if (BackLight == 0) BackLightRGB(&LedOFF); else if (BackLight == 2) BackLightRGB(&Led_Week[Data.week]); MENU = 34;}

 SeparaUnidade(Led.b / 2);

 WriteDisplay(0x03,0,0,0x04,1,0,0x0F,0,0,0x0F,0,0,toggle_Set == 1 ? dezena : 0x0F,0,0,toggle_Set == 1 ? unidade : 0x0F,0,0,0,0);

}





void Menu_41() {

 if (Botao_INC()) { LDR_Auto = 1; ACESO = Light_Sensor; APAGADO = 100-ACESO;}
 if (Botao_DEC()) { LDR_Auto = 0; ACESO = ler_eeprom(0x07); APAGADO = 100-ACESO;}
 if (Botao_ENT()) { escrever_eeprom(0x06,LDR_Auto); MENU = 41;}

 WriteDisplay(0x04,0,0,0x01,1,0,0x0F,0,0,0x0F,0,0,0x0F,0,0,toggle_Set == 1 ? (unsigned char)LDR_Auto : 0x0F,0,0,0,0);

}





void Menu_42() {

 if (Botao_INC() && ACESO<99) {ACESO++; APAGADO = 100-ACESO;}
 if (Botao_DEC() && ACESO>0) {ACESO--; APAGADO = 100-ACESO;}
 if (Botao_ENT()) { escrever_eeprom(0x07,ACESO); LDR_Auto = ler_eeprom(0x06); MENU = 42;}

 SeparaUnidade(ACESO);

 WriteDisplay(0x04,0,0,0x02,1,0,0x0F,0,0,0x0F,0,0,toggle_Set == 1 ? dezena : 0x0F,0,0,toggle_Set == 1 ? unidade : 0x0F,0,0,0,0);

}





void Menu_51() {

 if (Botao_INC()) Presence = 1;
 if (Botao_DEC()) Presence = 0;
 if (Botao_ENT()) { escrever_eeprom(0x08,Presence); MENU = 51;}

 WriteDisplay(0x05,0,0,0x01,1,0,0x0F,0,0,0x0F,0,0,0x0F,0,0,toggle_Set == 1 ? (unsigned char)Presence : 0x0F,0,0,0,0);

}





void Menu_52() {

 if (Botao_INC() && PresenceTime<60) {PresenceTime += 10; if (PresenceTime == 40) PresenceTime = 60;}
 if (Botao_DEC() && PresenceTime>10) {PresenceTime -= 10; if (PresenceTime == 50) PresenceTime = 30;}
 if (Botao_ENT()) { escrever_eeprom(0x09,PresenceTime); MENU = 52;}

 SeparaUnidade(PresenceTime);

 WriteDisplay(0x05,0,0,0x02,1,0,0x0F,0,0,0x0F,0,0,toggle_Set == 1 ? dezena : 0x0F,0,0,toggle_Set == 1 ? unidade : 0x0F,0,0,0,0);

}





void Menu_53() {

 if (Botao_INC()) PresenceAuto = 1;
 if (Botao_DEC()) PresenceAuto = 0;
 if (Botao_ENT()) { escrever_eeprom(0x0A,PresenceAuto); MENU = 53;}

 WriteDisplay(0x05,0,0,0x03,1,0,0x0F,0,0,0x0F,0,0,0x0F,0,0,toggle_Set == 1 ? (unsigned char)PresenceAuto : 0x0F,0,0,0,0);

}





void Menu_61() {

 if (Botao_INC() && EffectMode<5) EffectMode++;
 if (Botao_DEC() && EffectMode>1) EffectMode--;
 if (Botao_ENT()) { escrever_eeprom(0x0B,EffectMode); MENU = 61;}

 WriteDisplay(0x06,0,0,0x01,1,0,0x0F,0,0,0x0F,0,0,0x0F,0,0,toggle_Set == 1 ? EffectMode : 0x0F,0,0,0,0);

}





void Menu_62() {

 if (Botao_INC()) Cathode = 1;
 if (Botao_DEC()) Cathode = 0;
 if (Botao_ENT()) { escrever_eeprom(0x0C,Cathode); MENU = 62;}

 WriteDisplay(0x06,0,0,0x02,1,0,0x0F,0,0,0x0F,0,0,0x0F,0,0,toggle_Set == 1 ? (unsigned char)Cathode : 0x0F,0,0,0,0);

}





void Menu_63() {

 if (Botao_INC() && CathodeTime<90) {CathodeTime += 15; if (CathodeTime == 75) CathodeTime = 90;}
 if (Botao_DEC() && CathodeTime>15) {CathodeTime -= 15; if (CathodeTime == 75) CathodeTime = 60;}
 if (Botao_ENT()) { escrever_eeprom(0x0D,CathodeTime); MENU = 63;}

 SeparaUnidade(CathodeTime);

 WriteDisplay(0x06,0,0,0x03,1,0,0x0F,0,0,0x0F,0,0,toggle_Set == 1 ? dezena : 0x0F,0,0,toggle_Set == 1 ? unidade : 0x0F,0,0,0,0);

}





void Menu_71() {

 if (Botao_INC()) AutoOffOn = 1;
 if (Botao_DEC()) AutoOffOn = 0;
 if (Botao_ENT()) { escrever_eeprom(0x0E,AutoOffOn); MENU = 71;}

 WriteDisplay(0x07,0,0,0x01,1,0,0x0F,0,0,0x0F,0,0,0x0F,0,0,toggle_Set == 1 ? (unsigned char)AutoOffOn : 0x0F,0,0,0,0);

}





void Menu_72_MIN() {

 if (Botao_INC()) {Display_Off_Minute = Dec2Bcd(Bcd2Dec(Display_Off_Minute)+1); if (Display_Off_Minute == 0x60) Display_Off_Minute = 0x00;}
 if (Botao_DEC()) {Display_Off_Minute = Dec2Bcd(Bcd2Dec(Display_Off_Minute)-1); if (Display_Off_Minute == Dec2Bcd(-1)) Display_Off_Minute = 0x59;}
 if (Botao_ENT()) {MENU = 721;}

 WriteDisplay(0x07,0,0,0x02,1,0,(Display_Off_Hour >> 4),Display_Off_PM,0,(Display_Off_Hour & 0x0F),0,0,toggle_Set == 1 ? (Display_Off_Minute >> 4) : 0x0F,0,0,toggle_Set == 1 ? (Display_Off_Minute & 0x0F) : 0x0F,0,0,1,0);

}





void Menu_72_HOUR() {

 if (Mode12h) {
 if (Botao_INC()) {Display_Off_Hour = Dec2Bcd(Bcd2Dec(Display_Off_Hour)+1); if (Display_Off_Hour == 0x12) Display_Off_PM = !Display_Off_PM; if (Display_Off_Hour == 0x13) Display_Off_Hour = 0x01;}
 if (Botao_DEC()) {Display_Off_Hour = Dec2Bcd(Bcd2Dec(Display_Off_Hour)-1); if (Display_Off_Hour == 0x11) Display_Off_PM = !Display_Off_PM; if (Display_Off_Hour == 0x00) Display_Off_Hour = 0x12;}

 } else {
 if (Botao_INC()) {Display_Off_Hour = Dec2Bcd(Bcd2Dec(Display_Off_Hour)+1); if (Display_Off_Hour == 0x24) Display_Off_Hour = 0x00;}
 if (Botao_DEC()) {Display_Off_Hour = Dec2Bcd(Bcd2Dec(Display_Off_Hour)-1); if (Display_Off_Hour == Dec2Bcd(-1)) Display_Off_Hour = 0x23;}
 }
 if (Botao_ENT()) {escrever_eeprom(0x0F,Display_Off_Hour); escrever_eeprom(0x10,Display_Off_Minute); escrever_eeprom(0x11,Display_Off_PM); MENU = 72;}

 WriteDisplay(0x07,0,0,0x02,1,0,toggle_Set == 1 ? (Display_Off_Hour >> 4) : 0x0F,toggle_Set == 1 ? Display_Off_PM : 0,0,toggle_Set == 1 ? (Display_Off_Hour & 0x0F) : 0x0F,0,0,(Display_Off_Minute >> 4),0,0,(Display_Off_Minute & 0x0F),0,0,1,0);

}





void Menu_73_MIN() {

 if (Botao_INC()) {Display_On_Minute = Dec2Bcd(Bcd2Dec(Display_On_Minute)+1); if (Display_On_Minute == 0x60) Display_On_Minute = 0x00;}
 if (Botao_DEC()) {Display_On_Minute = Dec2Bcd(Bcd2Dec(Display_On_Minute)-1); if (Display_On_Minute == Dec2Bcd(-1)) Display_On_Minute = 0x59;}
 if (Botao_ENT()) {MENU = 731;}

 WriteDisplay(0x07,0,0,0x03,1,0,(Display_On_Hour >> 4),Display_On_PM,0,(Display_On_Hour & 0x0F),0,0,toggle_Set == 1 ? (Display_On_Minute >> 4) : 0x0F,0,0,toggle_Set == 1 ? (Display_On_Minute & 0x0F) : 0x0F,0,0,1,0);

}





void Menu_73_HOUR() {

 if (Mode12h) {
 if (Botao_INC()) {Display_On_Hour = Dec2Bcd(Bcd2Dec(Display_On_Hour)+1); if (Display_On_Hour == 0x12) Display_On_PM = !Display_On_PM; if (Display_On_Hour == 0x13) Display_On_Hour = 0x01;}
 if (Botao_DEC()) {Display_On_Hour = Dec2Bcd(Bcd2Dec(Display_On_Hour)-1); if (Display_On_Hour == 0x11) Display_On_PM = !Display_On_PM; if (Display_On_Hour == 0x00) Display_On_Hour = 0x12;}

 } else {
 if (Botao_INC()) {Display_On_Hour = Dec2Bcd(Bcd2Dec(Display_On_Hour)+1); if (Display_On_Hour == 0x24) Display_On_Hour = 0x00;}
 if (Botao_DEC()) {Display_On_Hour = Dec2Bcd(Bcd2Dec(Display_On_Hour)-1); if (Display_On_Hour == Dec2Bcd(-1)) Display_On_Hour = 0x23;}
 }
 if (Botao_ENT()) {escrever_eeprom(0x12,Display_On_Hour); escrever_eeprom(0x13,Display_On_Minute); escrever_eeprom(0x14,Display_On_PM); MENU = 73;}

 WriteDisplay(0x07,0,0,0x03,1,0,toggle_Set == 1 ? (Display_On_Hour >> 4) : 0x0F,toggle_Set == 1 ? Display_On_PM : 0,0,toggle_Set == 1 ? (Display_On_Hour & 0x0F) : 0x0F,0,0,(Display_On_Minute >> 4),0,0,(Display_On_Minute & 0x0F),0,0,1,0);

}





void Menu_81() {

 if (Botao_INC()) Alarm = 1;
 if (Botao_DEC()) Alarm = 0;
 if (Botao_ENT()) { escrever_eeprom(0x15,Alarm); MENU = 81;}

 WriteDisplay(0x08,0,0,0x01,1,0,0x0F,0,0,0x0F,0,0,0x0F,0,0,toggle_Set == 1 ? (unsigned char)Alarm : 0x0F,0,0,0,0);

}





void Menu_82_MIN() {

 if (Botao_INC()) {Alarm_Minute = Dec2Bcd(Bcd2Dec(Alarm_Minute)+1); if (Alarm_Minute == 0x60) Alarm_Minute = 0x00;}
 if (Botao_DEC()) {Alarm_Minute = Dec2Bcd(Bcd2Dec(Alarm_Minute)-1); if (Alarm_Minute == Dec2Bcd(-1)) Alarm_Minute = 0x59;}
 if (Botao_ENT()) {MENU = 821;}

 WriteDisplay(0x08,0,0,0x02,1,0,(Alarm_Hour >> 4),Alarm_PM,0,(Alarm_Hour & 0x0F),0,0,toggle_Set == 1 ? (Alarm_Minute >> 4) : 0x0F,0,0,toggle_Set == 1 ? (Alarm_Minute & 0x0F) : 0x0F,0,0,1,0);

}





void Menu_82_HOUR() {

 if (Mode12h) {
 if (Botao_INC()) {Alarm_Hour = Dec2Bcd(Bcd2Dec(Alarm_Hour)+1); if (Alarm_Hour == 0x12) Alarm_PM = !Alarm_PM; if (Alarm_Hour == 0x13) Alarm_Hour = 0x01;}
 if (Botao_DEC()) {Alarm_Hour = Dec2Bcd(Bcd2Dec(Alarm_Hour)-1); if (Alarm_Hour == 0x11) Alarm_PM = !Alarm_PM; if (Alarm_Hour == 0x00) Alarm_Hour = 0x12;}

 } else {
 if (Botao_INC()) {Alarm_Hour = Dec2Bcd(Bcd2Dec(Alarm_Hour)+1); if (Alarm_Hour == 0x24) Alarm_Hour = 0x00;}
 if (Botao_DEC()) {Alarm_Hour = Dec2Bcd(Bcd2Dec(Alarm_Hour)-1); if (Alarm_Hour == Dec2Bcd(-1)) Alarm_Hour = 0x23;}
 }
 if (Botao_ENT()) {escrever_eeprom(0x16,Alarm_Hour); escrever_eeprom(0x17,Alarm_Minute); escrever_eeprom(0x18,Alarm_PM); MENU = 82;}

 WriteDisplay(0x08,0,0,0x02,1,0,toggle_Set == 1 ? (Alarm_Hour >> 4) : 0x0F,toggle_Set == 1 ? Alarm_PM : 0,0,toggle_Set == 1 ? (Alarm_Hour & 0x0F) : 0x0F,0,0,(Alarm_Minute >> 4),0,0,(Alarm_Minute & 0x0F),0,0,1,0);

}





void Menu_91() {

 if (Botao_INC()) HourBeep = 1;
 if (Botao_DEC()) HourBeep = 0;
 if (Botao_ENT()) { escrever_eeprom(0x01,HourBeep); MENU = 91;}

 WriteDisplay(0x09,0,0,0x01,1,0,0x0F,0,0,0x0F,0,0,0x0F,0,0,toggle_Set == 1 ? (unsigned char)HourBeep : 0x0F,0,0,0,0);

}





void Menu_92() {

 if (Botao_INC()) SecondBeep = 1;
 if (Botao_DEC()) SecondBeep = 0;
 if (Botao_ENT()) { escrever_eeprom(0x1A,SecondBeep); MENU = 92;}

 WriteDisplay(0x09,0,0,0x02,1,0,0x0F,0,0,0x0F,0,0,0x0F,0,0,toggle_Set == 1 ? (unsigned char)SecondBeep : 0x0F,0,0,0,0);

}





void Menu_93() {

 if (Botao_INC()) ButtonBeep = 1;
 if (Botao_DEC()) ButtonBeep = 0;
 if (Botao_ENT()) { escrever_eeprom(0x1B,ButtonBeep); MENU = 93;}

 WriteDisplay(0x09,0,0,0x03,1,0,0x0F,0,0,0x0F,0,0,0x0F,0,0,toggle_Set == 1 ? (unsigned char)ButtonBeep : 0x0F,0,0,0,0);

}





void Menu_94() {

 if (Botao_INC() && Ajust_Temp<100) {Ajust_Temp += 10;}
 if (Botao_DEC() && Ajust_Temp>-100) {Ajust_Temp -= 10;}
 if (Botao_ENT()) { escrever_eeprom(0x19,Ajust_Temp); MENU = 94;}

 SeparaUnidade(Temp_Celsius);

 WriteDisplay(0x09,0,0,0x04,1,0,0x0F,0,0,0x0F,0,0,toggle_Set == 1 ? centena : 0x0F,0,0,toggle_Set == 1 ? dezena : 0x0F,0,0,0,0);

}









void BackLightRGB(ws2812Led* ledRGB) {

 int i;

 GIE_bit = 0;

 for (i=0;i<6;i++)
 ws2812_send(&*ledRGB);

 GIE_bit = 1;

 asm CLRWDT;
}





void SeparaUnidade(unsigned long int Numero) {

 unidade_m = Numero / 1000;
 centena = (Numero / 100) % 10;
 dezena = (Numero / 10) % 10;
 unidade = Numero % 10;

}





void WriteDisplay(unsigned char D5, unsigned char D5_L_P, unsigned char D5_R_P, unsigned char D4, unsigned char D4_L_P, unsigned char D4_R_P, unsigned char D3, unsigned char D3_L_P, unsigned char D3_R_P, unsigned char D2, unsigned char D2_L_P, unsigned char D2_R_P, unsigned char D1, unsigned char D1_L_P, unsigned char D1_R_P, unsigned char D0, unsigned char D0_L_P, unsigned char D0_R_P, unsigned char N0, unsigned char N1) {

  LATC0_bit = LATE2_bit = LATE1_bit = LATE0_bit = LATA5_bit = LATA4_bit  = 0;
  LATD5_bit = LATD4_bit  = 0;
  LATD6_bit = LATD6_bit  = 0;

 Number(D0);
  LATD5_bit  = D0_L_P;
  LATD4_bit  = D0_R_P;
  LATA4_bit  = 1;
 DELAY(ACESO);
  LATA4_bit  = 0;

 DELAY(APAGADO);

 Number(D1);
  LATD5_bit  = D1_L_P;
  LATD4_bit  = D1_R_P;
  LATA5_bit  = 1;
 DELAY(ACESO);
  LATA5_bit  = 0;

 DELAY(APAGADO);

  LATD6_bit  = N0;
 DELAY(ACESO);
  LATD6_bit  = 0;
 DELAY(APAGADO);

 Number(D2);
  LATD5_bit  = D2_L_P;
  LATD4_bit  = D2_R_P;
  LATE0_bit  = 1;
 DELAY(ACESO);
  LATE0_bit  = 0;

 DELAY(APAGADO);

 Number(D3);
  LATD5_bit  = D3_L_P;
  LATD4_bit  = D3_R_P;
  LATE1_bit  = 1;
 DELAY(ACESO);
  LATE1_bit  = 0;

 DELAY(APAGADO);

  LATD7_bit  = N1;
 DELAY(ACESO);
  LATD7_bit  = 0;
 DELAY(APAGADO);

 Number(D4);
  LATD5_bit  = D4_L_P;
  LATD4_bit  = D4_R_P;
  LATE2_bit  = 1;
 DELAY(ACESO);
  LATE2_bit  = 0;

 DELAY(APAGADO);

 Number(D5);
  LATD5_bit  = D5_L_P;
  LATD4_bit  = D5_R_P;
  LATC0_bit  = 1;
 DELAY(ACESO);
  LATC0_bit  = 0;

 DELAY(APAGADO);

  LATD5_bit = LATD4_bit  = 0;
}






void WriteDisplay_Fading(unsigned char D5, unsigned char D5_L_P, unsigned char D5_R_P, char F5, unsigned char D4, unsigned char D4_L_P, unsigned char D4_R_P, char F4, unsigned char D3, unsigned char D3_L_P, unsigned char D3_R_P, char F3, unsigned char D2, unsigned char D2_L_P, unsigned char D2_R_P, char F2, unsigned char D1, unsigned char D1_L_P, unsigned char D1_R_P, char F1, unsigned char D0, unsigned char D0_L_P, unsigned char D0_R_P, char F0, unsigned char N0, char F_N0, unsigned char N1, char F_N1, unsigned char ON, unsigned char OFF) {

  LATC0_bit = LATE2_bit = LATE1_bit = LATE0_bit = LATA5_bit = LATA4_bit  = 0;
  LATD5_bit = LATD4_bit  = 0;
  LATD6_bit = LATD6_bit  = 0;

 Number(D0);
  LATD5_bit  = D0_L_P;
  LATD4_bit  = D0_R_P;
  LATA4_bit  = 1;
 if (!F0) {DELAY(ACESO);  LATA4_bit  = 0; DELAY(APAGADO);}
 else {DELAY(ON);  LATA4_bit  = 0; DELAY(OFF);}

 Number(D1);
  LATD5_bit  = D1_L_P;
  LATD4_bit  = D1_R_P;
  LATA5_bit  = 1;
 if (!F1) {DELAY(ACESO);  LATA5_bit  = 0; DELAY(APAGADO);}
 else {DELAY(ON);  LATA5_bit  = 0; DELAY(OFF);}

  LATD6_bit  = N0;
 if (!F_N0) {DELAY(ACESO);  LATD6_bit  = 0; DELAY(APAGADO);}
 else {DELAY(ON);  LATD6_bit  = 0; DELAY(OFF);}

 Number(D2);
  LATD5_bit  = D2_L_P;
  LATD4_bit  = D2_R_P;
  LATE0_bit  = 1;
 if (!F2) {DELAY(ACESO);  LATE0_bit  = 0; DELAY(APAGADO);}
 else {DELAY(ON);  LATE0_bit  = 0; DELAY(OFF);}

 Number(D3);
  LATD5_bit  = D3_L_P;
  LATD4_bit  = D3_R_P;
  LATE1_bit  = 1;
 if (!F3) {DELAY(ACESO);  LATE1_bit  = 0; DELAY(APAGADO);}
 else {DELAY(ON);  LATE1_bit  = 0; DELAY(OFF);}

  LATD7_bit  = N1;
 if (!F_N1) {DELAY(ACESO);  LATD7_bit  = 0; DELAY(APAGADO);}
 else {DELAY(ON);  LATD7_bit  = 0; DELAY(OFF);}

 Number(D4);
  LATD5_bit  = D4_L_P;
  LATD4_bit  = D4_R_P;
  LATE2_bit  = 1;
 if (!F4) {DELAY(ACESO);  LATE2_bit  = 0; DELAY(APAGADO);}
 else {DELAY(ON);  LATE2_bit  = 0; DELAY(OFF);}

 Number(D5);
  LATD5_bit  = D5_L_P;
  LATD4_bit  = D5_R_P;
  LATC0_bit  = 1;
 if (!F5) {DELAY(ACESO);  LATC0_bit  = 0; DELAY(APAGADO);}
 else {DELAY(ON);  LATC0_bit  = 0; DELAY(OFF);}

  LATD5_bit = LATD4_bit  = 0;

}





void Number(unsigned char digit) {

  LATD0_bit  = digit.B0;
  LATD1_bit  = digit.B1;
  LATD2_bit  = digit.B2;
  LATD3_bit  = digit.B3;

}





void DELAY(unsigned char L) {


 while(L>=1){Delay_us(10); L--;}

return;
}





void Hour(unsigned char Point) {

 WriteDisplay((Data.hour >> 4),Data.PM,0,(Data.hour & 0x0F),0,0,(Data.minute >> 4),0,0,(Data.minute & 0x0F),0,0,(Data.second >> 4),0,0,(Data.second & 0x0F),0,(unsigned char)Alarm,Point,Point);

}






void Hour_Cathode() {

 unsigned char n_Cathode;

 if (old_Data.second != Data.second) {

 Flag_Cathode_Poisoning = 1;

 if (Cathode_Poisoning >= 0x57) {
 Flag_Cathode_Poisoning = 0;
 Cathode_Poisoning = 0;
 old_Data = Data;
 }

 n_Cathode = Cathode_Poisoning / 8;

 WriteDisplay((old_Data.hour & 0xF0) != (Data.hour & 0xF0) ? (n_Cathode+(old_Data.hour >> 4))%10 : (Data.hour >> 4),Data.PM,0,old_Data.hour != Data.hour ? (n_Cathode+(old_Data.hour & 0x0F))%10 : (Data.hour & 0x0F),0,0,(old_Data.minute & 0xF0) != (Data.minute & 0xF0) ? (n_Cathode+(old_Data.minute >> 4))%10 : (Data.minute >> 4),0,0,old_Data.minute != Data.minute ? (n_Cathode+(old_Data.minute & 0x0F))%10 : (Data.minute & 0x0F),0,0,(old_Data.second & 0xF0) != (Data.second & 0xF0) ? (n_Cathode+(old_Data.second >> 4))%10 : (Data.second >> 4),0,0,old_Data.second != Data.second ? (n_Cathode+(old_Data.second & 0x0F))%10 : (Data.second & 0x0F),0,(unsigned char)Alarm,0,0);

 } else


 Hour(1);


}






void Hour_Fading() {

 unsigned char old_Fading, new_Fading;

 if (old_Data.second != Data.second) {

 Flag_Fading = 1;

 if (Fading >= 160) {
 Flag_Fading = 0;
 Fading = 0;
 toggle_Fading = 0;
 old_Data = Data;
 return;
 }

 new_Fading = (Fading*ACESO) / 160;
 old_Fading = ACESO - new_Fading;

 if (toggle_Fading)
 WriteDisplay_Fading((Data.hour >> 4),Data.PM,0,(old_Data.hour & 0xF0) != (Data.hour & 0xF0) ? 1 : 0,(Data.hour & 0x0F),0,0,old_Data.hour != Data.hour ? 1 : 0,(Data.minute >> 4),0,0,(old_Data.minute & 0xF0) != (Data.minute & 0xF0) ? 1 : 0,(Data.minute & 0x0F),0,0,old_Data.minute != Data.minute ? 1 : 0,(Data.second >> 4),0,0,(old_Data.second & 0xF0) != (Data.second & 0xF0) ? 1 : 0,(Data.second & 0x0F),0,(unsigned char)Alarm,old_Data.second != Data.second ? 1 : 0,0,0,0,0,new_Fading,(100-new_Fading));
 else
 WriteDisplay_Fading((old_Data.hour >> 4),Data.PM,0,(old_Data.hour & 0xF0) != (Data.hour & 0xF0) ? 1 : 0,(old_Data.hour & 0x0F),0,0,old_Data.hour != Data.hour ? 1 : 0,(old_Data.minute >> 4),0,0,(old_Data.minute & 0xF0) != (Data.minute & 0xF0) ? 1 : 0,(old_Data.minute & 0x0F),0,0,old_Data.minute != Data.minute ? 1 : 0,(old_Data.second >> 4),0,0,(old_Data.second & 0xF0) != (Data.second & 0xF0) ? 1 : 0,(old_Data.second & 0x0F),0,(unsigned char)Alarm,old_Data.second != Data.second ? 1 : 0,0,0,0,0,old_Fading,(100-old_Fading));

 toggle_Fading = !toggle_Fading;

 } else

 WriteDisplay_Fading((Data.hour >> 4),Data.PM,0,0,(Data.hour & 0x0F),0,0,0,(Data.minute >> 4),0,0,0,(Data.minute & 0x0F),0,0,0,(Data.second >> 4),0,0,0,(Data.second & 0x0F),0,(unsigned char)Alarm,0,1,0,1,0,ACESO,APAGADO);

}





void Hour_FadingFull() {

 unsigned char old_Fading, new_Fading;

 if (old_Data.second != Data.second) {

 Flag_Fading = 1;

 if (Fading >= 0x00 && Fading <= 0x59) {

 new_Fading = (unsigned char)(((float)ACESO / 0x5A) * Fading);
 old_Fading = ACESO - new_Fading;

 WriteDisplay_Fading((old_Data.hour >> 4),Data.PM,0,1,(old_Data.hour & 0x0F),0,0,1,(old_Data.minute >> 4),0,0,1,(old_Data.minute & 0x0F),0,0,1,(old_Data.second >> 4),0,0,1,(old_Data.second & 0x0F),0,(unsigned char)Alarm,1,1,1,1,1,old_Fading,(100-old_Fading));

 } else

 if (Fading >= 0x5A && Fading <= 0x69) {

 WriteDisplay_Fading(0x0F,0,0,0,0x0F,0,0,0,0x0F,0,0,0,0x0F,0,0,0,0x0F,0,0,0,0x0F,0,0,0,0,0,0,0,0,100);

 } else

 if (Fading >= 0x6A && Fading <= 0xC3) {

 new_Fading = (unsigned char)(((float)ACESO / 0x5A) * (Fading - 0x6A));
 old_Fading = ACESO - new_Fading;

 WriteDisplay_Fading((Data.hour >> 4),Data.PM,0,1,(Data.hour & 0x0F),0,0,1,(Data.minute >> 4),0,0,1,(Data.minute & 0x0F),0,0,1,(Data.second >> 4),0,0,1,(Data.second & 0x0F),0,(unsigned char)Alarm,1,1,1,1,1,new_Fading,(100-new_Fading));

 } else

 if (Fading >= 0xC4) {

 Flag_Fading = 0;
 Fading = 0;
 old_Data = Data;

 }

 } else

 WriteDisplay_Fading((Data.hour >> 4),Data.PM,0,0,(Data.hour & 0x0F),0,0,0,(Data.minute >> 4),0,0,0,(Data.minute & 0x0F),0,0,0,(Data.second >> 4),0,0,0,(Data.second & 0x0F),0,(unsigned char)Alarm,0,1,0,1,0,ACESO,APAGADO);

}






void Hour_Scroll() {

 if (old_Data.second != Data.second) {

 Flag_Scroll = 1;

 if (Scroll >=0 && Scroll <=12)
 WriteDisplay(0x0F,0,0,(old_Data.hour >> 4),Data.PM,0,(old_Data.hour & 0x0F),0,0,(old_Data.minute >> 4),0,0,(old_Data.minute & 0x0F),0,0,(old_Data.second >> 4),0,0,0,0);
 else
 if (Scroll >=13 && Scroll <=25)
 WriteDisplay(0x0F,0,0,0x0F,0,0,(old_Data.hour >> 4),Data.PM,0,(old_Data.hour & 0x0F),0,0,(old_Data.minute >> 4),0,0,(old_Data.minute & 0x0F),0,0,0,0);
 else
 if (Scroll >=26 && Scroll <=38)
 WriteDisplay(0x0F,0,0,0x0F,0,0,0x0F,0,0,(old_Data.hour >> 4),Data.PM,0,(old_Data.hour & 0x0F),0,0,(old_Data.minute >> 4),0,0,0,0);
 else
 if (Scroll >=39 && Scroll <=51)
 WriteDisplay((Data.second & 0x0F),0,(unsigned char)Alarm,0x0F,0,0,0x0F,0,0,0x0F,0,0,(old_Data.hour >> 4),Data.PM,0,(old_Data.hour & 0x0F),0,0,0,0);
 else
 if (Scroll >=52 && Scroll <=64)
 WriteDisplay((Data.second >> 4),0,0,(Data.second & 0x0F),0,(unsigned char)Alarm,0x0F,0,0,0x0F,0,0,0x0F,0,0,(old_Data.hour >> 4),Data.PM,0,0,0);
 else
 if (Scroll >=65 && Scroll <=77)
 WriteDisplay((Data.minute & 0x0F),0,0,(Data.second >> 4),0,0,(Data.second & 0x0F),0,(unsigned char)Alarm,0x0F,0,0,0x0F,0,0,0x0F,0,0,0,0);
 else
 if (Scroll >=78 && Scroll <=90)
 WriteDisplay((Data.minute >> 4),0,0,(Data.minute & 0x0F),0,0,(Data.second >> 4),0,0,(Data.second & 0x0F),0,(unsigned char)Alarm,0x0F,0,0,0x0F,0,0,0,0);
 else
 if (Scroll >=91 && Scroll <=103)
 WriteDisplay((Data.hour & 0x0F),0,0,(Data.minute >> 4),0,0,(Data.minute & 0x0F),0,0,(Data.second >> 4),0,0,(Data.second & 0x0F),0,(unsigned char)Alarm,0x0F,0,0,0,0);
 else

 if (Scroll >= 104) {

 Flag_Scroll = 0;
 Scroll = 0;
 old_Data = Data;

 }

 } else


 Hour(1);


}





void Date() {

 WriteDisplay((Data.day >> 4),1,0,(Data.day & 0x0F),0,1,(Data.month >> 4),1,0,(Data.month & 0x0F),0,1,(Data.year >> 4),1,0,(Data.year & 0x0F),0,1,0,0);

}






void Temp() {

 SeparaUnidade(Temp_Celsius);

 WriteDisplay(0x0F,1,1,0x0F,1,1,centena,0,0,dezena,0,0,0x0F,1,1,0x0F,1,1,0,0);

}






void High_Volt() {

 SeparaUnidade(High_Voltage);

 WriteDisplay(0x0F,0,0,0x0F,0,0,unidade_m,0,0,centena,0,0,dezena,0,0,unidade,1,0,0,0);

}





void CathodePoisoning() {

 unsigned char number_Cathode_Poisoning, ON, OFF;
 static unsigned int count = 0;

 ON = ACESO;
 OFF = APAGADO;

 ACESO = 50;
 APAGADO = 50;

 Flag_Cathode_Poisoning = 1;

 if (Cathode_Poisoning >= 0x50) {
 Cathode_Poisoning = 0;
 count++;
 }

 number_Cathode_Poisoning = Cathode_Poisoning / 8;


 WriteDisplay((number_Cathode_Poisoning+2)%10,1,1,(number_Cathode_Poisoning+4)%10,1,1,(number_Cathode_Poisoning+6)%10,1,1,(number_Cathode_Poisoning+8)%10,1,1,(number_Cathode_Poisoning+3)%10,1,1,number_Cathode_Poisoning,1,1,0,0);
#line 1949 "C:/NIXIE/soft/Nixie/Nixie.c"
 if (count >= 142 || awake || Botao_INC() || Botao_DEC() || Botao_ENT()) {
 Flag_Cathode_Poisoning = 0;
 Cathode_Poisoning = 0;
 count = 0;
 MENU = 1;
 }

 ACESO = ON;
 APAGADO = OFF;

}





void DisplayOFF() {

 if (Botao_INC() || Botao_DEC() || Botao_ENT() || awake) {
 MENU = 1;
 persistence_timer = 0;
 if (BackLight == 1) BackLightRGB(&Led);
 else if (BackLight == 2) BackLightRGB(&Led_Week[Data.week]);
 }

}





void main() {

 unsigned char old_hour = 0, old_week = 0;
 unsigned int Hour_Off = 0, Hour_On = 0, Hour_Current = 0, count_cathode = 0;

 asm CLRWDT;

 Setup();

 asm CLRWDT;

 Start();

 old_hour = Data.hour;
 old_week = Data.week;

 while(1) {

 asm CLRWDT;


 if (MENU == 1) {Menu_Show(); }

 if (MENU == 0) {Menu_Exit(); if(Botao_INC()){MENU = 11;} else if(Botao_DEC()){MENU = 95;} if(Botao_ENT()){MENU = 1; CountShowMode = 0;}}

 if (MENU == 11) {Menu_TimeFormat(); if(Botao_INC()){MENU = 12;} else if(Botao_DEC()){MENU = 0;} if(Botao_ENT()){MENU = 110;}}
 if (MENU == 12) {Menu_SetTime(); if(Botao_INC()){MENU = 21;} else if(Botao_DEC()){MENU = 11;} if(Botao_ENT()){MENU = 120; temp_Data = Data;}}

 if (MENU == 21) {Menu_SetDate(); if(Botao_INC()){MENU = 22;} else if(Botao_DEC()){MENU = 12;} if(Botao_ENT()){MENU = 210; temp_Data = Data;}}
 if (MENU == 22) {Menu_SetWeek(); if(Botao_INC()){MENU = 31;} else if(Botao_DEC()){MENU = 21;} if(Botao_ENT()){MENU = 220; temp_Data = Data;}}

 if (MENU == 31) {Menu_SetBackLight(); if(Botao_INC()){MENU = 32;} else if(Botao_DEC()){MENU = 22;} if(Botao_ENT()){MENU = 310;}}
 if (MENU == 32) {Menu_SetR(); if(Botao_INC()){MENU = 33;} else if(Botao_DEC()){MENU = 31;} if(Botao_ENT()){MENU = 320; BackLightRGB(&Led);}}
 if (MENU == 33) {Menu_SetG(); if(Botao_INC()){MENU = 34;} else if(Botao_DEC()){MENU = 32;} if(Botao_ENT()){MENU = 330; BackLightRGB(&Led);}}
 if (MENU == 34) {Menu_SetB(); if(Botao_INC()){MENU = 41;} else if(Botao_DEC()){MENU = 33;} if(Botao_ENT()){MENU = 340; BackLightRGB(&Led);}}

 if (MENU == 41) {Menu_LDR(); if(Botao_INC()){MENU = 42;} else if(Botao_DEC()){MENU = 34;} if(Botao_ENT()){MENU = 410;}}
 if (MENU == 42) {Menu_SetBright(); if(Botao_INC()){MENU = 51;} else if(Botao_DEC()){MENU = 41;} if(Botao_ENT()){MENU = 420; LDR_Auto = 0; ACESO = ler_eeprom(0x07); APAGADO = 100-ACESO;}}

 if (MENU == 51) {Menu_Presence(); if(Botao_INC()){MENU = 52;} else if(Botao_DEC()){MENU = 42;} if(Botao_ENT()){MENU = 510;}}
 if (MENU == 52) {Menu_TimePresence(); if(Botao_INC()){MENU = 53;} else if(Botao_DEC()){MENU = 51;} if(Botao_ENT()){MENU = 520;}}
 if (MENU == 53) {Menu_AutoPresence(); if(Botao_INC()){MENU = 61;} else if(Botao_DEC()){MENU = 52;} if(Botao_ENT()){MENU = 530;}}

 if (MENU == 61) {Menu_SetDisplayEffect(); if(Botao_INC()){MENU = 62;} else if(Botao_DEC()){MENU = 53;} if(Botao_ENT()){MENU = 610;}}
 if (MENU == 62) {Menu_CathodePoisoning(); if(Botao_INC()){MENU = 63;} else if(Botao_DEC()){MENU = 61;} if(Botao_ENT()){MENU = 620;}}
 if (MENU == 63) {Menu_TimeCathodePoisoning(); if(Botao_INC()){MENU = 71;} else if(Botao_DEC()){MENU = 62;} if(Botao_ENT()){MENU = 630;}}

 if (MENU == 71) {Menu_SetAutoOFFON(); if(Botao_INC()){MENU = 72;} else if(Botao_DEC()){MENU = 63;} if(Botao_ENT()){MENU = 710;}}
 if (MENU == 72) {Menu_SetAutoOFF(); if(Botao_INC()){MENU = 73;} else if(Botao_DEC()){MENU = 71;} if(Botao_ENT()){MENU = 720;}}
 if (MENU == 73) {Menu_SetAutoON(); if(Botao_INC()){MENU = 81;} else if(Botao_DEC()){MENU = 72;} if(Botao_ENT()){MENU = 730;}}

 if (MENU == 81) {Menu_SetAlarm(); if(Botao_INC()){MENU = 82;} else if(Botao_DEC()){MENU = 73;} if(Botao_ENT()){MENU = 810;}}
 if (MENU == 82) {Menu_HourAlarm(); if(Botao_INC()){MENU = 91;} else if(Botao_DEC()){MENU = 81;} if(Botao_ENT()){MENU = 820;}}

 if (MENU == 91) {Menu_HourBeep(); if(Botao_INC()){MENU = 92;} else if(Botao_DEC()){MENU = 82;} if(Botao_ENT()){MENU = 910;}}
 if (MENU == 92) {Menu_SecondBeep(); if(Botao_INC()){MENU = 93;} else if(Botao_DEC()){MENU = 91;} if(Botao_ENT()){MENU = 920;}}
 if (MENU == 93) {Menu_ButtonBeep(); if(Botao_INC()){MENU = 94;} else if(Botao_DEC()){MENU = 92;} if(Botao_ENT()){MENU = 930;}}
 if (MENU == 94) {Menu_AjustTemp(); if(Botao_INC()){MENU = 95;} else if(Botao_DEC()){MENU = 93;} if(Botao_ENT()){MENU = 940;}}
 if (MENU == 95) {Menu_HighVoltage(); if(Botao_INC()){MENU = 0;} else if(Botao_DEC()){MENU = 94;} }


 if (MENU == 110) {Menu_11(); }
 if (MENU == 120) {Menu_12_SEG(); }
 if (MENU == 121) {Menu_12_MIN(); }
 if (MENU == 122) {Menu_12_HOUR(); }

 if (MENU == 210) {Menu_21_DAY(); }
 if (MENU == 211) {Menu_21_MON(); }
 if (MENU == 212) {Menu_21_YEAR(); }
 if (MENU == 220) {Menu_22(); }

 if (MENU == 310) {Menu_31(); }
 if (MENU == 320) {Menu_32(); }
 if (MENU == 330) {Menu_33(); }
 if (MENU == 340) {Menu_34(); }

 if (MENU == 410) {Menu_41(); }
 if (MENU == 420) {Menu_42(); }

 if (MENU == 510) {Menu_51(); }
 if (MENU == 520) {Menu_52(); }
 if (MENU == 530) {Menu_53(); }

 if (MENU == 610) {Menu_61(); }
 if (MENU == 620) {Menu_62(); }
 if (MENU == 630) {Menu_63(); }

 if (MENU == 710) {Menu_71(); }
 if (MENU == 720) {Menu_72_MIN(); }
 if (MENU == 721) {Menu_72_HOUR(); }
 if (MENU == 730) {Menu_73_MIN(); }
 if (MENU == 731) {Menu_73_HOUR(); }

 if (MENU == 810) {Menu_81(); }
 if (MENU == 820) {Menu_82_MIN(); }
 if (MENU == 821) {Menu_82_HOUR(); }

 if (MENU == 910) {Menu_91(); }
 if (MENU == 920) {Menu_92(); }
 if (MENU == 930) {Menu_93(); }
 if (MENU == 940) {Menu_94(); }

 if (MENU == 1000) {CathodePoisoning(); }

 if (MENU == 2000) {DisplayOFF(); }



 if (reset_RTC) {
 Write_RTC(Data);
 reset_RTC = 0;
 BEEP_ALARM();
 }

 if (refresh_RTC) {

 Data = Read_RTC();

 if (SecondBeep && (MENU == 1))  (RC7_bit = 1),(Delay_us(7)),(RC7_bit = 0) ;

 if (Data.hour != old_hour) {
 old_hour = Data.hour;
 if (HourBeep && (MENU == 1 || MENU == 1000)) BEEP_HOUR();
 }

 if ((BackLight == 2) && (MENU != 2000) && (MENU != 310) && (MENU != 320) && (MENU != 330) && (MENU != 340)) {
 if (Data.week != old_week) {old_week = Data.week; BackLightRGB(&Led_Week[Data.week]);}
 }

 if (Cathode && MENU == 1) {
 count_cathode++;
 if (count_cathode >= CathodeTime*60) {MENU = 1000; count_cathode = 0;}
 } else count_cathode = 0;

 CountShowMode++;
 if (CountShowMode == 60) CountShowMode = 0;

 if (Alarm && (MENU == 1 || MENU == 1000 || MENU == 2000)) {
 if (Alarm_Hour == Data.hour && Alarm_Minute == Data.minute && Alarm_PM == Data.PM && Data.second == 0x00) {
 awake = 1;
 } else
 if (Alarm_Hour != Data.hour || Alarm_Minute != Data.minute || Alarm_PM != Data.PM) {
 awake = 0;
 }
 }

 if (awake) BEEP_ALARM();

 if (AutoOffOn && (MENU == 1 || MENU == 2000)) {

 if (persistence_timer < PresenceTime) persistence_timer++;

 if (Mode12h) {
 if (Display_Off_PM) Hour_Off = ((Display_Off_Hour == 0x12 ? 0x12 : Dec2Bcd(12 + Bcd2Dec(Display_Off_Hour))) << 8) + Display_Off_Minute;
 else Hour_Off = ((Display_Off_Hour == 0x12 ? 0x00 : Display_Off_Hour) << 8) + Display_Off_Minute;

 if (Display_On_PM) Hour_On = ((Display_On_Hour == 0x12 ? 0x12 : Dec2Bcd(12 + Bcd2Dec(Display_On_Hour))) << 8) + Display_On_Minute;
 else Hour_On = ((Display_On_Hour == 0x12 ? 0x00 : Display_On_Hour) << 8) + Display_On_Minute;

 if (Data.PM) Hour_Current = ((Data.hour == 0x12 ? 0x12 : Dec2Bcd(12 + Bcd2Dec(Data.hour))) << 8) + Data.minute;
 else Hour_Current = ((Data.hour == 0x12 ? 0x00 : Data.hour) << 8) + Data.minute;
 } else {
 Hour_Off = (Display_Off_Hour << 8) + Display_Off_Minute;
 Hour_On = (Display_On_Hour << 8) + Display_On_Minute;
 Hour_Current = (Data.hour << 8) + Data.minute;
 }

 if (Hour_Off < Hour_On) {
 if (Hour_Current >= Hour_Off && Hour_Current < Hour_On) {if (persistence_timer >= PresenceTime) {MENU = 2000; BackLightRGB(&LedOFF);}}
 else {MENU = 1; if (BackLight == 1) BackLightRGB(&Led); else if (BackLight == 2) BackLightRGB(&Led_Week[Data.week]);}
 } else

 if (Hour_Off > Hour_On) {
 if (Hour_Current < Hour_Off && Hour_Current >= Hour_On) {MENU = 1; if (BackLight == 1) BackLightRGB(&Led); else if (BackLight == 2) BackLightRGB(&Led_Week[Data.week]);}
 else if (persistence_timer >= PresenceTime) {MENU = 2000; BackLightRGB(&LedOFF);}
 }

 } else persistence_timer = 0;



 MEDIA_TEMP -= MM_TEMP[INDICE_MM_TEMP];
 MM_TEMP[INDICE_MM_TEMP] = VALOR_ADC(0);
 MEDIA_TEMP += MM_TEMP[INDICE_MM_TEMP];

 MEDIA_LDR -= MM_LDR[INDICE_MM];
 MM_LDR[INDICE_MM] = VALOR_ADC(1);
 MEDIA_LDR += MM_LDR[INDICE_MM];

 MEDIA_HIGH_VOLT -= MM_HIGH_VOLT[INDICE_MM];
 MM_HIGH_VOLT[INDICE_MM] = VALOR_ADC(2);
 MEDIA_HIGH_VOLT += MM_HIGH_VOLT[INDICE_MM];

 Temp_Celsius = (((MEDIA_TEMP /  300 )* 4945)/1023) + Ajust_Temp;

 if (Temp_Celsius > 65000) Temp_Celsius = 0;

 Light_Sensor = (((MEDIA_LDR /  10 )* 92)/1023) + 4;

 High_Voltage = ((MEDIA_HIGH_VOLT /  10 )* 2980)/1023;

 if (LDR_Auto) {
 ACESO = Light_Sensor;
 APAGADO = 100-ACESO;
 }

 INDICE_MM++;
 INDICE_MM_TEMP++;

 if (INDICE_MM_TEMP ==  300 ) INDICE_MM_TEMP = 0;
 if (INDICE_MM ==  10 ) INDICE_MM = 0;

 refresh_RTC = 0;

 toggle_Point = !toggle_Point;

 if (MENU == 1 && BackLight == 3) {

 if (ShowMode == 1 && CountShowMode <= 14) {
 GIE_bit = 0;

 ws2812_send(&Led_Week[Data.year & 0x0F]);
 ws2812_send(&Led_Week[Data.year & 0x0F]);
 ws2812_send(&Led_Week[Data.month & 0x0F]);
 ws2812_send(&Led_Week[Data.month & 0x0F]);
 ws2812_send(&Led_Week[Data.day & 0x0F]);
 ws2812_send(&Led_Week[Data.day & 0x0F]);

 GIE_bit = 1;
 } else

 if (ShowMode == 2 && CountShowMode <= 14) {

 if (Temp_Celsius <= 200) { LedTemp.b = (100 - (Temp_Celsius*10/20)); }
 else LedTemp.b = 0;

 if (Temp_Celsius >= 200 && Temp_Celsius <= 400) { LedTemp.r = ((Temp_Celsius-200)*10/20); }
 else if (Temp_Celsius > 400) { LedTemp.r = 100; }
 else if (Temp_Celsius < 200) { LedTemp.r = 0; }

 if (Temp_Celsius <= 200) { LedTemp.g = (Temp_Celsius*10/20); }
 else if (Temp_Celsius > 200 && Temp_Celsius <= 400) { LedTemp.g = (100 - ((Temp_Celsius-200)*10/20)); }
 else LedTemp.g = 0;

 GIE_bit = 0;

 ws2812_send(&LedOFF);
 ws2812_send(&LedOFF);
 ws2812_send(&LedTemp);
 ws2812_send(&LedTemp);
 ws2812_send(&LedOFF);
 ws2812_send(&LedOFF);

 GIE_bit = 1;
 } else {
 GIE_bit = 0;

 ws2812_send(&Led_Week[Data.second & 0x0F]);
 ws2812_send(&Led_Week[(Data.second & 0xF0) >> 4]);
 ws2812_send(&Led_Week[Data.minute & 0x0F]);
 ws2812_send(&Led_Week[(Data.minute & 0xF0) >> 4]);
 ws2812_send(&Led_Week[Data.hour & 0x0F]);
 ws2812_send(&Led_Week[(Data.hour & 0xF0) >> 4]);

 GIE_bit = 1;
 }
 } else

 if (BackLight == 3) BackLightRGB(&LedOFF);


 }
 }

}

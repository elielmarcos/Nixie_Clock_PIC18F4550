#line 1 "C:/NIXIE/soft/Nixie/adc.c"
#line 1 "c:/nixie/soft/nixie/adc.h"



unsigned int VALOR_ADC(unsigned char CH);

void VREF_NEGATIVA(unsigned char LD);

void VREF_POSITIVA(unsigned char LD);
#line 6 "C:/NIXIE/soft/Nixie/adc.c"
unsigned int VALOR_ADC(unsigned char CH){
unsigned int ADC=0;

ADCON0 = 0b00000001;

ADCON0 = ADCON0 | (CH << 2);


GO_DONE_bit = 1;
while(GO_DONE_bit);
ADC = 0;
ADC = ADRESH;
ADC = ADC << 8;
ADC = ADC + ADRESL;

return ADC;

}




void VREF_POSITIVA(unsigned char LD){

VCFG0_bit = LD;

return;
}




void VREF_NEGATIVA(unsigned char LD){

VCFG1_bit = LD;

return;
}

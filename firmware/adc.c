#include "adc.h"


// ==== LÊ ADC E RETORNA O VALOR DO CANAL SELECIONADO ====

unsigned int VALOR_ADC(unsigned char CH){
unsigned int ADC=0;

ADCON0 = 0b00000001;            // CH0 A/D

ADCON0 = ADCON0 | (CH << 2);    // Desloca 2 bits e seleciona o canal

//Delay_us(5);                    // Tempo de aquisição do sinal
GO_DONE_bit = 1;                // Inicia a conversao
while(GO_DONE_bit);             // Aguarda fim da converção
ADC = 0;    
ADC = ADRESH;                   // CAPTURA O VALOR + SIGNIFICATIVO E JUNTA COM O - SIGNIFICATIVO
ADC = ADC << 8;                 // Desloca 8 bits para esquerda 
ADC = ADC + ADRESL;             // concatena

return ADC;                     // Retorna o resultado

}


// ==== HABILITA/DESABILITA VREF + ====

void VREF_POSITIVA(unsigned char LD){

VCFG0_bit = LD;     // 0 = VDD, 1 = Vref+ (AN3)

return;
}


// ==== HABILITA/DESABILITA VREF - ====

void VREF_NEGATIVA(unsigned char LD){

VCFG1_bit = LD;     // 0 = VSS, 1 = Vref- (AN2)

return;
}

_VALOR_ADC:

;adc.c,6 :: 		unsigned int VALOR_ADC(unsigned char CH){
;adc.c,7 :: 		unsigned int ADC=0;
	CLRF        VALOR_ADC_ADC_L0+0 
	CLRF        VALOR_ADC_ADC_L0+1 
;adc.c,9 :: 		ADCON0 = 0b00000001;            // CH0 A/D
	MOVLW       1
	MOVWF       ADCON0+0 
;adc.c,11 :: 		ADCON0 = ADCON0 | (CH << 2);    // Desloca 2 bits e seleciona o canal
	MOVF        FARG_VALOR_ADC_CH+0, 0 
	MOVWF       R0 
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R0, 1 
	BCF         R0, 0 
	MOVF        R0, 0 
	IORWF       ADCON0+0, 1 
;adc.c,14 :: 		GO_DONE_bit = 1;                // Inicia a conversao
	BSF         GO_DONE_bit+0, BitPos(GO_DONE_bit+0) 
;adc.c,15 :: 		while(GO_DONE_bit);             // Aguarda fim da converção
L_VALOR_ADC0:
	BTFSS       GO_DONE_bit+0, BitPos(GO_DONE_bit+0) 
	GOTO        L_VALOR_ADC1
	GOTO        L_VALOR_ADC0
L_VALOR_ADC1:
;adc.c,16 :: 		ADC = 0;
	CLRF        VALOR_ADC_ADC_L0+0 
	CLRF        VALOR_ADC_ADC_L0+1 
;adc.c,17 :: 		ADC = ADRESH;                   // CAPTURA O VALOR + SIGNIFICATIVO E JUNTA COM O - SIGNIFICATIVO
	MOVF        ADRESH+0, 0 
	MOVWF       VALOR_ADC_ADC_L0+0 
	MOVLW       0
	MOVWF       VALOR_ADC_ADC_L0+1 
;adc.c,18 :: 		ADC = ADC << 8;                 // Desloca 8 bits para esquerda
	MOVF        VALOR_ADC_ADC_L0+0, 0 
	MOVWF       R1 
	CLRF        R0 
	MOVF        R0, 0 
	MOVWF       VALOR_ADC_ADC_L0+0 
	MOVF        R1, 0 
	MOVWF       VALOR_ADC_ADC_L0+1 
;adc.c,19 :: 		ADC = ADC + ADRESL;             // concatena
	MOVF        ADRESL+0, 0 
	ADDWF       R0, 1 
	MOVLW       0
	ADDWFC      R1, 1 
	MOVF        R0, 0 
	MOVWF       VALOR_ADC_ADC_L0+0 
	MOVF        R1, 0 
	MOVWF       VALOR_ADC_ADC_L0+1 
;adc.c,21 :: 		return ADC;                     // Retorna o resultado
;adc.c,23 :: 		}
L_end_VALOR_ADC:
	RETURN      0
; end of _VALOR_ADC

_VREF_POSITIVA:

;adc.c,28 :: 		void VREF_POSITIVA(unsigned char LD){
;adc.c,30 :: 		VCFG0_bit = LD;     // 0 = VDD, 1 = Vref+ (AN3)
	BTFSC       FARG_VREF_POSITIVA_LD+0, 0 
	GOTO        L__VREF_POSITIVA4
	BCF         VCFG0_bit+0, BitPos(VCFG0_bit+0) 
	GOTO        L__VREF_POSITIVA5
L__VREF_POSITIVA4:
	BSF         VCFG0_bit+0, BitPos(VCFG0_bit+0) 
L__VREF_POSITIVA5:
;adc.c,32 :: 		return;
;adc.c,33 :: 		}
L_end_VREF_POSITIVA:
	RETURN      0
; end of _VREF_POSITIVA

_VREF_NEGATIVA:

;adc.c,38 :: 		void VREF_NEGATIVA(unsigned char LD){
;adc.c,40 :: 		VCFG1_bit = LD;     // 0 = VSS, 1 = Vref- (AN2)
	BTFSC       FARG_VREF_NEGATIVA_LD+0, 0 
	GOTO        L__VREF_NEGATIVA7
	BCF         VCFG1_bit+0, BitPos(VCFG1_bit+0) 
	GOTO        L__VREF_NEGATIVA8
L__VREF_NEGATIVA7:
	BSF         VCFG1_bit+0, BitPos(VCFG1_bit+0) 
L__VREF_NEGATIVA8:
;adc.c,42 :: 		return;
;adc.c,43 :: 		}
L_end_VREF_NEGATIVA:
	RETURN      0
; end of _VREF_NEGATIVA

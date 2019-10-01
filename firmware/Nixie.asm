
_interrupt:

;Nixie.c,156 :: 		void interrupt() {
;Nixie.c,158 :: 		RC7_bit = 0;
	BCF         RC7_bit+0, BitPos(RC7_bit+0) 
;Nixie.c,160 :: 		if (INT2IF_bit && INT2IE_bit) {  // INTERRUPÇÃO SQW RTC
	BTFSS       INT2IF_bit+0, BitPos(INT2IF_bit+0) 
	GOTO        L_interrupt2
	BTFSS       INT2IE_bit+0, BitPos(INT2IE_bit+0) 
	GOTO        L_interrupt2
L__interrupt962:
;Nixie.c,161 :: 		INT2IF_bit = 0;
	BCF         INT2IF_bit+0, BitPos(INT2IF_bit+0) 
;Nixie.c,162 :: 		TMR0H = TMR0L = 0x00;
	CLRF        TMR0L+0 
	MOVF        TMR0L+0, 0 
	MOVWF       TMR0H+0 
;Nixie.c,163 :: 		refresh_RTC = 1;
	BSF         _refresh_RTC+0, BitPos(_refresh_RTC+0) 
;Nixie.c,164 :: 		}
L_interrupt2:
;Nixie.c,166 :: 		if (TMR0IF_bit && TMR0IE_bit) {  // INTERRUPÇÃO CADA 1.39s (RESET RTC)
	BTFSS       TMR0IF_bit+0, BitPos(TMR0IF_bit+0) 
	GOTO        L_interrupt5
	BTFSS       TMR0IE_bit+0, BitPos(TMR0IE_bit+0) 
	GOTO        L_interrupt5
L__interrupt961:
;Nixie.c,167 :: 		TMR0IF_bit = 0;
	BCF         TMR0IF_bit+0, BitPos(TMR0IF_bit+0) 
;Nixie.c,168 :: 		reset_RTC = 1;
	BSF         _reset_RTC+0, BitPos(_reset_RTC+0) 
;Nixie.c,169 :: 		}
L_interrupt5:
;Nixie.c,171 :: 		if (TMR1IF_bit && TMR1IE_bit) {  // INTERRUPÇÃO CADA 0.005s (BASE DE TEMPO)
	BTFSS       TMR1IF_bit+0, BitPos(TMR1IF_bit+0) 
	GOTO        L_interrupt8
	BTFSS       TMR1IE_bit+0, BitPos(TMR1IE_bit+0) 
	GOTO        L_interrupt8
L__interrupt960:
;Nixie.c,172 :: 		TMR1IF_bit = 0;
	BCF         TMR1IF_bit+0, BitPos(TMR1IF_bit+0) 
;Nixie.c,173 :: 		TMR1H = 0xE2; // 8bits + significativos
	MOVLW       226
	MOVWF       TMR1H+0 
;Nixie.c,174 :: 		TMR1L = 0xB4; // 8bits - significativos
	MOVLW       180
	MOVWF       TMR1L+0 
;Nixie.c,176 :: 		if (Flag_Cathode_Poisoning) Cathode_Poisoning++; else Cathode_Poisoning = 0;
	BTFSS       _Flag_Cathode_Poisoning+0, BitPos(_Flag_Cathode_Poisoning+0) 
	GOTO        L_interrupt9
	INCF        _Cathode_Poisoning+0, 1 
	GOTO        L_interrupt10
L_interrupt9:
	CLRF        _Cathode_Poisoning+0 
L_interrupt10:
;Nixie.c,177 :: 		if (Flag_Fading) Fading++; else Fading = 0;
	BTFSS       _Flag_Fading+0, BitPos(_Flag_Fading+0) 
	GOTO        L_interrupt11
	INCF        _Fading+0, 1 
	GOTO        L_interrupt12
L_interrupt11:
	CLRF        _Fading+0 
L_interrupt12:
;Nixie.c,178 :: 		if (Flag_Scroll) Scroll++; else Scroll = 0;
	BTFSS       _Flag_Scroll+0, BitPos(_Flag_Scroll+0) 
	GOTO        L_interrupt13
	INCF        _Scroll+0, 1 
	GOTO        L_interrupt14
L_interrupt13:
	CLRF        _Scroll+0 
L_interrupt14:
;Nixie.c,179 :: 		Set++;
	INCF        _Set+0, 1 
;Nixie.c,181 :: 		if (Set >= 40) {Set = 0; toggle_Set = !toggle_Set;}
	MOVLW       40
	SUBWF       _Set+0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_interrupt15
	CLRF        _Set+0 
	BTG         _toggle_Set+0, BitPos(_toggle_Set+0) 
L_interrupt15:
;Nixie.c,182 :: 		}
L_interrupt8:
;Nixie.c,184 :: 		if (RBIF_bit && RBIE_bit) {  // INTERRUPÇÃO QUANDO HÁ MUDANÇA NOS PINOS RB4(DP) ou RB5(CLK)
	BTFSS       RBIF_bit+0, BitPos(RBIF_bit+0) 
	GOTO        L_interrupt18
	BTFSS       RBIE_bit+0, BitPos(RBIE_bit+0) 
	GOTO        L_interrupt18
L__interrupt959:
;Nixie.c,186 :: 		debounce = 50;
	MOVLW       50
	MOVWF       _debounce+0 
;Nixie.c,188 :: 		while(debounce--){;} // debounce
L_interrupt19:
	MOVF        _debounce+0, 0 
	MOVWF       R0 
	DECF        _debounce+0, 1 
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_interrupt20
	GOTO        L_interrupt19
L_interrupt20:
;Nixie.c,190 :: 		if (enc_A != enc_F) {
	BTFSC       RB5_bit+0, BitPos(RB5_bit+0) 
	GOTO        L__interrupt1027
	BSF         4056, 0 
	GOTO        L__interrupt1028
L__interrupt1027:
	BCF         4056, 0 
L__interrupt1028:
	BTFSC       4056, 0 
	GOTO        L__interrupt1029
	BTFSS       _enc_F+0, BitPos(_enc_F+0) 
	GOTO        L_interrupt21
	GOTO        L__interrupt1030
L__interrupt1029:
	BTFSS       _enc_F+0, BitPos(_enc_F+0) 
	GOTO        L__interrupt1030
	GOTO        L_interrupt21
L__interrupt1030:
;Nixie.c,191 :: 		if (enc_A != enc_B) {INC = 1; DEC = 0;}
	BTFSC       RB5_bit+0, BitPos(RB5_bit+0) 
	GOTO        L__interrupt1031
	BSF         R1, 1 
	GOTO        L__interrupt1032
L__interrupt1031:
	BCF         R1, 1 
L__interrupt1032:
	BTFSC       RB4_bit+0, BitPos(RB4_bit+0) 
	GOTO        L__interrupt1033
	BSF         4056, 0 
	GOTO        L__interrupt1034
L__interrupt1033:
	BCF         4056, 0 
L__interrupt1034:
	BTFSC       R1, 1 
	GOTO        L__interrupt1035
	BTFSS       4056, 0 
	GOTO        L_interrupt22
	GOTO        L__interrupt1036
L__interrupt1035:
	BTFSS       4056, 0 
	GOTO        L__interrupt1036
	GOTO        L_interrupt22
L__interrupt1036:
	BSF         _INC+0, BitPos(_INC+0) 
	BCF         _DEC+0, BitPos(_DEC+0) 
	GOTO        L_interrupt23
L_interrupt22:
;Nixie.c,192 :: 		else {INC = 0; DEC = 1;}
	BCF         _INC+0, BitPos(_INC+0) 
	BSF         _DEC+0, BitPos(_DEC+0) 
L_interrupt23:
;Nixie.c,193 :: 		enc_F = enc_A;
	BTFSC       RB5_bit+0, BitPos(RB5_bit+0) 
	GOTO        L__interrupt1037
	BSF         _enc_F+0, BitPos(_enc_F+0) 
	GOTO        L__interrupt1038
L__interrupt1037:
	BCF         _enc_F+0, BitPos(_enc_F+0) 
L__interrupt1038:
;Nixie.c,194 :: 		}
L_interrupt21:
;Nixie.c,205 :: 		RBIF_bit = 0;
	BCF         RBIF_bit+0, BitPos(RBIF_bit+0) 
;Nixie.c,207 :: 		}
L_interrupt18:
;Nixie.c,209 :: 		}
L_end_interrupt:
L__interrupt1026:
	RETFIE      1
; end of _interrupt

_Start:

;Nixie.c,215 :: 		void Start() {
;Nixie.c,219 :: 		BEEP_HOUR();
	CALL        _BEEP_HOUR+0, 0
;Nixie.c,221 :: 		LDR_Start = VALOR_ADC(1);
	MOVLW       1
	MOVWF       FARG_VALOR_ADC_CH+0 
	CALL        _VALOR_ADC+0, 0
	MOVF        R0, 0 
	MOVWF       Start_LDR_Start_L0+0 
	MOVF        R1, 0 
	MOVWF       Start_LDR_Start_L0+1 
;Nixie.c,222 :: 		High_Volt_Start = VALOR_ADC(2);
	MOVLW       2
	MOVWF       FARG_VALOR_ADC_CH+0 
	CALL        _VALOR_ADC+0, 0
	MOVF        R0, 0 
	MOVWF       FLOC__Start+0 
	MOVF        R1, 0 
	MOVWF       FLOC__Start+1 
	MOVF        FLOC__Start+0, 0 
	MOVWF       Start_High_Volt_Start_L0+0 
	MOVF        FLOC__Start+1, 0 
	MOVWF       Start_High_Volt_Start_L0+1 
;Nixie.c,224 :: 		MEDIA_LDR = LDR_Start * MEDIA_MOVEL;
	MOVF        Start_LDR_Start_L0+0, 0 
	MOVWF       R0 
	MOVF        Start_LDR_Start_L0+1, 0 
	MOVWF       R1 
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVF        R0, 0 
	MOVWF       _MEDIA_LDR+0 
	MOVF        R1, 0 
	MOVWF       _MEDIA_LDR+1 
	MOVLW       0
	MOVWF       _MEDIA_LDR+2 
	MOVWF       _MEDIA_LDR+3 
;Nixie.c,225 :: 		MEDIA_HIGH_VOLT = High_Volt_Start * MEDIA_MOVEL;
	MOVF        FLOC__Start+0, 0 
	MOVWF       R0 
	MOVF        FLOC__Start+1, 0 
	MOVWF       R1 
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVF        R0, 0 
	MOVWF       _MEDIA_HIGH_VOLT+0 
	MOVF        R1, 0 
	MOVWF       _MEDIA_HIGH_VOLT+1 
	MOVLW       0
	MOVWF       _MEDIA_HIGH_VOLT+2 
	MOVWF       _MEDIA_HIGH_VOLT+3 
;Nixie.c,227 :: 		for (i = 0; i < MEDIA_MOVEL; i++) // Zera todos os vetores da Média Móvel
	CLRF        Start_i_L0+0 
	CLRF        Start_i_L0+1 
L_Start24:
	MOVLW       0
	SUBWF       Start_i_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__Start1040
	MOVLW       10
	SUBWF       Start_i_L0+0, 0 
L__Start1040:
	BTFSC       STATUS+0, 0 
	GOTO        L_Start25
;Nixie.c,228 :: 		{MM_LDR[i] = LDR_Start; MM_HIGH_VOLT[i] = High_Volt_Start;}
	MOVF        Start_i_L0+0, 0 
	MOVWF       R0 
	MOVF        Start_i_L0+1, 0 
	MOVWF       R1 
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	MOVLW       _MM_LDR+0
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       hi_addr(_MM_LDR+0)
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	MOVF        Start_LDR_Start_L0+0, 0 
	MOVWF       POSTINC1+0 
	MOVF        Start_LDR_Start_L0+1, 0 
	MOVWF       POSTINC1+0 
	MOVLW       0
	MOVWF       POSTINC1+0 
	MOVWF       POSTINC1+0 
	MOVF        Start_i_L0+0, 0 
	MOVWF       R0 
	MOVF        Start_i_L0+1, 0 
	MOVWF       R1 
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	MOVLW       _MM_HIGH_VOLT+0
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       hi_addr(_MM_HIGH_VOLT+0)
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	MOVF        Start_High_Volt_Start_L0+0, 0 
	MOVWF       POSTINC1+0 
	MOVF        Start_High_Volt_Start_L0+1, 0 
	MOVWF       POSTINC1+0 
	MOVLW       0
	MOVWF       POSTINC1+0 
	MOVWF       POSTINC1+0 
;Nixie.c,227 :: 		for (i = 0; i < MEDIA_MOVEL; i++) // Zera todos os vetores da Média Móvel
	INFSNZ      Start_i_L0+0, 1 
	INCF        Start_i_L0+1, 1 
;Nixie.c,228 :: 		{MM_LDR[i] = LDR_Start; MM_HIGH_VOLT[i] = High_Volt_Start;}
	GOTO        L_Start24
L_Start25:
;Nixie.c,230 :: 		Temp_Start = VALOR_ADC(0);
	CLRF        FARG_VALOR_ADC_CH+0 
	CALL        _VALOR_ADC+0, 0
	MOVF        R0, 0 
	MOVWF       Start_Temp_Start_L0+0 
	MOVF        R1, 0 
	MOVWF       Start_Temp_Start_L0+1 
;Nixie.c,232 :: 		MEDIA_TEMP = Temp_Start * MEDIA_MOVEL_TEMP;
	MOVLW       44
	MOVWF       R4 
	MOVLW       1
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVF        R0, 0 
	MOVWF       _MEDIA_TEMP+0 
	MOVF        R1, 0 
	MOVWF       _MEDIA_TEMP+1 
	MOVLW       0
	MOVWF       _MEDIA_TEMP+2 
	MOVWF       _MEDIA_TEMP+3 
;Nixie.c,234 :: 		for (i = 0; i < MEDIA_MOVEL_TEMP; i++) // Inicia o vetor média móvel da Temperatura
	CLRF        Start_i_L0+0 
	CLRF        Start_i_L0+1 
L_Start27:
	MOVLW       1
	SUBWF       Start_i_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__Start1041
	MOVLW       44
	SUBWF       Start_i_L0+0, 0 
L__Start1041:
	BTFSC       STATUS+0, 0 
	GOTO        L_Start28
;Nixie.c,235 :: 		MM_TEMP[i] = Temp_Start;
	MOVF        Start_i_L0+0, 0 
	MOVWF       R0 
	MOVF        Start_i_L0+1, 0 
	MOVWF       R1 
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	MOVLW       _MM_TEMP+0
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       hi_addr(_MM_TEMP+0)
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	MOVF        Start_Temp_Start_L0+0, 0 
	MOVWF       POSTINC1+0 
	MOVF        Start_Temp_Start_L0+1, 0 
	MOVWF       POSTINC1+0 
	MOVLW       0
	MOVWF       POSTINC1+0 
	MOVWF       POSTINC1+0 
;Nixie.c,234 :: 		for (i = 0; i < MEDIA_MOVEL_TEMP; i++) // Inicia o vetor média móvel da Temperatura
	INFSNZ      Start_i_L0+0, 1 
	INCF        Start_i_L0+1, 1 
;Nixie.c,235 :: 		MM_TEMP[i] = Temp_Start;
	GOTO        L_Start27
L_Start28:
;Nixie.c,238 :: 		refresh_RTC = 0;                // Zera todas as variáveis
	BCF         _refresh_RTC+0, BitPos(_refresh_RTC+0) 
;Nixie.c,239 :: 		reset_RTC = 0;
	BCF         _reset_RTC+0, BitPos(_reset_RTC+0) 
;Nixie.c,240 :: 		toggle_Fading = 0;
	BCF         _toggle_Fading+0, BitPos(_toggle_Fading+0) 
;Nixie.c,241 :: 		toggle_Point = 0;
	BCF         _toggle_Point+0, BitPos(_toggle_Point+0) 
;Nixie.c,242 :: 		toggle_Set = 0;
	BCF         _toggle_Set+0, BitPos(_toggle_Set+0) 
;Nixie.c,243 :: 		old_Button = 0;
	BCF         _old_Button+0, BitPos(_old_Button+0) 
;Nixie.c,244 :: 		enc_F = enc_A;
	BTFSC       RB5_bit+0, BitPos(RB5_bit+0) 
	GOTO        L__Start1042
	BSF         _enc_F+0, BitPos(_enc_F+0) 
	GOTO        L__Start1043
L__Start1042:
	BCF         _enc_F+0, BitPos(_enc_F+0) 
L__Start1043:
;Nixie.c,245 :: 		INC = 0;
	BCF         _INC+0, BitPos(_INC+0) 
;Nixie.c,246 :: 		DEC = 0;
	BCF         _DEC+0, BitPos(_DEC+0) 
;Nixie.c,247 :: 		Flag_Fading = 0;
	BCF         _Flag_Fading+0, BitPos(_Flag_Fading+0) 
;Nixie.c,248 :: 		Flag_Cathode_Poisoning = 0;
	BCF         _Flag_Cathode_Poisoning+0, BitPos(_Flag_Cathode_Poisoning+0) 
;Nixie.c,249 :: 		Flag_Scroll = 0;
	BCF         _Flag_Scroll+0, BitPos(_Flag_Scroll+0) 
;Nixie.c,250 :: 		awake = 0;
	BCF         _awake+0, BitPos(_awake+0) 
;Nixie.c,252 :: 		Led_Week[0].r = 0;
	CLRF        _Led_Week+0 
;Nixie.c,253 :: 		Led_Week[0].g = 0;
	CLRF        _Led_Week+2 
;Nixie.c,254 :: 		Led_Week[0].b = 50;
	MOVLW       50
	MOVWF       _Led_Week+1 
;Nixie.c,256 :: 		Led_Week[1].r = 70;
	MOVLW       70
	MOVWF       _Led_Week+3 
;Nixie.c,257 :: 		Led_Week[1].g = 50;
	MOVLW       50
	MOVWF       _Led_Week+5 
;Nixie.c,258 :: 		Led_Week[1].b = 0;
	CLRF        _Led_Week+4 
;Nixie.c,260 :: 		Led_Week[2].r = 40;
	MOVLW       40
	MOVWF       _Led_Week+6 
;Nixie.c,261 :: 		Led_Week[2].g = 0;
	CLRF        _Led_Week+8 
;Nixie.c,262 :: 		Led_Week[2].b = 100;
	MOVLW       100
	MOVWF       _Led_Week+7 
;Nixie.c,264 :: 		Led_Week[3].r = 80;
	MOVLW       80
	MOVWF       _Led_Week+9 
;Nixie.c,265 :: 		Led_Week[3].g = 140;
	MOVLW       140
	MOVWF       _Led_Week+11 
;Nixie.c,266 :: 		Led_Week[3].b = 40;
	MOVLW       40
	MOVWF       _Led_Week+10 
;Nixie.c,268 :: 		Led_Week[4].r = 140;
	MOVLW       140
	MOVWF       _Led_Week+12 
;Nixie.c,269 :: 		Led_Week[4].g = 0;
	CLRF        _Led_Week+14 
;Nixie.c,270 :: 		Led_Week[4].b = 120;
	MOVLW       120
	MOVWF       _Led_Week+13 
;Nixie.c,272 :: 		Led_Week[5].r = 0;
	CLRF        _Led_Week+15 
;Nixie.c,273 :: 		Led_Week[5].g = 60;
	MOVLW       60
	MOVWF       _Led_Week+17 
;Nixie.c,274 :: 		Led_Week[5].b = 50;
	MOVLW       50
	MOVWF       _Led_Week+16 
;Nixie.c,276 :: 		Led_Week[6].r = 20;
	MOVLW       20
	MOVWF       _Led_Week+18 
;Nixie.c,277 :: 		Led_Week[6].g = 180;
	MOVLW       180
	MOVWF       _Led_Week+20 
;Nixie.c,278 :: 		Led_Week[6].b = 10;
	MOVLW       10
	MOVWF       _Led_Week+19 
;Nixie.c,280 :: 		Led_Week[7].r = 170;
	MOVLW       170
	MOVWF       _Led_Week+21 
;Nixie.c,281 :: 		Led_Week[7].g = 24;
	MOVLW       24
	MOVWF       _Led_Week+23 
;Nixie.c,282 :: 		Led_Week[7].b = 0;
	CLRF        _Led_Week+22 
;Nixie.c,284 :: 		Led_Week[8].r = 120;
	MOVLW       120
	MOVWF       _Led_Week+24 
;Nixie.c,285 :: 		Led_Week[8].g = 0;
	CLRF        _Led_Week+26 
;Nixie.c,286 :: 		Led_Week[8].b = 0;
	CLRF        _Led_Week+25 
;Nixie.c,288 :: 		Led_Week[9].r = 120;
	MOVLW       120
	MOVWF       _Led_Week+27 
;Nixie.c,289 :: 		Led_Week[9].g = 120;
	MOVLW       120
	MOVWF       _Led_Week+29 
;Nixie.c,290 :: 		Led_Week[9].b = 120;
	MOVLW       120
	MOVWF       _Led_Week+28 
;Nixie.c,292 :: 		Mode12h = ler_eeprom(0x00);
	CLRF        FARG_ler_eeprom_address+0 
	CALL        _ler_eeprom+0, 0
	BTFSC       R0, 0 
	GOTO        L__Start1044
	BCF         _Mode12h+0, BitPos(_Mode12h+0) 
	GOTO        L__Start1045
L__Start1044:
	BSF         _Mode12h+0, BitPos(_Mode12h+0) 
L__Start1045:
;Nixie.c,293 :: 		HourBeep = ler_eeprom(0x01);
	MOVLW       1
	MOVWF       FARG_ler_eeprom_address+0 
	CALL        _ler_eeprom+0, 0
	BTFSC       R0, 0 
	GOTO        L__Start1046
	BCF         _HourBeep+0, BitPos(_HourBeep+0) 
	GOTO        L__Start1047
L__Start1046:
	BSF         _HourBeep+0, BitPos(_HourBeep+0) 
L__Start1047:
;Nixie.c,294 :: 		BackLight = ler_eeprom(0x02);
	MOVLW       2
	MOVWF       FARG_ler_eeprom_address+0 
	CALL        _ler_eeprom+0, 0
	MOVF        R0, 0 
	MOVWF       _BackLight+0 
;Nixie.c,295 :: 		Led.r = ler_eeprom(0x03);
	MOVLW       3
	MOVWF       FARG_ler_eeprom_address+0 
	CALL        _ler_eeprom+0, 0
	MOVF        R0, 0 
	MOVWF       _Led+0 
;Nixie.c,296 :: 		Led.g = ler_eeprom(0x04);
	MOVLW       4
	MOVWF       FARG_ler_eeprom_address+0 
	CALL        _ler_eeprom+0, 0
	MOVF        R0, 0 
	MOVWF       _Led+2 
;Nixie.c,297 :: 		Led.b = ler_eeprom(0x05);
	MOVLW       5
	MOVWF       FARG_ler_eeprom_address+0 
	CALL        _ler_eeprom+0, 0
	MOVF        R0, 0 
	MOVWF       _Led+1 
;Nixie.c,298 :: 		LDR_Auto = ler_eeprom(0x06);
	MOVLW       6
	MOVWF       FARG_ler_eeprom_address+0 
	CALL        _ler_eeprom+0, 0
	BTFSC       R0, 0 
	GOTO        L__Start1048
	BCF         _LDR_Auto+0, BitPos(_LDR_Auto+0) 
	GOTO        L__Start1049
L__Start1048:
	BSF         _LDR_Auto+0, BitPos(_LDR_Auto+0) 
L__Start1049:
;Nixie.c,299 :: 		ACESO = ler_eeprom(0x07);
	MOVLW       7
	MOVWF       FARG_ler_eeprom_address+0 
	CALL        _ler_eeprom+0, 0
	MOVF        R0, 0 
	MOVWF       _ACESO+0 
;Nixie.c,300 :: 		APAGADO = 100 - ACESO;
	MOVF        R0, 0 
	SUBLW       100
	MOVWF       _APAGADO+0 
;Nixie.c,301 :: 		Presence = ler_eeprom(0x08);
	MOVLW       8
	MOVWF       FARG_ler_eeprom_address+0 
	CALL        _ler_eeprom+0, 0
	BTFSC       R0, 0 
	GOTO        L__Start1050
	BCF         _Presence+0, BitPos(_Presence+0) 
	GOTO        L__Start1051
L__Start1050:
	BSF         _Presence+0, BitPos(_Presence+0) 
L__Start1051:
;Nixie.c,302 :: 		PresenceTime = ler_eeprom(0x09);
	MOVLW       9
	MOVWF       FARG_ler_eeprom_address+0 
	CALL        _ler_eeprom+0, 0
	MOVF        R0, 0 
	MOVWF       _PresenceTime+0 
;Nixie.c,303 :: 		PresenceAuto = ler_eeprom(0x0A);
	MOVLW       10
	MOVWF       FARG_ler_eeprom_address+0 
	CALL        _ler_eeprom+0, 0
	BTFSC       R0, 0 
	GOTO        L__Start1052
	BCF         _PresenceAuto+0, BitPos(_PresenceAuto+0) 
	GOTO        L__Start1053
L__Start1052:
	BSF         _PresenceAuto+0, BitPos(_PresenceAuto+0) 
L__Start1053:
;Nixie.c,304 :: 		EffectMode = ler_eeprom(0x0B);
	MOVLW       11
	MOVWF       FARG_ler_eeprom_address+0 
	CALL        _ler_eeprom+0, 0
	MOVF        R0, 0 
	MOVWF       _EffectMode+0 
;Nixie.c,305 :: 		Cathode = ler_eeprom(0x0C);
	MOVLW       12
	MOVWF       FARG_ler_eeprom_address+0 
	CALL        _ler_eeprom+0, 0
	BTFSC       R0, 0 
	GOTO        L__Start1054
	BCF         _Cathode+0, BitPos(_Cathode+0) 
	GOTO        L__Start1055
L__Start1054:
	BSF         _Cathode+0, BitPos(_Cathode+0) 
L__Start1055:
;Nixie.c,306 :: 		CathodeTime = ler_eeprom(0x0D);
	MOVLW       13
	MOVWF       FARG_ler_eeprom_address+0 
	CALL        _ler_eeprom+0, 0
	MOVF        R0, 0 
	MOVWF       _CathodeTime+0 
;Nixie.c,307 :: 		AutoOffOn = ler_eeprom(0x0E);
	MOVLW       14
	MOVWF       FARG_ler_eeprom_address+0 
	CALL        _ler_eeprom+0, 0
	BTFSC       R0, 0 
	GOTO        L__Start1056
	BCF         _AutoOffOn+0, BitPos(_AutoOffOn+0) 
	GOTO        L__Start1057
L__Start1056:
	BSF         _AutoOffOn+0, BitPos(_AutoOffOn+0) 
L__Start1057:
;Nixie.c,308 :: 		Display_Off_Hour = ler_eeprom(0x0F);
	MOVLW       15
	MOVWF       FARG_ler_eeprom_address+0 
	CALL        _ler_eeprom+0, 0
	MOVF        R0, 0 
	MOVWF       _Display_Off_Hour+0 
;Nixie.c,309 :: 		Display_Off_Minute = ler_eeprom(0x10);
	MOVLW       16
	MOVWF       FARG_ler_eeprom_address+0 
	CALL        _ler_eeprom+0, 0
	MOVF        R0, 0 
	MOVWF       _Display_Off_Minute+0 
;Nixie.c,310 :: 		Display_Off_PM = ler_eeprom(0x11);
	MOVLW       17
	MOVWF       FARG_ler_eeprom_address+0 
	CALL        _ler_eeprom+0, 0
	MOVF        R0, 0 
	MOVWF       _Display_Off_PM+0 
;Nixie.c,311 :: 		Display_On_Hour = ler_eeprom(0x12);
	MOVLW       18
	MOVWF       FARG_ler_eeprom_address+0 
	CALL        _ler_eeprom+0, 0
	MOVF        R0, 0 
	MOVWF       _Display_On_Hour+0 
;Nixie.c,312 :: 		Display_On_Minute = ler_eeprom(0x13);
	MOVLW       19
	MOVWF       FARG_ler_eeprom_address+0 
	CALL        _ler_eeprom+0, 0
	MOVF        R0, 0 
	MOVWF       _Display_On_Minute+0 
;Nixie.c,313 :: 		Display_On_PM = ler_eeprom(0x14);
	MOVLW       20
	MOVWF       FARG_ler_eeprom_address+0 
	CALL        _ler_eeprom+0, 0
	MOVF        R0, 0 
	MOVWF       _Display_On_PM+0 
;Nixie.c,314 :: 		Alarm = ler_eeprom(0x15);
	MOVLW       21
	MOVWF       FARG_ler_eeprom_address+0 
	CALL        _ler_eeprom+0, 0
	BTFSC       R0, 0 
	GOTO        L__Start1058
	BCF         _Alarm+0, BitPos(_Alarm+0) 
	GOTO        L__Start1059
L__Start1058:
	BSF         _Alarm+0, BitPos(_Alarm+0) 
L__Start1059:
;Nixie.c,315 :: 		Alarm_Hour = ler_eeprom(0x16);
	MOVLW       22
	MOVWF       FARG_ler_eeprom_address+0 
	CALL        _ler_eeprom+0, 0
	MOVF        R0, 0 
	MOVWF       _Alarm_Hour+0 
;Nixie.c,316 :: 		Alarm_Minute = ler_eeprom(0x17);
	MOVLW       23
	MOVWF       FARG_ler_eeprom_address+0 
	CALL        _ler_eeprom+0, 0
	MOVF        R0, 0 
	MOVWF       _Alarm_Minute+0 
;Nixie.c,317 :: 		Alarm_PM = ler_eeprom(0x18);
	MOVLW       24
	MOVWF       FARG_ler_eeprom_address+0 
	CALL        _ler_eeprom+0, 0
	MOVF        R0, 0 
	MOVWF       _Alarm_PM+0 
;Nixie.c,318 :: 		Ajust_Temp = ler_eeprom(0x19);
	MOVLW       25
	MOVWF       FARG_ler_eeprom_address+0 
	CALL        _ler_eeprom+0, 0
	MOVF        R0, 0 
	MOVWF       _Ajust_Temp+0 
;Nixie.c,319 :: 		SecondBeep = ler_eeprom(0x1A);
	MOVLW       26
	MOVWF       FARG_ler_eeprom_address+0 
	CALL        _ler_eeprom+0, 0
	BTFSC       R0, 0 
	GOTO        L__Start1060
	BCF         _SecondBeep+0, BitPos(_SecondBeep+0) 
	GOTO        L__Start1061
L__Start1060:
	BSF         _SecondBeep+0, BitPos(_SecondBeep+0) 
L__Start1061:
;Nixie.c,320 :: 		ButtonBeep = ler_eeprom(0x1B);
	MOVLW       27
	MOVWF       FARG_ler_eeprom_address+0 
	CALL        _ler_eeprom+0, 0
	BTFSC       R0, 0 
	GOTO        L__Start1062
	BCF         _ButtonBeep+0, BitPos(_ButtonBeep+0) 
	GOTO        L__Start1063
L__Start1062:
	BSF         _ButtonBeep+0, BitPos(_ButtonBeep+0) 
L__Start1063:
;Nixie.c,323 :: 		if (Mode12h) Data.hour = old_Data.hour = 0x12;
	BTFSS       _Mode12h+0, BitPos(_Mode12h+0) 
	GOTO        L_Start30
	MOVLW       18
	MOVWF       _old_Data+2 
	MOVLW       18
	MOVWF       _Data+2 
	GOTO        L_Start31
L_Start30:
;Nixie.c,324 :: 		else         Data.hour = old_Data.hour = 0x00;
	CLRF        _old_Data+2 
	CLRF        _Data+2 
L_Start31:
;Nixie.c,325 :: 		Data.second = old_Data.second = 0x00;        // Definie a hora e data iniciais
	CLRF        _old_Data+0 
	CLRF        _Data+0 
;Nixie.c,326 :: 		Data.minute = old_Data.minute = 0x00;
	CLRF        _old_Data+1 
	CLRF        _Data+1 
;Nixie.c,327 :: 		Data.PM = old_Data.PM = 0;
	CLRF        _old_Data+3 
	CLRF        _Data+3 
;Nixie.c,328 :: 		Data.mode12h = old_Data.mode12h = Mode12h;
	MOVLW       0
	BTFSC       _Mode12h+0, BitPos(_Mode12h+0) 
	MOVLW       1
	MOVWF       _old_Data+4 
	MOVF        _old_Data+4, 0 
	MOVWF       _Data+4 
;Nixie.c,329 :: 		Data.day = old_Data.day = 0x01;
	MOVLW       1
	MOVWF       _old_Data+5 
	MOVLW       1
	MOVWF       _Data+5 
;Nixie.c,330 :: 		Data.week = old_Data.week = 0x01;
	MOVLW       1
	MOVWF       _old_Data+6 
	MOVLW       1
	MOVWF       _Data+6 
;Nixie.c,331 :: 		Data.month = old_Data.month = 0x01;
	MOVLW       1
	MOVWF       _old_Data+7 
	MOVLW       1
	MOVWF       _Data+7 
;Nixie.c,332 :: 		Data.year = old_Data.year = 0x19;
	MOVLW       25
	MOVWF       _old_Data+8 
	MOVLW       25
	MOVWF       _Data+8 
;Nixie.c,334 :: 		I2C1_Init(400000);     // Iniciliza I2C com frequencia de 400KHz
	MOVLW       30
	MOVWF       SSPADD+0 
	CALL        _I2C1_Init+0, 0
;Nixie.c,336 :: 		asm CLRWDT;            // Watchdog
	CLRWDT
;Nixie.c,338 :: 		Delay_ms(1500);        // Aguarda 1.5s para obter resposta do RTC   (Interrupção por SQW)
	MOVLW       92
	MOVWF       R11, 0
	MOVLW       81
	MOVWF       R12, 0
	MOVLW       96
	MOVWF       R13, 0
L_Start32:
	DECFSZ      R13, 1, 1
	BRA         L_Start32
	DECFSZ      R12, 1, 1
	BRA         L_Start32
	DECFSZ      R11, 1, 1
	BRA         L_Start32
	NOP
;Nixie.c,340 :: 		if (reset_RTC) {       // Se RTC não respondeu (INTERRUPÇÃO TIMER 0 POR SQW), reseta RTC
	BTFSS       _reset_RTC+0, BitPos(_reset_RTC+0) 
	GOTO        L_Start33
;Nixie.c,341 :: 		Write_RTC(Data);    // Escreve a hora e data iniciais no RTC
	MOVLW       9
	MOVWF       R0 
	MOVLW       FARG_Write_RTC_Data+0
	MOVWF       FSR1 
	MOVLW       hi_addr(FARG_Write_RTC_Data+0)
	MOVWF       FSR1H 
	MOVLW       _Data+0
	MOVWF       FSR0 
	MOVLW       hi_addr(_Data+0)
	MOVWF       FSR0H 
L_Start34:
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
	DECF        R0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_Start34
	CALL        _Write_RTC+0, 0
;Nixie.c,342 :: 		reset_RTC = 0;
	BCF         _reset_RTC+0, BitPos(_reset_RTC+0) 
;Nixie.c,343 :: 		}
L_Start33:
;Nixie.c,347 :: 		LedOFF.r = 255;
	MOVLW       255
	MOVWF       _LedOFF+0 
;Nixie.c,348 :: 		LedOFF.g = 0;
	CLRF        _LedOFF+2 
;Nixie.c,349 :: 		LedOFF.b = 0;
	CLRF        _LedOFF+1 
;Nixie.c,351 :: 		BackLightRGB(&LedOFF);
	MOVLW       _LedOFF+0
	MOVWF       FARG_BackLightRGB_ledRGB+0 
	MOVLW       hi_addr(_LedOFF+0)
	MOVWF       FARG_BackLightRGB_ledRGB+1 
	CALL        _BackLightRGB+0, 0
;Nixie.c,353 :: 		Delay_ms(300);        // Aguarda para próxima atualização dos LED's
	MOVLW       19
	MOVWF       R11, 0
	MOVLW       68
	MOVWF       R12, 0
	MOVLW       68
	MOVWF       R13, 0
L_Start35:
	DECFSZ      R13, 1, 1
	BRA         L_Start35
	DECFSZ      R12, 1, 1
	BRA         L_Start35
	DECFSZ      R11, 1, 1
	BRA         L_Start35
	NOP
;Nixie.c,355 :: 		LedOFF.r = 0;
	CLRF        _LedOFF+0 
;Nixie.c,356 :: 		LedOFF.g = 255;
	MOVLW       255
	MOVWF       _LedOFF+2 
;Nixie.c,357 :: 		LedOFF.b = 0;
	CLRF        _LedOFF+1 
;Nixie.c,359 :: 		BackLightRGB(&LedOFF);
	MOVLW       _LedOFF+0
	MOVWF       FARG_BackLightRGB_ledRGB+0 
	MOVLW       hi_addr(_LedOFF+0)
	MOVWF       FARG_BackLightRGB_ledRGB+1 
	CALL        _BackLightRGB+0, 0
;Nixie.c,361 :: 		Delay_ms(300);        // Aguarda para próxima atualização dos LED's
	MOVLW       19
	MOVWF       R11, 0
	MOVLW       68
	MOVWF       R12, 0
	MOVLW       68
	MOVWF       R13, 0
L_Start36:
	DECFSZ      R13, 1, 1
	BRA         L_Start36
	DECFSZ      R12, 1, 1
	BRA         L_Start36
	DECFSZ      R11, 1, 1
	BRA         L_Start36
	NOP
;Nixie.c,363 :: 		LedOFF.r = 0;
	CLRF        _LedOFF+0 
;Nixie.c,364 :: 		LedOFF.g = 0;
	CLRF        _LedOFF+2 
;Nixie.c,365 :: 		LedOFF.b = 255;
	MOVLW       255
	MOVWF       _LedOFF+1 
;Nixie.c,367 :: 		BackLightRGB(&LedOFF);
	MOVLW       _LedOFF+0
	MOVWF       FARG_BackLightRGB_ledRGB+0 
	MOVLW       hi_addr(_LedOFF+0)
	MOVWF       FARG_BackLightRGB_ledRGB+1 
	CALL        _BackLightRGB+0, 0
;Nixie.c,369 :: 		Delay_ms(300);        // Aguarda para próxima atualização dos LED's
	MOVLW       19
	MOVWF       R11, 0
	MOVLW       68
	MOVWF       R12, 0
	MOVLW       68
	MOVWF       R13, 0
L_Start37:
	DECFSZ      R13, 1, 1
	BRA         L_Start37
	DECFSZ      R12, 1, 1
	BRA         L_Start37
	DECFSZ      R11, 1, 1
	BRA         L_Start37
	NOP
;Nixie.c,371 :: 		LedOFF.r = 0;            // Desliga LED's BackLight
	CLRF        _LedOFF+0 
;Nixie.c,372 :: 		LedOFF.g = 0;
	CLRF        _LedOFF+2 
;Nixie.c,373 :: 		LedOFF.b = 0;
	CLRF        _LedOFF+1 
;Nixie.c,375 :: 		BackLightRGB(&LedOFF);
	MOVLW       _LedOFF+0
	MOVWF       FARG_BackLightRGB_ledRGB+0 
	MOVLW       hi_addr(_LedOFF+0)
	MOVWF       FARG_BackLightRGB_ledRGB+1 
	CALL        _BackLightRGB+0, 0
;Nixie.c,377 :: 		Delay_ms(100);        // Aguarda para próxima atualização dos LED's
	MOVLW       7
	MOVWF       R11, 0
	MOVLW       23
	MOVWF       R12, 0
	MOVLW       106
	MOVWF       R13, 0
L_Start38:
	DECFSZ      R13, 1, 1
	BRA         L_Start38
	DECFSZ      R12, 1, 1
	BRA         L_Start38
	DECFSZ      R11, 1, 1
	BRA         L_Start38
	NOP
;Nixie.c,379 :: 		i=0;
	CLRF        Start_i_L0+0 
	CLRF        Start_i_L0+1 
;Nixie.c,380 :: 		while(i<17) {         // Inicializa Nixie Tubos
L_Start39:
	MOVLW       0
	SUBWF       Start_i_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__Start1064
	MOVLW       17
	SUBWF       Start_i_L0+0, 0 
L__Start1064:
	BTFSC       STATUS+0, 0 
	GOTO        L_Start40
;Nixie.c,382 :: 		Flag_Cathode_Poisoning = 1;
	BSF         _Flag_Cathode_Poisoning+0, BitPos(_Flag_Cathode_Poisoning+0) 
;Nixie.c,384 :: 		if (Cathode_Poisoning >= 0x50) {
	MOVLW       80
	SUBWF       _Cathode_Poisoning+0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_Start41
;Nixie.c,385 :: 		Flag_Cathode_Poisoning = 0;
	BCF         _Flag_Cathode_Poisoning+0, BitPos(_Flag_Cathode_Poisoning+0) 
;Nixie.c,386 :: 		Cathode_Poisoning = 0;
	CLRF        _Cathode_Poisoning+0 
;Nixie.c,387 :: 		i++;
	INFSNZ      Start_i_L0+0, 1 
	INCF        Start_i_L0+1, 1 
;Nixie.c,388 :: 		asm CLRWDT;
	CLRWDT
;Nixie.c,389 :: 		}
L_Start41:
;Nixie.c,391 :: 		Data = Read_RTC();
	MOVLW       FLOC__Start+0
	MOVWF       R0 
	MOVLW       hi_addr(FLOC__Start+0)
	MOVWF       R1 
	CALL        _Read_RTC+0, 0
	MOVLW       9
	MOVWF       R0 
	MOVLW       _Data+0
	MOVWF       FSR1 
	MOVLW       hi_addr(_Data+0)
	MOVWF       FSR1H 
	MOVLW       FLOC__Start+0
	MOVWF       FSR0 
	MOVLW       hi_addr(FLOC__Start+0)
	MOVWF       FSR0H 
L_Start42:
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
	DECF        R0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_Start42
;Nixie.c,392 :: 		n_cathode = Cathode_Poisoning / 8;
	MOVLW       3
	MOVWF       R0 
	MOVF        _Cathode_Poisoning+0, 0 
	MOVWF       Start_n_cathode_L0+0 
	MOVLW       0
	MOVWF       Start_n_cathode_L0+1 
	MOVF        R0, 0 
L__Start1065:
	BZ          L__Start1066
	RRCF        Start_n_cathode_L0+0, 1 
	BCF         Start_n_cathode_L0+0, 7 
	ADDLW       255
	GOTO        L__Start1065
L__Start1066:
	MOVLW       0
	MOVWF       Start_n_cathode_L0+1 
;Nixie.c,394 :: 		if (i < 3) {
	MOVLW       0
	SUBWF       Start_i_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__Start1067
	MOVLW       3
	SUBWF       Start_i_L0+0, 0 
L__Start1067:
	BTFSC       STATUS+0, 0 
	GOTO        L_Start43
;Nixie.c,395 :: 		WriteDisplay(0x0F,1,1,0x0F,1,1,0x0F,1,1,0x0F,1,1,0x0F,1,1,0x0F,1,1,1,1);
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D5+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D5_L_P+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D5_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D4+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D4_L_P+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D4_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D3+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D3_L_P+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D3_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D2+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D2_L_P+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D2_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D1+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D1_L_P+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D1_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D0+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D0_L_P+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D0_R_P+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_N0+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_N1+0 
	CALL        _WriteDisplay+0, 0
;Nixie.c,396 :: 		} else
	GOTO        L_Start44
L_Start43:
;Nixie.c,397 :: 		WriteDisplay((i-3) >= 12 ? (Data.hour >> 4) : n_cathode,0,0,(i-3) >= 10 ? (Data.hour & 0x0F) : n_cathode,0,0,(i-3) >= 8 ? (Data.minute >> 4) : n_cathode,0,0,(i-3) >= 6 ? (Data.minute & 0x0F) : n_cathode,0,0,(i-3) >= 4 ? (Data.second >> 4) : n_cathode,0,0,(i-3) >= 2 ? (Data.second & 0x0F) : n_cathode,0,0,0,0);
	MOVLW       3
	SUBWF       Start_i_L0+0, 0 
	MOVWF       R1 
	MOVLW       0
	SUBWFB      Start_i_L0+1, 0 
	MOVWF       R2 
	MOVLW       0
	SUBWF       R2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__Start1068
	MOVLW       12
	SUBWF       R1, 0 
L__Start1068:
	BTFSS       STATUS+0, 0 
	GOTO        L_Start45
	MOVLW       4
	MOVWF       R0 
	MOVF        _Data+2, 0 
	MOVWF       ?FLOC___StartT91+0 
	MOVLW       0
	MOVWF       ?FLOC___StartT91+1 
	MOVF        R0, 0 
L__Start1069:
	BZ          L__Start1070
	RRCF        ?FLOC___StartT91+0, 1 
	BCF         ?FLOC___StartT91+0, 7 
	ADDLW       255
	GOTO        L__Start1069
L__Start1070:
	MOVLW       0
	MOVWF       ?FLOC___StartT91+1 
	GOTO        L_Start46
L_Start45:
	MOVF        Start_n_cathode_L0+0, 0 
	MOVWF       ?FLOC___StartT91+0 
	MOVF        Start_n_cathode_L0+1, 0 
	MOVWF       ?FLOC___StartT91+1 
L_Start46:
	MOVF        ?FLOC___StartT91+0, 0 
	MOVWF       FARG_WriteDisplay_D5+0 
	CLRF        FARG_WriteDisplay_D5_L_P+0 
	CLRF        FARG_WriteDisplay_D5_R_P+0 
	MOVLW       3
	SUBWF       Start_i_L0+0, 0 
	MOVWF       R1 
	MOVLW       0
	SUBWFB      Start_i_L0+1, 0 
	MOVWF       R2 
	MOVLW       0
	SUBWF       R2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__Start1071
	MOVLW       10
	SUBWF       R1, 0 
L__Start1071:
	BTFSS       STATUS+0, 0 
	GOTO        L_Start47
	MOVLW       15
	ANDWF       _Data+2, 0 
	MOVWF       ?FLOC___StartT95+0 
	CLRF        ?FLOC___StartT95+1 
	MOVLW       0
	ANDWF       ?FLOC___StartT95+1, 1 
	MOVLW       0
	MOVWF       ?FLOC___StartT95+1 
	GOTO        L_Start48
L_Start47:
	MOVF        Start_n_cathode_L0+0, 0 
	MOVWF       ?FLOC___StartT95+0 
	MOVF        Start_n_cathode_L0+1, 0 
	MOVWF       ?FLOC___StartT95+1 
L_Start48:
	MOVF        ?FLOC___StartT95+0, 0 
	MOVWF       FARG_WriteDisplay_D4+0 
	CLRF        FARG_WriteDisplay_D4_L_P+0 
	CLRF        FARG_WriteDisplay_D4_R_P+0 
	MOVLW       3
	SUBWF       Start_i_L0+0, 0 
	MOVWF       R1 
	MOVLW       0
	SUBWFB      Start_i_L0+1, 0 
	MOVWF       R2 
	MOVLW       0
	SUBWF       R2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__Start1072
	MOVLW       8
	SUBWF       R1, 0 
L__Start1072:
	BTFSS       STATUS+0, 0 
	GOTO        L_Start49
	MOVLW       4
	MOVWF       R0 
	MOVF        _Data+1, 0 
	MOVWF       ?FLOC___StartT99+0 
	MOVLW       0
	MOVWF       ?FLOC___StartT99+1 
	MOVF        R0, 0 
L__Start1073:
	BZ          L__Start1074
	RRCF        ?FLOC___StartT99+0, 1 
	BCF         ?FLOC___StartT99+0, 7 
	ADDLW       255
	GOTO        L__Start1073
L__Start1074:
	MOVLW       0
	MOVWF       ?FLOC___StartT99+1 
	GOTO        L_Start50
L_Start49:
	MOVF        Start_n_cathode_L0+0, 0 
	MOVWF       ?FLOC___StartT99+0 
	MOVF        Start_n_cathode_L0+1, 0 
	MOVWF       ?FLOC___StartT99+1 
L_Start50:
	MOVF        ?FLOC___StartT99+0, 0 
	MOVWF       FARG_WriteDisplay_D3+0 
	CLRF        FARG_WriteDisplay_D3_L_P+0 
	CLRF        FARG_WriteDisplay_D3_R_P+0 
	MOVLW       3
	SUBWF       Start_i_L0+0, 0 
	MOVWF       R1 
	MOVLW       0
	SUBWFB      Start_i_L0+1, 0 
	MOVWF       R2 
	MOVLW       0
	SUBWF       R2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__Start1075
	MOVLW       6
	SUBWF       R1, 0 
L__Start1075:
	BTFSS       STATUS+0, 0 
	GOTO        L_Start51
	MOVLW       15
	ANDWF       _Data+1, 0 
	MOVWF       ?FLOC___StartT103+0 
	CLRF        ?FLOC___StartT103+1 
	MOVLW       0
	ANDWF       ?FLOC___StartT103+1, 1 
	MOVLW       0
	MOVWF       ?FLOC___StartT103+1 
	GOTO        L_Start52
L_Start51:
	MOVF        Start_n_cathode_L0+0, 0 
	MOVWF       ?FLOC___StartT103+0 
	MOVF        Start_n_cathode_L0+1, 0 
	MOVWF       ?FLOC___StartT103+1 
L_Start52:
	MOVF        ?FLOC___StartT103+0, 0 
	MOVWF       FARG_WriteDisplay_D2+0 
	CLRF        FARG_WriteDisplay_D2_L_P+0 
	CLRF        FARG_WriteDisplay_D2_R_P+0 
	MOVLW       3
	SUBWF       Start_i_L0+0, 0 
	MOVWF       R1 
	MOVLW       0
	SUBWFB      Start_i_L0+1, 0 
	MOVWF       R2 
	MOVLW       0
	SUBWF       R2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__Start1076
	MOVLW       4
	SUBWF       R1, 0 
L__Start1076:
	BTFSS       STATUS+0, 0 
	GOTO        L_Start53
	MOVLW       4
	MOVWF       R0 
	MOVF        _Data+0, 0 
	MOVWF       ?FLOC___StartT107+0 
	MOVLW       0
	MOVWF       ?FLOC___StartT107+1 
	MOVF        R0, 0 
L__Start1077:
	BZ          L__Start1078
	RRCF        ?FLOC___StartT107+0, 1 
	BCF         ?FLOC___StartT107+0, 7 
	ADDLW       255
	GOTO        L__Start1077
L__Start1078:
	MOVLW       0
	MOVWF       ?FLOC___StartT107+1 
	GOTO        L_Start54
L_Start53:
	MOVF        Start_n_cathode_L0+0, 0 
	MOVWF       ?FLOC___StartT107+0 
	MOVF        Start_n_cathode_L0+1, 0 
	MOVWF       ?FLOC___StartT107+1 
L_Start54:
	MOVF        ?FLOC___StartT107+0, 0 
	MOVWF       FARG_WriteDisplay_D1+0 
	CLRF        FARG_WriteDisplay_D1_L_P+0 
	CLRF        FARG_WriteDisplay_D1_R_P+0 
	MOVLW       3
	SUBWF       Start_i_L0+0, 0 
	MOVWF       R1 
	MOVLW       0
	SUBWFB      Start_i_L0+1, 0 
	MOVWF       R2 
	MOVLW       0
	SUBWF       R2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__Start1079
	MOVLW       2
	SUBWF       R1, 0 
L__Start1079:
	BTFSS       STATUS+0, 0 
	GOTO        L_Start55
	MOVLW       15
	ANDWF       _Data+0, 0 
	MOVWF       ?FLOC___StartT111+0 
	CLRF        ?FLOC___StartT111+1 
	MOVLW       0
	ANDWF       ?FLOC___StartT111+1, 1 
	MOVLW       0
	MOVWF       ?FLOC___StartT111+1 
	GOTO        L_Start56
L_Start55:
	MOVF        Start_n_cathode_L0+0, 0 
	MOVWF       ?FLOC___StartT111+0 
	MOVF        Start_n_cathode_L0+1, 0 
	MOVWF       ?FLOC___StartT111+1 
L_Start56:
	MOVF        ?FLOC___StartT111+0, 0 
	MOVWF       FARG_WriteDisplay_D0+0 
	CLRF        FARG_WriteDisplay_D0_L_P+0 
	CLRF        FARG_WriteDisplay_D0_R_P+0 
	CLRF        FARG_WriteDisplay_N0+0 
	CLRF        FARG_WriteDisplay_N1+0 
	CALL        _WriteDisplay+0, 0
L_Start44:
;Nixie.c,398 :: 		}
	GOTO        L_Start39
L_Start40:
;Nixie.c,400 :: 		if (BackLight == 1) BackLightRGB(&Led);
	MOVF        _BackLight+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_Start57
	MOVLW       _Led+0
	MOVWF       FARG_BackLightRGB_ledRGB+0 
	MOVLW       hi_addr(_Led+0)
	MOVWF       FARG_BackLightRGB_ledRGB+1 
	CALL        _BackLightRGB+0, 0
	GOTO        L_Start58
L_Start57:
;Nixie.c,401 :: 		else if (BackLight == 2) BackLightRGB(&Led_Week[Data.week]);
	MOVF        _BackLight+0, 0 
	XORLW       2
	BTFSS       STATUS+0, 2 
	GOTO        L_Start59
	MOVLW       3
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        _Data+6, 0 
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _Led_Week+0
	ADDWF       R0, 0 
	MOVWF       FARG_BackLightRGB_ledRGB+0 
	MOVLW       hi_addr(_Led_Week+0)
	ADDWFC      R1, 0 
	MOVWF       FARG_BackLightRGB_ledRGB+1 
	CALL        _BackLightRGB+0, 0
L_Start59:
L_Start58:
;Nixie.c,403 :: 		}
L_end_Start:
	RETURN      0
; end of _Start

_Setup:

;Nixie.c,409 :: 		void Setup() {
;Nixie.c,411 :: 		ADCON1 = 0x0F;  // Disable  ports A/D
	MOVLW       15
	MOVWF       ADCON1+0 
;Nixie.c,412 :: 		CMCON  |= 7;    // Disable comparators
	MOVLW       7
	IORWF       CMCON+0, 1 
;Nixie.c,413 :: 		RBPU_bit = 0;   // Enable PORTB Pull-Ups
	BCF         RBPU_bit+0, BitPos(RBPU_bit+0) 
;Nixie.c,414 :: 		TRISA = 0x07;   // RA0, RA1, RA2: entradas AN0, AN1, AN2
	MOVLW       7
	MOVWF       TRISA+0 
;Nixie.c,415 :: 		TRISB = 0x3C;   // RB2 entrada interrupção INT2 e RB3 (ENT), RB4(CLK), RB5(DP) entradas ENCODER
	MOVLW       60
	MOVWF       TRISB+0 
;Nixie.c,416 :: 		TRISC = 0x40;   // RC6 entrada sensor microondas RCWL
	MOVLW       64
	MOVWF       TRISC+0 
;Nixie.c,417 :: 		TRISD = 0x00;
	CLRF        TRISD+0 
;Nixie.c,418 :: 		TRISE = 0x00;
	CLRF        TRISE+0 
;Nixie.c,420 :: 		PORTA = 0x00;
	CLRF        PORTA+0 
;Nixie.c,421 :: 		PORTB = 0x00;
	CLRF        PORTB+0 
;Nixie.c,422 :: 		PORTC = 0x00;
	CLRF        PORTC+0 
;Nixie.c,423 :: 		PORTD = 0x00;
	CLRF        PORTD+0 
;Nixie.c,424 :: 		PORTE = 0x00;
	CLRF        PORTE+0 
;Nixie.c,426 :: 		LATA = 0x00;
	CLRF        LATA+0 
;Nixie.c,427 :: 		LATB = 0x00;
	CLRF        LATB+0 
;Nixie.c,428 :: 		LATC = 0x00;
	CLRF        LATC+0 
;Nixie.c,429 :: 		LATD = 0x00;
	CLRF        LATD+0 
;Nixie.c,430 :: 		LATE = 0x00;
	CLRF        LATE+0 
;Nixie.c,432 :: 		GIE_bit = 0;                // Habilita Interrupção Geral (IPEN=1, Habilita Interrupção de Alta Prioridade)
	BCF         GIE_bit+0, BitPos(GIE_bit+0) 
;Nixie.c,433 :: 		PEIE_bit = 0;                // Habilita Interrupção Periféricos (IPEN=1, Habilita Interrupção de Baixa Prioridade)
	BCF         PEIE_bit+0, BitPos(PEIE_bit+0) 
;Nixie.c,437 :: 		T08BIT_bit = 0;    // 16bits
	BCF         T08BIT_bit+0, BitPos(T08BIT_bit+0) 
;Nixie.c,438 :: 		T0CS_bit = 0;      // clock interno
	BCF         T0CS_bit+0, BitPos(T0CS_bit+0) 
;Nixie.c,439 :: 		T0SE_bit = 0;      // L to H
	BCF         T0SE_bit+0, BitPos(T0SE_bit+0) 
;Nixie.c,440 :: 		PSA_bit = 0;       // Com prescaler
	BCF         PSA_bit+0, BitPos(PSA_bit+0) 
;Nixie.c,441 :: 		T0PS2_bit = 1;     // prescaler 1:256
	BSF         T0PS2_bit+0, BitPos(T0PS2_bit+0) 
;Nixie.c,442 :: 		T0PS1_bit = 1;     // prescaler 1:256
	BSF         T0PS1_bit+0, BitPos(T0PS1_bit+0) 
;Nixie.c,443 :: 		T0PS0_bit = 1;     // prescaler 1:256
	BSF         T0PS0_bit+0, BitPos(T0PS0_bit+0) 
;Nixie.c,445 :: 		TMR0H = 0x00;      // 8bits + significativos
	CLRF        TMR0H+0 
;Nixie.c,446 :: 		TMR0L = 0x00;      // 8bits - significativos
	CLRF        TMR0L+0 
;Nixie.c,447 :: 		TMR0IF_bit = 0;    // flag da interrupção timer0
	BCF         TMR0IF_bit+0, BitPos(TMR0IF_bit+0) 
;Nixie.c,448 :: 		TMR0ON_bit = 0;    // timer0 OFF
	BCF         TMR0ON_bit+0, BitPos(TMR0ON_bit+0) 
;Nixie.c,449 :: 		TMR0IE_bit = 1;    // interrupção habilitada
	BSF         TMR0IE_bit+0, BitPos(TMR0IE_bit+0) 
;Nixie.c,450 :: 		TMR0IP_bit = 1;    // interrupção do timer0 com alta prioridade
	BSF         TMR0IP_bit+0, BitPos(TMR0IP_bit+0) 
;Nixie.c,454 :: 		RD16_T1CON_bit = 1; // 16bits
	BSF         RD16_T1CON_bit+0, BitPos(RD16_T1CON_bit+0) 
;Nixie.c,455 :: 		T1RUN_bit     = 0; // clock do dispositivo é derivado de ooutra fonte e não do Timer1
	BCF         T1RUN_bit+0, BitPos(T1RUN_bit+0) 
;Nixie.c,456 :: 		T1OSCEN_bit   = 0; // timer1 oscilador desabilitado
	BCF         T1OSCEN_bit+0, BitPos(T1OSCEN_bit+0) 
;Nixie.c,457 :: 		TMR1CS_bit    = 0; // clock interno
	BCF         TMR1CS_bit+0, BitPos(TMR1CS_bit+0) 
;Nixie.c,458 :: 		T1CKPS1_bit   = 1; // prescaler 1:8
	BSF         T1CKPS1_bit+0, BitPos(T1CKPS1_bit+0) 
;Nixie.c,459 :: 		T1CKPS0_bit   = 1; // prescaler 1:8
	BSF         T1CKPS0_bit+0, BitPos(T1CKPS0_bit+0) 
;Nixie.c,461 :: 		TMR1H         = 0xE2; // 8bits + significativos
	MOVLW       226
	MOVWF       TMR1H+0 
;Nixie.c,462 :: 		TMR1L         = 0xB4; // 8bits - significativos
	MOVLW       180
	MOVWF       TMR1L+0 
;Nixie.c,463 :: 		TMR1IF_bit    = 0; // flag da interrupção timer1
	BCF         TMR1IF_bit+0, BitPos(TMR1IF_bit+0) 
;Nixie.c,464 :: 		TMR1ON_bit    = 1; // timer1 ON
	BSF         TMR1ON_bit+0, BitPos(TMR1ON_bit+0) 
;Nixie.c,465 :: 		TMR1IE_bit    = 1; // interrupção habilitada
	BSF         TMR1IE_bit+0, BitPos(TMR1IE_bit+0) 
;Nixie.c,466 :: 		TMR1IP_bit    = 1; // interrupção do timer1 com alta prioridade
	BSF         TMR1IP_bit+0, BitPos(TMR1IP_bit+0) 
;Nixie.c,470 :: 		INT2IP_bit = 1;            // INT2 External Interrupt Priority bit (High priority)
	BSF         INT2IP_bit+0, BitPos(INT2IP_bit+0) 
;Nixie.c,471 :: 		INTEDG2_bit = 1;           // External Interrupt 2 Edge Select bit (Interrupt on rising edge)/ 1= Inter. na Subida, 0= Inter. na Descida.
	BSF         INTEDG2_bit+0, BitPos(INTEDG2_bit+0) 
;Nixie.c,472 :: 		INT2IF_bit = 0;            // INT2 Interrupt Flag
	BCF         INT2IF_bit+0, BitPos(INT2IF_bit+0) 
;Nixie.c,473 :: 		INT2IE_bit = 1;            // INT2 External Interrupt Enable bit (Enables the INT2 external interrupt)
	BSF         INT2IE_bit+0, BitPos(INT2IE_bit+0) 
;Nixie.c,478 :: 		ADCON0 = 0b00000001;  // CH0 A/D
	MOVLW       1
	MOVWF       ADCON0+0 
;Nixie.c,479 :: 		ADCON1 = 0b00001100;  // VREF+/- Desabilitado, e Analógico de AN0 a AN2
	MOVLW       12
	MOVWF       ADCON1+0 
;Nixie.c,480 :: 		ADCON2 = 0b10001110;  // Justificado a Direita, A/D Aquisição 2TAD, Clock Converção FOSC/64
	MOVLW       142
	MOVWF       ADCON2+0 
;Nixie.c,482 :: 		ADIF_bit = 0;             // Flag de Interrupção de Final de Conversão
	BCF         ADIF_bit+0, BitPos(ADIF_bit+0) 
;Nixie.c,483 :: 		ADIE_bit = 0;             // Desabilita Interrupção por A/D
	BCF         ADIE_bit+0, BitPos(ADIE_bit+0) 
;Nixie.c,488 :: 		RBIE_bit = 1;                  // RB Port Change Interrupt Enable bit
	BSF         RBIE_bit+0, BitPos(RBIE_bit+0) 
;Nixie.c,489 :: 		RBIF_bit = 0;                  // RB Port Change Interrupt Flag bit
	BCF         RBIF_bit+0, BitPos(RBIF_bit+0) 
;Nixie.c,490 :: 		RBIP_bit = 1;                  // RB Port Change Interrupt Priority bit
	BSF         RBIP_bit+0, BitPos(RBIP_bit+0) 
;Nixie.c,493 :: 		IPEN_bit = 0;                // Habilita nível de Prioridade (Alta/Baixa)
	BCF         IPEN_bit+0, BitPos(IPEN_bit+0) 
;Nixie.c,495 :: 		GIE_bit = 1;                // Habilita Interrupção Geral (IPEN=1, Habilita Interrupção de Alta Prioridade)
	BSF         GIE_bit+0, BitPos(GIE_bit+0) 
;Nixie.c,496 :: 		PEIE_bit = 1;               // Habilita Interrupção Periféricos (IPEN=1, Habilita Interrupção de Baixa Prioridade)
	BSF         PEIE_bit+0, BitPos(PEIE_bit+0) 
;Nixie.c,498 :: 		TMR0ON_bit = 1;         // timer0 ON
	BSF         TMR0ON_bit+0, BitPos(TMR0ON_bit+0) 
;Nixie.c,499 :: 		}
L_end_Setup:
	RETURN      0
; end of _Setup

_BEEP_1:

;Nixie.c,505 :: 		void BEEP_1() {
;Nixie.c,509 :: 		for (i=0;i<80;i++) if (ButtonBeep) BEEP2; else BEEP0;
	CLRF        R1 
	CLRF        R2 
L_BEEP_160:
	MOVLW       128
	XORWF       R2, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__BEEP_11082
	MOVLW       80
	SUBWF       R1, 0 
L__BEEP_11082:
	BTFSC       STATUS+0, 0 
	GOTO        L_BEEP_161
	BTFSS       _ButtonBeep+0, BitPos(_ButtonBeep+0) 
	GOTO        L_BEEP_163
	BSF         RC7_bit+0, BitPos(RC7_bit+0) 
	MOVLW       39
	MOVWF       R13, 0
L_BEEP_164:
	DECFSZ      R13, 1, 1
	BRA         L_BEEP_164
	NOP
	NOP
	BCF         RC7_bit+0, BitPos(RC7_bit+0) 
	MOVLW       8
	MOVWF       R12, 0
	MOVLW       201
	MOVWF       R13, 0
L_BEEP_165:
	DECFSZ      R13, 1, 1
	BRA         L_BEEP_165
	DECFSZ      R12, 1, 1
	BRA         L_BEEP_165
	NOP
	NOP
	GOTO        L_BEEP_166
L_BEEP_163:
	MOVLW       8
	MOVWF       R12, 0
	MOVLW       201
	MOVWF       R13, 0
L_BEEP_167:
	DECFSZ      R13, 1, 1
	BRA         L_BEEP_167
	DECFSZ      R12, 1, 1
	BRA         L_BEEP_167
	NOP
	NOP
L_BEEP_166:
	INFSNZ      R1, 1 
	INCF        R2, 1 
	GOTO        L_BEEP_160
L_BEEP_161:
;Nixie.c,511 :: 		}
L_end_BEEP_1:
	RETURN      0
; end of _BEEP_1

_BEEP_2:

;Nixie.c,517 :: 		void BEEP_2() {
;Nixie.c,520 :: 		for (i=0;i<80;i++) if (ButtonBeep) BEEP1; else BEEP0;
	CLRF        R1 
	CLRF        R2 
L_BEEP_268:
	MOVLW       128
	XORWF       R2, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__BEEP_21084
	MOVLW       80
	SUBWF       R1, 0 
L__BEEP_21084:
	BTFSC       STATUS+0, 0 
	GOTO        L_BEEP_269
	BTFSS       _ButtonBeep+0, BitPos(_ButtonBeep+0) 
	GOTO        L_BEEP_271
	BSF         RC7_bit+0, BitPos(RC7_bit+0) 
	MOVLW       39
	MOVWF       R13, 0
L_BEEP_272:
	DECFSZ      R13, 1, 1
	BRA         L_BEEP_272
	NOP
	NOP
	BCF         RC7_bit+0, BitPos(RC7_bit+0) 
	MOVLW       7
	MOVWF       R12, 0
	MOVLW       178
	MOVWF       R13, 0
L_BEEP_273:
	DECFSZ      R13, 1, 1
	BRA         L_BEEP_273
	DECFSZ      R12, 1, 1
	BRA         L_BEEP_273
	NOP
	GOTO        L_BEEP_274
L_BEEP_271:
	MOVLW       8
	MOVWF       R12, 0
	MOVLW       201
	MOVWF       R13, 0
L_BEEP_275:
	DECFSZ      R13, 1, 1
	BRA         L_BEEP_275
	DECFSZ      R12, 1, 1
	BRA         L_BEEP_275
	NOP
	NOP
L_BEEP_274:
	INFSNZ      R1, 1 
	INCF        R2, 1 
	GOTO        L_BEEP_268
L_BEEP_269:
;Nixie.c,521 :: 		Delay_ms(100);
	MOVLW       7
	MOVWF       R11, 0
	MOVLW       23
	MOVWF       R12, 0
	MOVLW       106
	MOVWF       R13, 0
L_BEEP_276:
	DECFSZ      R13, 1, 1
	BRA         L_BEEP_276
	DECFSZ      R12, 1, 1
	BRA         L_BEEP_276
	DECFSZ      R11, 1, 1
	BRA         L_BEEP_276
	NOP
;Nixie.c,522 :: 		for (i=0;i<80;i++) if (ButtonBeep) BEEP1; else BEEP0;
	CLRF        R1 
	CLRF        R2 
L_BEEP_277:
	MOVLW       128
	XORWF       R2, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__BEEP_21085
	MOVLW       80
	SUBWF       R1, 0 
L__BEEP_21085:
	BTFSC       STATUS+0, 0 
	GOTO        L_BEEP_278
	BTFSS       _ButtonBeep+0, BitPos(_ButtonBeep+0) 
	GOTO        L_BEEP_280
	BSF         RC7_bit+0, BitPos(RC7_bit+0) 
	MOVLW       39
	MOVWF       R13, 0
L_BEEP_281:
	DECFSZ      R13, 1, 1
	BRA         L_BEEP_281
	NOP
	NOP
	BCF         RC7_bit+0, BitPos(RC7_bit+0) 
	MOVLW       7
	MOVWF       R12, 0
	MOVLW       178
	MOVWF       R13, 0
L_BEEP_282:
	DECFSZ      R13, 1, 1
	BRA         L_BEEP_282
	DECFSZ      R12, 1, 1
	BRA         L_BEEP_282
	NOP
	GOTO        L_BEEP_283
L_BEEP_280:
	MOVLW       8
	MOVWF       R12, 0
	MOVLW       201
	MOVWF       R13, 0
L_BEEP_284:
	DECFSZ      R13, 1, 1
	BRA         L_BEEP_284
	DECFSZ      R12, 1, 1
	BRA         L_BEEP_284
	NOP
	NOP
L_BEEP_283:
	INFSNZ      R1, 1 
	INCF        R2, 1 
	GOTO        L_BEEP_277
L_BEEP_278:
;Nixie.c,524 :: 		}
L_end_BEEP_2:
	RETURN      0
; end of _BEEP_2

_BEEP_HOUR:

;Nixie.c,530 :: 		void BEEP_HOUR() {
;Nixie.c,533 :: 		for (i=0;i<200;i++) BEEP3;
	CLRF        R1 
	CLRF        R2 
L_BEEP_HOUR85:
	MOVLW       128
	XORWF       R2, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__BEEP_HOUR1087
	MOVLW       200
	SUBWF       R1, 0 
L__BEEP_HOUR1087:
	BTFSC       STATUS+0, 0 
	GOTO        L_BEEP_HOUR86
	BSF         RC7_bit+0, BitPos(RC7_bit+0) 
	MOVLW       39
	MOVWF       R13, 0
L_BEEP_HOUR88:
	DECFSZ      R13, 1, 1
	BRA         L_BEEP_HOUR88
	NOP
	NOP
	BCF         RC7_bit+0, BitPos(RC7_bit+0) 
	MOVLW       10
	MOVWF       R12, 0
	MOVLW       88
	MOVWF       R13, 0
L_BEEP_HOUR89:
	DECFSZ      R13, 1, 1
	BRA         L_BEEP_HOUR89
	DECFSZ      R12, 1, 1
	BRA         L_BEEP_HOUR89
	NOP
	INFSNZ      R1, 1 
	INCF        R2, 1 
	GOTO        L_BEEP_HOUR85
L_BEEP_HOUR86:
;Nixie.c,534 :: 		Delay_ms(150);
	MOVLW       10
	MOVWF       R11, 0
	MOVLW       34
	MOVWF       R12, 0
	MOVLW       161
	MOVWF       R13, 0
L_BEEP_HOUR90:
	DECFSZ      R13, 1, 1
	BRA         L_BEEP_HOUR90
	DECFSZ      R12, 1, 1
	BRA         L_BEEP_HOUR90
	DECFSZ      R11, 1, 1
	BRA         L_BEEP_HOUR90
;Nixie.c,535 :: 		for (i=0;i<200;i++) BEEP3;
	CLRF        R1 
	CLRF        R2 
L_BEEP_HOUR91:
	MOVLW       128
	XORWF       R2, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__BEEP_HOUR1088
	MOVLW       200
	SUBWF       R1, 0 
L__BEEP_HOUR1088:
	BTFSC       STATUS+0, 0 
	GOTO        L_BEEP_HOUR92
	BSF         RC7_bit+0, BitPos(RC7_bit+0) 
	MOVLW       39
	MOVWF       R13, 0
L_BEEP_HOUR94:
	DECFSZ      R13, 1, 1
	BRA         L_BEEP_HOUR94
	NOP
	NOP
	BCF         RC7_bit+0, BitPos(RC7_bit+0) 
	MOVLW       10
	MOVWF       R12, 0
	MOVLW       88
	MOVWF       R13, 0
L_BEEP_HOUR95:
	DECFSZ      R13, 1, 1
	BRA         L_BEEP_HOUR95
	DECFSZ      R12, 1, 1
	BRA         L_BEEP_HOUR95
	NOP
	INFSNZ      R1, 1 
	INCF        R2, 1 
	GOTO        L_BEEP_HOUR91
L_BEEP_HOUR92:
;Nixie.c,537 :: 		}
L_end_BEEP_HOUR:
	RETURN      0
; end of _BEEP_HOUR

_BEEP_ALARM:

;Nixie.c,543 :: 		void BEEP_ALARM() {
;Nixie.c,546 :: 		for (i=0;i<200;i++) BEEP4;
	CLRF        R1 
	CLRF        R2 
L_BEEP_ALARM96:
	MOVLW       128
	XORWF       R2, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__BEEP_ALARM1090
	MOVLW       200
	SUBWF       R1, 0 
L__BEEP_ALARM1090:
	BTFSC       STATUS+0, 0 
	GOTO        L_BEEP_ALARM97
	BSF         RC7_bit+0, BitPos(RC7_bit+0) 
	MOVLW       2
	MOVWF       R12, 0
	MOVLW       141
	MOVWF       R13, 0
L_BEEP_ALARM99:
	DECFSZ      R13, 1, 1
	BRA         L_BEEP_ALARM99
	DECFSZ      R12, 1, 1
	BRA         L_BEEP_ALARM99
	NOP
	NOP
	BCF         RC7_bit+0, BitPos(RC7_bit+0) 
	MOVLW       8
	MOVWF       R12, 0
	MOVLW       1
	MOVWF       R13, 0
L_BEEP_ALARM100:
	DECFSZ      R13, 1, 1
	BRA         L_BEEP_ALARM100
	DECFSZ      R12, 1, 1
	BRA         L_BEEP_ALARM100
	NOP
	NOP
	INFSNZ      R1, 1 
	INCF        R2, 1 
	GOTO        L_BEEP_ALARM96
L_BEEP_ALARM97:
;Nixie.c,547 :: 		Delay_ms(100);
	MOVLW       7
	MOVWF       R11, 0
	MOVLW       23
	MOVWF       R12, 0
	MOVLW       106
	MOVWF       R13, 0
L_BEEP_ALARM101:
	DECFSZ      R13, 1, 1
	BRA         L_BEEP_ALARM101
	DECFSZ      R12, 1, 1
	BRA         L_BEEP_ALARM101
	DECFSZ      R11, 1, 1
	BRA         L_BEEP_ALARM101
	NOP
;Nixie.c,548 :: 		for (i=0;i<200;i++) BEEP4;
	CLRF        R1 
	CLRF        R2 
L_BEEP_ALARM102:
	MOVLW       128
	XORWF       R2, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__BEEP_ALARM1091
	MOVLW       200
	SUBWF       R1, 0 
L__BEEP_ALARM1091:
	BTFSC       STATUS+0, 0 
	GOTO        L_BEEP_ALARM103
	BSF         RC7_bit+0, BitPos(RC7_bit+0) 
	MOVLW       2
	MOVWF       R12, 0
	MOVLW       141
	MOVWF       R13, 0
L_BEEP_ALARM105:
	DECFSZ      R13, 1, 1
	BRA         L_BEEP_ALARM105
	DECFSZ      R12, 1, 1
	BRA         L_BEEP_ALARM105
	NOP
	NOP
	BCF         RC7_bit+0, BitPos(RC7_bit+0) 
	MOVLW       8
	MOVWF       R12, 0
	MOVLW       1
	MOVWF       R13, 0
L_BEEP_ALARM106:
	DECFSZ      R13, 1, 1
	BRA         L_BEEP_ALARM106
	DECFSZ      R12, 1, 1
	BRA         L_BEEP_ALARM106
	NOP
	NOP
	INFSNZ      R1, 1 
	INCF        R2, 1 
	GOTO        L_BEEP_ALARM102
L_BEEP_ALARM103:
;Nixie.c,549 :: 		Delay_ms(100);
	MOVLW       7
	MOVWF       R11, 0
	MOVLW       23
	MOVWF       R12, 0
	MOVLW       106
	MOVWF       R13, 0
L_BEEP_ALARM107:
	DECFSZ      R13, 1, 1
	BRA         L_BEEP_ALARM107
	DECFSZ      R12, 1, 1
	BRA         L_BEEP_ALARM107
	DECFSZ      R11, 1, 1
	BRA         L_BEEP_ALARM107
	NOP
;Nixie.c,550 :: 		for (i=0;i<270;i++) BEEP4;
	CLRF        R1 
	CLRF        R2 
L_BEEP_ALARM108:
	MOVLW       128
	XORWF       R2, 0 
	MOVWF       R0 
	MOVLW       128
	XORLW       1
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__BEEP_ALARM1092
	MOVLW       14
	SUBWF       R1, 0 
L__BEEP_ALARM1092:
	BTFSC       STATUS+0, 0 
	GOTO        L_BEEP_ALARM109
	BSF         RC7_bit+0, BitPos(RC7_bit+0) 
	MOVLW       2
	MOVWF       R12, 0
	MOVLW       141
	MOVWF       R13, 0
L_BEEP_ALARM111:
	DECFSZ      R13, 1, 1
	BRA         L_BEEP_ALARM111
	DECFSZ      R12, 1, 1
	BRA         L_BEEP_ALARM111
	NOP
	NOP
	BCF         RC7_bit+0, BitPos(RC7_bit+0) 
	MOVLW       8
	MOVWF       R12, 0
	MOVLW       1
	MOVWF       R13, 0
L_BEEP_ALARM112:
	DECFSZ      R13, 1, 1
	BRA         L_BEEP_ALARM112
	DECFSZ      R12, 1, 1
	BRA         L_BEEP_ALARM112
	NOP
	NOP
	INFSNZ      R1, 1 
	INCF        R2, 1 
	GOTO        L_BEEP_ALARM108
L_BEEP_ALARM109:
;Nixie.c,552 :: 		}
L_end_BEEP_ALARM:
	RETURN      0
; end of _BEEP_ALARM

_Botao_INC:

;Nixie.c,559 :: 		unsigned char Botao_INC() {
;Nixie.c,561 :: 		if (INC) {
	BTFSS       _INC+0, BitPos(_INC+0) 
	GOTO        L_Botao_INC113
;Nixie.c,562 :: 		BEEP_1();
	CALL        _BEEP_1+0, 0
;Nixie.c,563 :: 		INC = 0;
	BCF         _INC+0, BitPos(_INC+0) 
;Nixie.c,564 :: 		return 1;
	MOVLW       1
	MOVWF       R0 
	GOTO        L_end_Botao_INC
;Nixie.c,565 :: 		}
L_Botao_INC113:
;Nixie.c,567 :: 		return 0;
	CLRF        R0 
;Nixie.c,568 :: 		}
L_end_Botao_INC:
	RETURN      0
; end of _Botao_INC

_Botao_DEC:

;Nixie.c,574 :: 		unsigned char Botao_DEC() {
;Nixie.c,576 :: 		if (DEC) {
	BTFSS       _DEC+0, BitPos(_DEC+0) 
	GOTO        L_Botao_DEC114
;Nixie.c,577 :: 		BEEP_1();
	CALL        _BEEP_1+0, 0
;Nixie.c,578 :: 		DEC = 0;
	BCF         _DEC+0, BitPos(_DEC+0) 
;Nixie.c,579 :: 		return 1;
	MOVLW       1
	MOVWF       R0 
	GOTO        L_end_Botao_DEC
;Nixie.c,580 :: 		}
L_Botao_DEC114:
;Nixie.c,582 :: 		return 0;
	CLRF        R0 
;Nixie.c,583 :: 		}
L_end_Botao_DEC:
	RETURN      0
; end of _Botao_DEC

_Botao_ENT:

;Nixie.c,589 :: 		unsigned char Botao_ENT() {
;Nixie.c,591 :: 		if ( (Button && (!old_Button)) || ((!Button) && old_Button) ){   // testa se a entrada mudou de valor
	BTFSC       RB3_bit+0, BitPos(RB3_bit+0) 
	GOTO        L__Botao_ENT966
	BTFSC       _old_Button+0, BitPos(_old_Button+0) 
	GOTO        L__Botao_ENT966
	GOTO        L__Botao_ENT964
L__Botao_ENT966:
	BTFSS       RB3_bit+0, BitPos(RB3_bit+0) 
	GOTO        L__Botao_ENT965
	BTFSS       _old_Button+0, BitPos(_old_Button+0) 
	GOTO        L__Botao_ENT965
	GOTO        L__Botao_ENT964
L__Botao_ENT965:
	GOTO        L_Botao_ENT121
L__Botao_ENT964:
;Nixie.c,592 :: 		if ( Button && (!old_Button) ) {                        // Se mudou e esta apertado
	BTFSC       RB3_bit+0, BitPos(RB3_bit+0) 
	GOTO        L_Botao_ENT124
	BTFSC       _old_Button+0, BitPos(_old_Button+0) 
	GOTO        L_Botao_ENT124
L__Botao_ENT963:
;Nixie.c,593 :: 		old_Button = Button;
	BTFSC       RB3_bit+0, BitPos(RB3_bit+0) 
	GOTO        L__Botao_ENT1096
	BSF         _old_Button+0, BitPos(_old_Button+0) 
	GOTO        L__Botao_ENT1097
L__Botao_ENT1096:
	BCF         _old_Button+0, BitPos(_old_Button+0) 
L__Botao_ENT1097:
;Nixie.c,594 :: 		BEEP_2();
	CALL        _BEEP_2+0, 0
;Nixie.c,595 :: 		return 1;                                         // Retorna Verdadeiro
	MOVLW       1
	MOVWF       R0 
	GOTO        L_end_Botao_ENT
;Nixie.c,596 :: 		}
L_Botao_ENT124:
;Nixie.c,597 :: 		old_Button = Button;                                  // guarda "novo valor antigo"
	BTFSC       RB3_bit+0, BitPos(RB3_bit+0) 
	GOTO        L__Botao_ENT1098
	BSF         _old_Button+0, BitPos(_old_Button+0) 
	GOTO        L__Botao_ENT1099
L__Botao_ENT1098:
	BCF         _old_Button+0, BitPos(_old_Button+0) 
L__Botao_ENT1099:
;Nixie.c,598 :: 		}
L_Botao_ENT121:
;Nixie.c,599 :: 		return 0;                                               // Se não, retorna Falso
	CLRF        R0 
;Nixie.c,601 :: 		}
L_end_Botao_ENT:
	RETURN      0
; end of _Botao_ENT

_Menu_Show:

;Nixie.c,607 :: 		void Menu_Show() {
;Nixie.c,609 :: 		if (awake) {
	BTFSS       _awake+0, BitPos(_awake+0) 
	GOTO        L_Menu_Show125
;Nixie.c,610 :: 		if (Botao_INC() || Botao_DEC() || Botao_ENT()) awake = 0;
	CALL        _Botao_INC+0, 0
	MOVF        R0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L__Menu_Show971
	CALL        _Botao_DEC+0, 0
	MOVF        R0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L__Menu_Show971
	CALL        _Botao_ENT+0, 0
	MOVF        R0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L__Menu_Show971
	GOTO        L_Menu_Show128
L__Menu_Show971:
	BCF         _awake+0, BitPos(_awake+0) 
L_Menu_Show128:
;Nixie.c,611 :: 		Hour(1);
	MOVLW       1
	MOVWF       FARG_Hour_Point+0 
	CALL        _Hour+0, 0
;Nixie.c,612 :: 		old_Data = Data;
	MOVLW       9
	MOVWF       R0 
	MOVLW       _old_Data+0
	MOVWF       FSR1 
	MOVLW       hi_addr(_old_Data+0)
	MOVWF       FSR1H 
	MOVLW       _Data+0
	MOVWF       FSR0 
	MOVLW       hi_addr(_Data+0)
	MOVWF       FSR0H 
L_Menu_Show129:
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
	DECF        R0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_Show129
;Nixie.c,613 :: 		} else {
	GOTO        L_Menu_Show130
L_Menu_Show125:
;Nixie.c,615 :: 		if (Botao_INC() && ShowMode<2) {ShowMode++; CountShowMode = 0;}
	CALL        _Botao_INC+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Menu_Show133
	MOVLW       2
	SUBWF       _ShowMode+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_Menu_Show133
L__Menu_Show970:
	INCF        _ShowMode+0, 1 
	CLRF        _CountShowMode+0 
	GOTO        L_Menu_Show134
L_Menu_Show133:
;Nixie.c,617 :: 		if (Botao_DEC() && ShowMode>0) {ShowMode--; CountShowMode = 0;}
	CALL        _Botao_DEC+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Menu_Show137
	MOVF        _ShowMode+0, 0 
	SUBLW       0
	BTFSC       STATUS+0, 0 
	GOTO        L_Menu_Show137
L__Menu_Show969:
	DECF        _ShowMode+0, 1 
	CLRF        _CountShowMode+0 
L_Menu_Show137:
L_Menu_Show134:
;Nixie.c,618 :: 		if(Botao_ENT()){ MENU = 11;}
	CALL        _Botao_ENT+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Menu_Show138
	MOVLW       11
	MOVWF       _MENU+0 
	MOVLW       0
	MOVWF       _MENU+1 
L_Menu_Show138:
;Nixie.c,621 :: 		if (ShowMode == 1 && CountShowMode <= 14) Date();
	MOVF        _ShowMode+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_Show141
	MOVF        _CountShowMode+0, 0 
	SUBLW       14
	BTFSS       STATUS+0, 0 
	GOTO        L_Menu_Show141
L__Menu_Show968:
	CALL        _Date+0, 0
	GOTO        L_Menu_Show142
L_Menu_Show141:
;Nixie.c,623 :: 		if (ShowMode == 2 && CountShowMode <= 14) Temp();
	MOVF        _ShowMode+0, 0 
	XORLW       2
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_Show145
	MOVF        _CountShowMode+0, 0 
	SUBLW       14
	BTFSS       STATUS+0, 0 
	GOTO        L_Menu_Show145
L__Menu_Show967:
	CALL        _Temp+0, 0
	GOTO        L_Menu_Show146
L_Menu_Show145:
;Nixie.c,625 :: 		if (EffectMode == 1) Hour(toggle_Point);
	MOVF        _EffectMode+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_Show147
	MOVLW       0
	BTFSC       _toggle_Point+0, BitPos(_toggle_Point+0) 
	MOVLW       1
	MOVWF       FARG_Hour_Point+0 
	CALL        _Hour+0, 0
	GOTO        L_Menu_Show148
L_Menu_Show147:
;Nixie.c,627 :: 		if (EffectMode == 2) Hour_Fading();
	MOVF        _EffectMode+0, 0 
	XORLW       2
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_Show149
	CALL        _Hour_Fading+0, 0
	GOTO        L_Menu_Show150
L_Menu_Show149:
;Nixie.c,629 :: 		if (EffectMode == 3) Hour_FadingFull();
	MOVF        _EffectMode+0, 0 
	XORLW       3
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_Show151
	CALL        _Hour_FadingFull+0, 0
	GOTO        L_Menu_Show152
L_Menu_Show151:
;Nixie.c,631 :: 		if (EffectMode == 4) Hour_Cathode();
	MOVF        _EffectMode+0, 0 
	XORLW       4
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_Show153
	CALL        _Hour_Cathode+0, 0
	GOTO        L_Menu_Show154
L_Menu_Show153:
;Nixie.c,633 :: 		if (EffectMode == 5) Hour_Scroll();
	MOVF        _EffectMode+0, 0 
	XORLW       5
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_Show155
	CALL        _Hour_Scroll+0, 0
L_Menu_Show155:
L_Menu_Show154:
L_Menu_Show152:
L_Menu_Show150:
L_Menu_Show148:
L_Menu_Show146:
L_Menu_Show142:
;Nixie.c,634 :: 		}
L_Menu_Show130:
;Nixie.c,635 :: 		}
L_end_Menu_Show:
	RETURN      0
; end of _Menu_Show

_Menu_Exit:

;Nixie.c,642 :: 		void Menu_Exit() {
;Nixie.c,644 :: 		WriteDisplay(0x00,0,0,0x00,1,0,0x0F,0,0,0x0F,0,0,0x0F,0,0,0x0F,0,0,0,0);
	CLRF        FARG_WriteDisplay_D5+0 
	CLRF        FARG_WriteDisplay_D5_L_P+0 
	CLRF        FARG_WriteDisplay_D5_R_P+0 
	CLRF        FARG_WriteDisplay_D4+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D4_L_P+0 
	CLRF        FARG_WriteDisplay_D4_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D3+0 
	CLRF        FARG_WriteDisplay_D3_L_P+0 
	CLRF        FARG_WriteDisplay_D3_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D2+0 
	CLRF        FARG_WriteDisplay_D2_L_P+0 
	CLRF        FARG_WriteDisplay_D2_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D1+0 
	CLRF        FARG_WriteDisplay_D1_L_P+0 
	CLRF        FARG_WriteDisplay_D1_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D0+0 
	CLRF        FARG_WriteDisplay_D0_L_P+0 
	CLRF        FARG_WriteDisplay_D0_R_P+0 
	CLRF        FARG_WriteDisplay_N0+0 
	CLRF        FARG_WriteDisplay_N1+0 
	CALL        _WriteDisplay+0, 0
;Nixie.c,646 :: 		}
L_end_Menu_Exit:
	RETURN      0
; end of _Menu_Exit

_Menu_TimeFormat:

;Nixie.c,652 :: 		void Menu_TimeFormat() {
;Nixie.c,654 :: 		WriteDisplay(0x01,0,0,0x01,1,0,0x0F,0,0,0x0F,0,0,0x02-Mode12h,0,0,0x04-(2*Mode12h),0,0,0,0);
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D5+0 
	CLRF        FARG_WriteDisplay_D5_L_P+0 
	CLRF        FARG_WriteDisplay_D5_R_P+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D4+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D4_L_P+0 
	CLRF        FARG_WriteDisplay_D4_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D3+0 
	CLRF        FARG_WriteDisplay_D3_L_P+0 
	CLRF        FARG_WriteDisplay_D3_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D2+0 
	CLRF        FARG_WriteDisplay_D2_L_P+0 
	CLRF        FARG_WriteDisplay_D2_R_P+0 
	CLRF        R0 
	BTFSC       _Mode12h+0, BitPos(_Mode12h+0) 
	INCF        R0, 1 
	MOVF        R0, 0 
	SUBLW       2
	MOVWF       FARG_WriteDisplay_D1+0 
	CLRF        FARG_WriteDisplay_D1_L_P+0 
	CLRF        FARG_WriteDisplay_D1_R_P+0 
	CLRF        R2 
	BTFSC       _Mode12h+0, BitPos(_Mode12h+0) 
	INCF        R2, 1 
	MOVF        R2, 0 
	MOVWF       R0 
	RLCF        R0, 1 
	BCF         R0, 0 
	MOVF        R0, 0 
	SUBLW       4
	MOVWF       FARG_WriteDisplay_D0+0 
	CLRF        FARG_WriteDisplay_D0_L_P+0 
	CLRF        FARG_WriteDisplay_D0_R_P+0 
	CLRF        FARG_WriteDisplay_N0+0 
	CLRF        FARG_WriteDisplay_N1+0 
	CALL        _WriteDisplay+0, 0
;Nixie.c,656 :: 		}
L_end_Menu_TimeFormat:
	RETURN      0
; end of _Menu_TimeFormat

_Menu_SetTime:

;Nixie.c,662 :: 		void Menu_SetTime() {
;Nixie.c,664 :: 		WriteDisplay(0x01,0,0,0x02,1,0,0x0F,0,0,0x0F,0,0,0x0F,0,0,0x0F,0,0,toggle_Point,toggle_Point);
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D5+0 
	CLRF        FARG_WriteDisplay_D5_L_P+0 
	CLRF        FARG_WriteDisplay_D5_R_P+0 
	MOVLW       2
	MOVWF       FARG_WriteDisplay_D4+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D4_L_P+0 
	CLRF        FARG_WriteDisplay_D4_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D3+0 
	CLRF        FARG_WriteDisplay_D3_L_P+0 
	CLRF        FARG_WriteDisplay_D3_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D2+0 
	CLRF        FARG_WriteDisplay_D2_L_P+0 
	CLRF        FARG_WriteDisplay_D2_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D1+0 
	CLRF        FARG_WriteDisplay_D1_L_P+0 
	CLRF        FARG_WriteDisplay_D1_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D0+0 
	CLRF        FARG_WriteDisplay_D0_L_P+0 
	CLRF        FARG_WriteDisplay_D0_R_P+0 
	MOVLW       0
	BTFSC       _toggle_Point+0, BitPos(_toggle_Point+0) 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_N0+0 
	MOVLW       0
	BTFSC       _toggle_Point+0, BitPos(_toggle_Point+0) 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_N1+0 
	CALL        _WriteDisplay+0, 0
;Nixie.c,666 :: 		}
L_end_Menu_SetTime:
	RETURN      0
; end of _Menu_SetTime

_Menu_SetDate:

;Nixie.c,672 :: 		void Menu_SetDate() {
;Nixie.c,674 :: 		WriteDisplay(0x02,0,0,0x01,1,0,0x0F,toggle_Point,0,0x0F,0,toggle_Point,0x0F,toggle_Point,0,0x0F,0,toggle_Point,0,0);
	MOVLW       2
	MOVWF       FARG_WriteDisplay_D5+0 
	CLRF        FARG_WriteDisplay_D5_L_P+0 
	CLRF        FARG_WriteDisplay_D5_R_P+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D4+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D4_L_P+0 
	CLRF        FARG_WriteDisplay_D4_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D3+0 
	MOVLW       0
	BTFSC       _toggle_Point+0, BitPos(_toggle_Point+0) 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D3_L_P+0 
	CLRF        FARG_WriteDisplay_D3_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D2+0 
	CLRF        FARG_WriteDisplay_D2_L_P+0 
	MOVLW       0
	BTFSC       _toggle_Point+0, BitPos(_toggle_Point+0) 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D2_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D1+0 
	MOVLW       0
	BTFSC       _toggle_Point+0, BitPos(_toggle_Point+0) 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D1_L_P+0 
	CLRF        FARG_WriteDisplay_D1_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D0+0 
	CLRF        FARG_WriteDisplay_D0_L_P+0 
	MOVLW       0
	BTFSC       _toggle_Point+0, BitPos(_toggle_Point+0) 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D0_R_P+0 
	CLRF        FARG_WriteDisplay_N0+0 
	CLRF        FARG_WriteDisplay_N1+0 
	CALL        _WriteDisplay+0, 0
;Nixie.c,676 :: 		}
L_end_Menu_SetDate:
	RETURN      0
; end of _Menu_SetDate

_Menu_SetWeek:

;Nixie.c,682 :: 		void Menu_SetWeek() {
;Nixie.c,684 :: 		WriteDisplay(0x02,0,0,0x02,1,0,0x0F,0,0,0x0F,0,0,0x0F,0,0,Data.week,0,0,0,0);
	MOVLW       2
	MOVWF       FARG_WriteDisplay_D5+0 
	CLRF        FARG_WriteDisplay_D5_L_P+0 
	CLRF        FARG_WriteDisplay_D5_R_P+0 
	MOVLW       2
	MOVWF       FARG_WriteDisplay_D4+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D4_L_P+0 
	CLRF        FARG_WriteDisplay_D4_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D3+0 
	CLRF        FARG_WriteDisplay_D3_L_P+0 
	CLRF        FARG_WriteDisplay_D3_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D2+0 
	CLRF        FARG_WriteDisplay_D2_L_P+0 
	CLRF        FARG_WriteDisplay_D2_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D1+0 
	CLRF        FARG_WriteDisplay_D1_L_P+0 
	CLRF        FARG_WriteDisplay_D1_R_P+0 
	MOVF        _Data+6, 0 
	MOVWF       FARG_WriteDisplay_D0+0 
	CLRF        FARG_WriteDisplay_D0_L_P+0 
	CLRF        FARG_WriteDisplay_D0_R_P+0 
	CLRF        FARG_WriteDisplay_N0+0 
	CLRF        FARG_WriteDisplay_N1+0 
	CALL        _WriteDisplay+0, 0
;Nixie.c,686 :: 		}
L_end_Menu_SetWeek:
	RETURN      0
; end of _Menu_SetWeek

_Menu_SetBackLight:

;Nixie.c,692 :: 		void Menu_SetBackLight() {
;Nixie.c,694 :: 		WriteDisplay(0x03,0,0,0x01,1,0,0x0F,0,0,0x0F,0,0,0x0F,0,0,BackLight,0,0,0,0);
	MOVLW       3
	MOVWF       FARG_WriteDisplay_D5+0 
	CLRF        FARG_WriteDisplay_D5_L_P+0 
	CLRF        FARG_WriteDisplay_D5_R_P+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D4+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D4_L_P+0 
	CLRF        FARG_WriteDisplay_D4_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D3+0 
	CLRF        FARG_WriteDisplay_D3_L_P+0 
	CLRF        FARG_WriteDisplay_D3_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D2+0 
	CLRF        FARG_WriteDisplay_D2_L_P+0 
	CLRF        FARG_WriteDisplay_D2_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D1+0 
	CLRF        FARG_WriteDisplay_D1_L_P+0 
	CLRF        FARG_WriteDisplay_D1_R_P+0 
	MOVF        _BackLight+0, 0 
	MOVWF       FARG_WriteDisplay_D0+0 
	CLRF        FARG_WriteDisplay_D0_L_P+0 
	CLRF        FARG_WriteDisplay_D0_R_P+0 
	CLRF        FARG_WriteDisplay_N0+0 
	CLRF        FARG_WriteDisplay_N1+0 
	CALL        _WriteDisplay+0, 0
;Nixie.c,695 :: 		}
L_end_Menu_SetBackLight:
	RETURN      0
; end of _Menu_SetBackLight

_Menu_SetR:

;Nixie.c,701 :: 		void Menu_SetR() {
;Nixie.c,703 :: 		SeparaUnidade(Led.r / 2);
	MOVF        _Led+0, 0 
	MOVWF       FARG_SeparaUnidade_Numero+0 
	MOVLW       0
	MOVWF       FARG_SeparaUnidade_Numero+1 
	MOVWF       FARG_SeparaUnidade_Numero+2 
	MOVWF       FARG_SeparaUnidade_Numero+3 
	RRCF        FARG_SeparaUnidade_Numero+0, 1 
	BCF         FARG_SeparaUnidade_Numero+0, 7 
	MOVLW       0
	MOVWF       FARG_SeparaUnidade_Numero+1 
	MOVWF       FARG_SeparaUnidade_Numero+2 
	MOVWF       FARG_SeparaUnidade_Numero+3 
	CALL        _SeparaUnidade+0, 0
;Nixie.c,705 :: 		WriteDisplay(0x03,0,0,0x02,1,0,0x0F,0,0,0x0F,0,0,dezena,0,0,unidade,0,0,0,0);
	MOVLW       3
	MOVWF       FARG_WriteDisplay_D5+0 
	CLRF        FARG_WriteDisplay_D5_L_P+0 
	CLRF        FARG_WriteDisplay_D5_R_P+0 
	MOVLW       2
	MOVWF       FARG_WriteDisplay_D4+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D4_L_P+0 
	CLRF        FARG_WriteDisplay_D4_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D3+0 
	CLRF        FARG_WriteDisplay_D3_L_P+0 
	CLRF        FARG_WriteDisplay_D3_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D2+0 
	CLRF        FARG_WriteDisplay_D2_L_P+0 
	CLRF        FARG_WriteDisplay_D2_R_P+0 
	MOVF        _dezena+0, 0 
	MOVWF       FARG_WriteDisplay_D1+0 
	CLRF        FARG_WriteDisplay_D1_L_P+0 
	CLRF        FARG_WriteDisplay_D1_R_P+0 
	MOVF        _unidade+0, 0 
	MOVWF       FARG_WriteDisplay_D0+0 
	CLRF        FARG_WriteDisplay_D0_L_P+0 
	CLRF        FARG_WriteDisplay_D0_R_P+0 
	CLRF        FARG_WriteDisplay_N0+0 
	CLRF        FARG_WriteDisplay_N1+0 
	CALL        _WriteDisplay+0, 0
;Nixie.c,707 :: 		}
L_end_Menu_SetR:
	RETURN      0
; end of _Menu_SetR

_Menu_SetG:

;Nixie.c,713 :: 		void Menu_SetG() {
;Nixie.c,715 :: 		SeparaUnidade(Led.g / 2);
	MOVF        _Led+2, 0 
	MOVWF       FARG_SeparaUnidade_Numero+0 
	MOVLW       0
	MOVWF       FARG_SeparaUnidade_Numero+1 
	MOVWF       FARG_SeparaUnidade_Numero+2 
	MOVWF       FARG_SeparaUnidade_Numero+3 
	RRCF        FARG_SeparaUnidade_Numero+0, 1 
	BCF         FARG_SeparaUnidade_Numero+0, 7 
	MOVLW       0
	MOVWF       FARG_SeparaUnidade_Numero+1 
	MOVWF       FARG_SeparaUnidade_Numero+2 
	MOVWF       FARG_SeparaUnidade_Numero+3 
	CALL        _SeparaUnidade+0, 0
;Nixie.c,717 :: 		WriteDisplay(0x03,0,0,0x03,1,0,0x0F,0,0,0x0F,0,0,dezena,0,0,unidade,0,0,0,0);
	MOVLW       3
	MOVWF       FARG_WriteDisplay_D5+0 
	CLRF        FARG_WriteDisplay_D5_L_P+0 
	CLRF        FARG_WriteDisplay_D5_R_P+0 
	MOVLW       3
	MOVWF       FARG_WriteDisplay_D4+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D4_L_P+0 
	CLRF        FARG_WriteDisplay_D4_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D3+0 
	CLRF        FARG_WriteDisplay_D3_L_P+0 
	CLRF        FARG_WriteDisplay_D3_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D2+0 
	CLRF        FARG_WriteDisplay_D2_L_P+0 
	CLRF        FARG_WriteDisplay_D2_R_P+0 
	MOVF        _dezena+0, 0 
	MOVWF       FARG_WriteDisplay_D1+0 
	CLRF        FARG_WriteDisplay_D1_L_P+0 
	CLRF        FARG_WriteDisplay_D1_R_P+0 
	MOVF        _unidade+0, 0 
	MOVWF       FARG_WriteDisplay_D0+0 
	CLRF        FARG_WriteDisplay_D0_L_P+0 
	CLRF        FARG_WriteDisplay_D0_R_P+0 
	CLRF        FARG_WriteDisplay_N0+0 
	CLRF        FARG_WriteDisplay_N1+0 
	CALL        _WriteDisplay+0, 0
;Nixie.c,719 :: 		}
L_end_Menu_SetG:
	RETURN      0
; end of _Menu_SetG

_Menu_SetB:

;Nixie.c,725 :: 		void Menu_SetB() {
;Nixie.c,727 :: 		SeparaUnidade(Led.b / 2);
	MOVF        _Led+1, 0 
	MOVWF       FARG_SeparaUnidade_Numero+0 
	MOVLW       0
	MOVWF       FARG_SeparaUnidade_Numero+1 
	MOVWF       FARG_SeparaUnidade_Numero+2 
	MOVWF       FARG_SeparaUnidade_Numero+3 
	RRCF        FARG_SeparaUnidade_Numero+0, 1 
	BCF         FARG_SeparaUnidade_Numero+0, 7 
	MOVLW       0
	MOVWF       FARG_SeparaUnidade_Numero+1 
	MOVWF       FARG_SeparaUnidade_Numero+2 
	MOVWF       FARG_SeparaUnidade_Numero+3 
	CALL        _SeparaUnidade+0, 0
;Nixie.c,729 :: 		WriteDisplay(0x03,0,0,0x04,1,0,0x0F,0,0,0x0F,0,0,dezena,0,0,unidade,0,0,0,0);
	MOVLW       3
	MOVWF       FARG_WriteDisplay_D5+0 
	CLRF        FARG_WriteDisplay_D5_L_P+0 
	CLRF        FARG_WriteDisplay_D5_R_P+0 
	MOVLW       4
	MOVWF       FARG_WriteDisplay_D4+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D4_L_P+0 
	CLRF        FARG_WriteDisplay_D4_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D3+0 
	CLRF        FARG_WriteDisplay_D3_L_P+0 
	CLRF        FARG_WriteDisplay_D3_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D2+0 
	CLRF        FARG_WriteDisplay_D2_L_P+0 
	CLRF        FARG_WriteDisplay_D2_R_P+0 
	MOVF        _dezena+0, 0 
	MOVWF       FARG_WriteDisplay_D1+0 
	CLRF        FARG_WriteDisplay_D1_L_P+0 
	CLRF        FARG_WriteDisplay_D1_R_P+0 
	MOVF        _unidade+0, 0 
	MOVWF       FARG_WriteDisplay_D0+0 
	CLRF        FARG_WriteDisplay_D0_L_P+0 
	CLRF        FARG_WriteDisplay_D0_R_P+0 
	CLRF        FARG_WriteDisplay_N0+0 
	CLRF        FARG_WriteDisplay_N1+0 
	CALL        _WriteDisplay+0, 0
;Nixie.c,731 :: 		}
L_end_Menu_SetB:
	RETURN      0
; end of _Menu_SetB

_Menu_LDR:

;Nixie.c,737 :: 		void Menu_LDR() {
;Nixie.c,739 :: 		WriteDisplay(0x04,0,0,0x01,1,0,0x0F,0,0,0x0F,0,0,0x0F,0,0,(unsigned char)LDR_Auto,0,0,0,0);
	MOVLW       4
	MOVWF       FARG_WriteDisplay_D5+0 
	CLRF        FARG_WriteDisplay_D5_L_P+0 
	CLRF        FARG_WriteDisplay_D5_R_P+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D4+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D4_L_P+0 
	CLRF        FARG_WriteDisplay_D4_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D3+0 
	CLRF        FARG_WriteDisplay_D3_L_P+0 
	CLRF        FARG_WriteDisplay_D3_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D2+0 
	CLRF        FARG_WriteDisplay_D2_L_P+0 
	CLRF        FARG_WriteDisplay_D2_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D1+0 
	CLRF        FARG_WriteDisplay_D1_L_P+0 
	CLRF        FARG_WriteDisplay_D1_R_P+0 
	MOVLW       0
	BTFSC       _LDR_Auto+0, BitPos(_LDR_Auto+0) 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D0+0 
	CLRF        FARG_WriteDisplay_D0_L_P+0 
	CLRF        FARG_WriteDisplay_D0_R_P+0 
	CLRF        FARG_WriteDisplay_N0+0 
	CLRF        FARG_WriteDisplay_N1+0 
	CALL        _WriteDisplay+0, 0
;Nixie.c,741 :: 		}
L_end_Menu_LDR:
	RETURN      0
; end of _Menu_LDR

_Menu_SetBright:

;Nixie.c,747 :: 		void Menu_SetBright() {
;Nixie.c,749 :: 		SeparaUnidade(ACESO);
	MOVF        _ACESO+0, 0 
	MOVWF       FARG_SeparaUnidade_Numero+0 
	MOVLW       0
	MOVWF       FARG_SeparaUnidade_Numero+1 
	MOVWF       FARG_SeparaUnidade_Numero+2 
	MOVWF       FARG_SeparaUnidade_Numero+3 
	CALL        _SeparaUnidade+0, 0
;Nixie.c,751 :: 		WriteDisplay(0x04,0,0,0x02,1,0,0x0F,0,0,0x0F,0,0,dezena,0,0,unidade,0,0,0,0);
	MOVLW       4
	MOVWF       FARG_WriteDisplay_D5+0 
	CLRF        FARG_WriteDisplay_D5_L_P+0 
	CLRF        FARG_WriteDisplay_D5_R_P+0 
	MOVLW       2
	MOVWF       FARG_WriteDisplay_D4+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D4_L_P+0 
	CLRF        FARG_WriteDisplay_D4_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D3+0 
	CLRF        FARG_WriteDisplay_D3_L_P+0 
	CLRF        FARG_WriteDisplay_D3_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D2+0 
	CLRF        FARG_WriteDisplay_D2_L_P+0 
	CLRF        FARG_WriteDisplay_D2_R_P+0 
	MOVF        _dezena+0, 0 
	MOVWF       FARG_WriteDisplay_D1+0 
	CLRF        FARG_WriteDisplay_D1_L_P+0 
	CLRF        FARG_WriteDisplay_D1_R_P+0 
	MOVF        _unidade+0, 0 
	MOVWF       FARG_WriteDisplay_D0+0 
	CLRF        FARG_WriteDisplay_D0_L_P+0 
	CLRF        FARG_WriteDisplay_D0_R_P+0 
	CLRF        FARG_WriteDisplay_N0+0 
	CLRF        FARG_WriteDisplay_N1+0 
	CALL        _WriteDisplay+0, 0
;Nixie.c,753 :: 		}
L_end_Menu_SetBright:
	RETURN      0
; end of _Menu_SetBright

_Menu_Presence:

;Nixie.c,759 :: 		void Menu_Presence() {
;Nixie.c,761 :: 		WriteDisplay(0x05,0,0,0x01,1,0,0x0F,0,0,0x0F,0,0,0x0F,0,0,(unsigned char)Presence,0,0,0,0);
	MOVLW       5
	MOVWF       FARG_WriteDisplay_D5+0 
	CLRF        FARG_WriteDisplay_D5_L_P+0 
	CLRF        FARG_WriteDisplay_D5_R_P+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D4+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D4_L_P+0 
	CLRF        FARG_WriteDisplay_D4_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D3+0 
	CLRF        FARG_WriteDisplay_D3_L_P+0 
	CLRF        FARG_WriteDisplay_D3_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D2+0 
	CLRF        FARG_WriteDisplay_D2_L_P+0 
	CLRF        FARG_WriteDisplay_D2_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D1+0 
	CLRF        FARG_WriteDisplay_D1_L_P+0 
	CLRF        FARG_WriteDisplay_D1_R_P+0 
	MOVLW       0
	BTFSC       _Presence+0, BitPos(_Presence+0) 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D0+0 
	CLRF        FARG_WriteDisplay_D0_L_P+0 
	CLRF        FARG_WriteDisplay_D0_R_P+0 
	CLRF        FARG_WriteDisplay_N0+0 
	CLRF        FARG_WriteDisplay_N1+0 
	CALL        _WriteDisplay+0, 0
;Nixie.c,763 :: 		}
L_end_Menu_Presence:
	RETURN      0
; end of _Menu_Presence

_Menu_TimePresence:

;Nixie.c,769 :: 		void Menu_TimePresence() {
;Nixie.c,771 :: 		SeparaUnidade(PresenceTime);
	MOVF        _PresenceTime+0, 0 
	MOVWF       FARG_SeparaUnidade_Numero+0 
	MOVLW       0
	MOVWF       FARG_SeparaUnidade_Numero+1 
	MOVWF       FARG_SeparaUnidade_Numero+2 
	MOVWF       FARG_SeparaUnidade_Numero+3 
	CALL        _SeparaUnidade+0, 0
;Nixie.c,773 :: 		WriteDisplay(0x05,0,0,0x02,1,0,0x0F,0,0,0x0F,0,0,dezena,0,0,unidade,0,0,0,0);
	MOVLW       5
	MOVWF       FARG_WriteDisplay_D5+0 
	CLRF        FARG_WriteDisplay_D5_L_P+0 
	CLRF        FARG_WriteDisplay_D5_R_P+0 
	MOVLW       2
	MOVWF       FARG_WriteDisplay_D4+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D4_L_P+0 
	CLRF        FARG_WriteDisplay_D4_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D3+0 
	CLRF        FARG_WriteDisplay_D3_L_P+0 
	CLRF        FARG_WriteDisplay_D3_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D2+0 
	CLRF        FARG_WriteDisplay_D2_L_P+0 
	CLRF        FARG_WriteDisplay_D2_R_P+0 
	MOVF        _dezena+0, 0 
	MOVWF       FARG_WriteDisplay_D1+0 
	CLRF        FARG_WriteDisplay_D1_L_P+0 
	CLRF        FARG_WriteDisplay_D1_R_P+0 
	MOVF        _unidade+0, 0 
	MOVWF       FARG_WriteDisplay_D0+0 
	CLRF        FARG_WriteDisplay_D0_L_P+0 
	CLRF        FARG_WriteDisplay_D0_R_P+0 
	CLRF        FARG_WriteDisplay_N0+0 
	CLRF        FARG_WriteDisplay_N1+0 
	CALL        _WriteDisplay+0, 0
;Nixie.c,775 :: 		}
L_end_Menu_TimePresence:
	RETURN      0
; end of _Menu_TimePresence

_Menu_AutoPresence:

;Nixie.c,781 :: 		void Menu_AutoPresence() {
;Nixie.c,783 :: 		WriteDisplay(0x05,0,0,0x03,1,0,0x0F,0,0,0x0F,0,0,0x0F,0,0,(unsigned char)PresenceAuto,0,0,0,0);
	MOVLW       5
	MOVWF       FARG_WriteDisplay_D5+0 
	CLRF        FARG_WriteDisplay_D5_L_P+0 
	CLRF        FARG_WriteDisplay_D5_R_P+0 
	MOVLW       3
	MOVWF       FARG_WriteDisplay_D4+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D4_L_P+0 
	CLRF        FARG_WriteDisplay_D4_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D3+0 
	CLRF        FARG_WriteDisplay_D3_L_P+0 
	CLRF        FARG_WriteDisplay_D3_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D2+0 
	CLRF        FARG_WriteDisplay_D2_L_P+0 
	CLRF        FARG_WriteDisplay_D2_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D1+0 
	CLRF        FARG_WriteDisplay_D1_L_P+0 
	CLRF        FARG_WriteDisplay_D1_R_P+0 
	MOVLW       0
	BTFSC       _PresenceAuto+0, BitPos(_PresenceAuto+0) 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D0+0 
	CLRF        FARG_WriteDisplay_D0_L_P+0 
	CLRF        FARG_WriteDisplay_D0_R_P+0 
	CLRF        FARG_WriteDisplay_N0+0 
	CLRF        FARG_WriteDisplay_N1+0 
	CALL        _WriteDisplay+0, 0
;Nixie.c,785 :: 		}
L_end_Menu_AutoPresence:
	RETURN      0
; end of _Menu_AutoPresence

_Menu_SetDisplayEffect:

;Nixie.c,791 :: 		void Menu_SetDisplayEffect() {
;Nixie.c,793 :: 		WriteDisplay(0x06,0,0,0x01,1,0,0x0F,0,0,0x0F,0,0,0x0F,0,0,EffectMode,0,0,0,0);
	MOVLW       6
	MOVWF       FARG_WriteDisplay_D5+0 
	CLRF        FARG_WriteDisplay_D5_L_P+0 
	CLRF        FARG_WriteDisplay_D5_R_P+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D4+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D4_L_P+0 
	CLRF        FARG_WriteDisplay_D4_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D3+0 
	CLRF        FARG_WriteDisplay_D3_L_P+0 
	CLRF        FARG_WriteDisplay_D3_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D2+0 
	CLRF        FARG_WriteDisplay_D2_L_P+0 
	CLRF        FARG_WriteDisplay_D2_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D1+0 
	CLRF        FARG_WriteDisplay_D1_L_P+0 
	CLRF        FARG_WriteDisplay_D1_R_P+0 
	MOVF        _EffectMode+0, 0 
	MOVWF       FARG_WriteDisplay_D0+0 
	CLRF        FARG_WriteDisplay_D0_L_P+0 
	CLRF        FARG_WriteDisplay_D0_R_P+0 
	CLRF        FARG_WriteDisplay_N0+0 
	CLRF        FARG_WriteDisplay_N1+0 
	CALL        _WriteDisplay+0, 0
;Nixie.c,795 :: 		}
L_end_Menu_SetDisplayEffect:
	RETURN      0
; end of _Menu_SetDisplayEffect

_Menu_CathodePoisoning:

;Nixie.c,801 :: 		void Menu_CathodePoisoning() {
;Nixie.c,803 :: 		WriteDisplay(0x06,0,0,0x02,1,0,0x0F,0,0,0x0F,0,0,0x0F,0,0,(unsigned char)Cathode,0,0,0,0);
	MOVLW       6
	MOVWF       FARG_WriteDisplay_D5+0 
	CLRF        FARG_WriteDisplay_D5_L_P+0 
	CLRF        FARG_WriteDisplay_D5_R_P+0 
	MOVLW       2
	MOVWF       FARG_WriteDisplay_D4+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D4_L_P+0 
	CLRF        FARG_WriteDisplay_D4_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D3+0 
	CLRF        FARG_WriteDisplay_D3_L_P+0 
	CLRF        FARG_WriteDisplay_D3_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D2+0 
	CLRF        FARG_WriteDisplay_D2_L_P+0 
	CLRF        FARG_WriteDisplay_D2_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D1+0 
	CLRF        FARG_WriteDisplay_D1_L_P+0 
	CLRF        FARG_WriteDisplay_D1_R_P+0 
	MOVLW       0
	BTFSC       _Cathode+0, BitPos(_Cathode+0) 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D0+0 
	CLRF        FARG_WriteDisplay_D0_L_P+0 
	CLRF        FARG_WriteDisplay_D0_R_P+0 
	CLRF        FARG_WriteDisplay_N0+0 
	CLRF        FARG_WriteDisplay_N1+0 
	CALL        _WriteDisplay+0, 0
;Nixie.c,805 :: 		}
L_end_Menu_CathodePoisoning:
	RETURN      0
; end of _Menu_CathodePoisoning

_Menu_TimeCathodePoisoning:

;Nixie.c,811 :: 		void Menu_TimeCathodePoisoning() {
;Nixie.c,813 :: 		SeparaUnidade(CathodeTime);
	MOVF        _CathodeTime+0, 0 
	MOVWF       FARG_SeparaUnidade_Numero+0 
	MOVLW       0
	MOVWF       FARG_SeparaUnidade_Numero+1 
	MOVWF       FARG_SeparaUnidade_Numero+2 
	MOVWF       FARG_SeparaUnidade_Numero+3 
	CALL        _SeparaUnidade+0, 0
;Nixie.c,815 :: 		WriteDisplay(0x06,0,0,0x03,1,0,0x0F,0,0,0x0F,0,0,dezena,0,0,unidade,0,0,0,0);
	MOVLW       6
	MOVWF       FARG_WriteDisplay_D5+0 
	CLRF        FARG_WriteDisplay_D5_L_P+0 
	CLRF        FARG_WriteDisplay_D5_R_P+0 
	MOVLW       3
	MOVWF       FARG_WriteDisplay_D4+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D4_L_P+0 
	CLRF        FARG_WriteDisplay_D4_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D3+0 
	CLRF        FARG_WriteDisplay_D3_L_P+0 
	CLRF        FARG_WriteDisplay_D3_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D2+0 
	CLRF        FARG_WriteDisplay_D2_L_P+0 
	CLRF        FARG_WriteDisplay_D2_R_P+0 
	MOVF        _dezena+0, 0 
	MOVWF       FARG_WriteDisplay_D1+0 
	CLRF        FARG_WriteDisplay_D1_L_P+0 
	CLRF        FARG_WriteDisplay_D1_R_P+0 
	MOVF        _unidade+0, 0 
	MOVWF       FARG_WriteDisplay_D0+0 
	CLRF        FARG_WriteDisplay_D0_L_P+0 
	CLRF        FARG_WriteDisplay_D0_R_P+0 
	CLRF        FARG_WriteDisplay_N0+0 
	CLRF        FARG_WriteDisplay_N1+0 
	CALL        _WriteDisplay+0, 0
;Nixie.c,817 :: 		}
L_end_Menu_TimeCathodePoisoning:
	RETURN      0
; end of _Menu_TimeCathodePoisoning

_Menu_SetAutoOFFON:

;Nixie.c,823 :: 		void Menu_SetAutoOFFON() {
;Nixie.c,825 :: 		WriteDisplay(0x07,0,0,0x01,1,0,0x0F,0,0,0x0F,0,0,0x0F,0,0,(unsigned char)AutoOffOn,0,0,0,0);
	MOVLW       7
	MOVWF       FARG_WriteDisplay_D5+0 
	CLRF        FARG_WriteDisplay_D5_L_P+0 
	CLRF        FARG_WriteDisplay_D5_R_P+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D4+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D4_L_P+0 
	CLRF        FARG_WriteDisplay_D4_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D3+0 
	CLRF        FARG_WriteDisplay_D3_L_P+0 
	CLRF        FARG_WriteDisplay_D3_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D2+0 
	CLRF        FARG_WriteDisplay_D2_L_P+0 
	CLRF        FARG_WriteDisplay_D2_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D1+0 
	CLRF        FARG_WriteDisplay_D1_L_P+0 
	CLRF        FARG_WriteDisplay_D1_R_P+0 
	MOVLW       0
	BTFSC       _AutoOffOn+0, BitPos(_AutoOffOn+0) 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D0+0 
	CLRF        FARG_WriteDisplay_D0_L_P+0 
	CLRF        FARG_WriteDisplay_D0_R_P+0 
	CLRF        FARG_WriteDisplay_N0+0 
	CLRF        FARG_WriteDisplay_N1+0 
	CALL        _WriteDisplay+0, 0
;Nixie.c,827 :: 		}
L_end_Menu_SetAutoOFFON:
	RETURN      0
; end of _Menu_SetAutoOFFON

_Menu_SetAutoOFF:

;Nixie.c,833 :: 		void Menu_SetAutoOFF() {
;Nixie.c,835 :: 		WriteDisplay(0x07,0,0,0x02,1,0,(Display_Off_Hour >> 4),Display_Off_PM,0,(Display_Off_Hour & 0x0F),0,0,(Display_Off_Minute >> 4),0,0,(Display_Off_Minute & 0x0F),0,0,1,0);
	MOVLW       7
	MOVWF       FARG_WriteDisplay_D5+0 
	CLRF        FARG_WriteDisplay_D5_L_P+0 
	CLRF        FARG_WriteDisplay_D5_R_P+0 
	MOVLW       2
	MOVWF       FARG_WriteDisplay_D4+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D4_L_P+0 
	CLRF        FARG_WriteDisplay_D4_R_P+0 
	MOVF        _Display_Off_Hour+0, 0 
	MOVWF       FARG_WriteDisplay_D3+0 
	RRCF        FARG_WriteDisplay_D3+0, 1 
	BCF         FARG_WriteDisplay_D3+0, 7 
	RRCF        FARG_WriteDisplay_D3+0, 1 
	BCF         FARG_WriteDisplay_D3+0, 7 
	RRCF        FARG_WriteDisplay_D3+0, 1 
	BCF         FARG_WriteDisplay_D3+0, 7 
	RRCF        FARG_WriteDisplay_D3+0, 1 
	BCF         FARG_WriteDisplay_D3+0, 7 
	MOVF        _Display_Off_PM+0, 0 
	MOVWF       FARG_WriteDisplay_D3_L_P+0 
	CLRF        FARG_WriteDisplay_D3_R_P+0 
	MOVLW       15
	ANDWF       _Display_Off_Hour+0, 0 
	MOVWF       FARG_WriteDisplay_D2+0 
	CLRF        FARG_WriteDisplay_D2_L_P+0 
	CLRF        FARG_WriteDisplay_D2_R_P+0 
	MOVF        _Display_Off_Minute+0, 0 
	MOVWF       FARG_WriteDisplay_D1+0 
	RRCF        FARG_WriteDisplay_D1+0, 1 
	BCF         FARG_WriteDisplay_D1+0, 7 
	RRCF        FARG_WriteDisplay_D1+0, 1 
	BCF         FARG_WriteDisplay_D1+0, 7 
	RRCF        FARG_WriteDisplay_D1+0, 1 
	BCF         FARG_WriteDisplay_D1+0, 7 
	RRCF        FARG_WriteDisplay_D1+0, 1 
	BCF         FARG_WriteDisplay_D1+0, 7 
	CLRF        FARG_WriteDisplay_D1_L_P+0 
	CLRF        FARG_WriteDisplay_D1_R_P+0 
	MOVLW       15
	ANDWF       _Display_Off_Minute+0, 0 
	MOVWF       FARG_WriteDisplay_D0+0 
	CLRF        FARG_WriteDisplay_D0_L_P+0 
	CLRF        FARG_WriteDisplay_D0_R_P+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_N0+0 
	CLRF        FARG_WriteDisplay_N1+0 
	CALL        _WriteDisplay+0, 0
;Nixie.c,837 :: 		}
L_end_Menu_SetAutoOFF:
	RETURN      0
; end of _Menu_SetAutoOFF

_Menu_SetAutoON:

;Nixie.c,843 :: 		void Menu_SetAutoON() {
;Nixie.c,845 :: 		WriteDisplay(0x07,0,0,0x03,1,0,(Display_On_Hour >> 4),Display_On_PM,0,(Display_On_Hour & 0x0F),0,0,(Display_On_Minute >> 4),0,0,(Display_On_Minute & 0x0F),0,0,1,0);
	MOVLW       7
	MOVWF       FARG_WriteDisplay_D5+0 
	CLRF        FARG_WriteDisplay_D5_L_P+0 
	CLRF        FARG_WriteDisplay_D5_R_P+0 
	MOVLW       3
	MOVWF       FARG_WriteDisplay_D4+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D4_L_P+0 
	CLRF        FARG_WriteDisplay_D4_R_P+0 
	MOVF        _Display_On_Hour+0, 0 
	MOVWF       FARG_WriteDisplay_D3+0 
	RRCF        FARG_WriteDisplay_D3+0, 1 
	BCF         FARG_WriteDisplay_D3+0, 7 
	RRCF        FARG_WriteDisplay_D3+0, 1 
	BCF         FARG_WriteDisplay_D3+0, 7 
	RRCF        FARG_WriteDisplay_D3+0, 1 
	BCF         FARG_WriteDisplay_D3+0, 7 
	RRCF        FARG_WriteDisplay_D3+0, 1 
	BCF         FARG_WriteDisplay_D3+0, 7 
	MOVF        _Display_On_PM+0, 0 
	MOVWF       FARG_WriteDisplay_D3_L_P+0 
	CLRF        FARG_WriteDisplay_D3_R_P+0 
	MOVLW       15
	ANDWF       _Display_On_Hour+0, 0 
	MOVWF       FARG_WriteDisplay_D2+0 
	CLRF        FARG_WriteDisplay_D2_L_P+0 
	CLRF        FARG_WriteDisplay_D2_R_P+0 
	MOVF        _Display_On_Minute+0, 0 
	MOVWF       FARG_WriteDisplay_D1+0 
	RRCF        FARG_WriteDisplay_D1+0, 1 
	BCF         FARG_WriteDisplay_D1+0, 7 
	RRCF        FARG_WriteDisplay_D1+0, 1 
	BCF         FARG_WriteDisplay_D1+0, 7 
	RRCF        FARG_WriteDisplay_D1+0, 1 
	BCF         FARG_WriteDisplay_D1+0, 7 
	RRCF        FARG_WriteDisplay_D1+0, 1 
	BCF         FARG_WriteDisplay_D1+0, 7 
	CLRF        FARG_WriteDisplay_D1_L_P+0 
	CLRF        FARG_WriteDisplay_D1_R_P+0 
	MOVLW       15
	ANDWF       _Display_On_Minute+0, 0 
	MOVWF       FARG_WriteDisplay_D0+0 
	CLRF        FARG_WriteDisplay_D0_L_P+0 
	CLRF        FARG_WriteDisplay_D0_R_P+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_N0+0 
	CLRF        FARG_WriteDisplay_N1+0 
	CALL        _WriteDisplay+0, 0
;Nixie.c,847 :: 		}
L_end_Menu_SetAutoON:
	RETURN      0
; end of _Menu_SetAutoON

_Menu_SetAlarm:

;Nixie.c,853 :: 		void Menu_SetAlarm() {
;Nixie.c,855 :: 		WriteDisplay(0x08,0,0,0x01,1,0,0x0F,0,0,0x0F,0,0,0x0F,0,0,(unsigned char)Alarm,0,0,0,0);
	MOVLW       8
	MOVWF       FARG_WriteDisplay_D5+0 
	CLRF        FARG_WriteDisplay_D5_L_P+0 
	CLRF        FARG_WriteDisplay_D5_R_P+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D4+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D4_L_P+0 
	CLRF        FARG_WriteDisplay_D4_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D3+0 
	CLRF        FARG_WriteDisplay_D3_L_P+0 
	CLRF        FARG_WriteDisplay_D3_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D2+0 
	CLRF        FARG_WriteDisplay_D2_L_P+0 
	CLRF        FARG_WriteDisplay_D2_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D1+0 
	CLRF        FARG_WriteDisplay_D1_L_P+0 
	CLRF        FARG_WriteDisplay_D1_R_P+0 
	MOVLW       0
	BTFSC       _Alarm+0, BitPos(_Alarm+0) 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D0+0 
	CLRF        FARG_WriteDisplay_D0_L_P+0 
	CLRF        FARG_WriteDisplay_D0_R_P+0 
	CLRF        FARG_WriteDisplay_N0+0 
	CLRF        FARG_WriteDisplay_N1+0 
	CALL        _WriteDisplay+0, 0
;Nixie.c,857 :: 		}
L_end_Menu_SetAlarm:
	RETURN      0
; end of _Menu_SetAlarm

_Menu_HourAlarm:

;Nixie.c,863 :: 		void Menu_HourAlarm() {
;Nixie.c,865 :: 		WriteDisplay(0x08,0,0,0x02,1,0,(Alarm_Hour >> 4),Alarm_PM,0,(Alarm_Hour & 0x0F),0,0,(Alarm_Minute >> 4),0,0,(Alarm_Minute & 0x0F),0,0,1,0);
	MOVLW       8
	MOVWF       FARG_WriteDisplay_D5+0 
	CLRF        FARG_WriteDisplay_D5_L_P+0 
	CLRF        FARG_WriteDisplay_D5_R_P+0 
	MOVLW       2
	MOVWF       FARG_WriteDisplay_D4+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D4_L_P+0 
	CLRF        FARG_WriteDisplay_D4_R_P+0 
	MOVF        _Alarm_Hour+0, 0 
	MOVWF       FARG_WriteDisplay_D3+0 
	RRCF        FARG_WriteDisplay_D3+0, 1 
	BCF         FARG_WriteDisplay_D3+0, 7 
	RRCF        FARG_WriteDisplay_D3+0, 1 
	BCF         FARG_WriteDisplay_D3+0, 7 
	RRCF        FARG_WriteDisplay_D3+0, 1 
	BCF         FARG_WriteDisplay_D3+0, 7 
	RRCF        FARG_WriteDisplay_D3+0, 1 
	BCF         FARG_WriteDisplay_D3+0, 7 
	MOVF        _Alarm_PM+0, 0 
	MOVWF       FARG_WriteDisplay_D3_L_P+0 
	CLRF        FARG_WriteDisplay_D3_R_P+0 
	MOVLW       15
	ANDWF       _Alarm_Hour+0, 0 
	MOVWF       FARG_WriteDisplay_D2+0 
	CLRF        FARG_WriteDisplay_D2_L_P+0 
	CLRF        FARG_WriteDisplay_D2_R_P+0 
	MOVF        _Alarm_Minute+0, 0 
	MOVWF       FARG_WriteDisplay_D1+0 
	RRCF        FARG_WriteDisplay_D1+0, 1 
	BCF         FARG_WriteDisplay_D1+0, 7 
	RRCF        FARG_WriteDisplay_D1+0, 1 
	BCF         FARG_WriteDisplay_D1+0, 7 
	RRCF        FARG_WriteDisplay_D1+0, 1 
	BCF         FARG_WriteDisplay_D1+0, 7 
	RRCF        FARG_WriteDisplay_D1+0, 1 
	BCF         FARG_WriteDisplay_D1+0, 7 
	CLRF        FARG_WriteDisplay_D1_L_P+0 
	CLRF        FARG_WriteDisplay_D1_R_P+0 
	MOVLW       15
	ANDWF       _Alarm_Minute+0, 0 
	MOVWF       FARG_WriteDisplay_D0+0 
	CLRF        FARG_WriteDisplay_D0_L_P+0 
	CLRF        FARG_WriteDisplay_D0_R_P+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_N0+0 
	CLRF        FARG_WriteDisplay_N1+0 
	CALL        _WriteDisplay+0, 0
;Nixie.c,867 :: 		}
L_end_Menu_HourAlarm:
	RETURN      0
; end of _Menu_HourAlarm

_Menu_HourBeep:

;Nixie.c,873 :: 		void Menu_HourBeep() {
;Nixie.c,875 :: 		WriteDisplay(0x09,0,0,0x01,1,0,0x0F,0,0,0x0F,0,0,0x0F,0,0,(unsigned char)HourBeep,0,0,0,0);
	MOVLW       9
	MOVWF       FARG_WriteDisplay_D5+0 
	CLRF        FARG_WriteDisplay_D5_L_P+0 
	CLRF        FARG_WriteDisplay_D5_R_P+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D4+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D4_L_P+0 
	CLRF        FARG_WriteDisplay_D4_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D3+0 
	CLRF        FARG_WriteDisplay_D3_L_P+0 
	CLRF        FARG_WriteDisplay_D3_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D2+0 
	CLRF        FARG_WriteDisplay_D2_L_P+0 
	CLRF        FARG_WriteDisplay_D2_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D1+0 
	CLRF        FARG_WriteDisplay_D1_L_P+0 
	CLRF        FARG_WriteDisplay_D1_R_P+0 
	MOVLW       0
	BTFSC       _HourBeep+0, BitPos(_HourBeep+0) 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D0+0 
	CLRF        FARG_WriteDisplay_D0_L_P+0 
	CLRF        FARG_WriteDisplay_D0_R_P+0 
	CLRF        FARG_WriteDisplay_N0+0 
	CLRF        FARG_WriteDisplay_N1+0 
	CALL        _WriteDisplay+0, 0
;Nixie.c,877 :: 		}
L_end_Menu_HourBeep:
	RETURN      0
; end of _Menu_HourBeep

_Menu_SecondBeep:

;Nixie.c,883 :: 		void Menu_SecondBeep() {
;Nixie.c,885 :: 		WriteDisplay(0x09,0,0,0x02,1,0,0x0F,0,0,0x0F,0,0,0x0F,0,0,(unsigned char)SecondBeep,0,0,0,0);
	MOVLW       9
	MOVWF       FARG_WriteDisplay_D5+0 
	CLRF        FARG_WriteDisplay_D5_L_P+0 
	CLRF        FARG_WriteDisplay_D5_R_P+0 
	MOVLW       2
	MOVWF       FARG_WriteDisplay_D4+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D4_L_P+0 
	CLRF        FARG_WriteDisplay_D4_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D3+0 
	CLRF        FARG_WriteDisplay_D3_L_P+0 
	CLRF        FARG_WriteDisplay_D3_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D2+0 
	CLRF        FARG_WriteDisplay_D2_L_P+0 
	CLRF        FARG_WriteDisplay_D2_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D1+0 
	CLRF        FARG_WriteDisplay_D1_L_P+0 
	CLRF        FARG_WriteDisplay_D1_R_P+0 
	MOVLW       0
	BTFSC       _SecondBeep+0, BitPos(_SecondBeep+0) 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D0+0 
	CLRF        FARG_WriteDisplay_D0_L_P+0 
	CLRF        FARG_WriteDisplay_D0_R_P+0 
	CLRF        FARG_WriteDisplay_N0+0 
	CLRF        FARG_WriteDisplay_N1+0 
	CALL        _WriteDisplay+0, 0
;Nixie.c,887 :: 		}
L_end_Menu_SecondBeep:
	RETURN      0
; end of _Menu_SecondBeep

_Menu_ButtonBeep:

;Nixie.c,893 :: 		void Menu_ButtonBeep() {
;Nixie.c,895 :: 		WriteDisplay(0x09,0,0,0x03,1,0,0x0F,0,0,0x0F,0,0,0x0F,0,0,(unsigned char)ButtonBeep,0,0,0,0);
	MOVLW       9
	MOVWF       FARG_WriteDisplay_D5+0 
	CLRF        FARG_WriteDisplay_D5_L_P+0 
	CLRF        FARG_WriteDisplay_D5_R_P+0 
	MOVLW       3
	MOVWF       FARG_WriteDisplay_D4+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D4_L_P+0 
	CLRF        FARG_WriteDisplay_D4_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D3+0 
	CLRF        FARG_WriteDisplay_D3_L_P+0 
	CLRF        FARG_WriteDisplay_D3_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D2+0 
	CLRF        FARG_WriteDisplay_D2_L_P+0 
	CLRF        FARG_WriteDisplay_D2_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D1+0 
	CLRF        FARG_WriteDisplay_D1_L_P+0 
	CLRF        FARG_WriteDisplay_D1_R_P+0 
	MOVLW       0
	BTFSC       _ButtonBeep+0, BitPos(_ButtonBeep+0) 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D0+0 
	CLRF        FARG_WriteDisplay_D0_L_P+0 
	CLRF        FARG_WriteDisplay_D0_R_P+0 
	CLRF        FARG_WriteDisplay_N0+0 
	CLRF        FARG_WriteDisplay_N1+0 
	CALL        _WriteDisplay+0, 0
;Nixie.c,897 :: 		}
L_end_Menu_ButtonBeep:
	RETURN      0
; end of _Menu_ButtonBeep

_Menu_AjustTemp:

;Nixie.c,903 :: 		void Menu_AjustTemp() {
;Nixie.c,905 :: 		SeparaUnidade(Temp_Celsius);
	MOVF        _Temp_Celsius+0, 0 
	MOVWF       FARG_SeparaUnidade_Numero+0 
	MOVF        _Temp_Celsius+1, 0 
	MOVWF       FARG_SeparaUnidade_Numero+1 
	MOVLW       0
	MOVWF       FARG_SeparaUnidade_Numero+2 
	MOVWF       FARG_SeparaUnidade_Numero+3 
	CALL        _SeparaUnidade+0, 0
;Nixie.c,907 :: 		WriteDisplay(0x09,0,0,0x04,1,0,0x0F,0,0,0x0F,0,0,centena,0,0,dezena,0,0,0,0);
	MOVLW       9
	MOVWF       FARG_WriteDisplay_D5+0 
	CLRF        FARG_WriteDisplay_D5_L_P+0 
	CLRF        FARG_WriteDisplay_D5_R_P+0 
	MOVLW       4
	MOVWF       FARG_WriteDisplay_D4+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D4_L_P+0 
	CLRF        FARG_WriteDisplay_D4_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D3+0 
	CLRF        FARG_WriteDisplay_D3_L_P+0 
	CLRF        FARG_WriteDisplay_D3_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D2+0 
	CLRF        FARG_WriteDisplay_D2_L_P+0 
	CLRF        FARG_WriteDisplay_D2_R_P+0 
	MOVF        _centena+0, 0 
	MOVWF       FARG_WriteDisplay_D1+0 
	CLRF        FARG_WriteDisplay_D1_L_P+0 
	CLRF        FARG_WriteDisplay_D1_R_P+0 
	MOVF        _dezena+0, 0 
	MOVWF       FARG_WriteDisplay_D0+0 
	CLRF        FARG_WriteDisplay_D0_L_P+0 
	CLRF        FARG_WriteDisplay_D0_R_P+0 
	CLRF        FARG_WriteDisplay_N0+0 
	CLRF        FARG_WriteDisplay_N1+0 
	CALL        _WriteDisplay+0, 0
;Nixie.c,909 :: 		}
L_end_Menu_AjustTemp:
	RETURN      0
; end of _Menu_AjustTemp

_Menu_HighVoltage:

;Nixie.c,915 :: 		void Menu_HighVoltage() {
;Nixie.c,917 :: 		SeparaUnidade(High_Voltage);
	MOVF        _High_Voltage+0, 0 
	MOVWF       FARG_SeparaUnidade_Numero+0 
	MOVF        _High_Voltage+1, 0 
	MOVWF       FARG_SeparaUnidade_Numero+1 
	MOVLW       0
	MOVWF       FARG_SeparaUnidade_Numero+2 
	MOVWF       FARG_SeparaUnidade_Numero+3 
	CALL        _SeparaUnidade+0, 0
;Nixie.c,919 :: 		WriteDisplay(0x09,0,0,0x05,1,0,0x0F,0,0,unidade_m,0,0,centena,0,0,dezena,0,0,0,0);
	MOVLW       9
	MOVWF       FARG_WriteDisplay_D5+0 
	CLRF        FARG_WriteDisplay_D5_L_P+0 
	CLRF        FARG_WriteDisplay_D5_R_P+0 
	MOVLW       5
	MOVWF       FARG_WriteDisplay_D4+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D4_L_P+0 
	CLRF        FARG_WriteDisplay_D4_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D3+0 
	CLRF        FARG_WriteDisplay_D3_L_P+0 
	CLRF        FARG_WriteDisplay_D3_R_P+0 
	MOVF        _unidade_m+0, 0 
	MOVWF       FARG_WriteDisplay_D2+0 
	CLRF        FARG_WriteDisplay_D2_L_P+0 
	CLRF        FARG_WriteDisplay_D2_R_P+0 
	MOVF        _centena+0, 0 
	MOVWF       FARG_WriteDisplay_D1+0 
	CLRF        FARG_WriteDisplay_D1_L_P+0 
	CLRF        FARG_WriteDisplay_D1_R_P+0 
	MOVF        _dezena+0, 0 
	MOVWF       FARG_WriteDisplay_D0+0 
	CLRF        FARG_WriteDisplay_D0_L_P+0 
	CLRF        FARG_WriteDisplay_D0_R_P+0 
	CLRF        FARG_WriteDisplay_N0+0 
	CLRF        FARG_WriteDisplay_N1+0 
	CALL        _WriteDisplay+0, 0
;Nixie.c,921 :: 		}
L_end_Menu_HighVoltage:
	RETURN      0
; end of _Menu_HighVoltage

_Menu_11:

;Nixie.c,932 :: 		void Menu_11() {
;Nixie.c,934 :: 		if (Botao_INC()) Mode12h = 0;
	CALL        _Botao_INC+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Menu_11156
	BCF         _Mode12h+0, BitPos(_Mode12h+0) 
L_Menu_11156:
;Nixie.c,935 :: 		if (Botao_DEC()) Mode12h = 1;
	CALL        _Botao_DEC+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Menu_11157
	BSF         _Mode12h+0, BitPos(_Mode12h+0) 
L_Menu_11157:
;Nixie.c,936 :: 		if (Botao_ENT()) {
	CALL        _Botao_ENT+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Menu_11158
;Nixie.c,938 :: 		if (Data.mode12h && !Mode12h) {
	MOVF        _Data+4, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Menu_11161
	BTFSC       _Mode12h+0, BitPos(_Mode12h+0) 
	GOTO        L_Menu_11161
L__Menu_11973:
;Nixie.c,939 :: 		if (Data.PM) Data.hour = Data.hour == 0x12 ? 0x12 : Dec2Bcd(12 + Bcd2Dec(Data.hour));
	MOVF        _Data+3, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Menu_11162
	MOVF        _Data+2, 0 
	XORLW       18
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_11163
	MOVLW       18
	MOVWF       ?FLOC___Menu_11T204+0 
	GOTO        L_Menu_11164
L_Menu_11163:
	MOVF        _Data+2, 0 
	MOVWF       FARG_Bcd2Dec_bcdnum+0 
	CALL        _Bcd2Dec+0, 0
	MOVF        R0, 0 
	ADDLW       12
	MOVWF       FARG_Dec2Bcd_decnum+0 
	CALL        _Dec2Bcd+0, 0
	MOVF        R0, 0 
	MOVWF       ?FLOC___Menu_11T204+0 
L_Menu_11164:
	MOVF        ?FLOC___Menu_11T204+0, 0 
	MOVWF       _Data+2 
	GOTO        L_Menu_11165
L_Menu_11162:
;Nixie.c,940 :: 		else         Data.hour = Data.hour == 0x12 ? 0x00 : Data.hour;
	MOVF        _Data+2, 0 
	XORLW       18
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_11166
	CLRF        ?FLOC___Menu_11T207+0 
	GOTO        L_Menu_11167
L_Menu_11166:
	MOVF        _Data+2, 0 
	MOVWF       ?FLOC___Menu_11T207+0 
L_Menu_11167:
	MOVF        ?FLOC___Menu_11T207+0, 0 
	MOVWF       _Data+2 
L_Menu_11165:
;Nixie.c,941 :: 		Data.PM = 0;
	CLRF        _Data+3 
;Nixie.c,943 :: 		if (Display_Off_PM) Display_Off_Hour = Display_Off_Hour == 0x12 ? 0x12 : Dec2Bcd(12 + Bcd2Dec(Display_Off_Hour));
	MOVF        _Display_Off_PM+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Menu_11168
	MOVF        _Display_Off_Hour+0, 0 
	XORLW       18
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_11169
	MOVLW       18
	MOVWF       ?FLOC___Menu_11T209+0 
	GOTO        L_Menu_11170
L_Menu_11169:
	MOVF        _Display_Off_Hour+0, 0 
	MOVWF       FARG_Bcd2Dec_bcdnum+0 
	CALL        _Bcd2Dec+0, 0
	MOVF        R0, 0 
	ADDLW       12
	MOVWF       FARG_Dec2Bcd_decnum+0 
	CALL        _Dec2Bcd+0, 0
	MOVF        R0, 0 
	MOVWF       ?FLOC___Menu_11T209+0 
L_Menu_11170:
	MOVF        ?FLOC___Menu_11T209+0, 0 
	MOVWF       _Display_Off_Hour+0 
	GOTO        L_Menu_11171
L_Menu_11168:
;Nixie.c,944 :: 		else                Display_Off_Hour = Display_Off_Hour == 0x12 ? 0x00 : Display_Off_Hour;
	MOVF        _Display_Off_Hour+0, 0 
	XORLW       18
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_11172
	CLRF        ?FLOC___Menu_11T212+0 
	GOTO        L_Menu_11173
L_Menu_11172:
	MOVF        _Display_Off_Hour+0, 0 
	MOVWF       ?FLOC___Menu_11T212+0 
L_Menu_11173:
	MOVF        ?FLOC___Menu_11T212+0, 0 
	MOVWF       _Display_Off_Hour+0 
L_Menu_11171:
;Nixie.c,945 :: 		Display_Off_PM = 0;
	CLRF        _Display_Off_PM+0 
;Nixie.c,947 :: 		if (Display_On_PM) Display_On_Hour = Display_On_Hour == 0x12 ? 0x12 : Dec2Bcd(12 + Bcd2Dec(Display_On_Hour));
	MOVF        _Display_On_PM+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Menu_11174
	MOVF        _Display_On_Hour+0, 0 
	XORLW       18
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_11175
	MOVLW       18
	MOVWF       ?FLOC___Menu_11T214+0 
	GOTO        L_Menu_11176
L_Menu_11175:
	MOVF        _Display_On_Hour+0, 0 
	MOVWF       FARG_Bcd2Dec_bcdnum+0 
	CALL        _Bcd2Dec+0, 0
	MOVF        R0, 0 
	ADDLW       12
	MOVWF       FARG_Dec2Bcd_decnum+0 
	CALL        _Dec2Bcd+0, 0
	MOVF        R0, 0 
	MOVWF       ?FLOC___Menu_11T214+0 
L_Menu_11176:
	MOVF        ?FLOC___Menu_11T214+0, 0 
	MOVWF       _Display_On_Hour+0 
	GOTO        L_Menu_11177
L_Menu_11174:
;Nixie.c,948 :: 		else               Display_On_Hour = Display_On_Hour == 0x12 ? 0x00 : Display_On_Hour;
	MOVF        _Display_On_Hour+0, 0 
	XORLW       18
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_11178
	CLRF        ?FLOC___Menu_11T217+0 
	GOTO        L_Menu_11179
L_Menu_11178:
	MOVF        _Display_On_Hour+0, 0 
	MOVWF       ?FLOC___Menu_11T217+0 
L_Menu_11179:
	MOVF        ?FLOC___Menu_11T217+0, 0 
	MOVWF       _Display_On_Hour+0 
L_Menu_11177:
;Nixie.c,949 :: 		Display_On_PM = 0;
	CLRF        _Display_On_PM+0 
;Nixie.c,951 :: 		if (Alarm_PM) Alarm_Hour = Alarm_Hour == 0x12 ? 0x12 : Dec2Bcd(12 + Bcd2Dec(Alarm_Hour));
	MOVF        _Alarm_PM+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Menu_11180
	MOVF        _Alarm_Hour+0, 0 
	XORLW       18
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_11181
	MOVLW       18
	MOVWF       ?FLOC___Menu_11T219+0 
	GOTO        L_Menu_11182
L_Menu_11181:
	MOVF        _Alarm_Hour+0, 0 
	MOVWF       FARG_Bcd2Dec_bcdnum+0 
	CALL        _Bcd2Dec+0, 0
	MOVF        R0, 0 
	ADDLW       12
	MOVWF       FARG_Dec2Bcd_decnum+0 
	CALL        _Dec2Bcd+0, 0
	MOVF        R0, 0 
	MOVWF       ?FLOC___Menu_11T219+0 
L_Menu_11182:
	MOVF        ?FLOC___Menu_11T219+0, 0 
	MOVWF       _Alarm_Hour+0 
	GOTO        L_Menu_11183
L_Menu_11180:
;Nixie.c,952 :: 		else          Alarm_Hour = Alarm_Hour == 0x12 ? 0x00 : Alarm_Hour;
	MOVF        _Alarm_Hour+0, 0 
	XORLW       18
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_11184
	CLRF        ?FLOC___Menu_11T222+0 
	GOTO        L_Menu_11185
L_Menu_11184:
	MOVF        _Alarm_Hour+0, 0 
	MOVWF       ?FLOC___Menu_11T222+0 
L_Menu_11185:
	MOVF        ?FLOC___Menu_11T222+0, 0 
	MOVWF       _Alarm_Hour+0 
L_Menu_11183:
;Nixie.c,953 :: 		Alarm_PM = 0;
	CLRF        _Alarm_PM+0 
;Nixie.c,955 :: 		} else
	GOTO        L_Menu_11186
L_Menu_11161:
;Nixie.c,956 :: 		if (!Data.mode12h && Mode12h) {
	MOVF        _Data+4, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_11189
	BTFSS       _Mode12h+0, BitPos(_Mode12h+0) 
	GOTO        L_Menu_11189
L__Menu_11972:
;Nixie.c,957 :: 		if (Data.hour >= 0x12) {Data.hour = Data.hour == 0x12 ? 0x12 : Dec2Bcd(Bcd2Dec(Data.hour) - 12); Data.PM = 1;}
	MOVLW       18
	SUBWF       _Data+2, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_Menu_11190
	MOVF        _Data+2, 0 
	XORLW       18
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_11191
	MOVLW       18
	MOVWF       ?FLOC___Menu_11T227+0 
	GOTO        L_Menu_11192
L_Menu_11191:
	MOVF        _Data+2, 0 
	MOVWF       FARG_Bcd2Dec_bcdnum+0 
	CALL        _Bcd2Dec+0, 0
	MOVLW       12
	SUBWF       R0, 0 
	MOVWF       FARG_Dec2Bcd_decnum+0 
	CALL        _Dec2Bcd+0, 0
	MOVF        R0, 0 
	MOVWF       ?FLOC___Menu_11T227+0 
L_Menu_11192:
	MOVF        ?FLOC___Menu_11T227+0, 0 
	MOVWF       _Data+2 
	MOVLW       1
	MOVWF       _Data+3 
	GOTO        L_Menu_11193
L_Menu_11190:
;Nixie.c,958 :: 		else                   {Data.hour = Data.hour == 0x00 ? 0x12 : Data.hour; Data.PM = 0;}
	MOVF        _Data+2, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_11194
	MOVLW       18
	MOVWF       ?FLOC___Menu_11T230+0 
	GOTO        L_Menu_11195
L_Menu_11194:
	MOVF        _Data+2, 0 
	MOVWF       ?FLOC___Menu_11T230+0 
L_Menu_11195:
	MOVF        ?FLOC___Menu_11T230+0, 0 
	MOVWF       _Data+2 
	CLRF        _Data+3 
L_Menu_11193:
;Nixie.c,960 :: 		if (Display_Off_Hour >= 0x12) {Display_Off_Hour = Display_Off_Hour == 0x12 ? 0x12 : Dec2Bcd(Bcd2Dec(Display_Off_Hour) - 12); Display_Off_PM = 1;}
	MOVLW       18
	SUBWF       _Display_Off_Hour+0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_Menu_11196
	MOVF        _Display_Off_Hour+0, 0 
	XORLW       18
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_11197
	MOVLW       18
	MOVWF       ?FLOC___Menu_11T233+0 
	GOTO        L_Menu_11198
L_Menu_11197:
	MOVF        _Display_Off_Hour+0, 0 
	MOVWF       FARG_Bcd2Dec_bcdnum+0 
	CALL        _Bcd2Dec+0, 0
	MOVLW       12
	SUBWF       R0, 0 
	MOVWF       FARG_Dec2Bcd_decnum+0 
	CALL        _Dec2Bcd+0, 0
	MOVF        R0, 0 
	MOVWF       ?FLOC___Menu_11T233+0 
L_Menu_11198:
	MOVF        ?FLOC___Menu_11T233+0, 0 
	MOVWF       _Display_Off_Hour+0 
	MOVLW       1
	MOVWF       _Display_Off_PM+0 
	GOTO        L_Menu_11199
L_Menu_11196:
;Nixie.c,961 :: 		else                          {Display_Off_Hour = Display_Off_Hour == 0x00 ? 0x12 : Display_Off_Hour; Display_Off_PM = 0;}
	MOVF        _Display_Off_Hour+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_11200
	MOVLW       18
	MOVWF       ?FLOC___Menu_11T236+0 
	GOTO        L_Menu_11201
L_Menu_11200:
	MOVF        _Display_Off_Hour+0, 0 
	MOVWF       ?FLOC___Menu_11T236+0 
L_Menu_11201:
	MOVF        ?FLOC___Menu_11T236+0, 0 
	MOVWF       _Display_Off_Hour+0 
	CLRF        _Display_Off_PM+0 
L_Menu_11199:
;Nixie.c,963 :: 		if (Display_On_Hour >= 0x12) {Display_On_Hour = Display_On_Hour == 0x12 ? 0x12 : Dec2Bcd(Bcd2Dec(Display_On_Hour) - 12); Display_On_PM = 1;}
	MOVLW       18
	SUBWF       _Display_On_Hour+0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_Menu_11202
	MOVF        _Display_On_Hour+0, 0 
	XORLW       18
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_11203
	MOVLW       18
	MOVWF       ?FLOC___Menu_11T239+0 
	GOTO        L_Menu_11204
L_Menu_11203:
	MOVF        _Display_On_Hour+0, 0 
	MOVWF       FARG_Bcd2Dec_bcdnum+0 
	CALL        _Bcd2Dec+0, 0
	MOVLW       12
	SUBWF       R0, 0 
	MOVWF       FARG_Dec2Bcd_decnum+0 
	CALL        _Dec2Bcd+0, 0
	MOVF        R0, 0 
	MOVWF       ?FLOC___Menu_11T239+0 
L_Menu_11204:
	MOVF        ?FLOC___Menu_11T239+0, 0 
	MOVWF       _Display_On_Hour+0 
	MOVLW       1
	MOVWF       _Display_On_PM+0 
	GOTO        L_Menu_11205
L_Menu_11202:
;Nixie.c,964 :: 		else                         {Display_On_Hour = Display_On_Hour == 0x00 ? 0x12 : Display_On_Hour; Display_On_PM = 0;}
	MOVF        _Display_On_Hour+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_11206
	MOVLW       18
	MOVWF       ?FLOC___Menu_11T242+0 
	GOTO        L_Menu_11207
L_Menu_11206:
	MOVF        _Display_On_Hour+0, 0 
	MOVWF       ?FLOC___Menu_11T242+0 
L_Menu_11207:
	MOVF        ?FLOC___Menu_11T242+0, 0 
	MOVWF       _Display_On_Hour+0 
	CLRF        _Display_On_PM+0 
L_Menu_11205:
;Nixie.c,966 :: 		if (Alarm_Hour >= 0x12) {Alarm_Hour = Alarm_Hour == 0x12 ? 0x12 : Dec2Bcd(Bcd2Dec(Alarm_Hour) - 12); Alarm_PM = 1;}
	MOVLW       18
	SUBWF       _Alarm_Hour+0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_Menu_11208
	MOVF        _Alarm_Hour+0, 0 
	XORLW       18
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_11209
	MOVLW       18
	MOVWF       ?FLOC___Menu_11T245+0 
	GOTO        L_Menu_11210
L_Menu_11209:
	MOVF        _Alarm_Hour+0, 0 
	MOVWF       FARG_Bcd2Dec_bcdnum+0 
	CALL        _Bcd2Dec+0, 0
	MOVLW       12
	SUBWF       R0, 0 
	MOVWF       FARG_Dec2Bcd_decnum+0 
	CALL        _Dec2Bcd+0, 0
	MOVF        R0, 0 
	MOVWF       ?FLOC___Menu_11T245+0 
L_Menu_11210:
	MOVF        ?FLOC___Menu_11T245+0, 0 
	MOVWF       _Alarm_Hour+0 
	MOVLW       1
	MOVWF       _Alarm_PM+0 
	GOTO        L_Menu_11211
L_Menu_11208:
;Nixie.c,967 :: 		else                    {Alarm_Hour = Alarm_Hour == 0x00 ? 0x12 : Alarm_Hour; Alarm_PM = 0;}
	MOVF        _Alarm_Hour+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_11212
	MOVLW       18
	MOVWF       ?FLOC___Menu_11T248+0 
	GOTO        L_Menu_11213
L_Menu_11212:
	MOVF        _Alarm_Hour+0, 0 
	MOVWF       ?FLOC___Menu_11T248+0 
L_Menu_11213:
	MOVF        ?FLOC___Menu_11T248+0, 0 
	MOVWF       _Alarm_Hour+0 
	CLRF        _Alarm_PM+0 
L_Menu_11211:
;Nixie.c,968 :: 		}
L_Menu_11189:
L_Menu_11186:
;Nixie.c,970 :: 		Data.mode12h = Mode12h;
	MOVLW       0
	BTFSC       _Mode12h+0, BitPos(_Mode12h+0) 
	MOVLW       1
	MOVWF       _Data+4 
;Nixie.c,971 :: 		Write_RTC(Data);
	MOVLW       9
	MOVWF       R0 
	MOVLW       FARG_Write_RTC_Data+0
	MOVWF       FSR1 
	MOVLW       hi_addr(FARG_Write_RTC_Data+0)
	MOVWF       FSR1H 
	MOVLW       _Data+0
	MOVWF       FSR0 
	MOVLW       hi_addr(_Data+0)
	MOVWF       FSR0H 
L_Menu_11214:
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
	DECF        R0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_11214
	CALL        _Write_RTC+0, 0
;Nixie.c,972 :: 		escrever_eeprom(0x00,Mode12h);
	CLRF        FARG_escrever_eeprom_address+0 
	MOVLW       0
	BTFSC       _Mode12h+0, BitPos(_Mode12h+0) 
	MOVLW       1
	MOVWF       FARG_escrever_eeprom_DADO_EEPROM+0 
	CALL        _escrever_eeprom+0, 0
;Nixie.c,974 :: 		escrever_eeprom(0x0F,Display_Off_Hour);
	MOVLW       15
	MOVWF       FARG_escrever_eeprom_address+0 
	MOVF        _Display_Off_Hour+0, 0 
	MOVWF       FARG_escrever_eeprom_DADO_EEPROM+0 
	CALL        _escrever_eeprom+0, 0
;Nixie.c,975 :: 		escrever_eeprom(0x10,Display_Off_Minute);
	MOVLW       16
	MOVWF       FARG_escrever_eeprom_address+0 
	MOVF        _Display_Off_Minute+0, 0 
	MOVWF       FARG_escrever_eeprom_DADO_EEPROM+0 
	CALL        _escrever_eeprom+0, 0
;Nixie.c,976 :: 		escrever_eeprom(0x11,Display_Off_PM);
	MOVLW       17
	MOVWF       FARG_escrever_eeprom_address+0 
	MOVF        _Display_Off_PM+0, 0 
	MOVWF       FARG_escrever_eeprom_DADO_EEPROM+0 
	CALL        _escrever_eeprom+0, 0
;Nixie.c,977 :: 		escrever_eeprom(0x12,Display_On_Hour);
	MOVLW       18
	MOVWF       FARG_escrever_eeprom_address+0 
	MOVF        _Display_On_Hour+0, 0 
	MOVWF       FARG_escrever_eeprom_DADO_EEPROM+0 
	CALL        _escrever_eeprom+0, 0
;Nixie.c,978 :: 		escrever_eeprom(0x13,Display_On_Minute);
	MOVLW       19
	MOVWF       FARG_escrever_eeprom_address+0 
	MOVF        _Display_On_Minute+0, 0 
	MOVWF       FARG_escrever_eeprom_DADO_EEPROM+0 
	CALL        _escrever_eeprom+0, 0
;Nixie.c,979 :: 		escrever_eeprom(0x14,Display_On_PM);
	MOVLW       20
	MOVWF       FARG_escrever_eeprom_address+0 
	MOVF        _Display_On_PM+0, 0 
	MOVWF       FARG_escrever_eeprom_DADO_EEPROM+0 
	CALL        _escrever_eeprom+0, 0
;Nixie.c,981 :: 		escrever_eeprom(0x16,Alarm_Hour);
	MOVLW       22
	MOVWF       FARG_escrever_eeprom_address+0 
	MOVF        _Alarm_Hour+0, 0 
	MOVWF       FARG_escrever_eeprom_DADO_EEPROM+0 
	CALL        _escrever_eeprom+0, 0
;Nixie.c,982 :: 		escrever_eeprom(0x17,Alarm_Minute);
	MOVLW       23
	MOVWF       FARG_escrever_eeprom_address+0 
	MOVF        _Alarm_Minute+0, 0 
	MOVWF       FARG_escrever_eeprom_DADO_EEPROM+0 
	CALL        _escrever_eeprom+0, 0
;Nixie.c,983 :: 		escrever_eeprom(0x18,Alarm_PM);
	MOVLW       24
	MOVWF       FARG_escrever_eeprom_address+0 
	MOVF        _Alarm_PM+0, 0 
	MOVWF       FARG_escrever_eeprom_DADO_EEPROM+0 
	CALL        _escrever_eeprom+0, 0
;Nixie.c,985 :: 		MENU = 11;
	MOVLW       11
	MOVWF       _MENU+0 
	MOVLW       0
	MOVWF       _MENU+1 
;Nixie.c,987 :: 		}
L_Menu_11158:
;Nixie.c,989 :: 		WriteDisplay(0x01,0,0,0x01,1,0,0x0F,0,0,0x0F,0,0,toggle_Set == 1 ? 0x02-Mode12h : 0x0F,0,0,toggle_Set == 1 ? 0x04-(2*Mode12h) : 0x0F,0,0,0,0);
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D5+0 
	CLRF        FARG_WriteDisplay_D5_L_P+0 
	CLRF        FARG_WriteDisplay_D5_R_P+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D4+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D4_L_P+0 
	CLRF        FARG_WriteDisplay_D4_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D3+0 
	CLRF        FARG_WriteDisplay_D3_L_P+0 
	CLRF        FARG_WriteDisplay_D3_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D2+0 
	CLRF        FARG_WriteDisplay_D2_L_P+0 
	CLRF        FARG_WriteDisplay_D2_R_P+0 
	CLRF        R1 
	BTFSC       _toggle_Set+0, BitPos(_toggle_Set+0) 
	INCF        R1, 1 
	MOVF        R1, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_11215
	CLRF        R0 
	BTFSC       _Mode12h+0, BitPos(_Mode12h+0) 
	INCF        R0, 1 
	MOVF        R0, 0 
	SUBLW       2
	MOVWF       ?FLOC___Menu_11T259+0 
	MOVLW       0
	MOVWF       ?FLOC___Menu_11T259+1 
	GOTO        L_Menu_11216
L_Menu_11215:
	MOVLW       15
	MOVWF       ?FLOC___Menu_11T259+0 
	MOVLW       0
	MOVWF       ?FLOC___Menu_11T259+1 
L_Menu_11216:
	MOVF        ?FLOC___Menu_11T259+0, 0 
	MOVWF       FARG_WriteDisplay_D1+0 
	CLRF        FARG_WriteDisplay_D1_L_P+0 
	CLRF        FARG_WriteDisplay_D1_R_P+0 
	CLRF        R1 
	BTFSC       _toggle_Set+0, BitPos(_toggle_Set+0) 
	INCF        R1, 1 
	MOVF        R1, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_11217
	CLRF        R2 
	BTFSC       _Mode12h+0, BitPos(_Mode12h+0) 
	INCF        R2, 1 
	MOVF        R2, 0 
	MOVWF       R0 
	RLCF        R0, 1 
	BCF         R0, 0 
	MOVF        R0, 0 
	SUBLW       4
	MOVWF       ?FLOC___Menu_11T265+0 
	MOVLW       0
	MOVWF       ?FLOC___Menu_11T265+1 
	GOTO        L_Menu_11218
L_Menu_11217:
	MOVLW       15
	MOVWF       ?FLOC___Menu_11T265+0 
	MOVLW       0
	MOVWF       ?FLOC___Menu_11T265+1 
L_Menu_11218:
	MOVF        ?FLOC___Menu_11T265+0, 0 
	MOVWF       FARG_WriteDisplay_D0+0 
	CLRF        FARG_WriteDisplay_D0_L_P+0 
	CLRF        FARG_WriteDisplay_D0_R_P+0 
	CLRF        FARG_WriteDisplay_N0+0 
	CLRF        FARG_WriteDisplay_N1+0 
	CALL        _WriteDisplay+0, 0
;Nixie.c,991 :: 		}
L_end_Menu_11:
	RETURN      0
; end of _Menu_11

_Menu_12_SEG:

;Nixie.c,997 :: 		void Menu_12_SEG() {
;Nixie.c,999 :: 		if (Botao_INC()) {temp_Data.second = Dec2Bcd(Bcd2Dec(temp_Data.second)+1); if (temp_Data.second == 0x60) temp_Data.second = 0x00;}
	CALL        _Botao_INC+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Menu_12_SEG219
	MOVF        _temp_Data+0, 0 
	MOVWF       FARG_Bcd2Dec_bcdnum+0 
	CALL        _Bcd2Dec+0, 0
	MOVF        R0, 0 
	ADDLW       1
	MOVWF       FARG_Dec2Bcd_decnum+0 
	CALL        _Dec2Bcd+0, 0
	MOVF        R0, 0 
	MOVWF       _temp_Data+0 
	MOVF        R0, 0 
	XORLW       96
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_12_SEG220
	CLRF        _temp_Data+0 
L_Menu_12_SEG220:
L_Menu_12_SEG219:
;Nixie.c,1000 :: 		if (Botao_DEC()) {temp_Data.second = Dec2Bcd(Bcd2Dec(temp_Data.second)-1); if (temp_Data.second == Dec2Bcd(-1)) temp_Data.second = 0x59;}
	CALL        _Botao_DEC+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Menu_12_SEG221
	MOVF        _temp_Data+0, 0 
	MOVWF       FARG_Bcd2Dec_bcdnum+0 
	CALL        _Bcd2Dec+0, 0
	DECF        R0, 0 
	MOVWF       FARG_Dec2Bcd_decnum+0 
	CALL        _Dec2Bcd+0, 0
	MOVF        R0, 0 
	MOVWF       _temp_Data+0 
	MOVLW       255
	MOVWF       FARG_Dec2Bcd_decnum+0 
	CALL        _Dec2Bcd+0, 0
	MOVF        _temp_Data+0, 0 
	XORWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_12_SEG222
	MOVLW       89
	MOVWF       _temp_Data+0 
L_Menu_12_SEG222:
L_Menu_12_SEG221:
;Nixie.c,1001 :: 		if (Botao_ENT()) {MENU = 121;}
	CALL        _Botao_ENT+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Menu_12_SEG223
	MOVLW       121
	MOVWF       _MENU+0 
	MOVLW       0
	MOVWF       _MENU+1 
L_Menu_12_SEG223:
;Nixie.c,1003 :: 		WriteDisplay((temp_Data.hour >> 4),temp_Data.PM,0,(temp_Data.hour & 0x0F),0,0,(temp_Data.minute >> 4),0,0,(temp_Data.minute & 0x0F),0,0,toggle_Set == 1 ? (temp_Data.second >> 4) : 0x0F,0,0,toggle_Set == 1 ? (temp_Data.second & 0x0F) : 0x0F,0,0,1,1);
	MOVF        _temp_Data+2, 0 
	MOVWF       FARG_WriteDisplay_D5+0 
	RRCF        FARG_WriteDisplay_D5+0, 1 
	BCF         FARG_WriteDisplay_D5+0, 7 
	RRCF        FARG_WriteDisplay_D5+0, 1 
	BCF         FARG_WriteDisplay_D5+0, 7 
	RRCF        FARG_WriteDisplay_D5+0, 1 
	BCF         FARG_WriteDisplay_D5+0, 7 
	RRCF        FARG_WriteDisplay_D5+0, 1 
	BCF         FARG_WriteDisplay_D5+0, 7 
	MOVF        _temp_Data+3, 0 
	MOVWF       FARG_WriteDisplay_D5_L_P+0 
	CLRF        FARG_WriteDisplay_D5_R_P+0 
	MOVLW       15
	ANDWF       _temp_Data+2, 0 
	MOVWF       FARG_WriteDisplay_D4+0 
	CLRF        FARG_WriteDisplay_D4_L_P+0 
	CLRF        FARG_WriteDisplay_D4_R_P+0 
	MOVF        _temp_Data+1, 0 
	MOVWF       FARG_WriteDisplay_D3+0 
	RRCF        FARG_WriteDisplay_D3+0, 1 
	BCF         FARG_WriteDisplay_D3+0, 7 
	RRCF        FARG_WriteDisplay_D3+0, 1 
	BCF         FARG_WriteDisplay_D3+0, 7 
	RRCF        FARG_WriteDisplay_D3+0, 1 
	BCF         FARG_WriteDisplay_D3+0, 7 
	RRCF        FARG_WriteDisplay_D3+0, 1 
	BCF         FARG_WriteDisplay_D3+0, 7 
	CLRF        FARG_WriteDisplay_D3_L_P+0 
	CLRF        FARG_WriteDisplay_D3_R_P+0 
	MOVLW       15
	ANDWF       _temp_Data+1, 0 
	MOVWF       FARG_WriteDisplay_D2+0 
	CLRF        FARG_WriteDisplay_D2_L_P+0 
	CLRF        FARG_WriteDisplay_D2_R_P+0 
	CLRF        R1 
	BTFSC       _toggle_Set+0, BitPos(_toggle_Set+0) 
	INCF        R1, 1 
	MOVF        R1, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_12_SEG224
	MOVF        _temp_Data+0, 0 
	MOVWF       ?FLOC___Menu_12_SEGT277+0 
	RRCF        ?FLOC___Menu_12_SEGT277+0, 1 
	BCF         ?FLOC___Menu_12_SEGT277+0, 7 
	RRCF        ?FLOC___Menu_12_SEGT277+0, 1 
	BCF         ?FLOC___Menu_12_SEGT277+0, 7 
	RRCF        ?FLOC___Menu_12_SEGT277+0, 1 
	BCF         ?FLOC___Menu_12_SEGT277+0, 7 
	RRCF        ?FLOC___Menu_12_SEGT277+0, 1 
	BCF         ?FLOC___Menu_12_SEGT277+0, 7 
	GOTO        L_Menu_12_SEG225
L_Menu_12_SEG224:
	MOVLW       15
	MOVWF       ?FLOC___Menu_12_SEGT277+0 
L_Menu_12_SEG225:
	MOVF        ?FLOC___Menu_12_SEGT277+0, 0 
	MOVWF       FARG_WriteDisplay_D1+0 
	CLRF        FARG_WriteDisplay_D1_L_P+0 
	CLRF        FARG_WriteDisplay_D1_R_P+0 
	CLRF        R1 
	BTFSC       _toggle_Set+0, BitPos(_toggle_Set+0) 
	INCF        R1, 1 
	MOVF        R1, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_12_SEG226
	MOVLW       15
	ANDWF       _temp_Data+0, 0 
	MOVWF       ?FLOC___Menu_12_SEGT281+0 
	GOTO        L_Menu_12_SEG227
L_Menu_12_SEG226:
	MOVLW       15
	MOVWF       ?FLOC___Menu_12_SEGT281+0 
L_Menu_12_SEG227:
	MOVF        ?FLOC___Menu_12_SEGT281+0, 0 
	MOVWF       FARG_WriteDisplay_D0+0 
	CLRF        FARG_WriteDisplay_D0_L_P+0 
	CLRF        FARG_WriteDisplay_D0_R_P+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_N0+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_N1+0 
	CALL        _WriteDisplay+0, 0
;Nixie.c,1005 :: 		}
L_end_Menu_12_SEG:
	RETURN      0
; end of _Menu_12_SEG

_Menu_12_MIN:

;Nixie.c,1011 :: 		void Menu_12_MIN() {
;Nixie.c,1013 :: 		if (Botao_INC()) {temp_Data.minute = Dec2Bcd(Bcd2Dec(temp_Data.minute)+1); if (temp_Data.minute == 0x60) temp_Data.minute = 0x00;}
	CALL        _Botao_INC+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Menu_12_MIN228
	MOVF        _temp_Data+1, 0 
	MOVWF       FARG_Bcd2Dec_bcdnum+0 
	CALL        _Bcd2Dec+0, 0
	MOVF        R0, 0 
	ADDLW       1
	MOVWF       FARG_Dec2Bcd_decnum+0 
	CALL        _Dec2Bcd+0, 0
	MOVF        R0, 0 
	MOVWF       _temp_Data+1 
	MOVF        R0, 0 
	XORLW       96
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_12_MIN229
	CLRF        _temp_Data+1 
L_Menu_12_MIN229:
L_Menu_12_MIN228:
;Nixie.c,1014 :: 		if (Botao_DEC()) {temp_Data.minute = Dec2Bcd(Bcd2Dec(temp_Data.minute)-1); if (temp_Data.minute == Dec2Bcd(-1)) temp_Data.minute = 0x59;}
	CALL        _Botao_DEC+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Menu_12_MIN230
	MOVF        _temp_Data+1, 0 
	MOVWF       FARG_Bcd2Dec_bcdnum+0 
	CALL        _Bcd2Dec+0, 0
	DECF        R0, 0 
	MOVWF       FARG_Dec2Bcd_decnum+0 
	CALL        _Dec2Bcd+0, 0
	MOVF        R0, 0 
	MOVWF       _temp_Data+1 
	MOVLW       255
	MOVWF       FARG_Dec2Bcd_decnum+0 
	CALL        _Dec2Bcd+0, 0
	MOVF        _temp_Data+1, 0 
	XORWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_12_MIN231
	MOVLW       89
	MOVWF       _temp_Data+1 
L_Menu_12_MIN231:
L_Menu_12_MIN230:
;Nixie.c,1015 :: 		if (Botao_ENT()) {MENU = 122;}
	CALL        _Botao_ENT+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Menu_12_MIN232
	MOVLW       122
	MOVWF       _MENU+0 
	MOVLW       0
	MOVWF       _MENU+1 
L_Menu_12_MIN232:
;Nixie.c,1017 :: 		WriteDisplay((temp_Data.hour >> 4),temp_Data.PM,0,(temp_Data.hour & 0x0F),0,0,toggle_Set == 1 ? (temp_Data.minute >> 4) : 0x0F,0,0,toggle_Set == 1 ? (temp_Data.minute & 0x0F) : 0x0F,0,0,(temp_Data.second >> 4),0,0,(temp_Data.second & 0x0F),0,0,1,1);
	MOVF        _temp_Data+2, 0 
	MOVWF       FARG_WriteDisplay_D5+0 
	RRCF        FARG_WriteDisplay_D5+0, 1 
	BCF         FARG_WriteDisplay_D5+0, 7 
	RRCF        FARG_WriteDisplay_D5+0, 1 
	BCF         FARG_WriteDisplay_D5+0, 7 
	RRCF        FARG_WriteDisplay_D5+0, 1 
	BCF         FARG_WriteDisplay_D5+0, 7 
	RRCF        FARG_WriteDisplay_D5+0, 1 
	BCF         FARG_WriteDisplay_D5+0, 7 
	MOVF        _temp_Data+3, 0 
	MOVWF       FARG_WriteDisplay_D5_L_P+0 
	CLRF        FARG_WriteDisplay_D5_R_P+0 
	MOVLW       15
	ANDWF       _temp_Data+2, 0 
	MOVWF       FARG_WriteDisplay_D4+0 
	CLRF        FARG_WriteDisplay_D4_L_P+0 
	CLRF        FARG_WriteDisplay_D4_R_P+0 
	CLRF        R1 
	BTFSC       _toggle_Set+0, BitPos(_toggle_Set+0) 
	INCF        R1, 1 
	MOVF        R1, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_12_MIN233
	MOVF        _temp_Data+1, 0 
	MOVWF       ?FLOC___Menu_12_MINT291+0 
	RRCF        ?FLOC___Menu_12_MINT291+0, 1 
	BCF         ?FLOC___Menu_12_MINT291+0, 7 
	RRCF        ?FLOC___Menu_12_MINT291+0, 1 
	BCF         ?FLOC___Menu_12_MINT291+0, 7 
	RRCF        ?FLOC___Menu_12_MINT291+0, 1 
	BCF         ?FLOC___Menu_12_MINT291+0, 7 
	RRCF        ?FLOC___Menu_12_MINT291+0, 1 
	BCF         ?FLOC___Menu_12_MINT291+0, 7 
	GOTO        L_Menu_12_MIN234
L_Menu_12_MIN233:
	MOVLW       15
	MOVWF       ?FLOC___Menu_12_MINT291+0 
L_Menu_12_MIN234:
	MOVF        ?FLOC___Menu_12_MINT291+0, 0 
	MOVWF       FARG_WriteDisplay_D3+0 
	CLRF        FARG_WriteDisplay_D3_L_P+0 
	CLRF        FARG_WriteDisplay_D3_R_P+0 
	CLRF        R1 
	BTFSC       _toggle_Set+0, BitPos(_toggle_Set+0) 
	INCF        R1, 1 
	MOVF        R1, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_12_MIN235
	MOVLW       15
	ANDWF       _temp_Data+1, 0 
	MOVWF       ?FLOC___Menu_12_MINT295+0 
	GOTO        L_Menu_12_MIN236
L_Menu_12_MIN235:
	MOVLW       15
	MOVWF       ?FLOC___Menu_12_MINT295+0 
L_Menu_12_MIN236:
	MOVF        ?FLOC___Menu_12_MINT295+0, 0 
	MOVWF       FARG_WriteDisplay_D2+0 
	CLRF        FARG_WriteDisplay_D2_L_P+0 
	CLRF        FARG_WriteDisplay_D2_R_P+0 
	MOVF        _temp_Data+0, 0 
	MOVWF       FARG_WriteDisplay_D1+0 
	RRCF        FARG_WriteDisplay_D1+0, 1 
	BCF         FARG_WriteDisplay_D1+0, 7 
	RRCF        FARG_WriteDisplay_D1+0, 1 
	BCF         FARG_WriteDisplay_D1+0, 7 
	RRCF        FARG_WriteDisplay_D1+0, 1 
	BCF         FARG_WriteDisplay_D1+0, 7 
	RRCF        FARG_WriteDisplay_D1+0, 1 
	BCF         FARG_WriteDisplay_D1+0, 7 
	CLRF        FARG_WriteDisplay_D1_L_P+0 
	CLRF        FARG_WriteDisplay_D1_R_P+0 
	MOVLW       15
	ANDWF       _temp_Data+0, 0 
	MOVWF       FARG_WriteDisplay_D0+0 
	CLRF        FARG_WriteDisplay_D0_L_P+0 
	CLRF        FARG_WriteDisplay_D0_R_P+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_N0+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_N1+0 
	CALL        _WriteDisplay+0, 0
;Nixie.c,1019 :: 		}
L_end_Menu_12_MIN:
	RETURN      0
; end of _Menu_12_MIN

_Menu_12_HOUR:

;Nixie.c,1025 :: 		void Menu_12_HOUR() {
;Nixie.c,1027 :: 		if (Mode12h) {
	BTFSS       _Mode12h+0, BitPos(_Mode12h+0) 
	GOTO        L_Menu_12_HOUR237
;Nixie.c,1028 :: 		if (Botao_INC()) {temp_Data.hour = Dec2Bcd(Bcd2Dec(temp_Data.hour)+1); if (temp_Data.hour == 0x12) temp_Data.PM = !temp_Data.PM; if (temp_Data.hour == 0x13) temp_Data.hour = 0x01;}
	CALL        _Botao_INC+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Menu_12_HOUR238
	MOVF        _temp_Data+2, 0 
	MOVWF       FARG_Bcd2Dec_bcdnum+0 
	CALL        _Bcd2Dec+0, 0
	MOVF        R0, 0 
	ADDLW       1
	MOVWF       FARG_Dec2Bcd_decnum+0 
	CALL        _Dec2Bcd+0, 0
	MOVF        R0, 0 
	MOVWF       _temp_Data+2 
	MOVF        R0, 0 
	XORLW       18
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_12_HOUR239
	MOVF        _temp_Data+3, 1 
	MOVLW       1
	BTFSS       STATUS+0, 2 
	MOVLW       0
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       _temp_Data+3 
L_Menu_12_HOUR239:
	MOVF        _temp_Data+2, 0 
	XORLW       19
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_12_HOUR240
	MOVLW       1
	MOVWF       _temp_Data+2 
L_Menu_12_HOUR240:
L_Menu_12_HOUR238:
;Nixie.c,1029 :: 		if (Botao_DEC()) {temp_Data.hour = Dec2Bcd(Bcd2Dec(temp_Data.hour)-1); if (temp_Data.hour == 0x11) temp_Data.PM = !temp_Data.PM; if (temp_Data.hour == 0x00) temp_Data.hour = 0x12;}
	CALL        _Botao_DEC+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Menu_12_HOUR241
	MOVF        _temp_Data+2, 0 
	MOVWF       FARG_Bcd2Dec_bcdnum+0 
	CALL        _Bcd2Dec+0, 0
	DECF        R0, 0 
	MOVWF       FARG_Dec2Bcd_decnum+0 
	CALL        _Dec2Bcd+0, 0
	MOVF        R0, 0 
	MOVWF       _temp_Data+2 
	MOVF        R0, 0 
	XORLW       17
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_12_HOUR242
	MOVF        _temp_Data+3, 1 
	MOVLW       1
	BTFSS       STATUS+0, 2 
	MOVLW       0
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       _temp_Data+3 
L_Menu_12_HOUR242:
	MOVF        _temp_Data+2, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_12_HOUR243
	MOVLW       18
	MOVWF       _temp_Data+2 
L_Menu_12_HOUR243:
L_Menu_12_HOUR241:
;Nixie.c,1031 :: 		} else {
	GOTO        L_Menu_12_HOUR244
L_Menu_12_HOUR237:
;Nixie.c,1032 :: 		if (Botao_INC()) {temp_Data.hour = Dec2Bcd(Bcd2Dec(temp_Data.hour)+1); if (temp_Data.hour == 0x24) temp_Data.hour = 0x00;}
	CALL        _Botao_INC+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Menu_12_HOUR245
	MOVF        _temp_Data+2, 0 
	MOVWF       FARG_Bcd2Dec_bcdnum+0 
	CALL        _Bcd2Dec+0, 0
	MOVF        R0, 0 
	ADDLW       1
	MOVWF       FARG_Dec2Bcd_decnum+0 
	CALL        _Dec2Bcd+0, 0
	MOVF        R0, 0 
	MOVWF       _temp_Data+2 
	MOVF        R0, 0 
	XORLW       36
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_12_HOUR246
	CLRF        _temp_Data+2 
L_Menu_12_HOUR246:
L_Menu_12_HOUR245:
;Nixie.c,1033 :: 		if (Botao_DEC()) {temp_Data.hour = Dec2Bcd(Bcd2Dec(temp_Data.hour)-1); if (temp_Data.hour == Dec2Bcd(-1)) temp_Data.hour = 0x23;}
	CALL        _Botao_DEC+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Menu_12_HOUR247
	MOVF        _temp_Data+2, 0 
	MOVWF       FARG_Bcd2Dec_bcdnum+0 
	CALL        _Bcd2Dec+0, 0
	DECF        R0, 0 
	MOVWF       FARG_Dec2Bcd_decnum+0 
	CALL        _Dec2Bcd+0, 0
	MOVF        R0, 0 
	MOVWF       _temp_Data+2 
	MOVLW       255
	MOVWF       FARG_Dec2Bcd_decnum+0 
	CALL        _Dec2Bcd+0, 0
	MOVF        _temp_Data+2, 0 
	XORWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_12_HOUR248
	MOVLW       35
	MOVWF       _temp_Data+2 
L_Menu_12_HOUR248:
L_Menu_12_HOUR247:
;Nixie.c,1034 :: 		}
L_Menu_12_HOUR244:
;Nixie.c,1035 :: 		if (Botao_ENT()) {Data.hour = temp_Data.hour; Data.minute = temp_Data.minute; Data.second = temp_Data.second; Data.PM = temp_Data.PM; Write_RTC(Data); MENU = 12;}
	CALL        _Botao_ENT+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Menu_12_HOUR249
	MOVF        _temp_Data+2, 0 
	MOVWF       _Data+2 
	MOVF        _temp_Data+1, 0 
	MOVWF       _Data+1 
	MOVF        _temp_Data+0, 0 
	MOVWF       _Data+0 
	MOVF        _temp_Data+3, 0 
	MOVWF       _Data+3 
	MOVLW       9
	MOVWF       R0 
	MOVLW       FARG_Write_RTC_Data+0
	MOVWF       FSR1 
	MOVLW       hi_addr(FARG_Write_RTC_Data+0)
	MOVWF       FSR1H 
	MOVLW       _Data+0
	MOVWF       FSR0 
	MOVLW       hi_addr(_Data+0)
	MOVWF       FSR0H 
L_Menu_12_HOUR250:
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
	DECF        R0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_12_HOUR250
	CALL        _Write_RTC+0, 0
	MOVLW       12
	MOVWF       _MENU+0 
	MOVLW       0
	MOVWF       _MENU+1 
L_Menu_12_HOUR249:
;Nixie.c,1037 :: 		WriteDisplay(toggle_Set == 1 ? (temp_Data.hour >> 4) : 0x0F,toggle_Set == 1 ? temp_Data.PM : 0,0,toggle_Set == 1 ? (temp_Data.hour & 0x0F) : 0x0F,0,0,(temp_Data.minute >> 4),0,0,(temp_Data.minute & 0x0F),0,0,(temp_Data.second >> 4),0,0,(temp_Data.second & 0x0F),0,0,1,1);
	CLRF        R1 
	BTFSC       _toggle_Set+0, BitPos(_toggle_Set+0) 
	INCF        R1, 1 
	MOVF        R1, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_12_HOUR251
	MOVF        _temp_Data+2, 0 
	MOVWF       ?FLOC___Menu_12_HOURT319+0 
	RRCF        ?FLOC___Menu_12_HOURT319+0, 1 
	BCF         ?FLOC___Menu_12_HOURT319+0, 7 
	RRCF        ?FLOC___Menu_12_HOURT319+0, 1 
	BCF         ?FLOC___Menu_12_HOURT319+0, 7 
	RRCF        ?FLOC___Menu_12_HOURT319+0, 1 
	BCF         ?FLOC___Menu_12_HOURT319+0, 7 
	RRCF        ?FLOC___Menu_12_HOURT319+0, 1 
	BCF         ?FLOC___Menu_12_HOURT319+0, 7 
	GOTO        L_Menu_12_HOUR252
L_Menu_12_HOUR251:
	MOVLW       15
	MOVWF       ?FLOC___Menu_12_HOURT319+0 
L_Menu_12_HOUR252:
	MOVF        ?FLOC___Menu_12_HOURT319+0, 0 
	MOVWF       FARG_WriteDisplay_D5+0 
	CLRF        R1 
	BTFSC       _toggle_Set+0, BitPos(_toggle_Set+0) 
	INCF        R1, 1 
	MOVF        R1, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_12_HOUR253
	MOVF        _temp_Data+3, 0 
	MOVWF       ?FLOC___Menu_12_HOURT322+0 
	GOTO        L_Menu_12_HOUR254
L_Menu_12_HOUR253:
	CLRF        ?FLOC___Menu_12_HOURT322+0 
L_Menu_12_HOUR254:
	MOVF        ?FLOC___Menu_12_HOURT322+0, 0 
	MOVWF       FARG_WriteDisplay_D5_L_P+0 
	CLRF        FARG_WriteDisplay_D5_R_P+0 
	CLRF        R1 
	BTFSC       _toggle_Set+0, BitPos(_toggle_Set+0) 
	INCF        R1, 1 
	MOVF        R1, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_12_HOUR255
	MOVLW       15
	ANDWF       _temp_Data+2, 0 
	MOVWF       ?FLOC___Menu_12_HOURT326+0 
	GOTO        L_Menu_12_HOUR256
L_Menu_12_HOUR255:
	MOVLW       15
	MOVWF       ?FLOC___Menu_12_HOURT326+0 
L_Menu_12_HOUR256:
	MOVF        ?FLOC___Menu_12_HOURT326+0, 0 
	MOVWF       FARG_WriteDisplay_D4+0 
	CLRF        FARG_WriteDisplay_D4_L_P+0 
	CLRF        FARG_WriteDisplay_D4_R_P+0 
	MOVF        _temp_Data+1, 0 
	MOVWF       FARG_WriteDisplay_D3+0 
	RRCF        FARG_WriteDisplay_D3+0, 1 
	BCF         FARG_WriteDisplay_D3+0, 7 
	RRCF        FARG_WriteDisplay_D3+0, 1 
	BCF         FARG_WriteDisplay_D3+0, 7 
	RRCF        FARG_WriteDisplay_D3+0, 1 
	BCF         FARG_WriteDisplay_D3+0, 7 
	RRCF        FARG_WriteDisplay_D3+0, 1 
	BCF         FARG_WriteDisplay_D3+0, 7 
	CLRF        FARG_WriteDisplay_D3_L_P+0 
	CLRF        FARG_WriteDisplay_D3_R_P+0 
	MOVLW       15
	ANDWF       _temp_Data+1, 0 
	MOVWF       FARG_WriteDisplay_D2+0 
	CLRF        FARG_WriteDisplay_D2_L_P+0 
	CLRF        FARG_WriteDisplay_D2_R_P+0 
	MOVF        _temp_Data+0, 0 
	MOVWF       FARG_WriteDisplay_D1+0 
	RRCF        FARG_WriteDisplay_D1+0, 1 
	BCF         FARG_WriteDisplay_D1+0, 7 
	RRCF        FARG_WriteDisplay_D1+0, 1 
	BCF         FARG_WriteDisplay_D1+0, 7 
	RRCF        FARG_WriteDisplay_D1+0, 1 
	BCF         FARG_WriteDisplay_D1+0, 7 
	RRCF        FARG_WriteDisplay_D1+0, 1 
	BCF         FARG_WriteDisplay_D1+0, 7 
	CLRF        FARG_WriteDisplay_D1_L_P+0 
	CLRF        FARG_WriteDisplay_D1_R_P+0 
	MOVLW       15
	ANDWF       _temp_Data+0, 0 
	MOVWF       FARG_WriteDisplay_D0+0 
	CLRF        FARG_WriteDisplay_D0_L_P+0 
	CLRF        FARG_WriteDisplay_D0_R_P+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_N0+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_N1+0 
	CALL        _WriteDisplay+0, 0
;Nixie.c,1039 :: 		}
L_end_Menu_12_HOUR:
	RETURN      0
; end of _Menu_12_HOUR

_Menu_21_DAY:

;Nixie.c,1045 :: 		void Menu_21_DAY() {
;Nixie.c,1047 :: 		if (Botao_INC()) {temp_Data.day = Dec2Bcd(Bcd2Dec(temp_Data.day)+1); if (temp_Data.day == 0x32) temp_Data.day = 0x01;}
	CALL        _Botao_INC+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Menu_21_DAY257
	MOVF        _temp_Data+5, 0 
	MOVWF       FARG_Bcd2Dec_bcdnum+0 
	CALL        _Bcd2Dec+0, 0
	MOVF        R0, 0 
	ADDLW       1
	MOVWF       FARG_Dec2Bcd_decnum+0 
	CALL        _Dec2Bcd+0, 0
	MOVF        R0, 0 
	MOVWF       _temp_Data+5 
	MOVF        R0, 0 
	XORLW       50
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_21_DAY258
	MOVLW       1
	MOVWF       _temp_Data+5 
L_Menu_21_DAY258:
L_Menu_21_DAY257:
;Nixie.c,1048 :: 		if (Botao_DEC()) {temp_Data.day = Dec2Bcd(Bcd2Dec(temp_Data.day)-1); if (temp_Data.day == 0x00) temp_Data.day = 0x31;}
	CALL        _Botao_DEC+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Menu_21_DAY259
	MOVF        _temp_Data+5, 0 
	MOVWF       FARG_Bcd2Dec_bcdnum+0 
	CALL        _Bcd2Dec+0, 0
	DECF        R0, 0 
	MOVWF       FARG_Dec2Bcd_decnum+0 
	CALL        _Dec2Bcd+0, 0
	MOVF        R0, 0 
	MOVWF       _temp_Data+5 
	MOVF        R0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_21_DAY260
	MOVLW       49
	MOVWF       _temp_Data+5 
L_Menu_21_DAY260:
L_Menu_21_DAY259:
;Nixie.c,1049 :: 		if (Botao_ENT()) {MENU = 211;}
	CALL        _Botao_ENT+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Menu_21_DAY261
	MOVLW       211
	MOVWF       _MENU+0 
	MOVLW       0
	MOVWF       _MENU+1 
L_Menu_21_DAY261:
;Nixie.c,1051 :: 		WriteDisplay(toggle_Set == 1 ? (temp_Data.day >> 4) : 0x0F,toggle_Set,0,toggle_Set == 1 ? (temp_Data.day & 0x0F) : 0x0F,0,toggle_Set,(temp_Data.month >> 4),1,0,(temp_Data.month & 0x0F),0,1,(temp_Data.year >> 4),1,0,(temp_Data.year & 0x0F),0,1,0,0);
	CLRF        R1 
	BTFSC       _toggle_Set+0, BitPos(_toggle_Set+0) 
	INCF        R1, 1 
	MOVF        R1, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_21_DAY262
	MOVF        _temp_Data+5, 0 
	MOVWF       ?FLOC___Menu_21_DAYT338+0 
	RRCF        ?FLOC___Menu_21_DAYT338+0, 1 
	BCF         ?FLOC___Menu_21_DAYT338+0, 7 
	RRCF        ?FLOC___Menu_21_DAYT338+0, 1 
	BCF         ?FLOC___Menu_21_DAYT338+0, 7 
	RRCF        ?FLOC___Menu_21_DAYT338+0, 1 
	BCF         ?FLOC___Menu_21_DAYT338+0, 7 
	RRCF        ?FLOC___Menu_21_DAYT338+0, 1 
	BCF         ?FLOC___Menu_21_DAYT338+0, 7 
	GOTO        L_Menu_21_DAY263
L_Menu_21_DAY262:
	MOVLW       15
	MOVWF       ?FLOC___Menu_21_DAYT338+0 
L_Menu_21_DAY263:
	MOVF        ?FLOC___Menu_21_DAYT338+0, 0 
	MOVWF       FARG_WriteDisplay_D5+0 
	MOVLW       0
	BTFSC       _toggle_Set+0, BitPos(_toggle_Set+0) 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D5_L_P+0 
	CLRF        FARG_WriteDisplay_D5_R_P+0 
	CLRF        R1 
	BTFSC       _toggle_Set+0, BitPos(_toggle_Set+0) 
	INCF        R1, 1 
	MOVF        R1, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_21_DAY264
	MOVLW       15
	ANDWF       _temp_Data+5, 0 
	MOVWF       ?FLOC___Menu_21_DAYT342+0 
	GOTO        L_Menu_21_DAY265
L_Menu_21_DAY264:
	MOVLW       15
	MOVWF       ?FLOC___Menu_21_DAYT342+0 
L_Menu_21_DAY265:
	MOVF        ?FLOC___Menu_21_DAYT342+0, 0 
	MOVWF       FARG_WriteDisplay_D4+0 
	CLRF        FARG_WriteDisplay_D4_L_P+0 
	MOVLW       0
	BTFSC       _toggle_Set+0, BitPos(_toggle_Set+0) 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D4_R_P+0 
	MOVF        _temp_Data+7, 0 
	MOVWF       FARG_WriteDisplay_D3+0 
	RRCF        FARG_WriteDisplay_D3+0, 1 
	BCF         FARG_WriteDisplay_D3+0, 7 
	RRCF        FARG_WriteDisplay_D3+0, 1 
	BCF         FARG_WriteDisplay_D3+0, 7 
	RRCF        FARG_WriteDisplay_D3+0, 1 
	BCF         FARG_WriteDisplay_D3+0, 7 
	RRCF        FARG_WriteDisplay_D3+0, 1 
	BCF         FARG_WriteDisplay_D3+0, 7 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D3_L_P+0 
	CLRF        FARG_WriteDisplay_D3_R_P+0 
	MOVLW       15
	ANDWF       _temp_Data+7, 0 
	MOVWF       FARG_WriteDisplay_D2+0 
	CLRF        FARG_WriteDisplay_D2_L_P+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D2_R_P+0 
	MOVF        _temp_Data+8, 0 
	MOVWF       FARG_WriteDisplay_D1+0 
	RRCF        FARG_WriteDisplay_D1+0, 1 
	BCF         FARG_WriteDisplay_D1+0, 7 
	RRCF        FARG_WriteDisplay_D1+0, 1 
	BCF         FARG_WriteDisplay_D1+0, 7 
	RRCF        FARG_WriteDisplay_D1+0, 1 
	BCF         FARG_WriteDisplay_D1+0, 7 
	RRCF        FARG_WriteDisplay_D1+0, 1 
	BCF         FARG_WriteDisplay_D1+0, 7 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D1_L_P+0 
	CLRF        FARG_WriteDisplay_D1_R_P+0 
	MOVLW       15
	ANDWF       _temp_Data+8, 0 
	MOVWF       FARG_WriteDisplay_D0+0 
	CLRF        FARG_WriteDisplay_D0_L_P+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D0_R_P+0 
	CLRF        FARG_WriteDisplay_N0+0 
	CLRF        FARG_WriteDisplay_N1+0 
	CALL        _WriteDisplay+0, 0
;Nixie.c,1053 :: 		}
L_end_Menu_21_DAY:
	RETURN      0
; end of _Menu_21_DAY

_Menu_21_MON:

;Nixie.c,1059 :: 		void Menu_21_MON() {
;Nixie.c,1061 :: 		if (Botao_INC()) {temp_Data.month = Dec2Bcd(Bcd2Dec(temp_Data.month)+1); if (temp_Data.month == 0x13) temp_Data.month = 0x01;}
	CALL        _Botao_INC+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Menu_21_MON266
	MOVF        _temp_Data+7, 0 
	MOVWF       FARG_Bcd2Dec_bcdnum+0 
	CALL        _Bcd2Dec+0, 0
	MOVF        R0, 0 
	ADDLW       1
	MOVWF       FARG_Dec2Bcd_decnum+0 
	CALL        _Dec2Bcd+0, 0
	MOVF        R0, 0 
	MOVWF       _temp_Data+7 
	MOVF        R0, 0 
	XORLW       19
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_21_MON267
	MOVLW       1
	MOVWF       _temp_Data+7 
L_Menu_21_MON267:
L_Menu_21_MON266:
;Nixie.c,1062 :: 		if (Botao_DEC()) {temp_Data.month = Dec2Bcd(Bcd2Dec(temp_Data.month)-1); if (temp_Data.month == 0x00) temp_Data.month = 0x12;}
	CALL        _Botao_DEC+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Menu_21_MON268
	MOVF        _temp_Data+7, 0 
	MOVWF       FARG_Bcd2Dec_bcdnum+0 
	CALL        _Bcd2Dec+0, 0
	DECF        R0, 0 
	MOVWF       FARG_Dec2Bcd_decnum+0 
	CALL        _Dec2Bcd+0, 0
	MOVF        R0, 0 
	MOVWF       _temp_Data+7 
	MOVF        R0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_21_MON269
	MOVLW       18
	MOVWF       _temp_Data+7 
L_Menu_21_MON269:
L_Menu_21_MON268:
;Nixie.c,1063 :: 		if (Botao_ENT()) {MENU = 212;}
	CALL        _Botao_ENT+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Menu_21_MON270
	MOVLW       212
	MOVWF       _MENU+0 
	MOVLW       0
	MOVWF       _MENU+1 
L_Menu_21_MON270:
;Nixie.c,1065 :: 		WriteDisplay((temp_Data.day >> 4),1,0,(temp_Data.day & 0x0F),0,1,toggle_Set == 1 ? (temp_Data.month >> 4) : 0x0F,toggle_Set,0,toggle_Set == 1 ? (temp_Data.month & 0x0F) : 0x0F,0,toggle_Set,(temp_Data.year >> 4),1,0,(temp_Data.year & 0x0F),0,1,0,0);
	MOVF        _temp_Data+5, 0 
	MOVWF       FARG_WriteDisplay_D5+0 
	RRCF        FARG_WriteDisplay_D5+0, 1 
	BCF         FARG_WriteDisplay_D5+0, 7 
	RRCF        FARG_WriteDisplay_D5+0, 1 
	BCF         FARG_WriteDisplay_D5+0, 7 
	RRCF        FARG_WriteDisplay_D5+0, 1 
	BCF         FARG_WriteDisplay_D5+0, 7 
	RRCF        FARG_WriteDisplay_D5+0, 1 
	BCF         FARG_WriteDisplay_D5+0, 7 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D5_L_P+0 
	CLRF        FARG_WriteDisplay_D5_R_P+0 
	MOVLW       15
	ANDWF       _temp_Data+5, 0 
	MOVWF       FARG_WriteDisplay_D4+0 
	CLRF        FARG_WriteDisplay_D4_L_P+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D4_R_P+0 
	CLRF        R1 
	BTFSC       _toggle_Set+0, BitPos(_toggle_Set+0) 
	INCF        R1, 1 
	MOVF        R1, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_21_MON271
	MOVF        _temp_Data+7, 0 
	MOVWF       ?FLOC___Menu_21_MONT356+0 
	RRCF        ?FLOC___Menu_21_MONT356+0, 1 
	BCF         ?FLOC___Menu_21_MONT356+0, 7 
	RRCF        ?FLOC___Menu_21_MONT356+0, 1 
	BCF         ?FLOC___Menu_21_MONT356+0, 7 
	RRCF        ?FLOC___Menu_21_MONT356+0, 1 
	BCF         ?FLOC___Menu_21_MONT356+0, 7 
	RRCF        ?FLOC___Menu_21_MONT356+0, 1 
	BCF         ?FLOC___Menu_21_MONT356+0, 7 
	GOTO        L_Menu_21_MON272
L_Menu_21_MON271:
	MOVLW       15
	MOVWF       ?FLOC___Menu_21_MONT356+0 
L_Menu_21_MON272:
	MOVF        ?FLOC___Menu_21_MONT356+0, 0 
	MOVWF       FARG_WriteDisplay_D3+0 
	MOVLW       0
	BTFSC       _toggle_Set+0, BitPos(_toggle_Set+0) 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D3_L_P+0 
	CLRF        FARG_WriteDisplay_D3_R_P+0 
	CLRF        R1 
	BTFSC       _toggle_Set+0, BitPos(_toggle_Set+0) 
	INCF        R1, 1 
	MOVF        R1, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_21_MON273
	MOVLW       15
	ANDWF       _temp_Data+7, 0 
	MOVWF       ?FLOC___Menu_21_MONT360+0 
	GOTO        L_Menu_21_MON274
L_Menu_21_MON273:
	MOVLW       15
	MOVWF       ?FLOC___Menu_21_MONT360+0 
L_Menu_21_MON274:
	MOVF        ?FLOC___Menu_21_MONT360+0, 0 
	MOVWF       FARG_WriteDisplay_D2+0 
	CLRF        FARG_WriteDisplay_D2_L_P+0 
	MOVLW       0
	BTFSC       _toggle_Set+0, BitPos(_toggle_Set+0) 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D2_R_P+0 
	MOVF        _temp_Data+8, 0 
	MOVWF       FARG_WriteDisplay_D1+0 
	RRCF        FARG_WriteDisplay_D1+0, 1 
	BCF         FARG_WriteDisplay_D1+0, 7 
	RRCF        FARG_WriteDisplay_D1+0, 1 
	BCF         FARG_WriteDisplay_D1+0, 7 
	RRCF        FARG_WriteDisplay_D1+0, 1 
	BCF         FARG_WriteDisplay_D1+0, 7 
	RRCF        FARG_WriteDisplay_D1+0, 1 
	BCF         FARG_WriteDisplay_D1+0, 7 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D1_L_P+0 
	CLRF        FARG_WriteDisplay_D1_R_P+0 
	MOVLW       15
	ANDWF       _temp_Data+8, 0 
	MOVWF       FARG_WriteDisplay_D0+0 
	CLRF        FARG_WriteDisplay_D0_L_P+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D0_R_P+0 
	CLRF        FARG_WriteDisplay_N0+0 
	CLRF        FARG_WriteDisplay_N1+0 
	CALL        _WriteDisplay+0, 0
;Nixie.c,1067 :: 		}
L_end_Menu_21_MON:
	RETURN      0
; end of _Menu_21_MON

_Menu_21_YEAR:

;Nixie.c,1073 :: 		void Menu_21_YEAR() {
;Nixie.c,1075 :: 		if (Botao_INC()) {temp_Data.year = Dec2Bcd(Bcd2Dec(temp_Data.year)+1); if (temp_Data.year == Dec2Bcd(100)) temp_Data.hour = 0x00;}
	CALL        _Botao_INC+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Menu_21_YEAR275
	MOVF        _temp_Data+8, 0 
	MOVWF       FARG_Bcd2Dec_bcdnum+0 
	CALL        _Bcd2Dec+0, 0
	MOVF        R0, 0 
	ADDLW       1
	MOVWF       FARG_Dec2Bcd_decnum+0 
	CALL        _Dec2Bcd+0, 0
	MOVF        R0, 0 
	MOVWF       _temp_Data+8 
	MOVLW       100
	MOVWF       FARG_Dec2Bcd_decnum+0 
	CALL        _Dec2Bcd+0, 0
	MOVF        _temp_Data+8, 0 
	XORWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_21_YEAR276
	CLRF        _temp_Data+2 
L_Menu_21_YEAR276:
L_Menu_21_YEAR275:
;Nixie.c,1076 :: 		if (Botao_DEC()) {temp_Data.year = Dec2Bcd(Bcd2Dec(temp_Data.year)-1); if (temp_Data.year == Dec2Bcd(-1)) temp_Data.hour = 0x99;}
	CALL        _Botao_DEC+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Menu_21_YEAR277
	MOVF        _temp_Data+8, 0 
	MOVWF       FARG_Bcd2Dec_bcdnum+0 
	CALL        _Bcd2Dec+0, 0
	DECF        R0, 0 
	MOVWF       FARG_Dec2Bcd_decnum+0 
	CALL        _Dec2Bcd+0, 0
	MOVF        R0, 0 
	MOVWF       _temp_Data+8 
	MOVLW       255
	MOVWF       FARG_Dec2Bcd_decnum+0 
	CALL        _Dec2Bcd+0, 0
	MOVF        _temp_Data+8, 0 
	XORWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_21_YEAR278
	MOVLW       153
	MOVWF       _temp_Data+2 
L_Menu_21_YEAR278:
L_Menu_21_YEAR277:
;Nixie.c,1077 :: 		if (Botao_ENT()) {Data.day = temp_Data.day; Data.month = temp_Data.month; Data.year = temp_Data.year; Write_RTC(Data); MENU = 21;}
	CALL        _Botao_ENT+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Menu_21_YEAR279
	MOVF        _temp_Data+5, 0 
	MOVWF       _Data+5 
	MOVF        _temp_Data+7, 0 
	MOVWF       _Data+7 
	MOVF        _temp_Data+8, 0 
	MOVWF       _Data+8 
	MOVLW       9
	MOVWF       R0 
	MOVLW       FARG_Write_RTC_Data+0
	MOVWF       FSR1 
	MOVLW       hi_addr(FARG_Write_RTC_Data+0)
	MOVWF       FSR1H 
	MOVLW       _Data+0
	MOVWF       FSR0 
	MOVLW       hi_addr(_Data+0)
	MOVWF       FSR0H 
L_Menu_21_YEAR280:
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
	DECF        R0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_21_YEAR280
	CALL        _Write_RTC+0, 0
	MOVLW       21
	MOVWF       _MENU+0 
	MOVLW       0
	MOVWF       _MENU+1 
L_Menu_21_YEAR279:
;Nixie.c,1079 :: 		WriteDisplay((temp_Data.day >> 4),1,0,(temp_Data.day & 0x0F),0,1,(temp_Data.month >> 4),1,0,(temp_Data.month & 0x0F),0,1,toggle_Set == 1 ? (temp_Data.year >> 4) : 0x0F,toggle_Set,0,toggle_Set == 1 ? (temp_Data.year & 0x0F) : 0x0F,0,toggle_Set,0,0);
	MOVF        _temp_Data+5, 0 
	MOVWF       FARG_WriteDisplay_D5+0 
	RRCF        FARG_WriteDisplay_D5+0, 1 
	BCF         FARG_WriteDisplay_D5+0, 7 
	RRCF        FARG_WriteDisplay_D5+0, 1 
	BCF         FARG_WriteDisplay_D5+0, 7 
	RRCF        FARG_WriteDisplay_D5+0, 1 
	BCF         FARG_WriteDisplay_D5+0, 7 
	RRCF        FARG_WriteDisplay_D5+0, 1 
	BCF         FARG_WriteDisplay_D5+0, 7 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D5_L_P+0 
	CLRF        FARG_WriteDisplay_D5_R_P+0 
	MOVLW       15
	ANDWF       _temp_Data+5, 0 
	MOVWF       FARG_WriteDisplay_D4+0 
	CLRF        FARG_WriteDisplay_D4_L_P+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D4_R_P+0 
	MOVF        _temp_Data+7, 0 
	MOVWF       FARG_WriteDisplay_D3+0 
	RRCF        FARG_WriteDisplay_D3+0, 1 
	BCF         FARG_WriteDisplay_D3+0, 7 
	RRCF        FARG_WriteDisplay_D3+0, 1 
	BCF         FARG_WriteDisplay_D3+0, 7 
	RRCF        FARG_WriteDisplay_D3+0, 1 
	BCF         FARG_WriteDisplay_D3+0, 7 
	RRCF        FARG_WriteDisplay_D3+0, 1 
	BCF         FARG_WriteDisplay_D3+0, 7 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D3_L_P+0 
	CLRF        FARG_WriteDisplay_D3_R_P+0 
	MOVLW       15
	ANDWF       _temp_Data+7, 0 
	MOVWF       FARG_WriteDisplay_D2+0 
	CLRF        FARG_WriteDisplay_D2_L_P+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D2_R_P+0 
	CLRF        R1 
	BTFSC       _toggle_Set+0, BitPos(_toggle_Set+0) 
	INCF        R1, 1 
	MOVF        R1, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_21_YEAR281
	MOVF        _temp_Data+8, 0 
	MOVWF       ?FLOC___Menu_21_YEART380+0 
	RRCF        ?FLOC___Menu_21_YEART380+0, 1 
	BCF         ?FLOC___Menu_21_YEART380+0, 7 
	RRCF        ?FLOC___Menu_21_YEART380+0, 1 
	BCF         ?FLOC___Menu_21_YEART380+0, 7 
	RRCF        ?FLOC___Menu_21_YEART380+0, 1 
	BCF         ?FLOC___Menu_21_YEART380+0, 7 
	RRCF        ?FLOC___Menu_21_YEART380+0, 1 
	BCF         ?FLOC___Menu_21_YEART380+0, 7 
	GOTO        L_Menu_21_YEAR282
L_Menu_21_YEAR281:
	MOVLW       15
	MOVWF       ?FLOC___Menu_21_YEART380+0 
L_Menu_21_YEAR282:
	MOVF        ?FLOC___Menu_21_YEART380+0, 0 
	MOVWF       FARG_WriteDisplay_D1+0 
	MOVLW       0
	BTFSC       _toggle_Set+0, BitPos(_toggle_Set+0) 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D1_L_P+0 
	CLRF        FARG_WriteDisplay_D1_R_P+0 
	CLRF        R1 
	BTFSC       _toggle_Set+0, BitPos(_toggle_Set+0) 
	INCF        R1, 1 
	MOVF        R1, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_21_YEAR283
	MOVLW       15
	ANDWF       _temp_Data+8, 0 
	MOVWF       ?FLOC___Menu_21_YEART384+0 
	GOTO        L_Menu_21_YEAR284
L_Menu_21_YEAR283:
	MOVLW       15
	MOVWF       ?FLOC___Menu_21_YEART384+0 
L_Menu_21_YEAR284:
	MOVF        ?FLOC___Menu_21_YEART384+0, 0 
	MOVWF       FARG_WriteDisplay_D0+0 
	CLRF        FARG_WriteDisplay_D0_L_P+0 
	MOVLW       0
	BTFSC       _toggle_Set+0, BitPos(_toggle_Set+0) 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D0_R_P+0 
	CLRF        FARG_WriteDisplay_N0+0 
	CLRF        FARG_WriteDisplay_N1+0 
	CALL        _WriteDisplay+0, 0
;Nixie.c,1080 :: 		}
L_end_Menu_21_YEAR:
	RETURN      0
; end of _Menu_21_YEAR

_Menu_22:

;Nixie.c,1086 :: 		void Menu_22() {
;Nixie.c,1088 :: 		if (Botao_INC() && temp_Data.week<7) temp_Data.week++;
	CALL        _Botao_INC+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Menu_22287
	MOVLW       7
	SUBWF       _temp_Data+6, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_Menu_22287
L__Menu_22975:
	MOVF        _temp_Data+6, 0 
	ADDLW       1
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       _temp_Data+6 
L_Menu_22287:
;Nixie.c,1089 :: 		if (Botao_DEC() && temp_Data.week>1) temp_Data.week--;
	CALL        _Botao_DEC+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Menu_22290
	MOVF        _temp_Data+6, 0 
	SUBLW       1
	BTFSC       STATUS+0, 0 
	GOTO        L_Menu_22290
L__Menu_22974:
	DECF        _temp_Data+6, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       _temp_Data+6 
L_Menu_22290:
;Nixie.c,1090 :: 		if (Botao_ENT()) {Data.week = temp_Data.week; Write_RTC(Data); MENU = 22;}
	CALL        _Botao_ENT+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Menu_22291
	MOVF        _temp_Data+6, 0 
	MOVWF       _Data+6 
	MOVLW       9
	MOVWF       R0 
	MOVLW       FARG_Write_RTC_Data+0
	MOVWF       FSR1 
	MOVLW       hi_addr(FARG_Write_RTC_Data+0)
	MOVWF       FSR1H 
	MOVLW       _Data+0
	MOVWF       FSR0 
	MOVLW       hi_addr(_Data+0)
	MOVWF       FSR0H 
L_Menu_22292:
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
	DECF        R0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_22292
	CALL        _Write_RTC+0, 0
	MOVLW       22
	MOVWF       _MENU+0 
	MOVLW       0
	MOVWF       _MENU+1 
L_Menu_22291:
;Nixie.c,1092 :: 		WriteDisplay(0x02,0,0,0x02,1,0,0x0F,0,0,0x0F,0,0,0x0F,0,0,toggle_Set == 1 ? temp_Data.week : 0x0F,0,0,0,0);
	MOVLW       2
	MOVWF       FARG_WriteDisplay_D5+0 
	CLRF        FARG_WriteDisplay_D5_L_P+0 
	CLRF        FARG_WriteDisplay_D5_R_P+0 
	MOVLW       2
	MOVWF       FARG_WriteDisplay_D4+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D4_L_P+0 
	CLRF        FARG_WriteDisplay_D4_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D3+0 
	CLRF        FARG_WriteDisplay_D3_L_P+0 
	CLRF        FARG_WriteDisplay_D3_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D2+0 
	CLRF        FARG_WriteDisplay_D2_L_P+0 
	CLRF        FARG_WriteDisplay_D2_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D1+0 
	CLRF        FARG_WriteDisplay_D1_L_P+0 
	CLRF        FARG_WriteDisplay_D1_R_P+0 
	CLRF        R1 
	BTFSC       _toggle_Set+0, BitPos(_toggle_Set+0) 
	INCF        R1, 1 
	MOVF        R1, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_22293
	MOVF        _temp_Data+6, 0 
	MOVWF       ?FLOC___Menu_22T399+0 
	GOTO        L_Menu_22294
L_Menu_22293:
	MOVLW       15
	MOVWF       ?FLOC___Menu_22T399+0 
L_Menu_22294:
	MOVF        ?FLOC___Menu_22T399+0, 0 
	MOVWF       FARG_WriteDisplay_D0+0 
	CLRF        FARG_WriteDisplay_D0_L_P+0 
	CLRF        FARG_WriteDisplay_D0_R_P+0 
	CLRF        FARG_WriteDisplay_N0+0 
	CLRF        FARG_WriteDisplay_N1+0 
	CALL        _WriteDisplay+0, 0
;Nixie.c,1094 :: 		}
L_end_Menu_22:
	RETURN      0
; end of _Menu_22

_Menu_31:

;Nixie.c,1100 :: 		void Menu_31() {
;Nixie.c,1102 :: 		if (Botao_INC() && (BackLight<3)) { BackLight++; if (BackLight == 1) BackLightRGB(&Led); else if (BackLight == 2) BackLightRGB(&Led_Week[Data.week]); else BackLightRGB(&LedOFF);}
	CALL        _Botao_INC+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Menu_31297
	MOVLW       3
	SUBWF       _BackLight+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_Menu_31297
L__Menu_31977:
	INCF        _BackLight+0, 1 
	MOVF        _BackLight+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_31298
	MOVLW       _Led+0
	MOVWF       FARG_BackLightRGB_ledRGB+0 
	MOVLW       hi_addr(_Led+0)
	MOVWF       FARG_BackLightRGB_ledRGB+1 
	CALL        _BackLightRGB+0, 0
	GOTO        L_Menu_31299
L_Menu_31298:
	MOVF        _BackLight+0, 0 
	XORLW       2
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_31300
	MOVLW       3
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        _Data+6, 0 
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _Led_Week+0
	ADDWF       R0, 0 
	MOVWF       FARG_BackLightRGB_ledRGB+0 
	MOVLW       hi_addr(_Led_Week+0)
	ADDWFC      R1, 0 
	MOVWF       FARG_BackLightRGB_ledRGB+1 
	CALL        _BackLightRGB+0, 0
	GOTO        L_Menu_31301
L_Menu_31300:
	MOVLW       _LedOFF+0
	MOVWF       FARG_BackLightRGB_ledRGB+0 
	MOVLW       hi_addr(_LedOFF+0)
	MOVWF       FARG_BackLightRGB_ledRGB+1 
	CALL        _BackLightRGB+0, 0
L_Menu_31301:
L_Menu_31299:
L_Menu_31297:
;Nixie.c,1103 :: 		if (Botao_DEC() && (BackLight>0)) { BackLight--; if (BackLight == 1) BackLightRGB(&Led); else if (BackLight == 2) BackLightRGB(&Led_Week[Data.week]); else BackLightRGB(&LedOFF);}
	CALL        _Botao_DEC+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Menu_31304
	MOVF        _BackLight+0, 0 
	SUBLW       0
	BTFSC       STATUS+0, 0 
	GOTO        L_Menu_31304
L__Menu_31976:
	DECF        _BackLight+0, 1 
	MOVF        _BackLight+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_31305
	MOVLW       _Led+0
	MOVWF       FARG_BackLightRGB_ledRGB+0 
	MOVLW       hi_addr(_Led+0)
	MOVWF       FARG_BackLightRGB_ledRGB+1 
	CALL        _BackLightRGB+0, 0
	GOTO        L_Menu_31306
L_Menu_31305:
	MOVF        _BackLight+0, 0 
	XORLW       2
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_31307
	MOVLW       3
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        _Data+6, 0 
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _Led_Week+0
	ADDWF       R0, 0 
	MOVWF       FARG_BackLightRGB_ledRGB+0 
	MOVLW       hi_addr(_Led_Week+0)
	ADDWFC      R1, 0 
	MOVWF       FARG_BackLightRGB_ledRGB+1 
	CALL        _BackLightRGB+0, 0
	GOTO        L_Menu_31308
L_Menu_31307:
	MOVLW       _LedOFF+0
	MOVWF       FARG_BackLightRGB_ledRGB+0 
	MOVLW       hi_addr(_LedOFF+0)
	MOVWF       FARG_BackLightRGB_ledRGB+1 
	CALL        _BackLightRGB+0, 0
L_Menu_31308:
L_Menu_31306:
L_Menu_31304:
;Nixie.c,1104 :: 		if (Botao_ENT()) { escrever_eeprom(0x02,BackLight); MENU = 31;}
	CALL        _Botao_ENT+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Menu_31309
	MOVLW       2
	MOVWF       FARG_escrever_eeprom_address+0 
	MOVF        _BackLight+0, 0 
	MOVWF       FARG_escrever_eeprom_DADO_EEPROM+0 
	CALL        _escrever_eeprom+0, 0
	MOVLW       31
	MOVWF       _MENU+0 
	MOVLW       0
	MOVWF       _MENU+1 
L_Menu_31309:
;Nixie.c,1106 :: 		WriteDisplay(0x03,0,0,0x01,1,0,0x0F,0,0,0x0F,0,0,0x0F,0,0,toggle_Set == 1 ? BackLight : 0x0F,0,0,0,0);
	MOVLW       3
	MOVWF       FARG_WriteDisplay_D5+0 
	CLRF        FARG_WriteDisplay_D5_L_P+0 
	CLRF        FARG_WriteDisplay_D5_R_P+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D4+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D4_L_P+0 
	CLRF        FARG_WriteDisplay_D4_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D3+0 
	CLRF        FARG_WriteDisplay_D3_L_P+0 
	CLRF        FARG_WriteDisplay_D3_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D2+0 
	CLRF        FARG_WriteDisplay_D2_L_P+0 
	CLRF        FARG_WriteDisplay_D2_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D1+0 
	CLRF        FARG_WriteDisplay_D1_L_P+0 
	CLRF        FARG_WriteDisplay_D1_R_P+0 
	CLRF        R1 
	BTFSC       _toggle_Set+0, BitPos(_toggle_Set+0) 
	INCF        R1, 1 
	MOVF        R1, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_31310
	MOVF        _BackLight+0, 0 
	MOVWF       ?FLOC___Menu_31T424+0 
	GOTO        L_Menu_31311
L_Menu_31310:
	MOVLW       15
	MOVWF       ?FLOC___Menu_31T424+0 
L_Menu_31311:
	MOVF        ?FLOC___Menu_31T424+0, 0 
	MOVWF       FARG_WriteDisplay_D0+0 
	CLRF        FARG_WriteDisplay_D0_L_P+0 
	CLRF        FARG_WriteDisplay_D0_R_P+0 
	CLRF        FARG_WriteDisplay_N0+0 
	CLRF        FARG_WriteDisplay_N1+0 
	CALL        _WriteDisplay+0, 0
;Nixie.c,1108 :: 		}
L_end_Menu_31:
	RETURN      0
; end of _Menu_31

_Menu_32:

;Nixie.c,1114 :: 		void Menu_32() {
;Nixie.c,1116 :: 		if (Botao_INC() && Led.r<198) {Led.r += 2; BackLightRGB(&Led);}
	CALL        _Botao_INC+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Menu_32314
	MOVLW       198
	SUBWF       _Led+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_Menu_32314
L__Menu_32979:
	MOVLW       2
	ADDWF       _Led+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       _Led+0 
	MOVLW       _Led+0
	MOVWF       FARG_BackLightRGB_ledRGB+0 
	MOVLW       hi_addr(_Led+0)
	MOVWF       FARG_BackLightRGB_ledRGB+1 
	CALL        _BackLightRGB+0, 0
L_Menu_32314:
;Nixie.c,1117 :: 		if (Botao_DEC() && Led.r>0)   {Led.r -= 2; BackLightRGB(&Led);}
	CALL        _Botao_DEC+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Menu_32317
	MOVF        _Led+0, 0 
	SUBLW       0
	BTFSC       STATUS+0, 0 
	GOTO        L_Menu_32317
L__Menu_32978:
	MOVLW       2
	SUBWF       _Led+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       _Led+0 
	MOVLW       _Led+0
	MOVWF       FARG_BackLightRGB_ledRGB+0 
	MOVLW       hi_addr(_Led+0)
	MOVWF       FARG_BackLightRGB_ledRGB+1 
	CALL        _BackLightRGB+0, 0
L_Menu_32317:
;Nixie.c,1118 :: 		if (Botao_ENT()) { escrever_eeprom(0x03,Led.r); if (BackLight == 0) BackLightRGB(&LedOFF); else if (BackLight == 2) BackLightRGB(&Led_Week[Data.week]);  MENU = 32;}
	CALL        _Botao_ENT+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Menu_32318
	MOVLW       3
	MOVWF       FARG_escrever_eeprom_address+0 
	MOVF        _Led+0, 0 
	MOVWF       FARG_escrever_eeprom_DADO_EEPROM+0 
	CALL        _escrever_eeprom+0, 0
	MOVF        _BackLight+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_32319
	MOVLW       _LedOFF+0
	MOVWF       FARG_BackLightRGB_ledRGB+0 
	MOVLW       hi_addr(_LedOFF+0)
	MOVWF       FARG_BackLightRGB_ledRGB+1 
	CALL        _BackLightRGB+0, 0
	GOTO        L_Menu_32320
L_Menu_32319:
	MOVF        _BackLight+0, 0 
	XORLW       2
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_32321
	MOVLW       3
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        _Data+6, 0 
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _Led_Week+0
	ADDWF       R0, 0 
	MOVWF       FARG_BackLightRGB_ledRGB+0 
	MOVLW       hi_addr(_Led_Week+0)
	ADDWFC      R1, 0 
	MOVWF       FARG_BackLightRGB_ledRGB+1 
	CALL        _BackLightRGB+0, 0
L_Menu_32321:
L_Menu_32320:
	MOVLW       32
	MOVWF       _MENU+0 
	MOVLW       0
	MOVWF       _MENU+1 
L_Menu_32318:
;Nixie.c,1120 :: 		SeparaUnidade(Led.r / 2);
	MOVF        _Led+0, 0 
	MOVWF       FARG_SeparaUnidade_Numero+0 
	MOVLW       0
	MOVWF       FARG_SeparaUnidade_Numero+1 
	MOVWF       FARG_SeparaUnidade_Numero+2 
	MOVWF       FARG_SeparaUnidade_Numero+3 
	RRCF        FARG_SeparaUnidade_Numero+0, 1 
	BCF         FARG_SeparaUnidade_Numero+0, 7 
	MOVLW       0
	MOVWF       FARG_SeparaUnidade_Numero+1 
	MOVWF       FARG_SeparaUnidade_Numero+2 
	MOVWF       FARG_SeparaUnidade_Numero+3 
	CALL        _SeparaUnidade+0, 0
;Nixie.c,1122 :: 		WriteDisplay(0x03,0,0,0x02,1,0,0x0F,0,0,0x0F,0,0,toggle_Set == 1 ? dezena : 0x0F,0,0,toggle_Set == 1 ? unidade : 0x0F,0,0,0,0);
	MOVLW       3
	MOVWF       FARG_WriteDisplay_D5+0 
	CLRF        FARG_WriteDisplay_D5_L_P+0 
	CLRF        FARG_WriteDisplay_D5_R_P+0 
	MOVLW       2
	MOVWF       FARG_WriteDisplay_D4+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D4_L_P+0 
	CLRF        FARG_WriteDisplay_D4_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D3+0 
	CLRF        FARG_WriteDisplay_D3_L_P+0 
	CLRF        FARG_WriteDisplay_D3_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D2+0 
	CLRF        FARG_WriteDisplay_D2_L_P+0 
	CLRF        FARG_WriteDisplay_D2_R_P+0 
	CLRF        R1 
	BTFSC       _toggle_Set+0, BitPos(_toggle_Set+0) 
	INCF        R1, 1 
	MOVF        R1, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_32322
	MOVF        _dezena+0, 0 
	MOVWF       ?FLOC___Menu_32T443+0 
	GOTO        L_Menu_32323
L_Menu_32322:
	MOVLW       15
	MOVWF       ?FLOC___Menu_32T443+0 
L_Menu_32323:
	MOVF        ?FLOC___Menu_32T443+0, 0 
	MOVWF       FARG_WriteDisplay_D1+0 
	CLRF        FARG_WriteDisplay_D1_L_P+0 
	CLRF        FARG_WriteDisplay_D1_R_P+0 
	CLRF        R1 
	BTFSC       _toggle_Set+0, BitPos(_toggle_Set+0) 
	INCF        R1, 1 
	MOVF        R1, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_32324
	MOVF        _unidade+0, 0 
	MOVWF       ?FLOC___Menu_32T446+0 
	GOTO        L_Menu_32325
L_Menu_32324:
	MOVLW       15
	MOVWF       ?FLOC___Menu_32T446+0 
L_Menu_32325:
	MOVF        ?FLOC___Menu_32T446+0, 0 
	MOVWF       FARG_WriteDisplay_D0+0 
	CLRF        FARG_WriteDisplay_D0_L_P+0 
	CLRF        FARG_WriteDisplay_D0_R_P+0 
	CLRF        FARG_WriteDisplay_N0+0 
	CLRF        FARG_WriteDisplay_N1+0 
	CALL        _WriteDisplay+0, 0
;Nixie.c,1124 :: 		}
L_end_Menu_32:
	RETURN      0
; end of _Menu_32

_Menu_33:

;Nixie.c,1130 :: 		void Menu_33() {
;Nixie.c,1132 :: 		if (Botao_INC() && Led.g<198) {Led.g += 2; BackLightRGB(&Led);}
	CALL        _Botao_INC+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Menu_33328
	MOVLW       198
	SUBWF       _Led+2, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_Menu_33328
L__Menu_33981:
	MOVLW       2
	ADDWF       _Led+2, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       _Led+2 
	MOVLW       _Led+0
	MOVWF       FARG_BackLightRGB_ledRGB+0 
	MOVLW       hi_addr(_Led+0)
	MOVWF       FARG_BackLightRGB_ledRGB+1 
	CALL        _BackLightRGB+0, 0
L_Menu_33328:
;Nixie.c,1133 :: 		if (Botao_DEC() && Led.g>0)   {Led.g -= 2; BackLightRGB(&Led);}
	CALL        _Botao_DEC+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Menu_33331
	MOVF        _Led+2, 0 
	SUBLW       0
	BTFSC       STATUS+0, 0 
	GOTO        L_Menu_33331
L__Menu_33980:
	MOVLW       2
	SUBWF       _Led+2, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       _Led+2 
	MOVLW       _Led+0
	MOVWF       FARG_BackLightRGB_ledRGB+0 
	MOVLW       hi_addr(_Led+0)
	MOVWF       FARG_BackLightRGB_ledRGB+1 
	CALL        _BackLightRGB+0, 0
L_Menu_33331:
;Nixie.c,1134 :: 		if (Botao_ENT()) { escrever_eeprom(0x04,Led.g); if (BackLight == 0) BackLightRGB(&LedOFF); else if (BackLight == 2) BackLightRGB(&Led_Week[Data.week]); MENU = 33;}
	CALL        _Botao_ENT+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Menu_33332
	MOVLW       4
	MOVWF       FARG_escrever_eeprom_address+0 
	MOVF        _Led+2, 0 
	MOVWF       FARG_escrever_eeprom_DADO_EEPROM+0 
	CALL        _escrever_eeprom+0, 0
	MOVF        _BackLight+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_33333
	MOVLW       _LedOFF+0
	MOVWF       FARG_BackLightRGB_ledRGB+0 
	MOVLW       hi_addr(_LedOFF+0)
	MOVWF       FARG_BackLightRGB_ledRGB+1 
	CALL        _BackLightRGB+0, 0
	GOTO        L_Menu_33334
L_Menu_33333:
	MOVF        _BackLight+0, 0 
	XORLW       2
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_33335
	MOVLW       3
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        _Data+6, 0 
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _Led_Week+0
	ADDWF       R0, 0 
	MOVWF       FARG_BackLightRGB_ledRGB+0 
	MOVLW       hi_addr(_Led_Week+0)
	ADDWFC      R1, 0 
	MOVWF       FARG_BackLightRGB_ledRGB+1 
	CALL        _BackLightRGB+0, 0
L_Menu_33335:
L_Menu_33334:
	MOVLW       33
	MOVWF       _MENU+0 
	MOVLW       0
	MOVWF       _MENU+1 
L_Menu_33332:
;Nixie.c,1136 :: 		SeparaUnidade(Led.g / 2);
	MOVF        _Led+2, 0 
	MOVWF       FARG_SeparaUnidade_Numero+0 
	MOVLW       0
	MOVWF       FARG_SeparaUnidade_Numero+1 
	MOVWF       FARG_SeparaUnidade_Numero+2 
	MOVWF       FARG_SeparaUnidade_Numero+3 
	RRCF        FARG_SeparaUnidade_Numero+0, 1 
	BCF         FARG_SeparaUnidade_Numero+0, 7 
	MOVLW       0
	MOVWF       FARG_SeparaUnidade_Numero+1 
	MOVWF       FARG_SeparaUnidade_Numero+2 
	MOVWF       FARG_SeparaUnidade_Numero+3 
	CALL        _SeparaUnidade+0, 0
;Nixie.c,1138 :: 		WriteDisplay(0x03,0,0,0x03,1,0,0x0F,0,0,0x0F,0,0,toggle_Set == 1 ? dezena : 0x0F,0,0,toggle_Set == 1 ? unidade : 0x0F,0,0,0,0);
	MOVLW       3
	MOVWF       FARG_WriteDisplay_D5+0 
	CLRF        FARG_WriteDisplay_D5_L_P+0 
	CLRF        FARG_WriteDisplay_D5_R_P+0 
	MOVLW       3
	MOVWF       FARG_WriteDisplay_D4+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D4_L_P+0 
	CLRF        FARG_WriteDisplay_D4_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D3+0 
	CLRF        FARG_WriteDisplay_D3_L_P+0 
	CLRF        FARG_WriteDisplay_D3_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D2+0 
	CLRF        FARG_WriteDisplay_D2_L_P+0 
	CLRF        FARG_WriteDisplay_D2_R_P+0 
	CLRF        R1 
	BTFSC       _toggle_Set+0, BitPos(_toggle_Set+0) 
	INCF        R1, 1 
	MOVF        R1, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_33336
	MOVF        _dezena+0, 0 
	MOVWF       ?FLOC___Menu_33T465+0 
	GOTO        L_Menu_33337
L_Menu_33336:
	MOVLW       15
	MOVWF       ?FLOC___Menu_33T465+0 
L_Menu_33337:
	MOVF        ?FLOC___Menu_33T465+0, 0 
	MOVWF       FARG_WriteDisplay_D1+0 
	CLRF        FARG_WriteDisplay_D1_L_P+0 
	CLRF        FARG_WriteDisplay_D1_R_P+0 
	CLRF        R1 
	BTFSC       _toggle_Set+0, BitPos(_toggle_Set+0) 
	INCF        R1, 1 
	MOVF        R1, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_33338
	MOVF        _unidade+0, 0 
	MOVWF       ?FLOC___Menu_33T468+0 
	GOTO        L_Menu_33339
L_Menu_33338:
	MOVLW       15
	MOVWF       ?FLOC___Menu_33T468+0 
L_Menu_33339:
	MOVF        ?FLOC___Menu_33T468+0, 0 
	MOVWF       FARG_WriteDisplay_D0+0 
	CLRF        FARG_WriteDisplay_D0_L_P+0 
	CLRF        FARG_WriteDisplay_D0_R_P+0 
	CLRF        FARG_WriteDisplay_N0+0 
	CLRF        FARG_WriteDisplay_N1+0 
	CALL        _WriteDisplay+0, 0
;Nixie.c,1140 :: 		}
L_end_Menu_33:
	RETURN      0
; end of _Menu_33

_Menu_34:

;Nixie.c,1146 :: 		void Menu_34() {
;Nixie.c,1148 :: 		if (Botao_INC() && Led.b<198) {Led.b += 2; BackLightRGB(&Led);}
	CALL        _Botao_INC+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Menu_34342
	MOVLW       198
	SUBWF       _Led+1, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_Menu_34342
L__Menu_34983:
	MOVLW       2
	ADDWF       _Led+1, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       _Led+1 
	MOVLW       _Led+0
	MOVWF       FARG_BackLightRGB_ledRGB+0 
	MOVLW       hi_addr(_Led+0)
	MOVWF       FARG_BackLightRGB_ledRGB+1 
	CALL        _BackLightRGB+0, 0
L_Menu_34342:
;Nixie.c,1149 :: 		if (Botao_DEC() && Led.b>0)   {Led.b -= 2; BackLightRGB(&Led);}
	CALL        _Botao_DEC+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Menu_34345
	MOVF        _Led+1, 0 
	SUBLW       0
	BTFSC       STATUS+0, 0 
	GOTO        L_Menu_34345
L__Menu_34982:
	MOVLW       2
	SUBWF       _Led+1, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       _Led+1 
	MOVLW       _Led+0
	MOVWF       FARG_BackLightRGB_ledRGB+0 
	MOVLW       hi_addr(_Led+0)
	MOVWF       FARG_BackLightRGB_ledRGB+1 
	CALL        _BackLightRGB+0, 0
L_Menu_34345:
;Nixie.c,1150 :: 		if (Botao_ENT()) { escrever_eeprom(0x05,Led.b); if (BackLight == 0) BackLightRGB(&LedOFF); else if (BackLight == 2) BackLightRGB(&Led_Week[Data.week]); MENU = 34;}
	CALL        _Botao_ENT+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Menu_34346
	MOVLW       5
	MOVWF       FARG_escrever_eeprom_address+0 
	MOVF        _Led+1, 0 
	MOVWF       FARG_escrever_eeprom_DADO_EEPROM+0 
	CALL        _escrever_eeprom+0, 0
	MOVF        _BackLight+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_34347
	MOVLW       _LedOFF+0
	MOVWF       FARG_BackLightRGB_ledRGB+0 
	MOVLW       hi_addr(_LedOFF+0)
	MOVWF       FARG_BackLightRGB_ledRGB+1 
	CALL        _BackLightRGB+0, 0
	GOTO        L_Menu_34348
L_Menu_34347:
	MOVF        _BackLight+0, 0 
	XORLW       2
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_34349
	MOVLW       3
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        _Data+6, 0 
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _Led_Week+0
	ADDWF       R0, 0 
	MOVWF       FARG_BackLightRGB_ledRGB+0 
	MOVLW       hi_addr(_Led_Week+0)
	ADDWFC      R1, 0 
	MOVWF       FARG_BackLightRGB_ledRGB+1 
	CALL        _BackLightRGB+0, 0
L_Menu_34349:
L_Menu_34348:
	MOVLW       34
	MOVWF       _MENU+0 
	MOVLW       0
	MOVWF       _MENU+1 
L_Menu_34346:
;Nixie.c,1152 :: 		SeparaUnidade(Led.b / 2);
	MOVF        _Led+1, 0 
	MOVWF       FARG_SeparaUnidade_Numero+0 
	MOVLW       0
	MOVWF       FARG_SeparaUnidade_Numero+1 
	MOVWF       FARG_SeparaUnidade_Numero+2 
	MOVWF       FARG_SeparaUnidade_Numero+3 
	RRCF        FARG_SeparaUnidade_Numero+0, 1 
	BCF         FARG_SeparaUnidade_Numero+0, 7 
	MOVLW       0
	MOVWF       FARG_SeparaUnidade_Numero+1 
	MOVWF       FARG_SeparaUnidade_Numero+2 
	MOVWF       FARG_SeparaUnidade_Numero+3 
	CALL        _SeparaUnidade+0, 0
;Nixie.c,1154 :: 		WriteDisplay(0x03,0,0,0x04,1,0,0x0F,0,0,0x0F,0,0,toggle_Set == 1 ? dezena : 0x0F,0,0,toggle_Set == 1 ? unidade : 0x0F,0,0,0,0);
	MOVLW       3
	MOVWF       FARG_WriteDisplay_D5+0 
	CLRF        FARG_WriteDisplay_D5_L_P+0 
	CLRF        FARG_WriteDisplay_D5_R_P+0 
	MOVLW       4
	MOVWF       FARG_WriteDisplay_D4+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D4_L_P+0 
	CLRF        FARG_WriteDisplay_D4_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D3+0 
	CLRF        FARG_WriteDisplay_D3_L_P+0 
	CLRF        FARG_WriteDisplay_D3_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D2+0 
	CLRF        FARG_WriteDisplay_D2_L_P+0 
	CLRF        FARG_WriteDisplay_D2_R_P+0 
	CLRF        R1 
	BTFSC       _toggle_Set+0, BitPos(_toggle_Set+0) 
	INCF        R1, 1 
	MOVF        R1, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_34350
	MOVF        _dezena+0, 0 
	MOVWF       ?FLOC___Menu_34T487+0 
	GOTO        L_Menu_34351
L_Menu_34350:
	MOVLW       15
	MOVWF       ?FLOC___Menu_34T487+0 
L_Menu_34351:
	MOVF        ?FLOC___Menu_34T487+0, 0 
	MOVWF       FARG_WriteDisplay_D1+0 
	CLRF        FARG_WriteDisplay_D1_L_P+0 
	CLRF        FARG_WriteDisplay_D1_R_P+0 
	CLRF        R1 
	BTFSC       _toggle_Set+0, BitPos(_toggle_Set+0) 
	INCF        R1, 1 
	MOVF        R1, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_34352
	MOVF        _unidade+0, 0 
	MOVWF       ?FLOC___Menu_34T490+0 
	GOTO        L_Menu_34353
L_Menu_34352:
	MOVLW       15
	MOVWF       ?FLOC___Menu_34T490+0 
L_Menu_34353:
	MOVF        ?FLOC___Menu_34T490+0, 0 
	MOVWF       FARG_WriteDisplay_D0+0 
	CLRF        FARG_WriteDisplay_D0_L_P+0 
	CLRF        FARG_WriteDisplay_D0_R_P+0 
	CLRF        FARG_WriteDisplay_N0+0 
	CLRF        FARG_WriteDisplay_N1+0 
	CALL        _WriteDisplay+0, 0
;Nixie.c,1156 :: 		}
L_end_Menu_34:
	RETURN      0
; end of _Menu_34

_Menu_41:

;Nixie.c,1162 :: 		void Menu_41() {
;Nixie.c,1164 :: 		if (Botao_INC()) { LDR_Auto = 1; ACESO = Light_Sensor; APAGADO = 100-ACESO;}
	CALL        _Botao_INC+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Menu_41354
	BSF         _LDR_Auto+0, BitPos(_LDR_Auto+0) 
	MOVF        _Light_Sensor+0, 0 
	MOVWF       _ACESO+0 
	MOVF        _Light_Sensor+0, 0 
	SUBLW       100
	MOVWF       _APAGADO+0 
L_Menu_41354:
;Nixie.c,1165 :: 		if (Botao_DEC()) { LDR_Auto = 0; ACESO = ler_eeprom(0x07); APAGADO = 100-ACESO;}
	CALL        _Botao_DEC+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Menu_41355
	BCF         _LDR_Auto+0, BitPos(_LDR_Auto+0) 
	MOVLW       7
	MOVWF       FARG_ler_eeprom_address+0 
	CALL        _ler_eeprom+0, 0
	MOVF        R0, 0 
	MOVWF       _ACESO+0 
	MOVF        R0, 0 
	SUBLW       100
	MOVWF       _APAGADO+0 
L_Menu_41355:
;Nixie.c,1166 :: 		if (Botao_ENT()) { escrever_eeprom(0x06,LDR_Auto); MENU = 41;}
	CALL        _Botao_ENT+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Menu_41356
	MOVLW       6
	MOVWF       FARG_escrever_eeprom_address+0 
	MOVLW       0
	BTFSC       _LDR_Auto+0, BitPos(_LDR_Auto+0) 
	MOVLW       1
	MOVWF       FARG_escrever_eeprom_DADO_EEPROM+0 
	CALL        _escrever_eeprom+0, 0
	MOVLW       41
	MOVWF       _MENU+0 
	MOVLW       0
	MOVWF       _MENU+1 
L_Menu_41356:
;Nixie.c,1168 :: 		WriteDisplay(0x04,0,0,0x01,1,0,0x0F,0,0,0x0F,0,0,0x0F,0,0,toggle_Set == 1 ? (unsigned char)LDR_Auto : 0x0F,0,0,0,0);
	MOVLW       4
	MOVWF       FARG_WriteDisplay_D5+0 
	CLRF        FARG_WriteDisplay_D5_L_P+0 
	CLRF        FARG_WriteDisplay_D5_R_P+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D4+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D4_L_P+0 
	CLRF        FARG_WriteDisplay_D4_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D3+0 
	CLRF        FARG_WriteDisplay_D3_L_P+0 
	CLRF        FARG_WriteDisplay_D3_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D2+0 
	CLRF        FARG_WriteDisplay_D2_L_P+0 
	CLRF        FARG_WriteDisplay_D2_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D1+0 
	CLRF        FARG_WriteDisplay_D1_L_P+0 
	CLRF        FARG_WriteDisplay_D1_R_P+0 
	CLRF        R1 
	BTFSC       _toggle_Set+0, BitPos(_toggle_Set+0) 
	INCF        R1, 1 
	MOVF        R1, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_41357
	MOVLW       0
	BTFSC       _LDR_Auto+0, BitPos(_LDR_Auto+0) 
	MOVLW       1
	MOVWF       ?FLOC___Menu_41T496+0 
	GOTO        L_Menu_41358
L_Menu_41357:
	MOVLW       15
	MOVWF       ?FLOC___Menu_41T496+0 
L_Menu_41358:
	MOVF        ?FLOC___Menu_41T496+0, 0 
	MOVWF       FARG_WriteDisplay_D0+0 
	CLRF        FARG_WriteDisplay_D0_L_P+0 
	CLRF        FARG_WriteDisplay_D0_R_P+0 
	CLRF        FARG_WriteDisplay_N0+0 
	CLRF        FARG_WriteDisplay_N1+0 
	CALL        _WriteDisplay+0, 0
;Nixie.c,1170 :: 		}
L_end_Menu_41:
	RETURN      0
; end of _Menu_41

_Menu_42:

;Nixie.c,1176 :: 		void Menu_42() {
;Nixie.c,1178 :: 		if (Botao_INC() && ACESO<99) {ACESO++; APAGADO = 100-ACESO;}
	CALL        _Botao_INC+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Menu_42361
	MOVLW       99
	SUBWF       _ACESO+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_Menu_42361
L__Menu_42985:
	INCF        _ACESO+0, 1 
	MOVF        _ACESO+0, 0 
	SUBLW       100
	MOVWF       _APAGADO+0 
L_Menu_42361:
;Nixie.c,1179 :: 		if (Botao_DEC() && ACESO>0)   {ACESO--; APAGADO = 100-ACESO;}
	CALL        _Botao_DEC+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Menu_42364
	MOVF        _ACESO+0, 0 
	SUBLW       0
	BTFSC       STATUS+0, 0 
	GOTO        L_Menu_42364
L__Menu_42984:
	DECF        _ACESO+0, 1 
	MOVF        _ACESO+0, 0 
	SUBLW       100
	MOVWF       _APAGADO+0 
L_Menu_42364:
;Nixie.c,1180 :: 		if (Botao_ENT()) { escrever_eeprom(0x07,ACESO);  LDR_Auto = ler_eeprom(0x06); MENU = 42;}
	CALL        _Botao_ENT+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Menu_42365
	MOVLW       7
	MOVWF       FARG_escrever_eeprom_address+0 
	MOVF        _ACESO+0, 0 
	MOVWF       FARG_escrever_eeprom_DADO_EEPROM+0 
	CALL        _escrever_eeprom+0, 0
	MOVLW       6
	MOVWF       FARG_ler_eeprom_address+0 
	CALL        _ler_eeprom+0, 0
	BTFSC       R0, 0 
	GOTO        L__Menu_421142
	BCF         _LDR_Auto+0, BitPos(_LDR_Auto+0) 
	GOTO        L__Menu_421143
L__Menu_421142:
	BSF         _LDR_Auto+0, BitPos(_LDR_Auto+0) 
L__Menu_421143:
	MOVLW       42
	MOVWF       _MENU+0 
	MOVLW       0
	MOVWF       _MENU+1 
L_Menu_42365:
;Nixie.c,1182 :: 		SeparaUnidade(ACESO);
	MOVF        _ACESO+0, 0 
	MOVWF       FARG_SeparaUnidade_Numero+0 
	MOVLW       0
	MOVWF       FARG_SeparaUnidade_Numero+1 
	MOVWF       FARG_SeparaUnidade_Numero+2 
	MOVWF       FARG_SeparaUnidade_Numero+3 
	CALL        _SeparaUnidade+0, 0
;Nixie.c,1184 :: 		WriteDisplay(0x04,0,0,0x02,1,0,0x0F,0,0,0x0F,0,0,toggle_Set == 1 ? dezena : 0x0F,0,0,toggle_Set == 1 ? unidade : 0x0F,0,0,0,0);
	MOVLW       4
	MOVWF       FARG_WriteDisplay_D5+0 
	CLRF        FARG_WriteDisplay_D5_L_P+0 
	CLRF        FARG_WriteDisplay_D5_R_P+0 
	MOVLW       2
	MOVWF       FARG_WriteDisplay_D4+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D4_L_P+0 
	CLRF        FARG_WriteDisplay_D4_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D3+0 
	CLRF        FARG_WriteDisplay_D3_L_P+0 
	CLRF        FARG_WriteDisplay_D3_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D2+0 
	CLRF        FARG_WriteDisplay_D2_L_P+0 
	CLRF        FARG_WriteDisplay_D2_R_P+0 
	CLRF        R1 
	BTFSC       _toggle_Set+0, BitPos(_toggle_Set+0) 
	INCF        R1, 1 
	MOVF        R1, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_42366
	MOVF        _dezena+0, 0 
	MOVWF       ?FLOC___Menu_42T507+0 
	GOTO        L_Menu_42367
L_Menu_42366:
	MOVLW       15
	MOVWF       ?FLOC___Menu_42T507+0 
L_Menu_42367:
	MOVF        ?FLOC___Menu_42T507+0, 0 
	MOVWF       FARG_WriteDisplay_D1+0 
	CLRF        FARG_WriteDisplay_D1_L_P+0 
	CLRF        FARG_WriteDisplay_D1_R_P+0 
	CLRF        R1 
	BTFSC       _toggle_Set+0, BitPos(_toggle_Set+0) 
	INCF        R1, 1 
	MOVF        R1, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_42368
	MOVF        _unidade+0, 0 
	MOVWF       ?FLOC___Menu_42T510+0 
	GOTO        L_Menu_42369
L_Menu_42368:
	MOVLW       15
	MOVWF       ?FLOC___Menu_42T510+0 
L_Menu_42369:
	MOVF        ?FLOC___Menu_42T510+0, 0 
	MOVWF       FARG_WriteDisplay_D0+0 
	CLRF        FARG_WriteDisplay_D0_L_P+0 
	CLRF        FARG_WriteDisplay_D0_R_P+0 
	CLRF        FARG_WriteDisplay_N0+0 
	CLRF        FARG_WriteDisplay_N1+0 
	CALL        _WriteDisplay+0, 0
;Nixie.c,1186 :: 		}
L_end_Menu_42:
	RETURN      0
; end of _Menu_42

_Menu_51:

;Nixie.c,1192 :: 		void Menu_51() {
;Nixie.c,1194 :: 		if (Botao_INC()) Presence = 1;
	CALL        _Botao_INC+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Menu_51370
	BSF         _Presence+0, BitPos(_Presence+0) 
L_Menu_51370:
;Nixie.c,1195 :: 		if (Botao_DEC()) Presence = 0;
	CALL        _Botao_DEC+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Menu_51371
	BCF         _Presence+0, BitPos(_Presence+0) 
L_Menu_51371:
;Nixie.c,1196 :: 		if (Botao_ENT()) { escrever_eeprom(0x08,Presence); MENU = 51;}
	CALL        _Botao_ENT+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Menu_51372
	MOVLW       8
	MOVWF       FARG_escrever_eeprom_address+0 
	MOVLW       0
	BTFSC       _Presence+0, BitPos(_Presence+0) 
	MOVLW       1
	MOVWF       FARG_escrever_eeprom_DADO_EEPROM+0 
	CALL        _escrever_eeprom+0, 0
	MOVLW       51
	MOVWF       _MENU+0 
	MOVLW       0
	MOVWF       _MENU+1 
L_Menu_51372:
;Nixie.c,1198 :: 		WriteDisplay(0x05,0,0,0x01,1,0,0x0F,0,0,0x0F,0,0,0x0F,0,0,toggle_Set == 1 ? (unsigned char)Presence : 0x0F,0,0,0,0);
	MOVLW       5
	MOVWF       FARG_WriteDisplay_D5+0 
	CLRF        FARG_WriteDisplay_D5_L_P+0 
	CLRF        FARG_WriteDisplay_D5_R_P+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D4+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D4_L_P+0 
	CLRF        FARG_WriteDisplay_D4_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D3+0 
	CLRF        FARG_WriteDisplay_D3_L_P+0 
	CLRF        FARG_WriteDisplay_D3_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D2+0 
	CLRF        FARG_WriteDisplay_D2_L_P+0 
	CLRF        FARG_WriteDisplay_D2_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D1+0 
	CLRF        FARG_WriteDisplay_D1_L_P+0 
	CLRF        FARG_WriteDisplay_D1_R_P+0 
	CLRF        R1 
	BTFSC       _toggle_Set+0, BitPos(_toggle_Set+0) 
	INCF        R1, 1 
	MOVF        R1, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_51373
	MOVLW       0
	BTFSC       _Presence+0, BitPos(_Presence+0) 
	MOVLW       1
	MOVWF       ?FLOC___Menu_51T514+0 
	GOTO        L_Menu_51374
L_Menu_51373:
	MOVLW       15
	MOVWF       ?FLOC___Menu_51T514+0 
L_Menu_51374:
	MOVF        ?FLOC___Menu_51T514+0, 0 
	MOVWF       FARG_WriteDisplay_D0+0 
	CLRF        FARG_WriteDisplay_D0_L_P+0 
	CLRF        FARG_WriteDisplay_D0_R_P+0 
	CLRF        FARG_WriteDisplay_N0+0 
	CLRF        FARG_WriteDisplay_N1+0 
	CALL        _WriteDisplay+0, 0
;Nixie.c,1200 :: 		}
L_end_Menu_51:
	RETURN      0
; end of _Menu_51

_Menu_52:

;Nixie.c,1206 :: 		void Menu_52() {
;Nixie.c,1208 :: 		if (Botao_INC() && PresenceTime<60) {PresenceTime += 10; if (PresenceTime == 40) PresenceTime = 60;}
	CALL        _Botao_INC+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Menu_52377
	MOVLW       60
	SUBWF       _PresenceTime+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_Menu_52377
L__Menu_52987:
	MOVLW       10
	ADDWF       _PresenceTime+0, 0 
	MOVWF       R1 
	MOVF        R1, 0 
	MOVWF       _PresenceTime+0 
	MOVF        R1, 0 
	XORLW       40
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_52378
	MOVLW       60
	MOVWF       _PresenceTime+0 
L_Menu_52378:
L_Menu_52377:
;Nixie.c,1209 :: 		if (Botao_DEC() && PresenceTime>10) {PresenceTime -= 10; if (PresenceTime == 50) PresenceTime = 30;}
	CALL        _Botao_DEC+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Menu_52381
	MOVF        _PresenceTime+0, 0 
	SUBLW       10
	BTFSC       STATUS+0, 0 
	GOTO        L_Menu_52381
L__Menu_52986:
	MOVLW       10
	SUBWF       _PresenceTime+0, 0 
	MOVWF       R1 
	MOVF        R1, 0 
	MOVWF       _PresenceTime+0 
	MOVF        R1, 0 
	XORLW       50
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_52382
	MOVLW       30
	MOVWF       _PresenceTime+0 
L_Menu_52382:
L_Menu_52381:
;Nixie.c,1210 :: 		if (Botao_ENT()) { escrever_eeprom(0x09,PresenceTime); MENU = 52;}
	CALL        _Botao_ENT+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Menu_52383
	MOVLW       9
	MOVWF       FARG_escrever_eeprom_address+0 
	MOVF        _PresenceTime+0, 0 
	MOVWF       FARG_escrever_eeprom_DADO_EEPROM+0 
	CALL        _escrever_eeprom+0, 0
	MOVLW       52
	MOVWF       _MENU+0 
	MOVLW       0
	MOVWF       _MENU+1 
L_Menu_52383:
;Nixie.c,1212 :: 		SeparaUnidade(PresenceTime);
	MOVF        _PresenceTime+0, 0 
	MOVWF       FARG_SeparaUnidade_Numero+0 
	MOVLW       0
	MOVWF       FARG_SeparaUnidade_Numero+1 
	MOVWF       FARG_SeparaUnidade_Numero+2 
	MOVWF       FARG_SeparaUnidade_Numero+3 
	CALL        _SeparaUnidade+0, 0
;Nixie.c,1214 :: 		WriteDisplay(0x05,0,0,0x02,1,0,0x0F,0,0,0x0F,0,0,toggle_Set == 1 ? dezena : 0x0F,0,0,toggle_Set == 1 ? unidade : 0x0F,0,0,0,0);
	MOVLW       5
	MOVWF       FARG_WriteDisplay_D5+0 
	CLRF        FARG_WriteDisplay_D5_L_P+0 
	CLRF        FARG_WriteDisplay_D5_R_P+0 
	MOVLW       2
	MOVWF       FARG_WriteDisplay_D4+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D4_L_P+0 
	CLRF        FARG_WriteDisplay_D4_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D3+0 
	CLRF        FARG_WriteDisplay_D3_L_P+0 
	CLRF        FARG_WriteDisplay_D3_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D2+0 
	CLRF        FARG_WriteDisplay_D2_L_P+0 
	CLRF        FARG_WriteDisplay_D2_R_P+0 
	CLRF        R1 
	BTFSC       _toggle_Set+0, BitPos(_toggle_Set+0) 
	INCF        R1, 1 
	MOVF        R1, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_52384
	MOVF        _dezena+0, 0 
	MOVWF       ?FLOC___Menu_52T525+0 
	GOTO        L_Menu_52385
L_Menu_52384:
	MOVLW       15
	MOVWF       ?FLOC___Menu_52T525+0 
L_Menu_52385:
	MOVF        ?FLOC___Menu_52T525+0, 0 
	MOVWF       FARG_WriteDisplay_D1+0 
	CLRF        FARG_WriteDisplay_D1_L_P+0 
	CLRF        FARG_WriteDisplay_D1_R_P+0 
	CLRF        R1 
	BTFSC       _toggle_Set+0, BitPos(_toggle_Set+0) 
	INCF        R1, 1 
	MOVF        R1, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_52386
	MOVF        _unidade+0, 0 
	MOVWF       ?FLOC___Menu_52T528+0 
	GOTO        L_Menu_52387
L_Menu_52386:
	MOVLW       15
	MOVWF       ?FLOC___Menu_52T528+0 
L_Menu_52387:
	MOVF        ?FLOC___Menu_52T528+0, 0 
	MOVWF       FARG_WriteDisplay_D0+0 
	CLRF        FARG_WriteDisplay_D0_L_P+0 
	CLRF        FARG_WriteDisplay_D0_R_P+0 
	CLRF        FARG_WriteDisplay_N0+0 
	CLRF        FARG_WriteDisplay_N1+0 
	CALL        _WriteDisplay+0, 0
;Nixie.c,1216 :: 		}
L_end_Menu_52:
	RETURN      0
; end of _Menu_52

_Menu_53:

;Nixie.c,1222 :: 		void Menu_53() {
;Nixie.c,1224 :: 		if (Botao_INC()) PresenceAuto = 1;
	CALL        _Botao_INC+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Menu_53388
	BSF         _PresenceAuto+0, BitPos(_PresenceAuto+0) 
L_Menu_53388:
;Nixie.c,1225 :: 		if (Botao_DEC()) PresenceAuto = 0;
	CALL        _Botao_DEC+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Menu_53389
	BCF         _PresenceAuto+0, BitPos(_PresenceAuto+0) 
L_Menu_53389:
;Nixie.c,1226 :: 		if (Botao_ENT()) { escrever_eeprom(0x0A,PresenceAuto); MENU = 53;}
	CALL        _Botao_ENT+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Menu_53390
	MOVLW       10
	MOVWF       FARG_escrever_eeprom_address+0 
	MOVLW       0
	BTFSC       _PresenceAuto+0, BitPos(_PresenceAuto+0) 
	MOVLW       1
	MOVWF       FARG_escrever_eeprom_DADO_EEPROM+0 
	CALL        _escrever_eeprom+0, 0
	MOVLW       53
	MOVWF       _MENU+0 
	MOVLW       0
	MOVWF       _MENU+1 
L_Menu_53390:
;Nixie.c,1228 :: 		WriteDisplay(0x05,0,0,0x03,1,0,0x0F,0,0,0x0F,0,0,0x0F,0,0,toggle_Set == 1 ? (unsigned char)PresenceAuto : 0x0F,0,0,0,0);
	MOVLW       5
	MOVWF       FARG_WriteDisplay_D5+0 
	CLRF        FARG_WriteDisplay_D5_L_P+0 
	CLRF        FARG_WriteDisplay_D5_R_P+0 
	MOVLW       3
	MOVWF       FARG_WriteDisplay_D4+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D4_L_P+0 
	CLRF        FARG_WriteDisplay_D4_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D3+0 
	CLRF        FARG_WriteDisplay_D3_L_P+0 
	CLRF        FARG_WriteDisplay_D3_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D2+0 
	CLRF        FARG_WriteDisplay_D2_L_P+0 
	CLRF        FARG_WriteDisplay_D2_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D1+0 
	CLRF        FARG_WriteDisplay_D1_L_P+0 
	CLRF        FARG_WriteDisplay_D1_R_P+0 
	CLRF        R1 
	BTFSC       _toggle_Set+0, BitPos(_toggle_Set+0) 
	INCF        R1, 1 
	MOVF        R1, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_53391
	MOVLW       0
	BTFSC       _PresenceAuto+0, BitPos(_PresenceAuto+0) 
	MOVLW       1
	MOVWF       ?FLOC___Menu_53T532+0 
	GOTO        L_Menu_53392
L_Menu_53391:
	MOVLW       15
	MOVWF       ?FLOC___Menu_53T532+0 
L_Menu_53392:
	MOVF        ?FLOC___Menu_53T532+0, 0 
	MOVWF       FARG_WriteDisplay_D0+0 
	CLRF        FARG_WriteDisplay_D0_L_P+0 
	CLRF        FARG_WriteDisplay_D0_R_P+0 
	CLRF        FARG_WriteDisplay_N0+0 
	CLRF        FARG_WriteDisplay_N1+0 
	CALL        _WriteDisplay+0, 0
;Nixie.c,1230 :: 		}
L_end_Menu_53:
	RETURN      0
; end of _Menu_53

_Menu_61:

;Nixie.c,1236 :: 		void Menu_61() {
;Nixie.c,1238 :: 		if (Botao_INC() && EffectMode<5) EffectMode++;
	CALL        _Botao_INC+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Menu_61395
	MOVLW       5
	SUBWF       _EffectMode+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_Menu_61395
L__Menu_61989:
	INCF        _EffectMode+0, 1 
L_Menu_61395:
;Nixie.c,1239 :: 		if (Botao_DEC() && EffectMode>1) EffectMode--;
	CALL        _Botao_DEC+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Menu_61398
	MOVF        _EffectMode+0, 0 
	SUBLW       1
	BTFSC       STATUS+0, 0 
	GOTO        L_Menu_61398
L__Menu_61988:
	DECF        _EffectMode+0, 1 
L_Menu_61398:
;Nixie.c,1240 :: 		if (Botao_ENT()) { escrever_eeprom(0x0B,EffectMode); MENU = 61;}
	CALL        _Botao_ENT+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Menu_61399
	MOVLW       11
	MOVWF       FARG_escrever_eeprom_address+0 
	MOVF        _EffectMode+0, 0 
	MOVWF       FARG_escrever_eeprom_DADO_EEPROM+0 
	CALL        _escrever_eeprom+0, 0
	MOVLW       61
	MOVWF       _MENU+0 
	MOVLW       0
	MOVWF       _MENU+1 
L_Menu_61399:
;Nixie.c,1242 :: 		WriteDisplay(0x06,0,0,0x01,1,0,0x0F,0,0,0x0F,0,0,0x0F,0,0,toggle_Set == 1 ? EffectMode : 0x0F,0,0,0,0);
	MOVLW       6
	MOVWF       FARG_WriteDisplay_D5+0 
	CLRF        FARG_WriteDisplay_D5_L_P+0 
	CLRF        FARG_WriteDisplay_D5_R_P+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D4+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D4_L_P+0 
	CLRF        FARG_WriteDisplay_D4_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D3+0 
	CLRF        FARG_WriteDisplay_D3_L_P+0 
	CLRF        FARG_WriteDisplay_D3_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D2+0 
	CLRF        FARG_WriteDisplay_D2_L_P+0 
	CLRF        FARG_WriteDisplay_D2_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D1+0 
	CLRF        FARG_WriteDisplay_D1_L_P+0 
	CLRF        FARG_WriteDisplay_D1_R_P+0 
	CLRF        R1 
	BTFSC       _toggle_Set+0, BitPos(_toggle_Set+0) 
	INCF        R1, 1 
	MOVF        R1, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_61400
	MOVF        _EffectMode+0, 0 
	MOVWF       ?FLOC___Menu_61T541+0 
	GOTO        L_Menu_61401
L_Menu_61400:
	MOVLW       15
	MOVWF       ?FLOC___Menu_61T541+0 
L_Menu_61401:
	MOVF        ?FLOC___Menu_61T541+0, 0 
	MOVWF       FARG_WriteDisplay_D0+0 
	CLRF        FARG_WriteDisplay_D0_L_P+0 
	CLRF        FARG_WriteDisplay_D0_R_P+0 
	CLRF        FARG_WriteDisplay_N0+0 
	CLRF        FARG_WriteDisplay_N1+0 
	CALL        _WriteDisplay+0, 0
;Nixie.c,1244 :: 		}
L_end_Menu_61:
	RETURN      0
; end of _Menu_61

_Menu_62:

;Nixie.c,1250 :: 		void Menu_62() {
;Nixie.c,1252 :: 		if (Botao_INC()) Cathode = 1;
	CALL        _Botao_INC+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Menu_62402
	BSF         _Cathode+0, BitPos(_Cathode+0) 
L_Menu_62402:
;Nixie.c,1253 :: 		if (Botao_DEC()) Cathode = 0;
	CALL        _Botao_DEC+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Menu_62403
	BCF         _Cathode+0, BitPos(_Cathode+0) 
L_Menu_62403:
;Nixie.c,1254 :: 		if (Botao_ENT()) { escrever_eeprom(0x0C,Cathode); MENU = 62;}
	CALL        _Botao_ENT+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Menu_62404
	MOVLW       12
	MOVWF       FARG_escrever_eeprom_address+0 
	MOVLW       0
	BTFSC       _Cathode+0, BitPos(_Cathode+0) 
	MOVLW       1
	MOVWF       FARG_escrever_eeprom_DADO_EEPROM+0 
	CALL        _escrever_eeprom+0, 0
	MOVLW       62
	MOVWF       _MENU+0 
	MOVLW       0
	MOVWF       _MENU+1 
L_Menu_62404:
;Nixie.c,1256 :: 		WriteDisplay(0x06,0,0,0x02,1,0,0x0F,0,0,0x0F,0,0,0x0F,0,0,toggle_Set == 1 ? (unsigned char)Cathode : 0x0F,0,0,0,0);
	MOVLW       6
	MOVWF       FARG_WriteDisplay_D5+0 
	CLRF        FARG_WriteDisplay_D5_L_P+0 
	CLRF        FARG_WriteDisplay_D5_R_P+0 
	MOVLW       2
	MOVWF       FARG_WriteDisplay_D4+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D4_L_P+0 
	CLRF        FARG_WriteDisplay_D4_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D3+0 
	CLRF        FARG_WriteDisplay_D3_L_P+0 
	CLRF        FARG_WriteDisplay_D3_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D2+0 
	CLRF        FARG_WriteDisplay_D2_L_P+0 
	CLRF        FARG_WriteDisplay_D2_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D1+0 
	CLRF        FARG_WriteDisplay_D1_L_P+0 
	CLRF        FARG_WriteDisplay_D1_R_P+0 
	CLRF        R1 
	BTFSC       _toggle_Set+0, BitPos(_toggle_Set+0) 
	INCF        R1, 1 
	MOVF        R1, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_62405
	MOVLW       0
	BTFSC       _Cathode+0, BitPos(_Cathode+0) 
	MOVLW       1
	MOVWF       ?FLOC___Menu_62T545+0 
	GOTO        L_Menu_62406
L_Menu_62405:
	MOVLW       15
	MOVWF       ?FLOC___Menu_62T545+0 
L_Menu_62406:
	MOVF        ?FLOC___Menu_62T545+0, 0 
	MOVWF       FARG_WriteDisplay_D0+0 
	CLRF        FARG_WriteDisplay_D0_L_P+0 
	CLRF        FARG_WriteDisplay_D0_R_P+0 
	CLRF        FARG_WriteDisplay_N0+0 
	CLRF        FARG_WriteDisplay_N1+0 
	CALL        _WriteDisplay+0, 0
;Nixie.c,1258 :: 		}
L_end_Menu_62:
	RETURN      0
; end of _Menu_62

_Menu_63:

;Nixie.c,1264 :: 		void Menu_63() {
;Nixie.c,1266 :: 		if (Botao_INC() && CathodeTime<90) {CathodeTime += 15; if (CathodeTime == 75) CathodeTime = 90;}
	CALL        _Botao_INC+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Menu_63409
	MOVLW       90
	SUBWF       _CathodeTime+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_Menu_63409
L__Menu_63991:
	MOVLW       15
	ADDWF       _CathodeTime+0, 0 
	MOVWF       R1 
	MOVF        R1, 0 
	MOVWF       _CathodeTime+0 
	MOVF        R1, 0 
	XORLW       75
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_63410
	MOVLW       90
	MOVWF       _CathodeTime+0 
L_Menu_63410:
L_Menu_63409:
;Nixie.c,1267 :: 		if (Botao_DEC() && CathodeTime>15) {CathodeTime -= 15; if (CathodeTime == 75) CathodeTime = 60;}
	CALL        _Botao_DEC+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Menu_63413
	MOVF        _CathodeTime+0, 0 
	SUBLW       15
	BTFSC       STATUS+0, 0 
	GOTO        L_Menu_63413
L__Menu_63990:
	MOVLW       15
	SUBWF       _CathodeTime+0, 0 
	MOVWF       R1 
	MOVF        R1, 0 
	MOVWF       _CathodeTime+0 
	MOVF        R1, 0 
	XORLW       75
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_63414
	MOVLW       60
	MOVWF       _CathodeTime+0 
L_Menu_63414:
L_Menu_63413:
;Nixie.c,1268 :: 		if (Botao_ENT()) { escrever_eeprom(0x0D,CathodeTime); MENU = 63;}
	CALL        _Botao_ENT+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Menu_63415
	MOVLW       13
	MOVWF       FARG_escrever_eeprom_address+0 
	MOVF        _CathodeTime+0, 0 
	MOVWF       FARG_escrever_eeprom_DADO_EEPROM+0 
	CALL        _escrever_eeprom+0, 0
	MOVLW       63
	MOVWF       _MENU+0 
	MOVLW       0
	MOVWF       _MENU+1 
L_Menu_63415:
;Nixie.c,1270 :: 		SeparaUnidade(CathodeTime);
	MOVF        _CathodeTime+0, 0 
	MOVWF       FARG_SeparaUnidade_Numero+0 
	MOVLW       0
	MOVWF       FARG_SeparaUnidade_Numero+1 
	MOVWF       FARG_SeparaUnidade_Numero+2 
	MOVWF       FARG_SeparaUnidade_Numero+3 
	CALL        _SeparaUnidade+0, 0
;Nixie.c,1272 :: 		WriteDisplay(0x06,0,0,0x03,1,0,0x0F,0,0,0x0F,0,0,toggle_Set == 1 ? dezena : 0x0F,0,0,toggle_Set == 1 ? unidade : 0x0F,0,0,0,0);
	MOVLW       6
	MOVWF       FARG_WriteDisplay_D5+0 
	CLRF        FARG_WriteDisplay_D5_L_P+0 
	CLRF        FARG_WriteDisplay_D5_R_P+0 
	MOVLW       3
	MOVWF       FARG_WriteDisplay_D4+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D4_L_P+0 
	CLRF        FARG_WriteDisplay_D4_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D3+0 
	CLRF        FARG_WriteDisplay_D3_L_P+0 
	CLRF        FARG_WriteDisplay_D3_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D2+0 
	CLRF        FARG_WriteDisplay_D2_L_P+0 
	CLRF        FARG_WriteDisplay_D2_R_P+0 
	CLRF        R1 
	BTFSC       _toggle_Set+0, BitPos(_toggle_Set+0) 
	INCF        R1, 1 
	MOVF        R1, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_63416
	MOVF        _dezena+0, 0 
	MOVWF       ?FLOC___Menu_63T556+0 
	GOTO        L_Menu_63417
L_Menu_63416:
	MOVLW       15
	MOVWF       ?FLOC___Menu_63T556+0 
L_Menu_63417:
	MOVF        ?FLOC___Menu_63T556+0, 0 
	MOVWF       FARG_WriteDisplay_D1+0 
	CLRF        FARG_WriteDisplay_D1_L_P+0 
	CLRF        FARG_WriteDisplay_D1_R_P+0 
	CLRF        R1 
	BTFSC       _toggle_Set+0, BitPos(_toggle_Set+0) 
	INCF        R1, 1 
	MOVF        R1, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_63418
	MOVF        _unidade+0, 0 
	MOVWF       ?FLOC___Menu_63T559+0 
	GOTO        L_Menu_63419
L_Menu_63418:
	MOVLW       15
	MOVWF       ?FLOC___Menu_63T559+0 
L_Menu_63419:
	MOVF        ?FLOC___Menu_63T559+0, 0 
	MOVWF       FARG_WriteDisplay_D0+0 
	CLRF        FARG_WriteDisplay_D0_L_P+0 
	CLRF        FARG_WriteDisplay_D0_R_P+0 
	CLRF        FARG_WriteDisplay_N0+0 
	CLRF        FARG_WriteDisplay_N1+0 
	CALL        _WriteDisplay+0, 0
;Nixie.c,1274 :: 		}
L_end_Menu_63:
	RETURN      0
; end of _Menu_63

_Menu_71:

;Nixie.c,1280 :: 		void Menu_71() {
;Nixie.c,1282 :: 		if (Botao_INC()) AutoOffOn = 1;
	CALL        _Botao_INC+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Menu_71420
	BSF         _AutoOffOn+0, BitPos(_AutoOffOn+0) 
L_Menu_71420:
;Nixie.c,1283 :: 		if (Botao_DEC()) AutoOffOn = 0;
	CALL        _Botao_DEC+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Menu_71421
	BCF         _AutoOffOn+0, BitPos(_AutoOffOn+0) 
L_Menu_71421:
;Nixie.c,1284 :: 		if (Botao_ENT()) { escrever_eeprom(0x0E,AutoOffOn); MENU = 71;}
	CALL        _Botao_ENT+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Menu_71422
	MOVLW       14
	MOVWF       FARG_escrever_eeprom_address+0 
	MOVLW       0
	BTFSC       _AutoOffOn+0, BitPos(_AutoOffOn+0) 
	MOVLW       1
	MOVWF       FARG_escrever_eeprom_DADO_EEPROM+0 
	CALL        _escrever_eeprom+0, 0
	MOVLW       71
	MOVWF       _MENU+0 
	MOVLW       0
	MOVWF       _MENU+1 
L_Menu_71422:
;Nixie.c,1286 :: 		WriteDisplay(0x07,0,0,0x01,1,0,0x0F,0,0,0x0F,0,0,0x0F,0,0,toggle_Set == 1 ? (unsigned char)AutoOffOn : 0x0F,0,0,0,0);
	MOVLW       7
	MOVWF       FARG_WriteDisplay_D5+0 
	CLRF        FARG_WriteDisplay_D5_L_P+0 
	CLRF        FARG_WriteDisplay_D5_R_P+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D4+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D4_L_P+0 
	CLRF        FARG_WriteDisplay_D4_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D3+0 
	CLRF        FARG_WriteDisplay_D3_L_P+0 
	CLRF        FARG_WriteDisplay_D3_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D2+0 
	CLRF        FARG_WriteDisplay_D2_L_P+0 
	CLRF        FARG_WriteDisplay_D2_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D1+0 
	CLRF        FARG_WriteDisplay_D1_L_P+0 
	CLRF        FARG_WriteDisplay_D1_R_P+0 
	CLRF        R1 
	BTFSC       _toggle_Set+0, BitPos(_toggle_Set+0) 
	INCF        R1, 1 
	MOVF        R1, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_71423
	MOVLW       0
	BTFSC       _AutoOffOn+0, BitPos(_AutoOffOn+0) 
	MOVLW       1
	MOVWF       ?FLOC___Menu_71T563+0 
	GOTO        L_Menu_71424
L_Menu_71423:
	MOVLW       15
	MOVWF       ?FLOC___Menu_71T563+0 
L_Menu_71424:
	MOVF        ?FLOC___Menu_71T563+0, 0 
	MOVWF       FARG_WriteDisplay_D0+0 
	CLRF        FARG_WriteDisplay_D0_L_P+0 
	CLRF        FARG_WriteDisplay_D0_R_P+0 
	CLRF        FARG_WriteDisplay_N0+0 
	CLRF        FARG_WriteDisplay_N1+0 
	CALL        _WriteDisplay+0, 0
;Nixie.c,1288 :: 		}
L_end_Menu_71:
	RETURN      0
; end of _Menu_71

_Menu_72_MIN:

;Nixie.c,1294 :: 		void Menu_72_MIN() {
;Nixie.c,1296 :: 		if (Botao_INC()) {Display_Off_Minute = Dec2Bcd(Bcd2Dec(Display_Off_Minute)+1); if (Display_Off_Minute == 0x60) Display_Off_Minute = 0x00;}
	CALL        _Botao_INC+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Menu_72_MIN425
	MOVF        _Display_Off_Minute+0, 0 
	MOVWF       FARG_Bcd2Dec_bcdnum+0 
	CALL        _Bcd2Dec+0, 0
	MOVF        R0, 0 
	ADDLW       1
	MOVWF       FARG_Dec2Bcd_decnum+0 
	CALL        _Dec2Bcd+0, 0
	MOVF        R0, 0 
	MOVWF       _Display_Off_Minute+0 
	MOVF        R0, 0 
	XORLW       96
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_72_MIN426
	CLRF        _Display_Off_Minute+0 
L_Menu_72_MIN426:
L_Menu_72_MIN425:
;Nixie.c,1297 :: 		if (Botao_DEC()) {Display_Off_Minute = Dec2Bcd(Bcd2Dec(Display_Off_Minute)-1); if (Display_Off_Minute == Dec2Bcd(-1)) Display_Off_Minute = 0x59;}
	CALL        _Botao_DEC+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Menu_72_MIN427
	MOVF        _Display_Off_Minute+0, 0 
	MOVWF       FARG_Bcd2Dec_bcdnum+0 
	CALL        _Bcd2Dec+0, 0
	DECF        R0, 0 
	MOVWF       FARG_Dec2Bcd_decnum+0 
	CALL        _Dec2Bcd+0, 0
	MOVF        R0, 0 
	MOVWF       _Display_Off_Minute+0 
	MOVLW       255
	MOVWF       FARG_Dec2Bcd_decnum+0 
	CALL        _Dec2Bcd+0, 0
	MOVF        _Display_Off_Minute+0, 0 
	XORWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_72_MIN428
	MOVLW       89
	MOVWF       _Display_Off_Minute+0 
L_Menu_72_MIN428:
L_Menu_72_MIN427:
;Nixie.c,1298 :: 		if (Botao_ENT()) {MENU = 721;}
	CALL        _Botao_ENT+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Menu_72_MIN429
	MOVLW       209
	MOVWF       _MENU+0 
	MOVLW       2
	MOVWF       _MENU+1 
L_Menu_72_MIN429:
;Nixie.c,1300 :: 		WriteDisplay(0x07,0,0,0x02,1,0,(Display_Off_Hour >> 4),Display_Off_PM,0,(Display_Off_Hour & 0x0F),0,0,toggle_Set == 1 ? (Display_Off_Minute >> 4) : 0x0F,0,0,toggle_Set == 1 ? (Display_Off_Minute & 0x0F) : 0x0F,0,0,1,0);
	MOVLW       7
	MOVWF       FARG_WriteDisplay_D5+0 
	CLRF        FARG_WriteDisplay_D5_L_P+0 
	CLRF        FARG_WriteDisplay_D5_R_P+0 
	MOVLW       2
	MOVWF       FARG_WriteDisplay_D4+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D4_L_P+0 
	CLRF        FARG_WriteDisplay_D4_R_P+0 
	MOVF        _Display_Off_Hour+0, 0 
	MOVWF       FARG_WriteDisplay_D3+0 
	RRCF        FARG_WriteDisplay_D3+0, 1 
	BCF         FARG_WriteDisplay_D3+0, 7 
	RRCF        FARG_WriteDisplay_D3+0, 1 
	BCF         FARG_WriteDisplay_D3+0, 7 
	RRCF        FARG_WriteDisplay_D3+0, 1 
	BCF         FARG_WriteDisplay_D3+0, 7 
	RRCF        FARG_WriteDisplay_D3+0, 1 
	BCF         FARG_WriteDisplay_D3+0, 7 
	MOVF        _Display_Off_PM+0, 0 
	MOVWF       FARG_WriteDisplay_D3_L_P+0 
	CLRF        FARG_WriteDisplay_D3_R_P+0 
	MOVLW       15
	ANDWF       _Display_Off_Hour+0, 0 
	MOVWF       FARG_WriteDisplay_D2+0 
	CLRF        FARG_WriteDisplay_D2_L_P+0 
	CLRF        FARG_WriteDisplay_D2_R_P+0 
	CLRF        R1 
	BTFSC       _toggle_Set+0, BitPos(_toggle_Set+0) 
	INCF        R1, 1 
	MOVF        R1, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_72_MIN430
	MOVF        _Display_Off_Minute+0, 0 
	MOVWF       ?FLOC___Menu_72_MINT573+0 
	RRCF        ?FLOC___Menu_72_MINT573+0, 1 
	BCF         ?FLOC___Menu_72_MINT573+0, 7 
	RRCF        ?FLOC___Menu_72_MINT573+0, 1 
	BCF         ?FLOC___Menu_72_MINT573+0, 7 
	RRCF        ?FLOC___Menu_72_MINT573+0, 1 
	BCF         ?FLOC___Menu_72_MINT573+0, 7 
	RRCF        ?FLOC___Menu_72_MINT573+0, 1 
	BCF         ?FLOC___Menu_72_MINT573+0, 7 
	GOTO        L_Menu_72_MIN431
L_Menu_72_MIN430:
	MOVLW       15
	MOVWF       ?FLOC___Menu_72_MINT573+0 
L_Menu_72_MIN431:
	MOVF        ?FLOC___Menu_72_MINT573+0, 0 
	MOVWF       FARG_WriteDisplay_D1+0 
	CLRF        FARG_WriteDisplay_D1_L_P+0 
	CLRF        FARG_WriteDisplay_D1_R_P+0 
	CLRF        R1 
	BTFSC       _toggle_Set+0, BitPos(_toggle_Set+0) 
	INCF        R1, 1 
	MOVF        R1, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_72_MIN432
	MOVLW       15
	ANDWF       _Display_Off_Minute+0, 0 
	MOVWF       ?FLOC___Menu_72_MINT577+0 
	GOTO        L_Menu_72_MIN433
L_Menu_72_MIN432:
	MOVLW       15
	MOVWF       ?FLOC___Menu_72_MINT577+0 
L_Menu_72_MIN433:
	MOVF        ?FLOC___Menu_72_MINT577+0, 0 
	MOVWF       FARG_WriteDisplay_D0+0 
	CLRF        FARG_WriteDisplay_D0_L_P+0 
	CLRF        FARG_WriteDisplay_D0_R_P+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_N0+0 
	CLRF        FARG_WriteDisplay_N1+0 
	CALL        _WriteDisplay+0, 0
;Nixie.c,1302 :: 		}
L_end_Menu_72_MIN:
	RETURN      0
; end of _Menu_72_MIN

_Menu_72_HOUR:

;Nixie.c,1308 :: 		void Menu_72_HOUR() {
;Nixie.c,1310 :: 		if (Mode12h) {
	BTFSS       _Mode12h+0, BitPos(_Mode12h+0) 
	GOTO        L_Menu_72_HOUR434
;Nixie.c,1311 :: 		if (Botao_INC()) {Display_Off_Hour = Dec2Bcd(Bcd2Dec(Display_Off_Hour)+1); if (Display_Off_Hour == 0x12) Display_Off_PM = !Display_Off_PM; if (Display_Off_Hour == 0x13) Display_Off_Hour = 0x01;}
	CALL        _Botao_INC+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Menu_72_HOUR435
	MOVF        _Display_Off_Hour+0, 0 
	MOVWF       FARG_Bcd2Dec_bcdnum+0 
	CALL        _Bcd2Dec+0, 0
	MOVF        R0, 0 
	ADDLW       1
	MOVWF       FARG_Dec2Bcd_decnum+0 
	CALL        _Dec2Bcd+0, 0
	MOVF        R0, 0 
	MOVWF       _Display_Off_Hour+0 
	MOVF        R0, 0 
	XORLW       18
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_72_HOUR436
	MOVF        _Display_Off_PM+0, 1 
	MOVLW       1
	BTFSS       STATUS+0, 2 
	MOVLW       0
	MOVWF       _Display_Off_PM+0 
L_Menu_72_HOUR436:
	MOVF        _Display_Off_Hour+0, 0 
	XORLW       19
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_72_HOUR437
	MOVLW       1
	MOVWF       _Display_Off_Hour+0 
L_Menu_72_HOUR437:
L_Menu_72_HOUR435:
;Nixie.c,1312 :: 		if (Botao_DEC()) {Display_Off_Hour = Dec2Bcd(Bcd2Dec(Display_Off_Hour)-1); if (Display_Off_Hour == 0x11) Display_Off_PM = !Display_Off_PM; if (Display_Off_Hour == 0x00) Display_Off_Hour = 0x12;}
	CALL        _Botao_DEC+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Menu_72_HOUR438
	MOVF        _Display_Off_Hour+0, 0 
	MOVWF       FARG_Bcd2Dec_bcdnum+0 
	CALL        _Bcd2Dec+0, 0
	DECF        R0, 0 
	MOVWF       FARG_Dec2Bcd_decnum+0 
	CALL        _Dec2Bcd+0, 0
	MOVF        R0, 0 
	MOVWF       _Display_Off_Hour+0 
	MOVF        R0, 0 
	XORLW       17
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_72_HOUR439
	MOVF        _Display_Off_PM+0, 1 
	MOVLW       1
	BTFSS       STATUS+0, 2 
	MOVLW       0
	MOVWF       _Display_Off_PM+0 
L_Menu_72_HOUR439:
	MOVF        _Display_Off_Hour+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_72_HOUR440
	MOVLW       18
	MOVWF       _Display_Off_Hour+0 
L_Menu_72_HOUR440:
L_Menu_72_HOUR438:
;Nixie.c,1314 :: 		} else {
	GOTO        L_Menu_72_HOUR441
L_Menu_72_HOUR434:
;Nixie.c,1315 :: 		if (Botao_INC()) {Display_Off_Hour = Dec2Bcd(Bcd2Dec(Display_Off_Hour)+1); if (Display_Off_Hour == 0x24) Display_Off_Hour = 0x00;}
	CALL        _Botao_INC+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Menu_72_HOUR442
	MOVF        _Display_Off_Hour+0, 0 
	MOVWF       FARG_Bcd2Dec_bcdnum+0 
	CALL        _Bcd2Dec+0, 0
	MOVF        R0, 0 
	ADDLW       1
	MOVWF       FARG_Dec2Bcd_decnum+0 
	CALL        _Dec2Bcd+0, 0
	MOVF        R0, 0 
	MOVWF       _Display_Off_Hour+0 
	MOVF        R0, 0 
	XORLW       36
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_72_HOUR443
	CLRF        _Display_Off_Hour+0 
L_Menu_72_HOUR443:
L_Menu_72_HOUR442:
;Nixie.c,1316 :: 		if (Botao_DEC()) {Display_Off_Hour = Dec2Bcd(Bcd2Dec(Display_Off_Hour)-1); if (Display_Off_Hour == Dec2Bcd(-1)) Display_Off_Hour = 0x23;}
	CALL        _Botao_DEC+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Menu_72_HOUR444
	MOVF        _Display_Off_Hour+0, 0 
	MOVWF       FARG_Bcd2Dec_bcdnum+0 
	CALL        _Bcd2Dec+0, 0
	DECF        R0, 0 
	MOVWF       FARG_Dec2Bcd_decnum+0 
	CALL        _Dec2Bcd+0, 0
	MOVF        R0, 0 
	MOVWF       _Display_Off_Hour+0 
	MOVLW       255
	MOVWF       FARG_Dec2Bcd_decnum+0 
	CALL        _Dec2Bcd+0, 0
	MOVF        _Display_Off_Hour+0, 0 
	XORWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_72_HOUR445
	MOVLW       35
	MOVWF       _Display_Off_Hour+0 
L_Menu_72_HOUR445:
L_Menu_72_HOUR444:
;Nixie.c,1317 :: 		}
L_Menu_72_HOUR441:
;Nixie.c,1318 :: 		if (Botao_ENT()) {escrever_eeprom(0x0F,Display_Off_Hour); escrever_eeprom(0x10,Display_Off_Minute); escrever_eeprom(0x11,Display_Off_PM); MENU = 72;}
	CALL        _Botao_ENT+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Menu_72_HOUR446
	MOVLW       15
	MOVWF       FARG_escrever_eeprom_address+0 
	MOVF        _Display_Off_Hour+0, 0 
	MOVWF       FARG_escrever_eeprom_DADO_EEPROM+0 
	CALL        _escrever_eeprom+0, 0
	MOVLW       16
	MOVWF       FARG_escrever_eeprom_address+0 
	MOVF        _Display_Off_Minute+0, 0 
	MOVWF       FARG_escrever_eeprom_DADO_EEPROM+0 
	CALL        _escrever_eeprom+0, 0
	MOVLW       17
	MOVWF       FARG_escrever_eeprom_address+0 
	MOVF        _Display_Off_PM+0, 0 
	MOVWF       FARG_escrever_eeprom_DADO_EEPROM+0 
	CALL        _escrever_eeprom+0, 0
	MOVLW       72
	MOVWF       _MENU+0 
	MOVLW       0
	MOVWF       _MENU+1 
L_Menu_72_HOUR446:
;Nixie.c,1320 :: 		WriteDisplay(0x07,0,0,0x02,1,0,toggle_Set == 1 ? (Display_Off_Hour >> 4) : 0x0F,toggle_Set == 1 ? Display_Off_PM : 0,0,toggle_Set == 1 ? (Display_Off_Hour & 0x0F) : 0x0F,0,0,(Display_Off_Minute >> 4),0,0,(Display_Off_Minute & 0x0F),0,0,1,0);
	MOVLW       7
	MOVWF       FARG_WriteDisplay_D5+0 
	CLRF        FARG_WriteDisplay_D5_L_P+0 
	CLRF        FARG_WriteDisplay_D5_R_P+0 
	MOVLW       2
	MOVWF       FARG_WriteDisplay_D4+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D4_L_P+0 
	CLRF        FARG_WriteDisplay_D4_R_P+0 
	CLRF        R1 
	BTFSC       _toggle_Set+0, BitPos(_toggle_Set+0) 
	INCF        R1, 1 
	MOVF        R1, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_72_HOUR447
	MOVF        _Display_Off_Hour+0, 0 
	MOVWF       ?FLOC___Menu_72_HOURT593+0 
	RRCF        ?FLOC___Menu_72_HOURT593+0, 1 
	BCF         ?FLOC___Menu_72_HOURT593+0, 7 
	RRCF        ?FLOC___Menu_72_HOURT593+0, 1 
	BCF         ?FLOC___Menu_72_HOURT593+0, 7 
	RRCF        ?FLOC___Menu_72_HOURT593+0, 1 
	BCF         ?FLOC___Menu_72_HOURT593+0, 7 
	RRCF        ?FLOC___Menu_72_HOURT593+0, 1 
	BCF         ?FLOC___Menu_72_HOURT593+0, 7 
	GOTO        L_Menu_72_HOUR448
L_Menu_72_HOUR447:
	MOVLW       15
	MOVWF       ?FLOC___Menu_72_HOURT593+0 
L_Menu_72_HOUR448:
	MOVF        ?FLOC___Menu_72_HOURT593+0, 0 
	MOVWF       FARG_WriteDisplay_D3+0 
	CLRF        R1 
	BTFSC       _toggle_Set+0, BitPos(_toggle_Set+0) 
	INCF        R1, 1 
	MOVF        R1, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_72_HOUR449
	MOVF        _Display_Off_PM+0, 0 
	MOVWF       ?FLOC___Menu_72_HOURT596+0 
	GOTO        L_Menu_72_HOUR450
L_Menu_72_HOUR449:
	CLRF        ?FLOC___Menu_72_HOURT596+0 
L_Menu_72_HOUR450:
	MOVF        ?FLOC___Menu_72_HOURT596+0, 0 
	MOVWF       FARG_WriteDisplay_D3_L_P+0 
	CLRF        FARG_WriteDisplay_D3_R_P+0 
	CLRF        R1 
	BTFSC       _toggle_Set+0, BitPos(_toggle_Set+0) 
	INCF        R1, 1 
	MOVF        R1, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_72_HOUR451
	MOVLW       15
	ANDWF       _Display_Off_Hour+0, 0 
	MOVWF       ?FLOC___Menu_72_HOURT600+0 
	GOTO        L_Menu_72_HOUR452
L_Menu_72_HOUR451:
	MOVLW       15
	MOVWF       ?FLOC___Menu_72_HOURT600+0 
L_Menu_72_HOUR452:
	MOVF        ?FLOC___Menu_72_HOURT600+0, 0 
	MOVWF       FARG_WriteDisplay_D2+0 
	CLRF        FARG_WriteDisplay_D2_L_P+0 
	CLRF        FARG_WriteDisplay_D2_R_P+0 
	MOVF        _Display_Off_Minute+0, 0 
	MOVWF       FARG_WriteDisplay_D1+0 
	RRCF        FARG_WriteDisplay_D1+0, 1 
	BCF         FARG_WriteDisplay_D1+0, 7 
	RRCF        FARG_WriteDisplay_D1+0, 1 
	BCF         FARG_WriteDisplay_D1+0, 7 
	RRCF        FARG_WriteDisplay_D1+0, 1 
	BCF         FARG_WriteDisplay_D1+0, 7 
	RRCF        FARG_WriteDisplay_D1+0, 1 
	BCF         FARG_WriteDisplay_D1+0, 7 
	CLRF        FARG_WriteDisplay_D1_L_P+0 
	CLRF        FARG_WriteDisplay_D1_R_P+0 
	MOVLW       15
	ANDWF       _Display_Off_Minute+0, 0 
	MOVWF       FARG_WriteDisplay_D0+0 
	CLRF        FARG_WriteDisplay_D0_L_P+0 
	CLRF        FARG_WriteDisplay_D0_R_P+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_N0+0 
	CLRF        FARG_WriteDisplay_N1+0 
	CALL        _WriteDisplay+0, 0
;Nixie.c,1322 :: 		}
L_end_Menu_72_HOUR:
	RETURN      0
; end of _Menu_72_HOUR

_Menu_73_MIN:

;Nixie.c,1328 :: 		void Menu_73_MIN() {
;Nixie.c,1330 :: 		if (Botao_INC()) {Display_On_Minute = Dec2Bcd(Bcd2Dec(Display_On_Minute)+1); if (Display_On_Minute == 0x60) Display_On_Minute = 0x00;}
	CALL        _Botao_INC+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Menu_73_MIN453
	MOVF        _Display_On_Minute+0, 0 
	MOVWF       FARG_Bcd2Dec_bcdnum+0 
	CALL        _Bcd2Dec+0, 0
	MOVF        R0, 0 
	ADDLW       1
	MOVWF       FARG_Dec2Bcd_decnum+0 
	CALL        _Dec2Bcd+0, 0
	MOVF        R0, 0 
	MOVWF       _Display_On_Minute+0 
	MOVF        R0, 0 
	XORLW       96
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_73_MIN454
	CLRF        _Display_On_Minute+0 
L_Menu_73_MIN454:
L_Menu_73_MIN453:
;Nixie.c,1331 :: 		if (Botao_DEC()) {Display_On_Minute = Dec2Bcd(Bcd2Dec(Display_On_Minute)-1); if (Display_On_Minute == Dec2Bcd(-1)) Display_On_Minute = 0x59;}
	CALL        _Botao_DEC+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Menu_73_MIN455
	MOVF        _Display_On_Minute+0, 0 
	MOVWF       FARG_Bcd2Dec_bcdnum+0 
	CALL        _Bcd2Dec+0, 0
	DECF        R0, 0 
	MOVWF       FARG_Dec2Bcd_decnum+0 
	CALL        _Dec2Bcd+0, 0
	MOVF        R0, 0 
	MOVWF       _Display_On_Minute+0 
	MOVLW       255
	MOVWF       FARG_Dec2Bcd_decnum+0 
	CALL        _Dec2Bcd+0, 0
	MOVF        _Display_On_Minute+0, 0 
	XORWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_73_MIN456
	MOVLW       89
	MOVWF       _Display_On_Minute+0 
L_Menu_73_MIN456:
L_Menu_73_MIN455:
;Nixie.c,1332 :: 		if (Botao_ENT()) {MENU = 731;}
	CALL        _Botao_ENT+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Menu_73_MIN457
	MOVLW       219
	MOVWF       _MENU+0 
	MOVLW       2
	MOVWF       _MENU+1 
L_Menu_73_MIN457:
;Nixie.c,1334 :: 		WriteDisplay(0x07,0,0,0x03,1,0,(Display_On_Hour >> 4),Display_On_PM,0,(Display_On_Hour & 0x0F),0,0,toggle_Set == 1 ? (Display_On_Minute >> 4) : 0x0F,0,0,toggle_Set == 1 ? (Display_On_Minute & 0x0F) : 0x0F,0,0,1,0);
	MOVLW       7
	MOVWF       FARG_WriteDisplay_D5+0 
	CLRF        FARG_WriteDisplay_D5_L_P+0 
	CLRF        FARG_WriteDisplay_D5_R_P+0 
	MOVLW       3
	MOVWF       FARG_WriteDisplay_D4+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D4_L_P+0 
	CLRF        FARG_WriteDisplay_D4_R_P+0 
	MOVF        _Display_On_Hour+0, 0 
	MOVWF       FARG_WriteDisplay_D3+0 
	RRCF        FARG_WriteDisplay_D3+0, 1 
	BCF         FARG_WriteDisplay_D3+0, 7 
	RRCF        FARG_WriteDisplay_D3+0, 1 
	BCF         FARG_WriteDisplay_D3+0, 7 
	RRCF        FARG_WriteDisplay_D3+0, 1 
	BCF         FARG_WriteDisplay_D3+0, 7 
	RRCF        FARG_WriteDisplay_D3+0, 1 
	BCF         FARG_WriteDisplay_D3+0, 7 
	MOVF        _Display_On_PM+0, 0 
	MOVWF       FARG_WriteDisplay_D3_L_P+0 
	CLRF        FARG_WriteDisplay_D3_R_P+0 
	MOVLW       15
	ANDWF       _Display_On_Hour+0, 0 
	MOVWF       FARG_WriteDisplay_D2+0 
	CLRF        FARG_WriteDisplay_D2_L_P+0 
	CLRF        FARG_WriteDisplay_D2_R_P+0 
	CLRF        R1 
	BTFSC       _toggle_Set+0, BitPos(_toggle_Set+0) 
	INCF        R1, 1 
	MOVF        R1, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_73_MIN458
	MOVF        _Display_On_Minute+0, 0 
	MOVWF       ?FLOC___Menu_73_MINT612+0 
	RRCF        ?FLOC___Menu_73_MINT612+0, 1 
	BCF         ?FLOC___Menu_73_MINT612+0, 7 
	RRCF        ?FLOC___Menu_73_MINT612+0, 1 
	BCF         ?FLOC___Menu_73_MINT612+0, 7 
	RRCF        ?FLOC___Menu_73_MINT612+0, 1 
	BCF         ?FLOC___Menu_73_MINT612+0, 7 
	RRCF        ?FLOC___Menu_73_MINT612+0, 1 
	BCF         ?FLOC___Menu_73_MINT612+0, 7 
	GOTO        L_Menu_73_MIN459
L_Menu_73_MIN458:
	MOVLW       15
	MOVWF       ?FLOC___Menu_73_MINT612+0 
L_Menu_73_MIN459:
	MOVF        ?FLOC___Menu_73_MINT612+0, 0 
	MOVWF       FARG_WriteDisplay_D1+0 
	CLRF        FARG_WriteDisplay_D1_L_P+0 
	CLRF        FARG_WriteDisplay_D1_R_P+0 
	CLRF        R1 
	BTFSC       _toggle_Set+0, BitPos(_toggle_Set+0) 
	INCF        R1, 1 
	MOVF        R1, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_73_MIN460
	MOVLW       15
	ANDWF       _Display_On_Minute+0, 0 
	MOVWF       ?FLOC___Menu_73_MINT616+0 
	GOTO        L_Menu_73_MIN461
L_Menu_73_MIN460:
	MOVLW       15
	MOVWF       ?FLOC___Menu_73_MINT616+0 
L_Menu_73_MIN461:
	MOVF        ?FLOC___Menu_73_MINT616+0, 0 
	MOVWF       FARG_WriteDisplay_D0+0 
	CLRF        FARG_WriteDisplay_D0_L_P+0 
	CLRF        FARG_WriteDisplay_D0_R_P+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_N0+0 
	CLRF        FARG_WriteDisplay_N1+0 
	CALL        _WriteDisplay+0, 0
;Nixie.c,1336 :: 		}
L_end_Menu_73_MIN:
	RETURN      0
; end of _Menu_73_MIN

_Menu_73_HOUR:

;Nixie.c,1342 :: 		void Menu_73_HOUR() {
;Nixie.c,1344 :: 		if (Mode12h) {
	BTFSS       _Mode12h+0, BitPos(_Mode12h+0) 
	GOTO        L_Menu_73_HOUR462
;Nixie.c,1345 :: 		if (Botao_INC()) {Display_On_Hour = Dec2Bcd(Bcd2Dec(Display_On_Hour)+1); if (Display_On_Hour == 0x12) Display_On_PM = !Display_On_PM; if (Display_On_Hour == 0x13) Display_On_Hour = 0x01;}
	CALL        _Botao_INC+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Menu_73_HOUR463
	MOVF        _Display_On_Hour+0, 0 
	MOVWF       FARG_Bcd2Dec_bcdnum+0 
	CALL        _Bcd2Dec+0, 0
	MOVF        R0, 0 
	ADDLW       1
	MOVWF       FARG_Dec2Bcd_decnum+0 
	CALL        _Dec2Bcd+0, 0
	MOVF        R0, 0 
	MOVWF       _Display_On_Hour+0 
	MOVF        R0, 0 
	XORLW       18
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_73_HOUR464
	MOVF        _Display_On_PM+0, 1 
	MOVLW       1
	BTFSS       STATUS+0, 2 
	MOVLW       0
	MOVWF       _Display_On_PM+0 
L_Menu_73_HOUR464:
	MOVF        _Display_On_Hour+0, 0 
	XORLW       19
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_73_HOUR465
	MOVLW       1
	MOVWF       _Display_On_Hour+0 
L_Menu_73_HOUR465:
L_Menu_73_HOUR463:
;Nixie.c,1346 :: 		if (Botao_DEC()) {Display_On_Hour = Dec2Bcd(Bcd2Dec(Display_On_Hour)-1); if (Display_On_Hour == 0x11) Display_On_PM = !Display_On_PM; if (Display_On_Hour == 0x00) Display_On_Hour = 0x12;}
	CALL        _Botao_DEC+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Menu_73_HOUR466
	MOVF        _Display_On_Hour+0, 0 
	MOVWF       FARG_Bcd2Dec_bcdnum+0 
	CALL        _Bcd2Dec+0, 0
	DECF        R0, 0 
	MOVWF       FARG_Dec2Bcd_decnum+0 
	CALL        _Dec2Bcd+0, 0
	MOVF        R0, 0 
	MOVWF       _Display_On_Hour+0 
	MOVF        R0, 0 
	XORLW       17
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_73_HOUR467
	MOVF        _Display_On_PM+0, 1 
	MOVLW       1
	BTFSS       STATUS+0, 2 
	MOVLW       0
	MOVWF       _Display_On_PM+0 
L_Menu_73_HOUR467:
	MOVF        _Display_On_Hour+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_73_HOUR468
	MOVLW       18
	MOVWF       _Display_On_Hour+0 
L_Menu_73_HOUR468:
L_Menu_73_HOUR466:
;Nixie.c,1348 :: 		} else {
	GOTO        L_Menu_73_HOUR469
L_Menu_73_HOUR462:
;Nixie.c,1349 :: 		if (Botao_INC()) {Display_On_Hour = Dec2Bcd(Bcd2Dec(Display_On_Hour)+1); if (Display_On_Hour == 0x24) Display_On_Hour = 0x00;}
	CALL        _Botao_INC+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Menu_73_HOUR470
	MOVF        _Display_On_Hour+0, 0 
	MOVWF       FARG_Bcd2Dec_bcdnum+0 
	CALL        _Bcd2Dec+0, 0
	MOVF        R0, 0 
	ADDLW       1
	MOVWF       FARG_Dec2Bcd_decnum+0 
	CALL        _Dec2Bcd+0, 0
	MOVF        R0, 0 
	MOVWF       _Display_On_Hour+0 
	MOVF        R0, 0 
	XORLW       36
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_73_HOUR471
	CLRF        _Display_On_Hour+0 
L_Menu_73_HOUR471:
L_Menu_73_HOUR470:
;Nixie.c,1350 :: 		if (Botao_DEC()) {Display_On_Hour = Dec2Bcd(Bcd2Dec(Display_On_Hour)-1); if (Display_On_Hour == Dec2Bcd(-1)) Display_On_Hour = 0x23;}
	CALL        _Botao_DEC+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Menu_73_HOUR472
	MOVF        _Display_On_Hour+0, 0 
	MOVWF       FARG_Bcd2Dec_bcdnum+0 
	CALL        _Bcd2Dec+0, 0
	DECF        R0, 0 
	MOVWF       FARG_Dec2Bcd_decnum+0 
	CALL        _Dec2Bcd+0, 0
	MOVF        R0, 0 
	MOVWF       _Display_On_Hour+0 
	MOVLW       255
	MOVWF       FARG_Dec2Bcd_decnum+0 
	CALL        _Dec2Bcd+0, 0
	MOVF        _Display_On_Hour+0, 0 
	XORWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_73_HOUR473
	MOVLW       35
	MOVWF       _Display_On_Hour+0 
L_Menu_73_HOUR473:
L_Menu_73_HOUR472:
;Nixie.c,1351 :: 		}
L_Menu_73_HOUR469:
;Nixie.c,1352 :: 		if (Botao_ENT()) {escrever_eeprom(0x12,Display_On_Hour); escrever_eeprom(0x13,Display_On_Minute); escrever_eeprom(0x14,Display_On_PM); MENU = 73;}
	CALL        _Botao_ENT+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Menu_73_HOUR474
	MOVLW       18
	MOVWF       FARG_escrever_eeprom_address+0 
	MOVF        _Display_On_Hour+0, 0 
	MOVWF       FARG_escrever_eeprom_DADO_EEPROM+0 
	CALL        _escrever_eeprom+0, 0
	MOVLW       19
	MOVWF       FARG_escrever_eeprom_address+0 
	MOVF        _Display_On_Minute+0, 0 
	MOVWF       FARG_escrever_eeprom_DADO_EEPROM+0 
	CALL        _escrever_eeprom+0, 0
	MOVLW       20
	MOVWF       FARG_escrever_eeprom_address+0 
	MOVF        _Display_On_PM+0, 0 
	MOVWF       FARG_escrever_eeprom_DADO_EEPROM+0 
	CALL        _escrever_eeprom+0, 0
	MOVLW       73
	MOVWF       _MENU+0 
	MOVLW       0
	MOVWF       _MENU+1 
L_Menu_73_HOUR474:
;Nixie.c,1354 :: 		WriteDisplay(0x07,0,0,0x03,1,0,toggle_Set == 1 ? (Display_On_Hour >> 4) : 0x0F,toggle_Set == 1 ? Display_On_PM : 0,0,toggle_Set == 1 ? (Display_On_Hour & 0x0F) : 0x0F,0,0,(Display_On_Minute >> 4),0,0,(Display_On_Minute & 0x0F),0,0,1,0);
	MOVLW       7
	MOVWF       FARG_WriteDisplay_D5+0 
	CLRF        FARG_WriteDisplay_D5_L_P+0 
	CLRF        FARG_WriteDisplay_D5_R_P+0 
	MOVLW       3
	MOVWF       FARG_WriteDisplay_D4+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D4_L_P+0 
	CLRF        FARG_WriteDisplay_D4_R_P+0 
	CLRF        R1 
	BTFSC       _toggle_Set+0, BitPos(_toggle_Set+0) 
	INCF        R1, 1 
	MOVF        R1, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_73_HOUR475
	MOVF        _Display_On_Hour+0, 0 
	MOVWF       ?FLOC___Menu_73_HOURT632+0 
	RRCF        ?FLOC___Menu_73_HOURT632+0, 1 
	BCF         ?FLOC___Menu_73_HOURT632+0, 7 
	RRCF        ?FLOC___Menu_73_HOURT632+0, 1 
	BCF         ?FLOC___Menu_73_HOURT632+0, 7 
	RRCF        ?FLOC___Menu_73_HOURT632+0, 1 
	BCF         ?FLOC___Menu_73_HOURT632+0, 7 
	RRCF        ?FLOC___Menu_73_HOURT632+0, 1 
	BCF         ?FLOC___Menu_73_HOURT632+0, 7 
	GOTO        L_Menu_73_HOUR476
L_Menu_73_HOUR475:
	MOVLW       15
	MOVWF       ?FLOC___Menu_73_HOURT632+0 
L_Menu_73_HOUR476:
	MOVF        ?FLOC___Menu_73_HOURT632+0, 0 
	MOVWF       FARG_WriteDisplay_D3+0 
	CLRF        R1 
	BTFSC       _toggle_Set+0, BitPos(_toggle_Set+0) 
	INCF        R1, 1 
	MOVF        R1, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_73_HOUR477
	MOVF        _Display_On_PM+0, 0 
	MOVWF       ?FLOC___Menu_73_HOURT635+0 
	GOTO        L_Menu_73_HOUR478
L_Menu_73_HOUR477:
	CLRF        ?FLOC___Menu_73_HOURT635+0 
L_Menu_73_HOUR478:
	MOVF        ?FLOC___Menu_73_HOURT635+0, 0 
	MOVWF       FARG_WriteDisplay_D3_L_P+0 
	CLRF        FARG_WriteDisplay_D3_R_P+0 
	CLRF        R1 
	BTFSC       _toggle_Set+0, BitPos(_toggle_Set+0) 
	INCF        R1, 1 
	MOVF        R1, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_73_HOUR479
	MOVLW       15
	ANDWF       _Display_On_Hour+0, 0 
	MOVWF       ?FLOC___Menu_73_HOURT639+0 
	GOTO        L_Menu_73_HOUR480
L_Menu_73_HOUR479:
	MOVLW       15
	MOVWF       ?FLOC___Menu_73_HOURT639+0 
L_Menu_73_HOUR480:
	MOVF        ?FLOC___Menu_73_HOURT639+0, 0 
	MOVWF       FARG_WriteDisplay_D2+0 
	CLRF        FARG_WriteDisplay_D2_L_P+0 
	CLRF        FARG_WriteDisplay_D2_R_P+0 
	MOVF        _Display_On_Minute+0, 0 
	MOVWF       FARG_WriteDisplay_D1+0 
	RRCF        FARG_WriteDisplay_D1+0, 1 
	BCF         FARG_WriteDisplay_D1+0, 7 
	RRCF        FARG_WriteDisplay_D1+0, 1 
	BCF         FARG_WriteDisplay_D1+0, 7 
	RRCF        FARG_WriteDisplay_D1+0, 1 
	BCF         FARG_WriteDisplay_D1+0, 7 
	RRCF        FARG_WriteDisplay_D1+0, 1 
	BCF         FARG_WriteDisplay_D1+0, 7 
	CLRF        FARG_WriteDisplay_D1_L_P+0 
	CLRF        FARG_WriteDisplay_D1_R_P+0 
	MOVLW       15
	ANDWF       _Display_On_Minute+0, 0 
	MOVWF       FARG_WriteDisplay_D0+0 
	CLRF        FARG_WriteDisplay_D0_L_P+0 
	CLRF        FARG_WriteDisplay_D0_R_P+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_N0+0 
	CLRF        FARG_WriteDisplay_N1+0 
	CALL        _WriteDisplay+0, 0
;Nixie.c,1356 :: 		}
L_end_Menu_73_HOUR:
	RETURN      0
; end of _Menu_73_HOUR

_Menu_81:

;Nixie.c,1362 :: 		void Menu_81() {
;Nixie.c,1364 :: 		if (Botao_INC()) Alarm = 1;
	CALL        _Botao_INC+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Menu_81481
	BSF         _Alarm+0, BitPos(_Alarm+0) 
L_Menu_81481:
;Nixie.c,1365 :: 		if (Botao_DEC()) Alarm = 0;
	CALL        _Botao_DEC+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Menu_81482
	BCF         _Alarm+0, BitPos(_Alarm+0) 
L_Menu_81482:
;Nixie.c,1366 :: 		if (Botao_ENT()) { escrever_eeprom(0x15,Alarm); MENU = 81;}
	CALL        _Botao_ENT+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Menu_81483
	MOVLW       21
	MOVWF       FARG_escrever_eeprom_address+0 
	MOVLW       0
	BTFSC       _Alarm+0, BitPos(_Alarm+0) 
	MOVLW       1
	MOVWF       FARG_escrever_eeprom_DADO_EEPROM+0 
	CALL        _escrever_eeprom+0, 0
	MOVLW       81
	MOVWF       _MENU+0 
	MOVLW       0
	MOVWF       _MENU+1 
L_Menu_81483:
;Nixie.c,1368 :: 		WriteDisplay(0x08,0,0,0x01,1,0,0x0F,0,0,0x0F,0,0,0x0F,0,0,toggle_Set == 1 ? (unsigned char)Alarm : 0x0F,0,0,0,0);
	MOVLW       8
	MOVWF       FARG_WriteDisplay_D5+0 
	CLRF        FARG_WriteDisplay_D5_L_P+0 
	CLRF        FARG_WriteDisplay_D5_R_P+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D4+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D4_L_P+0 
	CLRF        FARG_WriteDisplay_D4_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D3+0 
	CLRF        FARG_WriteDisplay_D3_L_P+0 
	CLRF        FARG_WriteDisplay_D3_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D2+0 
	CLRF        FARG_WriteDisplay_D2_L_P+0 
	CLRF        FARG_WriteDisplay_D2_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D1+0 
	CLRF        FARG_WriteDisplay_D1_L_P+0 
	CLRF        FARG_WriteDisplay_D1_R_P+0 
	CLRF        R1 
	BTFSC       _toggle_Set+0, BitPos(_toggle_Set+0) 
	INCF        R1, 1 
	MOVF        R1, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_81484
	MOVLW       0
	BTFSC       _Alarm+0, BitPos(_Alarm+0) 
	MOVLW       1
	MOVWF       ?FLOC___Menu_81T645+0 
	GOTO        L_Menu_81485
L_Menu_81484:
	MOVLW       15
	MOVWF       ?FLOC___Menu_81T645+0 
L_Menu_81485:
	MOVF        ?FLOC___Menu_81T645+0, 0 
	MOVWF       FARG_WriteDisplay_D0+0 
	CLRF        FARG_WriteDisplay_D0_L_P+0 
	CLRF        FARG_WriteDisplay_D0_R_P+0 
	CLRF        FARG_WriteDisplay_N0+0 
	CLRF        FARG_WriteDisplay_N1+0 
	CALL        _WriteDisplay+0, 0
;Nixie.c,1370 :: 		}
L_end_Menu_81:
	RETURN      0
; end of _Menu_81

_Menu_82_MIN:

;Nixie.c,1376 :: 		void Menu_82_MIN() {
;Nixie.c,1378 :: 		if (Botao_INC()) {Alarm_Minute = Dec2Bcd(Bcd2Dec(Alarm_Minute)+1); if (Alarm_Minute == 0x60) Alarm_Minute = 0x00;}
	CALL        _Botao_INC+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Menu_82_MIN486
	MOVF        _Alarm_Minute+0, 0 
	MOVWF       FARG_Bcd2Dec_bcdnum+0 
	CALL        _Bcd2Dec+0, 0
	MOVF        R0, 0 
	ADDLW       1
	MOVWF       FARG_Dec2Bcd_decnum+0 
	CALL        _Dec2Bcd+0, 0
	MOVF        R0, 0 
	MOVWF       _Alarm_Minute+0 
	MOVF        R0, 0 
	XORLW       96
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_82_MIN487
	CLRF        _Alarm_Minute+0 
L_Menu_82_MIN487:
L_Menu_82_MIN486:
;Nixie.c,1379 :: 		if (Botao_DEC()) {Alarm_Minute = Dec2Bcd(Bcd2Dec(Alarm_Minute)-1); if (Alarm_Minute == Dec2Bcd(-1)) Alarm_Minute = 0x59;}
	CALL        _Botao_DEC+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Menu_82_MIN488
	MOVF        _Alarm_Minute+0, 0 
	MOVWF       FARG_Bcd2Dec_bcdnum+0 
	CALL        _Bcd2Dec+0, 0
	DECF        R0, 0 
	MOVWF       FARG_Dec2Bcd_decnum+0 
	CALL        _Dec2Bcd+0, 0
	MOVF        R0, 0 
	MOVWF       _Alarm_Minute+0 
	MOVLW       255
	MOVWF       FARG_Dec2Bcd_decnum+0 
	CALL        _Dec2Bcd+0, 0
	MOVF        _Alarm_Minute+0, 0 
	XORWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_82_MIN489
	MOVLW       89
	MOVWF       _Alarm_Minute+0 
L_Menu_82_MIN489:
L_Menu_82_MIN488:
;Nixie.c,1380 :: 		if (Botao_ENT()) {MENU = 821;}
	CALL        _Botao_ENT+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Menu_82_MIN490
	MOVLW       53
	MOVWF       _MENU+0 
	MOVLW       3
	MOVWF       _MENU+1 
L_Menu_82_MIN490:
;Nixie.c,1382 :: 		WriteDisplay(0x08,0,0,0x02,1,0,(Alarm_Hour >> 4),Alarm_PM,0,(Alarm_Hour & 0x0F),0,0,toggle_Set == 1 ? (Alarm_Minute >> 4) : 0x0F,0,0,toggle_Set == 1 ? (Alarm_Minute & 0x0F) : 0x0F,0,0,1,0);
	MOVLW       8
	MOVWF       FARG_WriteDisplay_D5+0 
	CLRF        FARG_WriteDisplay_D5_L_P+0 
	CLRF        FARG_WriteDisplay_D5_R_P+0 
	MOVLW       2
	MOVWF       FARG_WriteDisplay_D4+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D4_L_P+0 
	CLRF        FARG_WriteDisplay_D4_R_P+0 
	MOVF        _Alarm_Hour+0, 0 
	MOVWF       FARG_WriteDisplay_D3+0 
	RRCF        FARG_WriteDisplay_D3+0, 1 
	BCF         FARG_WriteDisplay_D3+0, 7 
	RRCF        FARG_WriteDisplay_D3+0, 1 
	BCF         FARG_WriteDisplay_D3+0, 7 
	RRCF        FARG_WriteDisplay_D3+0, 1 
	BCF         FARG_WriteDisplay_D3+0, 7 
	RRCF        FARG_WriteDisplay_D3+0, 1 
	BCF         FARG_WriteDisplay_D3+0, 7 
	MOVF        _Alarm_PM+0, 0 
	MOVWF       FARG_WriteDisplay_D3_L_P+0 
	CLRF        FARG_WriteDisplay_D3_R_P+0 
	MOVLW       15
	ANDWF       _Alarm_Hour+0, 0 
	MOVWF       FARG_WriteDisplay_D2+0 
	CLRF        FARG_WriteDisplay_D2_L_P+0 
	CLRF        FARG_WriteDisplay_D2_R_P+0 
	CLRF        R1 
	BTFSC       _toggle_Set+0, BitPos(_toggle_Set+0) 
	INCF        R1, 1 
	MOVF        R1, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_82_MIN491
	MOVF        _Alarm_Minute+0, 0 
	MOVWF       ?FLOC___Menu_82_MINT655+0 
	RRCF        ?FLOC___Menu_82_MINT655+0, 1 
	BCF         ?FLOC___Menu_82_MINT655+0, 7 
	RRCF        ?FLOC___Menu_82_MINT655+0, 1 
	BCF         ?FLOC___Menu_82_MINT655+0, 7 
	RRCF        ?FLOC___Menu_82_MINT655+0, 1 
	BCF         ?FLOC___Menu_82_MINT655+0, 7 
	RRCF        ?FLOC___Menu_82_MINT655+0, 1 
	BCF         ?FLOC___Menu_82_MINT655+0, 7 
	GOTO        L_Menu_82_MIN492
L_Menu_82_MIN491:
	MOVLW       15
	MOVWF       ?FLOC___Menu_82_MINT655+0 
L_Menu_82_MIN492:
	MOVF        ?FLOC___Menu_82_MINT655+0, 0 
	MOVWF       FARG_WriteDisplay_D1+0 
	CLRF        FARG_WriteDisplay_D1_L_P+0 
	CLRF        FARG_WriteDisplay_D1_R_P+0 
	CLRF        R1 
	BTFSC       _toggle_Set+0, BitPos(_toggle_Set+0) 
	INCF        R1, 1 
	MOVF        R1, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_82_MIN493
	MOVLW       15
	ANDWF       _Alarm_Minute+0, 0 
	MOVWF       ?FLOC___Menu_82_MINT659+0 
	GOTO        L_Menu_82_MIN494
L_Menu_82_MIN493:
	MOVLW       15
	MOVWF       ?FLOC___Menu_82_MINT659+0 
L_Menu_82_MIN494:
	MOVF        ?FLOC___Menu_82_MINT659+0, 0 
	MOVWF       FARG_WriteDisplay_D0+0 
	CLRF        FARG_WriteDisplay_D0_L_P+0 
	CLRF        FARG_WriteDisplay_D0_R_P+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_N0+0 
	CLRF        FARG_WriteDisplay_N1+0 
	CALL        _WriteDisplay+0, 0
;Nixie.c,1384 :: 		}
L_end_Menu_82_MIN:
	RETURN      0
; end of _Menu_82_MIN

_Menu_82_HOUR:

;Nixie.c,1390 :: 		void Menu_82_HOUR() {
;Nixie.c,1392 :: 		if (Mode12h) {
	BTFSS       _Mode12h+0, BitPos(_Mode12h+0) 
	GOTO        L_Menu_82_HOUR495
;Nixie.c,1393 :: 		if (Botao_INC()) {Alarm_Hour = Dec2Bcd(Bcd2Dec(Alarm_Hour)+1); if (Alarm_Hour == 0x12) Alarm_PM = !Alarm_PM; if (Alarm_Hour == 0x13) Alarm_Hour = 0x01;}
	CALL        _Botao_INC+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Menu_82_HOUR496
	MOVF        _Alarm_Hour+0, 0 
	MOVWF       FARG_Bcd2Dec_bcdnum+0 
	CALL        _Bcd2Dec+0, 0
	MOVF        R0, 0 
	ADDLW       1
	MOVWF       FARG_Dec2Bcd_decnum+0 
	CALL        _Dec2Bcd+0, 0
	MOVF        R0, 0 
	MOVWF       _Alarm_Hour+0 
	MOVF        R0, 0 
	XORLW       18
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_82_HOUR497
	MOVF        _Alarm_PM+0, 1 
	MOVLW       1
	BTFSS       STATUS+0, 2 
	MOVLW       0
	MOVWF       _Alarm_PM+0 
L_Menu_82_HOUR497:
	MOVF        _Alarm_Hour+0, 0 
	XORLW       19
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_82_HOUR498
	MOVLW       1
	MOVWF       _Alarm_Hour+0 
L_Menu_82_HOUR498:
L_Menu_82_HOUR496:
;Nixie.c,1394 :: 		if (Botao_DEC()) {Alarm_Hour = Dec2Bcd(Bcd2Dec(Alarm_Hour)-1); if (Alarm_Hour == 0x11) Alarm_PM = !Alarm_PM; if (Alarm_Hour == 0x00) Alarm_Hour = 0x12;}
	CALL        _Botao_DEC+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Menu_82_HOUR499
	MOVF        _Alarm_Hour+0, 0 
	MOVWF       FARG_Bcd2Dec_bcdnum+0 
	CALL        _Bcd2Dec+0, 0
	DECF        R0, 0 
	MOVWF       FARG_Dec2Bcd_decnum+0 
	CALL        _Dec2Bcd+0, 0
	MOVF        R0, 0 
	MOVWF       _Alarm_Hour+0 
	MOVF        R0, 0 
	XORLW       17
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_82_HOUR500
	MOVF        _Alarm_PM+0, 1 
	MOVLW       1
	BTFSS       STATUS+0, 2 
	MOVLW       0
	MOVWF       _Alarm_PM+0 
L_Menu_82_HOUR500:
	MOVF        _Alarm_Hour+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_82_HOUR501
	MOVLW       18
	MOVWF       _Alarm_Hour+0 
L_Menu_82_HOUR501:
L_Menu_82_HOUR499:
;Nixie.c,1396 :: 		} else {
	GOTO        L_Menu_82_HOUR502
L_Menu_82_HOUR495:
;Nixie.c,1397 :: 		if (Botao_INC()) {Alarm_Hour = Dec2Bcd(Bcd2Dec(Alarm_Hour)+1); if (Alarm_Hour == 0x24) Alarm_Hour = 0x00;}
	CALL        _Botao_INC+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Menu_82_HOUR503
	MOVF        _Alarm_Hour+0, 0 
	MOVWF       FARG_Bcd2Dec_bcdnum+0 
	CALL        _Bcd2Dec+0, 0
	MOVF        R0, 0 
	ADDLW       1
	MOVWF       FARG_Dec2Bcd_decnum+0 
	CALL        _Dec2Bcd+0, 0
	MOVF        R0, 0 
	MOVWF       _Alarm_Hour+0 
	MOVF        R0, 0 
	XORLW       36
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_82_HOUR504
	CLRF        _Alarm_Hour+0 
L_Menu_82_HOUR504:
L_Menu_82_HOUR503:
;Nixie.c,1398 :: 		if (Botao_DEC()) {Alarm_Hour = Dec2Bcd(Bcd2Dec(Alarm_Hour)-1); if (Alarm_Hour == Dec2Bcd(-1)) Alarm_Hour = 0x23;}
	CALL        _Botao_DEC+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Menu_82_HOUR505
	MOVF        _Alarm_Hour+0, 0 
	MOVWF       FARG_Bcd2Dec_bcdnum+0 
	CALL        _Bcd2Dec+0, 0
	DECF        R0, 0 
	MOVWF       FARG_Dec2Bcd_decnum+0 
	CALL        _Dec2Bcd+0, 0
	MOVF        R0, 0 
	MOVWF       _Alarm_Hour+0 
	MOVLW       255
	MOVWF       FARG_Dec2Bcd_decnum+0 
	CALL        _Dec2Bcd+0, 0
	MOVF        _Alarm_Hour+0, 0 
	XORWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_82_HOUR506
	MOVLW       35
	MOVWF       _Alarm_Hour+0 
L_Menu_82_HOUR506:
L_Menu_82_HOUR505:
;Nixie.c,1399 :: 		}
L_Menu_82_HOUR502:
;Nixie.c,1400 :: 		if (Botao_ENT()) {escrever_eeprom(0x16,Alarm_Hour); escrever_eeprom(0x17,Alarm_Minute); escrever_eeprom(0x18,Alarm_PM); MENU = 82;}
	CALL        _Botao_ENT+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Menu_82_HOUR507
	MOVLW       22
	MOVWF       FARG_escrever_eeprom_address+0 
	MOVF        _Alarm_Hour+0, 0 
	MOVWF       FARG_escrever_eeprom_DADO_EEPROM+0 
	CALL        _escrever_eeprom+0, 0
	MOVLW       23
	MOVWF       FARG_escrever_eeprom_address+0 
	MOVF        _Alarm_Minute+0, 0 
	MOVWF       FARG_escrever_eeprom_DADO_EEPROM+0 
	CALL        _escrever_eeprom+0, 0
	MOVLW       24
	MOVWF       FARG_escrever_eeprom_address+0 
	MOVF        _Alarm_PM+0, 0 
	MOVWF       FARG_escrever_eeprom_DADO_EEPROM+0 
	CALL        _escrever_eeprom+0, 0
	MOVLW       82
	MOVWF       _MENU+0 
	MOVLW       0
	MOVWF       _MENU+1 
L_Menu_82_HOUR507:
;Nixie.c,1402 :: 		WriteDisplay(0x08,0,0,0x02,1,0,toggle_Set == 1 ? (Alarm_Hour >> 4) : 0x0F,toggle_Set == 1 ? Alarm_PM : 0,0,toggle_Set == 1 ? (Alarm_Hour & 0x0F) : 0x0F,0,0,(Alarm_Minute >> 4),0,0,(Alarm_Minute & 0x0F),0,0,1,0);
	MOVLW       8
	MOVWF       FARG_WriteDisplay_D5+0 
	CLRF        FARG_WriteDisplay_D5_L_P+0 
	CLRF        FARG_WriteDisplay_D5_R_P+0 
	MOVLW       2
	MOVWF       FARG_WriteDisplay_D4+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D4_L_P+0 
	CLRF        FARG_WriteDisplay_D4_R_P+0 
	CLRF        R1 
	BTFSC       _toggle_Set+0, BitPos(_toggle_Set+0) 
	INCF        R1, 1 
	MOVF        R1, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_82_HOUR508
	MOVF        _Alarm_Hour+0, 0 
	MOVWF       ?FLOC___Menu_82_HOURT675+0 
	RRCF        ?FLOC___Menu_82_HOURT675+0, 1 
	BCF         ?FLOC___Menu_82_HOURT675+0, 7 
	RRCF        ?FLOC___Menu_82_HOURT675+0, 1 
	BCF         ?FLOC___Menu_82_HOURT675+0, 7 
	RRCF        ?FLOC___Menu_82_HOURT675+0, 1 
	BCF         ?FLOC___Menu_82_HOURT675+0, 7 
	RRCF        ?FLOC___Menu_82_HOURT675+0, 1 
	BCF         ?FLOC___Menu_82_HOURT675+0, 7 
	GOTO        L_Menu_82_HOUR509
L_Menu_82_HOUR508:
	MOVLW       15
	MOVWF       ?FLOC___Menu_82_HOURT675+0 
L_Menu_82_HOUR509:
	MOVF        ?FLOC___Menu_82_HOURT675+0, 0 
	MOVWF       FARG_WriteDisplay_D3+0 
	CLRF        R1 
	BTFSC       _toggle_Set+0, BitPos(_toggle_Set+0) 
	INCF        R1, 1 
	MOVF        R1, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_82_HOUR510
	MOVF        _Alarm_PM+0, 0 
	MOVWF       ?FLOC___Menu_82_HOURT678+0 
	GOTO        L_Menu_82_HOUR511
L_Menu_82_HOUR510:
	CLRF        ?FLOC___Menu_82_HOURT678+0 
L_Menu_82_HOUR511:
	MOVF        ?FLOC___Menu_82_HOURT678+0, 0 
	MOVWF       FARG_WriteDisplay_D3_L_P+0 
	CLRF        FARG_WriteDisplay_D3_R_P+0 
	CLRF        R1 
	BTFSC       _toggle_Set+0, BitPos(_toggle_Set+0) 
	INCF        R1, 1 
	MOVF        R1, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_82_HOUR512
	MOVLW       15
	ANDWF       _Alarm_Hour+0, 0 
	MOVWF       ?FLOC___Menu_82_HOURT682+0 
	GOTO        L_Menu_82_HOUR513
L_Menu_82_HOUR512:
	MOVLW       15
	MOVWF       ?FLOC___Menu_82_HOURT682+0 
L_Menu_82_HOUR513:
	MOVF        ?FLOC___Menu_82_HOURT682+0, 0 
	MOVWF       FARG_WriteDisplay_D2+0 
	CLRF        FARG_WriteDisplay_D2_L_P+0 
	CLRF        FARG_WriteDisplay_D2_R_P+0 
	MOVF        _Alarm_Minute+0, 0 
	MOVWF       FARG_WriteDisplay_D1+0 
	RRCF        FARG_WriteDisplay_D1+0, 1 
	BCF         FARG_WriteDisplay_D1+0, 7 
	RRCF        FARG_WriteDisplay_D1+0, 1 
	BCF         FARG_WriteDisplay_D1+0, 7 
	RRCF        FARG_WriteDisplay_D1+0, 1 
	BCF         FARG_WriteDisplay_D1+0, 7 
	RRCF        FARG_WriteDisplay_D1+0, 1 
	BCF         FARG_WriteDisplay_D1+0, 7 
	CLRF        FARG_WriteDisplay_D1_L_P+0 
	CLRF        FARG_WriteDisplay_D1_R_P+0 
	MOVLW       15
	ANDWF       _Alarm_Minute+0, 0 
	MOVWF       FARG_WriteDisplay_D0+0 
	CLRF        FARG_WriteDisplay_D0_L_P+0 
	CLRF        FARG_WriteDisplay_D0_R_P+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_N0+0 
	CLRF        FARG_WriteDisplay_N1+0 
	CALL        _WriteDisplay+0, 0
;Nixie.c,1404 :: 		}
L_end_Menu_82_HOUR:
	RETURN      0
; end of _Menu_82_HOUR

_Menu_91:

;Nixie.c,1410 :: 		void Menu_91() {
;Nixie.c,1412 :: 		if (Botao_INC()) HourBeep = 1;
	CALL        _Botao_INC+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Menu_91514
	BSF         _HourBeep+0, BitPos(_HourBeep+0) 
L_Menu_91514:
;Nixie.c,1413 :: 		if (Botao_DEC()) HourBeep = 0;
	CALL        _Botao_DEC+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Menu_91515
	BCF         _HourBeep+0, BitPos(_HourBeep+0) 
L_Menu_91515:
;Nixie.c,1414 :: 		if (Botao_ENT()) { escrever_eeprom(0x01,HourBeep); MENU = 91;}
	CALL        _Botao_ENT+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Menu_91516
	MOVLW       1
	MOVWF       FARG_escrever_eeprom_address+0 
	MOVLW       0
	BTFSC       _HourBeep+0, BitPos(_HourBeep+0) 
	MOVLW       1
	MOVWF       FARG_escrever_eeprom_DADO_EEPROM+0 
	CALL        _escrever_eeprom+0, 0
	MOVLW       91
	MOVWF       _MENU+0 
	MOVLW       0
	MOVWF       _MENU+1 
L_Menu_91516:
;Nixie.c,1416 :: 		WriteDisplay(0x09,0,0,0x01,1,0,0x0F,0,0,0x0F,0,0,0x0F,0,0,toggle_Set == 1 ? (unsigned char)HourBeep : 0x0F,0,0,0,0);
	MOVLW       9
	MOVWF       FARG_WriteDisplay_D5+0 
	CLRF        FARG_WriteDisplay_D5_L_P+0 
	CLRF        FARG_WriteDisplay_D5_R_P+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D4+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D4_L_P+0 
	CLRF        FARG_WriteDisplay_D4_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D3+0 
	CLRF        FARG_WriteDisplay_D3_L_P+0 
	CLRF        FARG_WriteDisplay_D3_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D2+0 
	CLRF        FARG_WriteDisplay_D2_L_P+0 
	CLRF        FARG_WriteDisplay_D2_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D1+0 
	CLRF        FARG_WriteDisplay_D1_L_P+0 
	CLRF        FARG_WriteDisplay_D1_R_P+0 
	CLRF        R1 
	BTFSC       _toggle_Set+0, BitPos(_toggle_Set+0) 
	INCF        R1, 1 
	MOVF        R1, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_91517
	MOVLW       0
	BTFSC       _HourBeep+0, BitPos(_HourBeep+0) 
	MOVLW       1
	MOVWF       ?FLOC___Menu_91T688+0 
	GOTO        L_Menu_91518
L_Menu_91517:
	MOVLW       15
	MOVWF       ?FLOC___Menu_91T688+0 
L_Menu_91518:
	MOVF        ?FLOC___Menu_91T688+0, 0 
	MOVWF       FARG_WriteDisplay_D0+0 
	CLRF        FARG_WriteDisplay_D0_L_P+0 
	CLRF        FARG_WriteDisplay_D0_R_P+0 
	CLRF        FARG_WriteDisplay_N0+0 
	CLRF        FARG_WriteDisplay_N1+0 
	CALL        _WriteDisplay+0, 0
;Nixie.c,1418 :: 		}
L_end_Menu_91:
	RETURN      0
; end of _Menu_91

_Menu_92:

;Nixie.c,1424 :: 		void Menu_92() {
;Nixie.c,1426 :: 		if (Botao_INC()) SecondBeep = 1;
	CALL        _Botao_INC+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Menu_92519
	BSF         _SecondBeep+0, BitPos(_SecondBeep+0) 
L_Menu_92519:
;Nixie.c,1427 :: 		if (Botao_DEC()) SecondBeep = 0;
	CALL        _Botao_DEC+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Menu_92520
	BCF         _SecondBeep+0, BitPos(_SecondBeep+0) 
L_Menu_92520:
;Nixie.c,1428 :: 		if (Botao_ENT()) { escrever_eeprom(0x1A,SecondBeep); MENU = 92;}
	CALL        _Botao_ENT+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Menu_92521
	MOVLW       26
	MOVWF       FARG_escrever_eeprom_address+0 
	MOVLW       0
	BTFSC       _SecondBeep+0, BitPos(_SecondBeep+0) 
	MOVLW       1
	MOVWF       FARG_escrever_eeprom_DADO_EEPROM+0 
	CALL        _escrever_eeprom+0, 0
	MOVLW       92
	MOVWF       _MENU+0 
	MOVLW       0
	MOVWF       _MENU+1 
L_Menu_92521:
;Nixie.c,1430 :: 		WriteDisplay(0x09,0,0,0x02,1,0,0x0F,0,0,0x0F,0,0,0x0F,0,0,toggle_Set == 1 ? (unsigned char)SecondBeep : 0x0F,0,0,0,0);
	MOVLW       9
	MOVWF       FARG_WriteDisplay_D5+0 
	CLRF        FARG_WriteDisplay_D5_L_P+0 
	CLRF        FARG_WriteDisplay_D5_R_P+0 
	MOVLW       2
	MOVWF       FARG_WriteDisplay_D4+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D4_L_P+0 
	CLRF        FARG_WriteDisplay_D4_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D3+0 
	CLRF        FARG_WriteDisplay_D3_L_P+0 
	CLRF        FARG_WriteDisplay_D3_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D2+0 
	CLRF        FARG_WriteDisplay_D2_L_P+0 
	CLRF        FARG_WriteDisplay_D2_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D1+0 
	CLRF        FARG_WriteDisplay_D1_L_P+0 
	CLRF        FARG_WriteDisplay_D1_R_P+0 
	CLRF        R1 
	BTFSC       _toggle_Set+0, BitPos(_toggle_Set+0) 
	INCF        R1, 1 
	MOVF        R1, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_92522
	MOVLW       0
	BTFSC       _SecondBeep+0, BitPos(_SecondBeep+0) 
	MOVLW       1
	MOVWF       ?FLOC___Menu_92T692+0 
	GOTO        L_Menu_92523
L_Menu_92522:
	MOVLW       15
	MOVWF       ?FLOC___Menu_92T692+0 
L_Menu_92523:
	MOVF        ?FLOC___Menu_92T692+0, 0 
	MOVWF       FARG_WriteDisplay_D0+0 
	CLRF        FARG_WriteDisplay_D0_L_P+0 
	CLRF        FARG_WriteDisplay_D0_R_P+0 
	CLRF        FARG_WriteDisplay_N0+0 
	CLRF        FARG_WriteDisplay_N1+0 
	CALL        _WriteDisplay+0, 0
;Nixie.c,1432 :: 		}
L_end_Menu_92:
	RETURN      0
; end of _Menu_92

_Menu_93:

;Nixie.c,1438 :: 		void Menu_93() {
;Nixie.c,1440 :: 		if (Botao_INC()) ButtonBeep = 1;
	CALL        _Botao_INC+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Menu_93524
	BSF         _ButtonBeep+0, BitPos(_ButtonBeep+0) 
L_Menu_93524:
;Nixie.c,1441 :: 		if (Botao_DEC()) ButtonBeep = 0;
	CALL        _Botao_DEC+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Menu_93525
	BCF         _ButtonBeep+0, BitPos(_ButtonBeep+0) 
L_Menu_93525:
;Nixie.c,1442 :: 		if (Botao_ENT()) { escrever_eeprom(0x1B,ButtonBeep); MENU = 93;}
	CALL        _Botao_ENT+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Menu_93526
	MOVLW       27
	MOVWF       FARG_escrever_eeprom_address+0 
	MOVLW       0
	BTFSC       _ButtonBeep+0, BitPos(_ButtonBeep+0) 
	MOVLW       1
	MOVWF       FARG_escrever_eeprom_DADO_EEPROM+0 
	CALL        _escrever_eeprom+0, 0
	MOVLW       93
	MOVWF       _MENU+0 
	MOVLW       0
	MOVWF       _MENU+1 
L_Menu_93526:
;Nixie.c,1444 :: 		WriteDisplay(0x09,0,0,0x03,1,0,0x0F,0,0,0x0F,0,0,0x0F,0,0,toggle_Set == 1 ? (unsigned char)ButtonBeep : 0x0F,0,0,0,0);
	MOVLW       9
	MOVWF       FARG_WriteDisplay_D5+0 
	CLRF        FARG_WriteDisplay_D5_L_P+0 
	CLRF        FARG_WriteDisplay_D5_R_P+0 
	MOVLW       3
	MOVWF       FARG_WriteDisplay_D4+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D4_L_P+0 
	CLRF        FARG_WriteDisplay_D4_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D3+0 
	CLRF        FARG_WriteDisplay_D3_L_P+0 
	CLRF        FARG_WriteDisplay_D3_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D2+0 
	CLRF        FARG_WriteDisplay_D2_L_P+0 
	CLRF        FARG_WriteDisplay_D2_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D1+0 
	CLRF        FARG_WriteDisplay_D1_L_P+0 
	CLRF        FARG_WriteDisplay_D1_R_P+0 
	CLRF        R1 
	BTFSC       _toggle_Set+0, BitPos(_toggle_Set+0) 
	INCF        R1, 1 
	MOVF        R1, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_93527
	MOVLW       0
	BTFSC       _ButtonBeep+0, BitPos(_ButtonBeep+0) 
	MOVLW       1
	MOVWF       ?FLOC___Menu_93T696+0 
	GOTO        L_Menu_93528
L_Menu_93527:
	MOVLW       15
	MOVWF       ?FLOC___Menu_93T696+0 
L_Menu_93528:
	MOVF        ?FLOC___Menu_93T696+0, 0 
	MOVWF       FARG_WriteDisplay_D0+0 
	CLRF        FARG_WriteDisplay_D0_L_P+0 
	CLRF        FARG_WriteDisplay_D0_R_P+0 
	CLRF        FARG_WriteDisplay_N0+0 
	CLRF        FARG_WriteDisplay_N1+0 
	CALL        _WriteDisplay+0, 0
;Nixie.c,1446 :: 		}
L_end_Menu_93:
	RETURN      0
; end of _Menu_93

_Menu_94:

;Nixie.c,1452 :: 		void Menu_94() {
;Nixie.c,1454 :: 		if (Botao_INC() && Ajust_Temp<100)  {Ajust_Temp += 10;}
	CALL        _Botao_INC+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Menu_94531
	MOVLW       128
	XORWF       _Ajust_Temp+0, 0 
	MOVWF       R0 
	MOVLW       128
	XORLW       100
	SUBWF       R0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_Menu_94531
L__Menu_94993:
	MOVLW       10
	ADDWF       _Ajust_Temp+0, 1 
L_Menu_94531:
;Nixie.c,1455 :: 		if (Botao_DEC() && Ajust_Temp>-100) {Ajust_Temp -= 10;}
	CALL        _Botao_DEC+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Menu_94534
	MOVLW       128
	XORLW       156
	MOVWF       R0 
	MOVLW       128
	XORWF       _Ajust_Temp+0, 0 
	SUBWF       R0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_Menu_94534
L__Menu_94992:
	MOVLW       10
	SUBWF       _Ajust_Temp+0, 1 
L_Menu_94534:
;Nixie.c,1456 :: 		if (Botao_ENT()) { escrever_eeprom(0x19,Ajust_Temp); MENU = 94;}
	CALL        _Botao_ENT+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Menu_94535
	MOVLW       25
	MOVWF       FARG_escrever_eeprom_address+0 
	MOVF        _Ajust_Temp+0, 0 
	MOVWF       FARG_escrever_eeprom_DADO_EEPROM+0 
	CALL        _escrever_eeprom+0, 0
	MOVLW       94
	MOVWF       _MENU+0 
	MOVLW       0
	MOVWF       _MENU+1 
L_Menu_94535:
;Nixie.c,1458 :: 		SeparaUnidade(Temp_Celsius);
	MOVF        _Temp_Celsius+0, 0 
	MOVWF       FARG_SeparaUnidade_Numero+0 
	MOVF        _Temp_Celsius+1, 0 
	MOVWF       FARG_SeparaUnidade_Numero+1 
	MOVLW       0
	MOVWF       FARG_SeparaUnidade_Numero+2 
	MOVWF       FARG_SeparaUnidade_Numero+3 
	CALL        _SeparaUnidade+0, 0
;Nixie.c,1460 :: 		WriteDisplay(0x09,0,0,0x04,1,0,0x0F,0,0,0x0F,0,0,toggle_Set == 1 ? centena : 0x0F,0,0,toggle_Set == 1 ? dezena : 0x0F,0,0,0,0);
	MOVLW       9
	MOVWF       FARG_WriteDisplay_D5+0 
	CLRF        FARG_WriteDisplay_D5_L_P+0 
	CLRF        FARG_WriteDisplay_D5_R_P+0 
	MOVLW       4
	MOVWF       FARG_WriteDisplay_D4+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D4_L_P+0 
	CLRF        FARG_WriteDisplay_D4_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D3+0 
	CLRF        FARG_WriteDisplay_D3_L_P+0 
	CLRF        FARG_WriteDisplay_D3_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D2+0 
	CLRF        FARG_WriteDisplay_D2_L_P+0 
	CLRF        FARG_WriteDisplay_D2_R_P+0 
	CLRF        R1 
	BTFSC       _toggle_Set+0, BitPos(_toggle_Set+0) 
	INCF        R1, 1 
	MOVF        R1, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_94536
	MOVF        _centena+0, 0 
	MOVWF       ?FLOC___Menu_94T705+0 
	GOTO        L_Menu_94537
L_Menu_94536:
	MOVLW       15
	MOVWF       ?FLOC___Menu_94T705+0 
L_Menu_94537:
	MOVF        ?FLOC___Menu_94T705+0, 0 
	MOVWF       FARG_WriteDisplay_D1+0 
	CLRF        FARG_WriteDisplay_D1_L_P+0 
	CLRF        FARG_WriteDisplay_D1_R_P+0 
	CLRF        R1 
	BTFSC       _toggle_Set+0, BitPos(_toggle_Set+0) 
	INCF        R1, 1 
	MOVF        R1, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_Menu_94538
	MOVF        _dezena+0, 0 
	MOVWF       ?FLOC___Menu_94T708+0 
	GOTO        L_Menu_94539
L_Menu_94538:
	MOVLW       15
	MOVWF       ?FLOC___Menu_94T708+0 
L_Menu_94539:
	MOVF        ?FLOC___Menu_94T708+0, 0 
	MOVWF       FARG_WriteDisplay_D0+0 
	CLRF        FARG_WriteDisplay_D0_L_P+0 
	CLRF        FARG_WriteDisplay_D0_R_P+0 
	CLRF        FARG_WriteDisplay_N0+0 
	CLRF        FARG_WriteDisplay_N1+0 
	CALL        _WriteDisplay+0, 0
;Nixie.c,1462 :: 		}
L_end_Menu_94:
	RETURN      0
; end of _Menu_94

_BackLightRGB:

;Nixie.c,1472 :: 		void BackLightRGB(ws2812Led* ledRGB) {
;Nixie.c,1476 :: 		GIE_bit = 0;
	BCF         GIE_bit+0, BitPos(GIE_bit+0) 
;Nixie.c,1478 :: 		for (i=0;i<6;i++)
	CLRF        BackLightRGB_i_L0+0 
	CLRF        BackLightRGB_i_L0+1 
L_BackLightRGB540:
	MOVLW       128
	XORWF       BackLightRGB_i_L0+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__BackLightRGB1163
	MOVLW       6
	SUBWF       BackLightRGB_i_L0+0, 0 
L__BackLightRGB1163:
	BTFSC       STATUS+0, 0 
	GOTO        L_BackLightRGB541
;Nixie.c,1479 :: 		ws2812_send(&*ledRGB);
	MOVF        FARG_BackLightRGB_ledRGB+0, 0 
	MOVWF       FARG_ws2812_send_led+0 
	MOVF        FARG_BackLightRGB_ledRGB+1, 0 
	MOVWF       FARG_ws2812_send_led+1 
	CALL        _ws2812_send+0, 0
;Nixie.c,1478 :: 		for (i=0;i<6;i++)
	INFSNZ      BackLightRGB_i_L0+0, 1 
	INCF        BackLightRGB_i_L0+1, 1 
;Nixie.c,1479 :: 		ws2812_send(&*ledRGB);
	GOTO        L_BackLightRGB540
L_BackLightRGB541:
;Nixie.c,1481 :: 		GIE_bit = 1;
	BSF         GIE_bit+0, BitPos(GIE_bit+0) 
;Nixie.c,1483 :: 		asm CLRWDT;            // Watchdog
	CLRWDT
;Nixie.c,1484 :: 		}
L_end_BackLightRGB:
	RETURN      0
; end of _BackLightRGB

_SeparaUnidade:

;Nixie.c,1490 :: 		void SeparaUnidade(unsigned long int Numero) {
;Nixie.c,1492 :: 		unidade_m = Numero / 1000;
	MOVLW       232
	MOVWF       R4 
	MOVLW       3
	MOVWF       R5 
	MOVLW       0
	MOVWF       R6 
	MOVWF       R7 
	MOVF        FARG_SeparaUnidade_Numero+0, 0 
	MOVWF       R0 
	MOVF        FARG_SeparaUnidade_Numero+1, 0 
	MOVWF       R1 
	MOVF        FARG_SeparaUnidade_Numero+2, 0 
	MOVWF       R2 
	MOVF        FARG_SeparaUnidade_Numero+3, 0 
	MOVWF       R3 
	CALL        _Div_32x32_U+0, 0
	MOVF        R0, 0 
	MOVWF       _unidade_m+0 
;Nixie.c,1493 :: 		centena = (Numero / 100) % 10;
	MOVLW       100
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVWF       R6 
	MOVWF       R7 
	MOVF        FARG_SeparaUnidade_Numero+0, 0 
	MOVWF       R0 
	MOVF        FARG_SeparaUnidade_Numero+1, 0 
	MOVWF       R1 
	MOVF        FARG_SeparaUnidade_Numero+2, 0 
	MOVWF       R2 
	MOVF        FARG_SeparaUnidade_Numero+3, 0 
	MOVWF       R3 
	CALL        _Div_32x32_U+0, 0
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVWF       R6 
	MOVWF       R7 
	CALL        _Div_32x32_U+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVF        R10, 0 
	MOVWF       R2 
	MOVF        R11, 0 
	MOVWF       R3 
	MOVF        R0, 0 
	MOVWF       _centena+0 
;Nixie.c,1494 :: 		dezena = (Numero / 10) % 10;
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVWF       R6 
	MOVWF       R7 
	MOVF        FARG_SeparaUnidade_Numero+0, 0 
	MOVWF       R0 
	MOVF        FARG_SeparaUnidade_Numero+1, 0 
	MOVWF       R1 
	MOVF        FARG_SeparaUnidade_Numero+2, 0 
	MOVWF       R2 
	MOVF        FARG_SeparaUnidade_Numero+3, 0 
	MOVWF       R3 
	CALL        _Div_32x32_U+0, 0
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVWF       R6 
	MOVWF       R7 
	CALL        _Div_32x32_U+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVF        R10, 0 
	MOVWF       R2 
	MOVF        R11, 0 
	MOVWF       R3 
	MOVF        R0, 0 
	MOVWF       _dezena+0 
;Nixie.c,1495 :: 		unidade = Numero % 10;
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVWF       R6 
	MOVWF       R7 
	MOVF        FARG_SeparaUnidade_Numero+0, 0 
	MOVWF       R0 
	MOVF        FARG_SeparaUnidade_Numero+1, 0 
	MOVWF       R1 
	MOVF        FARG_SeparaUnidade_Numero+2, 0 
	MOVWF       R2 
	MOVF        FARG_SeparaUnidade_Numero+3, 0 
	MOVWF       R3 
	CALL        _Div_32x32_U+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVF        R10, 0 
	MOVWF       R2 
	MOVF        R11, 0 
	MOVWF       R3 
	MOVF        R0, 0 
	MOVWF       _unidade+0 
;Nixie.c,1497 :: 		}
L_end_SeparaUnidade:
	RETURN      0
; end of _SeparaUnidade

_WriteDisplay:

;Nixie.c,1503 :: 		void WriteDisplay(unsigned char D5, unsigned char D5_L_P, unsigned char D5_R_P, unsigned char D4, unsigned char D4_L_P, unsigned char D4_R_P, unsigned char D3, unsigned char D3_L_P, unsigned char D3_R_P, unsigned char D2, unsigned char D2_L_P, unsigned char D2_R_P, unsigned char D1, unsigned char D1_L_P, unsigned char D1_R_P, unsigned char D0, unsigned char D0_L_P, unsigned char D0_R_P, unsigned char N0, unsigned char N1) {
;Nixie.c,1505 :: 		anodo_D5=anodo_D4=anodo_D3=anodo_D2=anodo_D1=anodo_D0 = 0;
	BCF         LATA4_bit+0, BitPos(LATA4_bit+0) 
	BTFSC       LATA4_bit+0, BitPos(LATA4_bit+0) 
	GOTO        L__WriteDisplay1166
	BCF         LATA5_bit+0, BitPos(LATA5_bit+0) 
	GOTO        L__WriteDisplay1167
L__WriteDisplay1166:
	BSF         LATA5_bit+0, BitPos(LATA5_bit+0) 
L__WriteDisplay1167:
	BTFSC       LATA5_bit+0, BitPos(LATA5_bit+0) 
	GOTO        L__WriteDisplay1168
	BCF         LATE0_bit+0, BitPos(LATE0_bit+0) 
	GOTO        L__WriteDisplay1169
L__WriteDisplay1168:
	BSF         LATE0_bit+0, BitPos(LATE0_bit+0) 
L__WriteDisplay1169:
	BTFSC       LATE0_bit+0, BitPos(LATE0_bit+0) 
	GOTO        L__WriteDisplay1170
	BCF         LATE1_bit+0, BitPos(LATE1_bit+0) 
	GOTO        L__WriteDisplay1171
L__WriteDisplay1170:
	BSF         LATE1_bit+0, BitPos(LATE1_bit+0) 
L__WriteDisplay1171:
	BTFSC       LATE1_bit+0, BitPos(LATE1_bit+0) 
	GOTO        L__WriteDisplay1172
	BCF         LATE2_bit+0, BitPos(LATE2_bit+0) 
	GOTO        L__WriteDisplay1173
L__WriteDisplay1172:
	BSF         LATE2_bit+0, BitPos(LATE2_bit+0) 
L__WriteDisplay1173:
	BTFSC       LATE2_bit+0, BitPos(LATE2_bit+0) 
	GOTO        L__WriteDisplay1174
	BCF         LATC0_bit+0, BitPos(LATC0_bit+0) 
	GOTO        L__WriteDisplay1175
L__WriteDisplay1174:
	BSF         LATC0_bit+0, BitPos(LATC0_bit+0) 
L__WriteDisplay1175:
;Nixie.c,1506 :: 		L_P=R_P = 0;
	BCF         LATD4_bit+0, BitPos(LATD4_bit+0) 
	BTFSC       LATD4_bit+0, BitPos(LATD4_bit+0) 
	GOTO        L__WriteDisplay1176
	BCF         LATD5_bit+0, BitPos(LATD5_bit+0) 
	GOTO        L__WriteDisplay1177
L__WriteDisplay1176:
	BSF         LATD5_bit+0, BitPos(LATD5_bit+0) 
L__WriteDisplay1177:
;Nixie.c,1507 :: 		neon_0=neon_0 = 0;
	BCF         LATD6_bit+0, BitPos(LATD6_bit+0) 
;Nixie.c,1509 :: 		Number(D0);
	MOVF        FARG_WriteDisplay_D0+0, 0 
	MOVWF       FARG_Number_digit+0 
	CALL        _Number+0, 0
;Nixie.c,1510 :: 		L_P = D0_L_P;
	BTFSC       FARG_WriteDisplay_D0_L_P+0, 0 
	GOTO        L__WriteDisplay1178
	BCF         LATD5_bit+0, BitPos(LATD5_bit+0) 
	GOTO        L__WriteDisplay1179
L__WriteDisplay1178:
	BSF         LATD5_bit+0, BitPos(LATD5_bit+0) 
L__WriteDisplay1179:
;Nixie.c,1511 :: 		R_P = D0_R_P;
	BTFSC       FARG_WriteDisplay_D0_R_P+0, 0 
	GOTO        L__WriteDisplay1180
	BCF         LATD4_bit+0, BitPos(LATD4_bit+0) 
	GOTO        L__WriteDisplay1181
L__WriteDisplay1180:
	BSF         LATD4_bit+0, BitPos(LATD4_bit+0) 
L__WriteDisplay1181:
;Nixie.c,1512 :: 		anodo_D0 = 1;
	BSF         LATA4_bit+0, BitPos(LATA4_bit+0) 
;Nixie.c,1513 :: 		DELAY(ACESO);
	MOVF        _ACESO+0, 0 
	MOVWF       FARG_DELAY_L+0 
	CALL        _DELAY+0, 0
;Nixie.c,1514 :: 		anodo_D0 = 0;
	BCF         LATA4_bit+0, BitPos(LATA4_bit+0) 
;Nixie.c,1516 :: 		DELAY(APAGADO);
	MOVF        _APAGADO+0, 0 
	MOVWF       FARG_DELAY_L+0 
	CALL        _DELAY+0, 0
;Nixie.c,1518 :: 		Number(D1);
	MOVF        FARG_WriteDisplay_D1+0, 0 
	MOVWF       FARG_Number_digit+0 
	CALL        _Number+0, 0
;Nixie.c,1519 :: 		L_P = D1_L_P;
	BTFSC       FARG_WriteDisplay_D1_L_P+0, 0 
	GOTO        L__WriteDisplay1182
	BCF         LATD5_bit+0, BitPos(LATD5_bit+0) 
	GOTO        L__WriteDisplay1183
L__WriteDisplay1182:
	BSF         LATD5_bit+0, BitPos(LATD5_bit+0) 
L__WriteDisplay1183:
;Nixie.c,1520 :: 		R_P = D1_R_P;
	BTFSC       FARG_WriteDisplay_D1_R_P+0, 0 
	GOTO        L__WriteDisplay1184
	BCF         LATD4_bit+0, BitPos(LATD4_bit+0) 
	GOTO        L__WriteDisplay1185
L__WriteDisplay1184:
	BSF         LATD4_bit+0, BitPos(LATD4_bit+0) 
L__WriteDisplay1185:
;Nixie.c,1521 :: 		anodo_D1 = 1;
	BSF         LATA5_bit+0, BitPos(LATA5_bit+0) 
;Nixie.c,1522 :: 		DELAY(ACESO);
	MOVF        _ACESO+0, 0 
	MOVWF       FARG_DELAY_L+0 
	CALL        _DELAY+0, 0
;Nixie.c,1523 :: 		anodo_D1 = 0;
	BCF         LATA5_bit+0, BitPos(LATA5_bit+0) 
;Nixie.c,1525 :: 		DELAY(APAGADO);
	MOVF        _APAGADO+0, 0 
	MOVWF       FARG_DELAY_L+0 
	CALL        _DELAY+0, 0
;Nixie.c,1527 :: 		neon_0 = N0;
	BTFSC       FARG_WriteDisplay_N0+0, 0 
	GOTO        L__WriteDisplay1186
	BCF         LATD6_bit+0, BitPos(LATD6_bit+0) 
	GOTO        L__WriteDisplay1187
L__WriteDisplay1186:
	BSF         LATD6_bit+0, BitPos(LATD6_bit+0) 
L__WriteDisplay1187:
;Nixie.c,1528 :: 		DELAY(ACESO);
	MOVF        _ACESO+0, 0 
	MOVWF       FARG_DELAY_L+0 
	CALL        _DELAY+0, 0
;Nixie.c,1529 :: 		neon_0 = 0;
	BCF         LATD6_bit+0, BitPos(LATD6_bit+0) 
;Nixie.c,1530 :: 		DELAY(APAGADO);
	MOVF        _APAGADO+0, 0 
	MOVWF       FARG_DELAY_L+0 
	CALL        _DELAY+0, 0
;Nixie.c,1532 :: 		Number(D2);
	MOVF        FARG_WriteDisplay_D2+0, 0 
	MOVWF       FARG_Number_digit+0 
	CALL        _Number+0, 0
;Nixie.c,1533 :: 		L_P = D2_L_P;
	BTFSC       FARG_WriteDisplay_D2_L_P+0, 0 
	GOTO        L__WriteDisplay1188
	BCF         LATD5_bit+0, BitPos(LATD5_bit+0) 
	GOTO        L__WriteDisplay1189
L__WriteDisplay1188:
	BSF         LATD5_bit+0, BitPos(LATD5_bit+0) 
L__WriteDisplay1189:
;Nixie.c,1534 :: 		R_P = D2_R_P;
	BTFSC       FARG_WriteDisplay_D2_R_P+0, 0 
	GOTO        L__WriteDisplay1190
	BCF         LATD4_bit+0, BitPos(LATD4_bit+0) 
	GOTO        L__WriteDisplay1191
L__WriteDisplay1190:
	BSF         LATD4_bit+0, BitPos(LATD4_bit+0) 
L__WriteDisplay1191:
;Nixie.c,1535 :: 		anodo_D2 = 1;
	BSF         LATE0_bit+0, BitPos(LATE0_bit+0) 
;Nixie.c,1536 :: 		DELAY(ACESO);
	MOVF        _ACESO+0, 0 
	MOVWF       FARG_DELAY_L+0 
	CALL        _DELAY+0, 0
;Nixie.c,1537 :: 		anodo_D2 = 0;
	BCF         LATE0_bit+0, BitPos(LATE0_bit+0) 
;Nixie.c,1539 :: 		DELAY(APAGADO);
	MOVF        _APAGADO+0, 0 
	MOVWF       FARG_DELAY_L+0 
	CALL        _DELAY+0, 0
;Nixie.c,1541 :: 		Number(D3);
	MOVF        FARG_WriteDisplay_D3+0, 0 
	MOVWF       FARG_Number_digit+0 
	CALL        _Number+0, 0
;Nixie.c,1542 :: 		L_P = D3_L_P;
	BTFSC       FARG_WriteDisplay_D3_L_P+0, 0 
	GOTO        L__WriteDisplay1192
	BCF         LATD5_bit+0, BitPos(LATD5_bit+0) 
	GOTO        L__WriteDisplay1193
L__WriteDisplay1192:
	BSF         LATD5_bit+0, BitPos(LATD5_bit+0) 
L__WriteDisplay1193:
;Nixie.c,1543 :: 		R_P = D3_R_P;
	BTFSC       FARG_WriteDisplay_D3_R_P+0, 0 
	GOTO        L__WriteDisplay1194
	BCF         LATD4_bit+0, BitPos(LATD4_bit+0) 
	GOTO        L__WriteDisplay1195
L__WriteDisplay1194:
	BSF         LATD4_bit+0, BitPos(LATD4_bit+0) 
L__WriteDisplay1195:
;Nixie.c,1544 :: 		anodo_D3 = 1;
	BSF         LATE1_bit+0, BitPos(LATE1_bit+0) 
;Nixie.c,1545 :: 		DELAY(ACESO);
	MOVF        _ACESO+0, 0 
	MOVWF       FARG_DELAY_L+0 
	CALL        _DELAY+0, 0
;Nixie.c,1546 :: 		anodo_D3 = 0;
	BCF         LATE1_bit+0, BitPos(LATE1_bit+0) 
;Nixie.c,1548 :: 		DELAY(APAGADO);
	MOVF        _APAGADO+0, 0 
	MOVWF       FARG_DELAY_L+0 
	CALL        _DELAY+0, 0
;Nixie.c,1550 :: 		neon_1 = N1;
	BTFSC       FARG_WriteDisplay_N1+0, 0 
	GOTO        L__WriteDisplay1196
	BCF         LATD7_bit+0, BitPos(LATD7_bit+0) 
	GOTO        L__WriteDisplay1197
L__WriteDisplay1196:
	BSF         LATD7_bit+0, BitPos(LATD7_bit+0) 
L__WriteDisplay1197:
;Nixie.c,1551 :: 		DELAY(ACESO);
	MOVF        _ACESO+0, 0 
	MOVWF       FARG_DELAY_L+0 
	CALL        _DELAY+0, 0
;Nixie.c,1552 :: 		neon_1 = 0;
	BCF         LATD7_bit+0, BitPos(LATD7_bit+0) 
;Nixie.c,1553 :: 		DELAY(APAGADO);
	MOVF        _APAGADO+0, 0 
	MOVWF       FARG_DELAY_L+0 
	CALL        _DELAY+0, 0
;Nixie.c,1555 :: 		Number(D4);
	MOVF        FARG_WriteDisplay_D4+0, 0 
	MOVWF       FARG_Number_digit+0 
	CALL        _Number+0, 0
;Nixie.c,1556 :: 		L_P = D4_L_P;
	BTFSC       FARG_WriteDisplay_D4_L_P+0, 0 
	GOTO        L__WriteDisplay1198
	BCF         LATD5_bit+0, BitPos(LATD5_bit+0) 
	GOTO        L__WriteDisplay1199
L__WriteDisplay1198:
	BSF         LATD5_bit+0, BitPos(LATD5_bit+0) 
L__WriteDisplay1199:
;Nixie.c,1557 :: 		R_P = D4_R_P;
	BTFSC       FARG_WriteDisplay_D4_R_P+0, 0 
	GOTO        L__WriteDisplay1200
	BCF         LATD4_bit+0, BitPos(LATD4_bit+0) 
	GOTO        L__WriteDisplay1201
L__WriteDisplay1200:
	BSF         LATD4_bit+0, BitPos(LATD4_bit+0) 
L__WriteDisplay1201:
;Nixie.c,1558 :: 		anodo_D4 = 1;
	BSF         LATE2_bit+0, BitPos(LATE2_bit+0) 
;Nixie.c,1559 :: 		DELAY(ACESO);
	MOVF        _ACESO+0, 0 
	MOVWF       FARG_DELAY_L+0 
	CALL        _DELAY+0, 0
;Nixie.c,1560 :: 		anodo_D4 = 0;
	BCF         LATE2_bit+0, BitPos(LATE2_bit+0) 
;Nixie.c,1562 :: 		DELAY(APAGADO);
	MOVF        _APAGADO+0, 0 
	MOVWF       FARG_DELAY_L+0 
	CALL        _DELAY+0, 0
;Nixie.c,1564 :: 		Number(D5);
	MOVF        FARG_WriteDisplay_D5+0, 0 
	MOVWF       FARG_Number_digit+0 
	CALL        _Number+0, 0
;Nixie.c,1565 :: 		L_P = D5_L_P;
	BTFSC       FARG_WriteDisplay_D5_L_P+0, 0 
	GOTO        L__WriteDisplay1202
	BCF         LATD5_bit+0, BitPos(LATD5_bit+0) 
	GOTO        L__WriteDisplay1203
L__WriteDisplay1202:
	BSF         LATD5_bit+0, BitPos(LATD5_bit+0) 
L__WriteDisplay1203:
;Nixie.c,1566 :: 		R_P = D5_R_P;
	BTFSC       FARG_WriteDisplay_D5_R_P+0, 0 
	GOTO        L__WriteDisplay1204
	BCF         LATD4_bit+0, BitPos(LATD4_bit+0) 
	GOTO        L__WriteDisplay1205
L__WriteDisplay1204:
	BSF         LATD4_bit+0, BitPos(LATD4_bit+0) 
L__WriteDisplay1205:
;Nixie.c,1567 :: 		anodo_D5 = 1;
	BSF         LATC0_bit+0, BitPos(LATC0_bit+0) 
;Nixie.c,1568 :: 		DELAY(ACESO);
	MOVF        _ACESO+0, 0 
	MOVWF       FARG_DELAY_L+0 
	CALL        _DELAY+0, 0
;Nixie.c,1569 :: 		anodo_D5 = 0;
	BCF         LATC0_bit+0, BitPos(LATC0_bit+0) 
;Nixie.c,1571 :: 		DELAY(APAGADO);
	MOVF        _APAGADO+0, 0 
	MOVWF       FARG_DELAY_L+0 
	CALL        _DELAY+0, 0
;Nixie.c,1573 :: 		L_P=R_P = 0;
	BCF         LATD4_bit+0, BitPos(LATD4_bit+0) 
	BTFSC       LATD4_bit+0, BitPos(LATD4_bit+0) 
	GOTO        L__WriteDisplay1206
	BCF         LATD5_bit+0, BitPos(LATD5_bit+0) 
	GOTO        L__WriteDisplay1207
L__WriteDisplay1206:
	BSF         LATD5_bit+0, BitPos(LATD5_bit+0) 
L__WriteDisplay1207:
;Nixie.c,1574 :: 		}
L_end_WriteDisplay:
	RETURN      0
; end of _WriteDisplay

_WriteDisplay_Fading:

;Nixie.c,1581 :: 		void WriteDisplay_Fading(unsigned char D5, unsigned char D5_L_P, unsigned char D5_R_P, char F5, unsigned char D4, unsigned char D4_L_P, unsigned char D4_R_P, char F4, unsigned char D3, unsigned char D3_L_P, unsigned char D3_R_P, char F3, unsigned char D2, unsigned char D2_L_P, unsigned char D2_R_P, char F2, unsigned char D1, unsigned char D1_L_P, unsigned char D1_R_P, char F1, unsigned char D0, unsigned char D0_L_P, unsigned char D0_R_P, char F0, unsigned char N0, char F_N0, unsigned char N1, char F_N1, unsigned char ON, unsigned char OFF) {
;Nixie.c,1583 :: 		anodo_D5=anodo_D4=anodo_D3=anodo_D2=anodo_D1=anodo_D0 = 0;
	BCF         LATA4_bit+0, BitPos(LATA4_bit+0) 
	BTFSC       LATA4_bit+0, BitPos(LATA4_bit+0) 
	GOTO        L__WriteDisplay_Fading1209
	BCF         LATA5_bit+0, BitPos(LATA5_bit+0) 
	GOTO        L__WriteDisplay_Fading1210
L__WriteDisplay_Fading1209:
	BSF         LATA5_bit+0, BitPos(LATA5_bit+0) 
L__WriteDisplay_Fading1210:
	BTFSC       LATA5_bit+0, BitPos(LATA5_bit+0) 
	GOTO        L__WriteDisplay_Fading1211
	BCF         LATE0_bit+0, BitPos(LATE0_bit+0) 
	GOTO        L__WriteDisplay_Fading1212
L__WriteDisplay_Fading1211:
	BSF         LATE0_bit+0, BitPos(LATE0_bit+0) 
L__WriteDisplay_Fading1212:
	BTFSC       LATE0_bit+0, BitPos(LATE0_bit+0) 
	GOTO        L__WriteDisplay_Fading1213
	BCF         LATE1_bit+0, BitPos(LATE1_bit+0) 
	GOTO        L__WriteDisplay_Fading1214
L__WriteDisplay_Fading1213:
	BSF         LATE1_bit+0, BitPos(LATE1_bit+0) 
L__WriteDisplay_Fading1214:
	BTFSC       LATE1_bit+0, BitPos(LATE1_bit+0) 
	GOTO        L__WriteDisplay_Fading1215
	BCF         LATE2_bit+0, BitPos(LATE2_bit+0) 
	GOTO        L__WriteDisplay_Fading1216
L__WriteDisplay_Fading1215:
	BSF         LATE2_bit+0, BitPos(LATE2_bit+0) 
L__WriteDisplay_Fading1216:
	BTFSC       LATE2_bit+0, BitPos(LATE2_bit+0) 
	GOTO        L__WriteDisplay_Fading1217
	BCF         LATC0_bit+0, BitPos(LATC0_bit+0) 
	GOTO        L__WriteDisplay_Fading1218
L__WriteDisplay_Fading1217:
	BSF         LATC0_bit+0, BitPos(LATC0_bit+0) 
L__WriteDisplay_Fading1218:
;Nixie.c,1584 :: 		L_P=R_P = 0;
	BCF         LATD4_bit+0, BitPos(LATD4_bit+0) 
	BTFSC       LATD4_bit+0, BitPos(LATD4_bit+0) 
	GOTO        L__WriteDisplay_Fading1219
	BCF         LATD5_bit+0, BitPos(LATD5_bit+0) 
	GOTO        L__WriteDisplay_Fading1220
L__WriteDisplay_Fading1219:
	BSF         LATD5_bit+0, BitPos(LATD5_bit+0) 
L__WriteDisplay_Fading1220:
;Nixie.c,1585 :: 		neon_0=neon_0 = 0;
	BCF         LATD6_bit+0, BitPos(LATD6_bit+0) 
;Nixie.c,1587 :: 		Number(D0);
	MOVF        FARG_WriteDisplay_Fading_D0+0, 0 
	MOVWF       FARG_Number_digit+0 
	CALL        _Number+0, 0
;Nixie.c,1588 :: 		L_P = D0_L_P;
	BTFSC       FARG_WriteDisplay_Fading_D0_L_P+0, 0 
	GOTO        L__WriteDisplay_Fading1221
	BCF         LATD5_bit+0, BitPos(LATD5_bit+0) 
	GOTO        L__WriteDisplay_Fading1222
L__WriteDisplay_Fading1221:
	BSF         LATD5_bit+0, BitPos(LATD5_bit+0) 
L__WriteDisplay_Fading1222:
;Nixie.c,1589 :: 		R_P = D0_R_P;
	BTFSC       FARG_WriteDisplay_Fading_D0_R_P+0, 0 
	GOTO        L__WriteDisplay_Fading1223
	BCF         LATD4_bit+0, BitPos(LATD4_bit+0) 
	GOTO        L__WriteDisplay_Fading1224
L__WriteDisplay_Fading1223:
	BSF         LATD4_bit+0, BitPos(LATD4_bit+0) 
L__WriteDisplay_Fading1224:
;Nixie.c,1590 :: 		anodo_D0 = 1;
	BSF         LATA4_bit+0, BitPos(LATA4_bit+0) 
;Nixie.c,1591 :: 		if (!F0) {DELAY(ACESO); anodo_D0 = 0; DELAY(APAGADO);}
	MOVF        FARG_WriteDisplay_Fading_F0+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_WriteDisplay_Fading543
	MOVF        _ACESO+0, 0 
	MOVWF       FARG_DELAY_L+0 
	CALL        _DELAY+0, 0
	BCF         LATA4_bit+0, BitPos(LATA4_bit+0) 
	MOVF        _APAGADO+0, 0 
	MOVWF       FARG_DELAY_L+0 
	CALL        _DELAY+0, 0
	GOTO        L_WriteDisplay_Fading544
L_WriteDisplay_Fading543:
;Nixie.c,1592 :: 		else     {DELAY(ON); anodo_D0 = 0; DELAY(OFF);}
	MOVF        FARG_WriteDisplay_Fading_ON+0, 0 
	MOVWF       FARG_DELAY_L+0 
	CALL        _DELAY+0, 0
	BCF         LATA4_bit+0, BitPos(LATA4_bit+0) 
	MOVF        FARG_WriteDisplay_Fading_OFF+0, 0 
	MOVWF       FARG_DELAY_L+0 
	CALL        _DELAY+0, 0
L_WriteDisplay_Fading544:
;Nixie.c,1594 :: 		Number(D1);
	MOVF        FARG_WriteDisplay_Fading_D1+0, 0 
	MOVWF       FARG_Number_digit+0 
	CALL        _Number+0, 0
;Nixie.c,1595 :: 		L_P = D1_L_P;
	BTFSC       FARG_WriteDisplay_Fading_D1_L_P+0, 0 
	GOTO        L__WriteDisplay_Fading1225
	BCF         LATD5_bit+0, BitPos(LATD5_bit+0) 
	GOTO        L__WriteDisplay_Fading1226
L__WriteDisplay_Fading1225:
	BSF         LATD5_bit+0, BitPos(LATD5_bit+0) 
L__WriteDisplay_Fading1226:
;Nixie.c,1596 :: 		R_P = D1_R_P;
	BTFSC       FARG_WriteDisplay_Fading_D1_R_P+0, 0 
	GOTO        L__WriteDisplay_Fading1227
	BCF         LATD4_bit+0, BitPos(LATD4_bit+0) 
	GOTO        L__WriteDisplay_Fading1228
L__WriteDisplay_Fading1227:
	BSF         LATD4_bit+0, BitPos(LATD4_bit+0) 
L__WriteDisplay_Fading1228:
;Nixie.c,1597 :: 		anodo_D1 = 1;
	BSF         LATA5_bit+0, BitPos(LATA5_bit+0) 
;Nixie.c,1598 :: 		if (!F1) {DELAY(ACESO); anodo_D1 = 0; DELAY(APAGADO);}
	MOVF        FARG_WriteDisplay_Fading_F1+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_WriteDisplay_Fading545
	MOVF        _ACESO+0, 0 
	MOVWF       FARG_DELAY_L+0 
	CALL        _DELAY+0, 0
	BCF         LATA5_bit+0, BitPos(LATA5_bit+0) 
	MOVF        _APAGADO+0, 0 
	MOVWF       FARG_DELAY_L+0 
	CALL        _DELAY+0, 0
	GOTO        L_WriteDisplay_Fading546
L_WriteDisplay_Fading545:
;Nixie.c,1599 :: 		else     {DELAY(ON); anodo_D1 = 0; DELAY(OFF);}
	MOVF        FARG_WriteDisplay_Fading_ON+0, 0 
	MOVWF       FARG_DELAY_L+0 
	CALL        _DELAY+0, 0
	BCF         LATA5_bit+0, BitPos(LATA5_bit+0) 
	MOVF        FARG_WriteDisplay_Fading_OFF+0, 0 
	MOVWF       FARG_DELAY_L+0 
	CALL        _DELAY+0, 0
L_WriteDisplay_Fading546:
;Nixie.c,1601 :: 		neon_0 = N0;
	BTFSC       FARG_WriteDisplay_Fading_N0+0, 0 
	GOTO        L__WriteDisplay_Fading1229
	BCF         LATD6_bit+0, BitPos(LATD6_bit+0) 
	GOTO        L__WriteDisplay_Fading1230
L__WriteDisplay_Fading1229:
	BSF         LATD6_bit+0, BitPos(LATD6_bit+0) 
L__WriteDisplay_Fading1230:
;Nixie.c,1602 :: 		if (!F_N0) {DELAY(ACESO); neon_0 = 0; DELAY(APAGADO);}
	MOVF        FARG_WriteDisplay_Fading_F_N0+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_WriteDisplay_Fading547
	MOVF        _ACESO+0, 0 
	MOVWF       FARG_DELAY_L+0 
	CALL        _DELAY+0, 0
	BCF         LATD6_bit+0, BitPos(LATD6_bit+0) 
	MOVF        _APAGADO+0, 0 
	MOVWF       FARG_DELAY_L+0 
	CALL        _DELAY+0, 0
	GOTO        L_WriteDisplay_Fading548
L_WriteDisplay_Fading547:
;Nixie.c,1603 :: 		else       {DELAY(ON); neon_0 = 0; DELAY(OFF);}
	MOVF        FARG_WriteDisplay_Fading_ON+0, 0 
	MOVWF       FARG_DELAY_L+0 
	CALL        _DELAY+0, 0
	BCF         LATD6_bit+0, BitPos(LATD6_bit+0) 
	MOVF        FARG_WriteDisplay_Fading_OFF+0, 0 
	MOVWF       FARG_DELAY_L+0 
	CALL        _DELAY+0, 0
L_WriteDisplay_Fading548:
;Nixie.c,1605 :: 		Number(D2);
	MOVF        FARG_WriteDisplay_Fading_D2+0, 0 
	MOVWF       FARG_Number_digit+0 
	CALL        _Number+0, 0
;Nixie.c,1606 :: 		L_P = D2_L_P;
	BTFSC       FARG_WriteDisplay_Fading_D2_L_P+0, 0 
	GOTO        L__WriteDisplay_Fading1231
	BCF         LATD5_bit+0, BitPos(LATD5_bit+0) 
	GOTO        L__WriteDisplay_Fading1232
L__WriteDisplay_Fading1231:
	BSF         LATD5_bit+0, BitPos(LATD5_bit+0) 
L__WriteDisplay_Fading1232:
;Nixie.c,1607 :: 		R_P = D2_R_P;
	BTFSC       FARG_WriteDisplay_Fading_D2_R_P+0, 0 
	GOTO        L__WriteDisplay_Fading1233
	BCF         LATD4_bit+0, BitPos(LATD4_bit+0) 
	GOTO        L__WriteDisplay_Fading1234
L__WriteDisplay_Fading1233:
	BSF         LATD4_bit+0, BitPos(LATD4_bit+0) 
L__WriteDisplay_Fading1234:
;Nixie.c,1608 :: 		anodo_D2 = 1;
	BSF         LATE0_bit+0, BitPos(LATE0_bit+0) 
;Nixie.c,1609 :: 		if (!F2) {DELAY(ACESO); anodo_D2 = 0; DELAY(APAGADO);}
	MOVF        FARG_WriteDisplay_Fading_F2+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_WriteDisplay_Fading549
	MOVF        _ACESO+0, 0 
	MOVWF       FARG_DELAY_L+0 
	CALL        _DELAY+0, 0
	BCF         LATE0_bit+0, BitPos(LATE0_bit+0) 
	MOVF        _APAGADO+0, 0 
	MOVWF       FARG_DELAY_L+0 
	CALL        _DELAY+0, 0
	GOTO        L_WriteDisplay_Fading550
L_WriteDisplay_Fading549:
;Nixie.c,1610 :: 		else     {DELAY(ON); anodo_D2 = 0; DELAY(OFF);}
	MOVF        FARG_WriteDisplay_Fading_ON+0, 0 
	MOVWF       FARG_DELAY_L+0 
	CALL        _DELAY+0, 0
	BCF         LATE0_bit+0, BitPos(LATE0_bit+0) 
	MOVF        FARG_WriteDisplay_Fading_OFF+0, 0 
	MOVWF       FARG_DELAY_L+0 
	CALL        _DELAY+0, 0
L_WriteDisplay_Fading550:
;Nixie.c,1612 :: 		Number(D3);
	MOVF        FARG_WriteDisplay_Fading_D3+0, 0 
	MOVWF       FARG_Number_digit+0 
	CALL        _Number+0, 0
;Nixie.c,1613 :: 		L_P = D3_L_P;
	BTFSC       FARG_WriteDisplay_Fading_D3_L_P+0, 0 
	GOTO        L__WriteDisplay_Fading1235
	BCF         LATD5_bit+0, BitPos(LATD5_bit+0) 
	GOTO        L__WriteDisplay_Fading1236
L__WriteDisplay_Fading1235:
	BSF         LATD5_bit+0, BitPos(LATD5_bit+0) 
L__WriteDisplay_Fading1236:
;Nixie.c,1614 :: 		R_P = D3_R_P;
	BTFSC       FARG_WriteDisplay_Fading_D3_R_P+0, 0 
	GOTO        L__WriteDisplay_Fading1237
	BCF         LATD4_bit+0, BitPos(LATD4_bit+0) 
	GOTO        L__WriteDisplay_Fading1238
L__WriteDisplay_Fading1237:
	BSF         LATD4_bit+0, BitPos(LATD4_bit+0) 
L__WriteDisplay_Fading1238:
;Nixie.c,1615 :: 		anodo_D3 = 1;
	BSF         LATE1_bit+0, BitPos(LATE1_bit+0) 
;Nixie.c,1616 :: 		if (!F3) {DELAY(ACESO); anodo_D3 = 0; DELAY(APAGADO);}
	MOVF        FARG_WriteDisplay_Fading_F3+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_WriteDisplay_Fading551
	MOVF        _ACESO+0, 0 
	MOVWF       FARG_DELAY_L+0 
	CALL        _DELAY+0, 0
	BCF         LATE1_bit+0, BitPos(LATE1_bit+0) 
	MOVF        _APAGADO+0, 0 
	MOVWF       FARG_DELAY_L+0 
	CALL        _DELAY+0, 0
	GOTO        L_WriteDisplay_Fading552
L_WriteDisplay_Fading551:
;Nixie.c,1617 :: 		else     {DELAY(ON); anodo_D3 = 0; DELAY(OFF);}
	MOVF        FARG_WriteDisplay_Fading_ON+0, 0 
	MOVWF       FARG_DELAY_L+0 
	CALL        _DELAY+0, 0
	BCF         LATE1_bit+0, BitPos(LATE1_bit+0) 
	MOVF        FARG_WriteDisplay_Fading_OFF+0, 0 
	MOVWF       FARG_DELAY_L+0 
	CALL        _DELAY+0, 0
L_WriteDisplay_Fading552:
;Nixie.c,1619 :: 		neon_1 = N1;
	BTFSC       FARG_WriteDisplay_Fading_N1+0, 0 
	GOTO        L__WriteDisplay_Fading1239
	BCF         LATD7_bit+0, BitPos(LATD7_bit+0) 
	GOTO        L__WriteDisplay_Fading1240
L__WriteDisplay_Fading1239:
	BSF         LATD7_bit+0, BitPos(LATD7_bit+0) 
L__WriteDisplay_Fading1240:
;Nixie.c,1620 :: 		if (!F_N1) {DELAY(ACESO); neon_1 = 0; DELAY(APAGADO);}
	MOVF        FARG_WriteDisplay_Fading_F_N1+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_WriteDisplay_Fading553
	MOVF        _ACESO+0, 0 
	MOVWF       FARG_DELAY_L+0 
	CALL        _DELAY+0, 0
	BCF         LATD7_bit+0, BitPos(LATD7_bit+0) 
	MOVF        _APAGADO+0, 0 
	MOVWF       FARG_DELAY_L+0 
	CALL        _DELAY+0, 0
	GOTO        L_WriteDisplay_Fading554
L_WriteDisplay_Fading553:
;Nixie.c,1621 :: 		else       {DELAY(ON); neon_1 = 0; DELAY(OFF);}
	MOVF        FARG_WriteDisplay_Fading_ON+0, 0 
	MOVWF       FARG_DELAY_L+0 
	CALL        _DELAY+0, 0
	BCF         LATD7_bit+0, BitPos(LATD7_bit+0) 
	MOVF        FARG_WriteDisplay_Fading_OFF+0, 0 
	MOVWF       FARG_DELAY_L+0 
	CALL        _DELAY+0, 0
L_WriteDisplay_Fading554:
;Nixie.c,1623 :: 		Number(D4);
	MOVF        FARG_WriteDisplay_Fading_D4+0, 0 
	MOVWF       FARG_Number_digit+0 
	CALL        _Number+0, 0
;Nixie.c,1624 :: 		L_P = D4_L_P;
	BTFSC       FARG_WriteDisplay_Fading_D4_L_P+0, 0 
	GOTO        L__WriteDisplay_Fading1241
	BCF         LATD5_bit+0, BitPos(LATD5_bit+0) 
	GOTO        L__WriteDisplay_Fading1242
L__WriteDisplay_Fading1241:
	BSF         LATD5_bit+0, BitPos(LATD5_bit+0) 
L__WriteDisplay_Fading1242:
;Nixie.c,1625 :: 		R_P = D4_R_P;
	BTFSC       FARG_WriteDisplay_Fading_D4_R_P+0, 0 
	GOTO        L__WriteDisplay_Fading1243
	BCF         LATD4_bit+0, BitPos(LATD4_bit+0) 
	GOTO        L__WriteDisplay_Fading1244
L__WriteDisplay_Fading1243:
	BSF         LATD4_bit+0, BitPos(LATD4_bit+0) 
L__WriteDisplay_Fading1244:
;Nixie.c,1626 :: 		anodo_D4 = 1;
	BSF         LATE2_bit+0, BitPos(LATE2_bit+0) 
;Nixie.c,1627 :: 		if (!F4) {DELAY(ACESO); anodo_D4 = 0; DELAY(APAGADO);}
	MOVF        FARG_WriteDisplay_Fading_F4+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_WriteDisplay_Fading555
	MOVF        _ACESO+0, 0 
	MOVWF       FARG_DELAY_L+0 
	CALL        _DELAY+0, 0
	BCF         LATE2_bit+0, BitPos(LATE2_bit+0) 
	MOVF        _APAGADO+0, 0 
	MOVWF       FARG_DELAY_L+0 
	CALL        _DELAY+0, 0
	GOTO        L_WriteDisplay_Fading556
L_WriteDisplay_Fading555:
;Nixie.c,1628 :: 		else     {DELAY(ON); anodo_D4 = 0; DELAY(OFF);}
	MOVF        FARG_WriteDisplay_Fading_ON+0, 0 
	MOVWF       FARG_DELAY_L+0 
	CALL        _DELAY+0, 0
	BCF         LATE2_bit+0, BitPos(LATE2_bit+0) 
	MOVF        FARG_WriteDisplay_Fading_OFF+0, 0 
	MOVWF       FARG_DELAY_L+0 
	CALL        _DELAY+0, 0
L_WriteDisplay_Fading556:
;Nixie.c,1630 :: 		Number(D5);
	MOVF        FARG_WriteDisplay_Fading_D5+0, 0 
	MOVWF       FARG_Number_digit+0 
	CALL        _Number+0, 0
;Nixie.c,1631 :: 		L_P = D5_L_P;
	BTFSC       FARG_WriteDisplay_Fading_D5_L_P+0, 0 
	GOTO        L__WriteDisplay_Fading1245
	BCF         LATD5_bit+0, BitPos(LATD5_bit+0) 
	GOTO        L__WriteDisplay_Fading1246
L__WriteDisplay_Fading1245:
	BSF         LATD5_bit+0, BitPos(LATD5_bit+0) 
L__WriteDisplay_Fading1246:
;Nixie.c,1632 :: 		R_P = D5_R_P;
	BTFSC       FARG_WriteDisplay_Fading_D5_R_P+0, 0 
	GOTO        L__WriteDisplay_Fading1247
	BCF         LATD4_bit+0, BitPos(LATD4_bit+0) 
	GOTO        L__WriteDisplay_Fading1248
L__WriteDisplay_Fading1247:
	BSF         LATD4_bit+0, BitPos(LATD4_bit+0) 
L__WriteDisplay_Fading1248:
;Nixie.c,1633 :: 		anodo_D5 = 1;
	BSF         LATC0_bit+0, BitPos(LATC0_bit+0) 
;Nixie.c,1634 :: 		if (!F5) {DELAY(ACESO); anodo_D5 = 0; DELAY(APAGADO);}
	MOVF        FARG_WriteDisplay_Fading_F5+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_WriteDisplay_Fading557
	MOVF        _ACESO+0, 0 
	MOVWF       FARG_DELAY_L+0 
	CALL        _DELAY+0, 0
	BCF         LATC0_bit+0, BitPos(LATC0_bit+0) 
	MOVF        _APAGADO+0, 0 
	MOVWF       FARG_DELAY_L+0 
	CALL        _DELAY+0, 0
	GOTO        L_WriteDisplay_Fading558
L_WriteDisplay_Fading557:
;Nixie.c,1635 :: 		else     {DELAY(ON); anodo_D5 = 0; DELAY(OFF);}
	MOVF        FARG_WriteDisplay_Fading_ON+0, 0 
	MOVWF       FARG_DELAY_L+0 
	CALL        _DELAY+0, 0
	BCF         LATC0_bit+0, BitPos(LATC0_bit+0) 
	MOVF        FARG_WriteDisplay_Fading_OFF+0, 0 
	MOVWF       FARG_DELAY_L+0 
	CALL        _DELAY+0, 0
L_WriteDisplay_Fading558:
;Nixie.c,1637 :: 		L_P=R_P = 0;
	BCF         LATD4_bit+0, BitPos(LATD4_bit+0) 
	BTFSC       LATD4_bit+0, BitPos(LATD4_bit+0) 
	GOTO        L__WriteDisplay_Fading1249
	BCF         LATD5_bit+0, BitPos(LATD5_bit+0) 
	GOTO        L__WriteDisplay_Fading1250
L__WriteDisplay_Fading1249:
	BSF         LATD5_bit+0, BitPos(LATD5_bit+0) 
L__WriteDisplay_Fading1250:
;Nixie.c,1639 :: 		}
L_end_WriteDisplay_Fading:
	RETURN      0
; end of _WriteDisplay_Fading

_Number:

;Nixie.c,1645 :: 		void Number(unsigned char digit) {
;Nixie.c,1647 :: 		k155_A = digit.B0;//(digit & 0b00000001);
	BTFSC       FARG_Number_digit+0, 0 
	GOTO        L__Number1252
	BCF         LATD0_bit+0, BitPos(LATD0_bit+0) 
	GOTO        L__Number1253
L__Number1252:
	BSF         LATD0_bit+0, BitPos(LATD0_bit+0) 
L__Number1253:
;Nixie.c,1648 :: 		k155_B = digit.B1;//(digit & 0b00000010)>>1;
	BTFSC       FARG_Number_digit+0, 1 
	GOTO        L__Number1254
	BCF         LATD1_bit+0, BitPos(LATD1_bit+0) 
	GOTO        L__Number1255
L__Number1254:
	BSF         LATD1_bit+0, BitPos(LATD1_bit+0) 
L__Number1255:
;Nixie.c,1649 :: 		k155_C = digit.B2;//(digit & 0b00000100)>>2;
	BTFSC       FARG_Number_digit+0, 2 
	GOTO        L__Number1256
	BCF         LATD2_bit+0, BitPos(LATD2_bit+0) 
	GOTO        L__Number1257
L__Number1256:
	BSF         LATD2_bit+0, BitPos(LATD2_bit+0) 
L__Number1257:
;Nixie.c,1650 :: 		k155_D = digit.B3;//(digit & 0b00001000)>>3;
	BTFSC       FARG_Number_digit+0, 3 
	GOTO        L__Number1258
	BCF         LATD3_bit+0, BitPos(LATD3_bit+0) 
	GOTO        L__Number1259
L__Number1258:
	BSF         LATD3_bit+0, BitPos(LATD3_bit+0) 
L__Number1259:
;Nixie.c,1652 :: 		}
L_end_Number:
	RETURN      0
; end of _Number

_DELAY:

;Nixie.c,1658 :: 		void DELAY(unsigned char L) {
;Nixie.c,1661 :: 		while(L>=1){Delay_us(10); L--;}
L_DELAY559:
	MOVLW       1
	SUBWF       FARG_DELAY_L+0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_DELAY560
	MOVLW       39
	MOVWF       R13, 0
L_DELAY561:
	DECFSZ      R13, 1, 1
	BRA         L_DELAY561
	NOP
	NOP
	DECF        FARG_DELAY_L+0, 1 
	GOTO        L_DELAY559
L_DELAY560:
;Nixie.c,1663 :: 		return;
;Nixie.c,1664 :: 		}
L_end_DELAY:
	RETURN      0
; end of _DELAY

_Hour:

;Nixie.c,1670 :: 		void Hour(unsigned char Point) {
;Nixie.c,1672 :: 		WriteDisplay((Data.hour >> 4),Data.PM,0,(Data.hour & 0x0F),0,0,(Data.minute >> 4),0,0,(Data.minute & 0x0F),0,0,(Data.second >> 4),0,0,(Data.second & 0x0F),0,(unsigned char)Alarm,Point,Point);
	MOVF        _Data+2, 0 
	MOVWF       FARG_WriteDisplay_D5+0 
	RRCF        FARG_WriteDisplay_D5+0, 1 
	BCF         FARG_WriteDisplay_D5+0, 7 
	RRCF        FARG_WriteDisplay_D5+0, 1 
	BCF         FARG_WriteDisplay_D5+0, 7 
	RRCF        FARG_WriteDisplay_D5+0, 1 
	BCF         FARG_WriteDisplay_D5+0, 7 
	RRCF        FARG_WriteDisplay_D5+0, 1 
	BCF         FARG_WriteDisplay_D5+0, 7 
	MOVF        _Data+3, 0 
	MOVWF       FARG_WriteDisplay_D5_L_P+0 
	CLRF        FARG_WriteDisplay_D5_R_P+0 
	MOVLW       15
	ANDWF       _Data+2, 0 
	MOVWF       FARG_WriteDisplay_D4+0 
	CLRF        FARG_WriteDisplay_D4_L_P+0 
	CLRF        FARG_WriteDisplay_D4_R_P+0 
	MOVF        _Data+1, 0 
	MOVWF       FARG_WriteDisplay_D3+0 
	RRCF        FARG_WriteDisplay_D3+0, 1 
	BCF         FARG_WriteDisplay_D3+0, 7 
	RRCF        FARG_WriteDisplay_D3+0, 1 
	BCF         FARG_WriteDisplay_D3+0, 7 
	RRCF        FARG_WriteDisplay_D3+0, 1 
	BCF         FARG_WriteDisplay_D3+0, 7 
	RRCF        FARG_WriteDisplay_D3+0, 1 
	BCF         FARG_WriteDisplay_D3+0, 7 
	CLRF        FARG_WriteDisplay_D3_L_P+0 
	CLRF        FARG_WriteDisplay_D3_R_P+0 
	MOVLW       15
	ANDWF       _Data+1, 0 
	MOVWF       FARG_WriteDisplay_D2+0 
	CLRF        FARG_WriteDisplay_D2_L_P+0 
	CLRF        FARG_WriteDisplay_D2_R_P+0 
	MOVF        _Data+0, 0 
	MOVWF       FARG_WriteDisplay_D1+0 
	RRCF        FARG_WriteDisplay_D1+0, 1 
	BCF         FARG_WriteDisplay_D1+0, 7 
	RRCF        FARG_WriteDisplay_D1+0, 1 
	BCF         FARG_WriteDisplay_D1+0, 7 
	RRCF        FARG_WriteDisplay_D1+0, 1 
	BCF         FARG_WriteDisplay_D1+0, 7 
	RRCF        FARG_WriteDisplay_D1+0, 1 
	BCF         FARG_WriteDisplay_D1+0, 7 
	CLRF        FARG_WriteDisplay_D1_L_P+0 
	CLRF        FARG_WriteDisplay_D1_R_P+0 
	MOVLW       15
	ANDWF       _Data+0, 0 
	MOVWF       FARG_WriteDisplay_D0+0 
	CLRF        FARG_WriteDisplay_D0_L_P+0 
	MOVLW       0
	BTFSC       _Alarm+0, BitPos(_Alarm+0) 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D0_R_P+0 
	MOVF        FARG_Hour_Point+0, 0 
	MOVWF       FARG_WriteDisplay_N0+0 
	MOVF        FARG_Hour_Point+0, 0 
	MOVWF       FARG_WriteDisplay_N1+0 
	CALL        _WriteDisplay+0, 0
;Nixie.c,1674 :: 		}
L_end_Hour:
	RETURN      0
; end of _Hour

_Hour_Cathode:

;Nixie.c,1681 :: 		void Hour_Cathode() {
;Nixie.c,1685 :: 		if (old_Data.second != Data.second) {
	MOVF        _old_Data+0, 0 
	XORWF       _Data+0, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_Hour_Cathode562
;Nixie.c,1687 :: 		Flag_Cathode_Poisoning = 1;
	BSF         _Flag_Cathode_Poisoning+0, BitPos(_Flag_Cathode_Poisoning+0) 
;Nixie.c,1689 :: 		if (Cathode_Poisoning >= 0x57) {
	MOVLW       87
	SUBWF       _Cathode_Poisoning+0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_Hour_Cathode563
;Nixie.c,1690 :: 		Flag_Cathode_Poisoning = 0;
	BCF         _Flag_Cathode_Poisoning+0, BitPos(_Flag_Cathode_Poisoning+0) 
;Nixie.c,1691 :: 		Cathode_Poisoning = 0;
	CLRF        _Cathode_Poisoning+0 
;Nixie.c,1692 :: 		old_Data = Data;
	MOVLW       9
	MOVWF       R0 
	MOVLW       _old_Data+0
	MOVWF       FSR1 
	MOVLW       hi_addr(_old_Data+0)
	MOVWF       FSR1H 
	MOVLW       _Data+0
	MOVWF       FSR0 
	MOVLW       hi_addr(_Data+0)
	MOVWF       FSR0H 
L_Hour_Cathode564:
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
	DECF        R0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_Hour_Cathode564
;Nixie.c,1693 :: 		}
L_Hour_Cathode563:
;Nixie.c,1695 :: 		n_Cathode = Cathode_Poisoning / 8;
	MOVF        _Cathode_Poisoning+0, 0 
	MOVWF       Hour_Cathode_n_Cathode_L0+0 
	RRCF        Hour_Cathode_n_Cathode_L0+0, 1 
	BCF         Hour_Cathode_n_Cathode_L0+0, 7 
	RRCF        Hour_Cathode_n_Cathode_L0+0, 1 
	BCF         Hour_Cathode_n_Cathode_L0+0, 7 
	RRCF        Hour_Cathode_n_Cathode_L0+0, 1 
	BCF         Hour_Cathode_n_Cathode_L0+0, 7 
;Nixie.c,1697 :: 		WriteDisplay((old_Data.hour & 0xF0) != (Data.hour & 0xF0) ? (n_Cathode+(old_Data.hour >> 4))%10 : (Data.hour >> 4),Data.PM,0,old_Data.hour != Data.hour ? (n_Cathode+(old_Data.hour & 0x0F))%10 : (Data.hour & 0x0F),0,0,(old_Data.minute & 0xF0) != (Data.minute & 0xF0) ? (n_Cathode+(old_Data.minute >> 4))%10 : (Data.minute >> 4),0,0,old_Data.minute != Data.minute ? (n_Cathode+(old_Data.minute & 0x0F))%10 : (Data.minute & 0x0F),0,0,(old_Data.second & 0xF0) != (Data.second & 0xF0) ? (n_Cathode+(old_Data.second >> 4))%10 : (Data.second >> 4),0,0,old_Data.second != Data.second ? (n_Cathode+(old_Data.second & 0x0F))%10 : (Data.second & 0x0F),0,(unsigned char)Alarm,0,0);
	MOVLW       240
	ANDWF       _old_Data+2, 0 
	MOVWF       R2 
	MOVLW       240
	ANDWF       _Data+2, 0 
	MOVWF       R1 
	MOVF        R2, 0 
	XORWF       R1, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_Hour_Cathode565
	MOVF        _old_Data+2, 0 
	MOVWF       R0 
	RRCF        R0, 1 
	BCF         R0, 7 
	RRCF        R0, 1 
	BCF         R0, 7 
	RRCF        R0, 1 
	BCF         R0, 7 
	RRCF        R0, 1 
	BCF         R0, 7 
	MOVF        Hour_Cathode_n_Cathode_L0+0, 0 
	ADDWF       R0, 1 
	CLRF        R1 
	MOVLW       0
	ADDWFC      R1, 1 
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Div_16x16_S+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       ?FLOC___Hour_CathodeT754+0 
	MOVF        R1, 0 
	MOVWF       ?FLOC___Hour_CathodeT754+1 
	GOTO        L_Hour_Cathode566
L_Hour_Cathode565:
	MOVLW       4
	MOVWF       R0 
	MOVF        _Data+2, 0 
	MOVWF       ?FLOC___Hour_CathodeT754+0 
	MOVLW       0
	MOVWF       ?FLOC___Hour_CathodeT754+1 
	MOVF        R0, 0 
L__Hour_Cathode1263:
	BZ          L__Hour_Cathode1264
	RRCF        ?FLOC___Hour_CathodeT754+0, 1 
	BCF         ?FLOC___Hour_CathodeT754+0, 7 
	ADDLW       255
	GOTO        L__Hour_Cathode1263
L__Hour_Cathode1264:
	MOVLW       0
	MOVWF       ?FLOC___Hour_CathodeT754+1 
L_Hour_Cathode566:
	MOVF        ?FLOC___Hour_CathodeT754+0, 0 
	MOVWF       FARG_WriteDisplay_D5+0 
	MOVF        _Data+3, 0 
	MOVWF       FARG_WriteDisplay_D5_L_P+0 
	CLRF        FARG_WriteDisplay_D5_R_P+0 
	MOVF        _old_Data+2, 0 
	XORWF       _Data+2, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_Hour_Cathode567
	MOVLW       15
	ANDWF       _old_Data+2, 0 
	MOVWF       R0 
	MOVF        Hour_Cathode_n_Cathode_L0+0, 0 
	ADDWF       R0, 1 
	CLRF        R1 
	MOVLW       0
	ADDWFC      R1, 1 
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Div_16x16_S+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       ?FLOC___Hour_CathodeT760+0 
	MOVF        R1, 0 
	MOVWF       ?FLOC___Hour_CathodeT760+1 
	GOTO        L_Hour_Cathode568
L_Hour_Cathode567:
	MOVLW       15
	ANDWF       _Data+2, 0 
	MOVWF       ?FLOC___Hour_CathodeT760+0 
	CLRF        ?FLOC___Hour_CathodeT760+1 
	MOVLW       0
	ANDWF       ?FLOC___Hour_CathodeT760+1, 1 
	MOVLW       0
	MOVWF       ?FLOC___Hour_CathodeT760+1 
L_Hour_Cathode568:
	MOVF        ?FLOC___Hour_CathodeT760+0, 0 
	MOVWF       FARG_WriteDisplay_D4+0 
	CLRF        FARG_WriteDisplay_D4_L_P+0 
	CLRF        FARG_WriteDisplay_D4_R_P+0 
	MOVLW       240
	ANDWF       _old_Data+1, 0 
	MOVWF       R2 
	MOVLW       240
	ANDWF       _Data+1, 0 
	MOVWF       R1 
	MOVF        R2, 0 
	XORWF       R1, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_Hour_Cathode569
	MOVF        _old_Data+1, 0 
	MOVWF       R0 
	RRCF        R0, 1 
	BCF         R0, 7 
	RRCF        R0, 1 
	BCF         R0, 7 
	RRCF        R0, 1 
	BCF         R0, 7 
	RRCF        R0, 1 
	BCF         R0, 7 
	MOVF        Hour_Cathode_n_Cathode_L0+0, 0 
	ADDWF       R0, 1 
	CLRF        R1 
	MOVLW       0
	ADDWFC      R1, 1 
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Div_16x16_S+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       ?FLOC___Hour_CathodeT768+0 
	MOVF        R1, 0 
	MOVWF       ?FLOC___Hour_CathodeT768+1 
	GOTO        L_Hour_Cathode570
L_Hour_Cathode569:
	MOVLW       4
	MOVWF       R0 
	MOVF        _Data+1, 0 
	MOVWF       ?FLOC___Hour_CathodeT768+0 
	MOVLW       0
	MOVWF       ?FLOC___Hour_CathodeT768+1 
	MOVF        R0, 0 
L__Hour_Cathode1265:
	BZ          L__Hour_Cathode1266
	RRCF        ?FLOC___Hour_CathodeT768+0, 1 
	BCF         ?FLOC___Hour_CathodeT768+0, 7 
	ADDLW       255
	GOTO        L__Hour_Cathode1265
L__Hour_Cathode1266:
	MOVLW       0
	MOVWF       ?FLOC___Hour_CathodeT768+1 
L_Hour_Cathode570:
	MOVF        ?FLOC___Hour_CathodeT768+0, 0 
	MOVWF       FARG_WriteDisplay_D3+0 
	CLRF        FARG_WriteDisplay_D3_L_P+0 
	CLRF        FARG_WriteDisplay_D3_R_P+0 
	MOVF        _old_Data+1, 0 
	XORWF       _Data+1, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_Hour_Cathode571
	MOVLW       15
	ANDWF       _old_Data+1, 0 
	MOVWF       R0 
	MOVF        Hour_Cathode_n_Cathode_L0+0, 0 
	ADDWF       R0, 1 
	CLRF        R1 
	MOVLW       0
	ADDWFC      R1, 1 
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Div_16x16_S+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       ?FLOC___Hour_CathodeT774+0 
	MOVF        R1, 0 
	MOVWF       ?FLOC___Hour_CathodeT774+1 
	GOTO        L_Hour_Cathode572
L_Hour_Cathode571:
	MOVLW       15
	ANDWF       _Data+1, 0 
	MOVWF       ?FLOC___Hour_CathodeT774+0 
	CLRF        ?FLOC___Hour_CathodeT774+1 
	MOVLW       0
	ANDWF       ?FLOC___Hour_CathodeT774+1, 1 
	MOVLW       0
	MOVWF       ?FLOC___Hour_CathodeT774+1 
L_Hour_Cathode572:
	MOVF        ?FLOC___Hour_CathodeT774+0, 0 
	MOVWF       FARG_WriteDisplay_D2+0 
	CLRF        FARG_WriteDisplay_D2_L_P+0 
	CLRF        FARG_WriteDisplay_D2_R_P+0 
	MOVLW       240
	ANDWF       _old_Data+0, 0 
	MOVWF       R2 
	MOVLW       240
	ANDWF       _Data+0, 0 
	MOVWF       R1 
	MOVF        R2, 0 
	XORWF       R1, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_Hour_Cathode573
	MOVF        _old_Data+0, 0 
	MOVWF       R0 
	RRCF        R0, 1 
	BCF         R0, 7 
	RRCF        R0, 1 
	BCF         R0, 7 
	RRCF        R0, 1 
	BCF         R0, 7 
	RRCF        R0, 1 
	BCF         R0, 7 
	MOVF        Hour_Cathode_n_Cathode_L0+0, 0 
	ADDWF       R0, 1 
	CLRF        R1 
	MOVLW       0
	ADDWFC      R1, 1 
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Div_16x16_S+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       ?FLOC___Hour_CathodeT782+0 
	MOVF        R1, 0 
	MOVWF       ?FLOC___Hour_CathodeT782+1 
	GOTO        L_Hour_Cathode574
L_Hour_Cathode573:
	MOVLW       4
	MOVWF       R0 
	MOVF        _Data+0, 0 
	MOVWF       ?FLOC___Hour_CathodeT782+0 
	MOVLW       0
	MOVWF       ?FLOC___Hour_CathodeT782+1 
	MOVF        R0, 0 
L__Hour_Cathode1267:
	BZ          L__Hour_Cathode1268
	RRCF        ?FLOC___Hour_CathodeT782+0, 1 
	BCF         ?FLOC___Hour_CathodeT782+0, 7 
	ADDLW       255
	GOTO        L__Hour_Cathode1267
L__Hour_Cathode1268:
	MOVLW       0
	MOVWF       ?FLOC___Hour_CathodeT782+1 
L_Hour_Cathode574:
	MOVF        ?FLOC___Hour_CathodeT782+0, 0 
	MOVWF       FARG_WriteDisplay_D1+0 
	CLRF        FARG_WriteDisplay_D1_L_P+0 
	CLRF        FARG_WriteDisplay_D1_R_P+0 
	MOVF        _old_Data+0, 0 
	XORWF       _Data+0, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_Hour_Cathode575
	MOVLW       15
	ANDWF       _old_Data+0, 0 
	MOVWF       R0 
	MOVF        Hour_Cathode_n_Cathode_L0+0, 0 
	ADDWF       R0, 1 
	CLRF        R1 
	MOVLW       0
	ADDWFC      R1, 1 
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Div_16x16_S+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       ?FLOC___Hour_CathodeT788+0 
	MOVF        R1, 0 
	MOVWF       ?FLOC___Hour_CathodeT788+1 
	GOTO        L_Hour_Cathode576
L_Hour_Cathode575:
	MOVLW       15
	ANDWF       _Data+0, 0 
	MOVWF       ?FLOC___Hour_CathodeT788+0 
	CLRF        ?FLOC___Hour_CathodeT788+1 
	MOVLW       0
	ANDWF       ?FLOC___Hour_CathodeT788+1, 1 
	MOVLW       0
	MOVWF       ?FLOC___Hour_CathodeT788+1 
L_Hour_Cathode576:
	MOVF        ?FLOC___Hour_CathodeT788+0, 0 
	MOVWF       FARG_WriteDisplay_D0+0 
	CLRF        FARG_WriteDisplay_D0_L_P+0 
	MOVLW       0
	BTFSC       _Alarm+0, BitPos(_Alarm+0) 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D0_R_P+0 
	CLRF        FARG_WriteDisplay_N0+0 
	CLRF        FARG_WriteDisplay_N1+0 
	CALL        _WriteDisplay+0, 0
;Nixie.c,1699 :: 		} else
	GOTO        L_Hour_Cathode577
L_Hour_Cathode562:
;Nixie.c,1702 :: 		Hour(1);
	MOVLW       1
	MOVWF       FARG_Hour_Point+0 
	CALL        _Hour+0, 0
L_Hour_Cathode577:
;Nixie.c,1705 :: 		}
L_end_Hour_Cathode:
	RETURN      0
; end of _Hour_Cathode

_Hour_Fading:

;Nixie.c,1712 :: 		void Hour_Fading() {
;Nixie.c,1716 :: 		if (old_Data.second != Data.second) {
	MOVF        _old_Data+0, 0 
	XORWF       _Data+0, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_Hour_Fading578
;Nixie.c,1718 :: 		Flag_Fading = 1;
	BSF         _Flag_Fading+0, BitPos(_Flag_Fading+0) 
;Nixie.c,1720 :: 		if (Fading >= 160) {
	MOVLW       160
	SUBWF       _Fading+0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_Hour_Fading579
;Nixie.c,1721 :: 		Flag_Fading = 0;
	BCF         _Flag_Fading+0, BitPos(_Flag_Fading+0) 
;Nixie.c,1722 :: 		Fading = 0;
	CLRF        _Fading+0 
;Nixie.c,1723 :: 		toggle_Fading = 0;
	BCF         _toggle_Fading+0, BitPos(_toggle_Fading+0) 
;Nixie.c,1724 :: 		old_Data = Data;
	MOVLW       9
	MOVWF       R0 
	MOVLW       _old_Data+0
	MOVWF       FSR1 
	MOVLW       hi_addr(_old_Data+0)
	MOVWF       FSR1H 
	MOVLW       _Data+0
	MOVWF       FSR0 
	MOVLW       hi_addr(_Data+0)
	MOVWF       FSR0H 
L_Hour_Fading580:
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
	DECF        R0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_Hour_Fading580
;Nixie.c,1725 :: 		return;
	GOTO        L_end_Hour_Fading
;Nixie.c,1726 :: 		}
L_Hour_Fading579:
;Nixie.c,1728 :: 		new_Fading = (Fading*ACESO) / 160;
	MOVF        _Fading+0, 0 
	MULWF       _ACESO+0 
	MOVF        PRODL+0, 0 
	MOVWF       R0 
	MOVF        PRODH+0, 0 
	MOVWF       R1 
	MOVLW       160
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Div_16x16_S+0, 0
	MOVF        R0, 0 
	MOVWF       Hour_Fading_new_Fading_L0+0 
;Nixie.c,1729 :: 		old_Fading = ACESO - new_Fading;
	MOVF        R0, 0 
	SUBWF       _ACESO+0, 0 
	MOVWF       Hour_Fading_old_Fading_L0+0 
;Nixie.c,1731 :: 		if (toggle_Fading)
	BTFSS       _toggle_Fading+0, BitPos(_toggle_Fading+0) 
	GOTO        L_Hour_Fading581
;Nixie.c,1732 :: 		WriteDisplay_Fading((Data.hour >> 4),Data.PM,0,(old_Data.hour & 0xF0) != (Data.hour & 0xF0) ? 1 : 0,(Data.hour & 0x0F),0,0,old_Data.hour != Data.hour ? 1 : 0,(Data.minute >> 4),0,0,(old_Data.minute & 0xF0) != (Data.minute & 0xF0) ? 1 : 0,(Data.minute & 0x0F),0,0,old_Data.minute != Data.minute ? 1 : 0,(Data.second >> 4),0,0,(old_Data.second & 0xF0) != (Data.second & 0xF0) ? 1 : 0,(Data.second & 0x0F),0,(unsigned char)Alarm,old_Data.second != Data.second ? 1 : 0,0,0,0,0,new_Fading,(100-new_Fading));
	MOVF        _Data+2, 0 
	MOVWF       FARG_WriteDisplay_Fading_D5+0 
	RRCF        FARG_WriteDisplay_Fading_D5+0, 1 
	BCF         FARG_WriteDisplay_Fading_D5+0, 7 
	RRCF        FARG_WriteDisplay_Fading_D5+0, 1 
	BCF         FARG_WriteDisplay_Fading_D5+0, 7 
	RRCF        FARG_WriteDisplay_Fading_D5+0, 1 
	BCF         FARG_WriteDisplay_Fading_D5+0, 7 
	RRCF        FARG_WriteDisplay_Fading_D5+0, 1 
	BCF         FARG_WriteDisplay_Fading_D5+0, 7 
	MOVF        _Data+3, 0 
	MOVWF       FARG_WriteDisplay_Fading_D5_L_P+0 
	CLRF        FARG_WriteDisplay_Fading_D5_R_P+0 
	MOVLW       240
	ANDWF       _old_Data+2, 0 
	MOVWF       R2 
	MOVLW       240
	ANDWF       _Data+2, 0 
	MOVWF       R1 
	MOVF        R2, 0 
	XORWF       R1, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_Hour_Fading582
	MOVLW       1
	MOVWF       ?FLOC___Hour_FadingT806+0 
	GOTO        L_Hour_Fading583
L_Hour_Fading582:
	CLRF        ?FLOC___Hour_FadingT806+0 
L_Hour_Fading583:
	MOVF        ?FLOC___Hour_FadingT806+0, 0 
	MOVWF       FARG_WriteDisplay_Fading_F5+0 
	MOVLW       15
	ANDWF       _Data+2, 0 
	MOVWF       FARG_WriteDisplay_Fading_D4+0 
	CLRF        FARG_WriteDisplay_Fading_D4_L_P+0 
	CLRF        FARG_WriteDisplay_Fading_D4_R_P+0 
	MOVF        _old_Data+2, 0 
	XORWF       _Data+2, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_Hour_Fading584
	MOVLW       1
	MOVWF       ?FLOC___Hour_FadingT809+0 
	GOTO        L_Hour_Fading585
L_Hour_Fading584:
	CLRF        ?FLOC___Hour_FadingT809+0 
L_Hour_Fading585:
	MOVF        ?FLOC___Hour_FadingT809+0, 0 
	MOVWF       FARG_WriteDisplay_Fading_F4+0 
	MOVF        _Data+1, 0 
	MOVWF       FARG_WriteDisplay_Fading_D3+0 
	RRCF        FARG_WriteDisplay_Fading_D3+0, 1 
	BCF         FARG_WriteDisplay_Fading_D3+0, 7 
	RRCF        FARG_WriteDisplay_Fading_D3+0, 1 
	BCF         FARG_WriteDisplay_Fading_D3+0, 7 
	RRCF        FARG_WriteDisplay_Fading_D3+0, 1 
	BCF         FARG_WriteDisplay_Fading_D3+0, 7 
	RRCF        FARG_WriteDisplay_Fading_D3+0, 1 
	BCF         FARG_WriteDisplay_Fading_D3+0, 7 
	CLRF        FARG_WriteDisplay_Fading_D3_L_P+0 
	CLRF        FARG_WriteDisplay_Fading_D3_R_P+0 
	MOVLW       240
	ANDWF       _old_Data+1, 0 
	MOVWF       R2 
	MOVLW       240
	ANDWF       _Data+1, 0 
	MOVWF       R1 
	MOVF        R2, 0 
	XORWF       R1, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_Hour_Fading586
	MOVLW       1
	MOVWF       ?FLOC___Hour_FadingT814+0 
	GOTO        L_Hour_Fading587
L_Hour_Fading586:
	CLRF        ?FLOC___Hour_FadingT814+0 
L_Hour_Fading587:
	MOVF        ?FLOC___Hour_FadingT814+0, 0 
	MOVWF       FARG_WriteDisplay_Fading_F3+0 
	MOVLW       15
	ANDWF       _Data+1, 0 
	MOVWF       FARG_WriteDisplay_Fading_D2+0 
	CLRF        FARG_WriteDisplay_Fading_D2_L_P+0 
	CLRF        FARG_WriteDisplay_Fading_D2_R_P+0 
	MOVF        _old_Data+1, 0 
	XORWF       _Data+1, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_Hour_Fading588
	MOVLW       1
	MOVWF       ?FLOC___Hour_FadingT817+0 
	GOTO        L_Hour_Fading589
L_Hour_Fading588:
	CLRF        ?FLOC___Hour_FadingT817+0 
L_Hour_Fading589:
	MOVF        ?FLOC___Hour_FadingT817+0, 0 
	MOVWF       FARG_WriteDisplay_Fading_F2+0 
	MOVF        _Data+0, 0 
	MOVWF       FARG_WriteDisplay_Fading_D1+0 
	RRCF        FARG_WriteDisplay_Fading_D1+0, 1 
	BCF         FARG_WriteDisplay_Fading_D1+0, 7 
	RRCF        FARG_WriteDisplay_Fading_D1+0, 1 
	BCF         FARG_WriteDisplay_Fading_D1+0, 7 
	RRCF        FARG_WriteDisplay_Fading_D1+0, 1 
	BCF         FARG_WriteDisplay_Fading_D1+0, 7 
	RRCF        FARG_WriteDisplay_Fading_D1+0, 1 
	BCF         FARG_WriteDisplay_Fading_D1+0, 7 
	CLRF        FARG_WriteDisplay_Fading_D1_L_P+0 
	CLRF        FARG_WriteDisplay_Fading_D1_R_P+0 
	MOVLW       240
	ANDWF       _old_Data+0, 0 
	MOVWF       R2 
	MOVLW       240
	ANDWF       _Data+0, 0 
	MOVWF       R1 
	MOVF        R2, 0 
	XORWF       R1, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_Hour_Fading590
	MOVLW       1
	MOVWF       ?FLOC___Hour_FadingT822+0 
	GOTO        L_Hour_Fading591
L_Hour_Fading590:
	CLRF        ?FLOC___Hour_FadingT822+0 
L_Hour_Fading591:
	MOVF        ?FLOC___Hour_FadingT822+0, 0 
	MOVWF       FARG_WriteDisplay_Fading_F1+0 
	MOVLW       15
	ANDWF       _Data+0, 0 
	MOVWF       FARG_WriteDisplay_Fading_D0+0 
	CLRF        FARG_WriteDisplay_Fading_D0_L_P+0 
	MOVLW       0
	BTFSC       _Alarm+0, BitPos(_Alarm+0) 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_Fading_D0_R_P+0 
	MOVF        _old_Data+0, 0 
	XORWF       _Data+0, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_Hour_Fading592
	MOVLW       1
	MOVWF       ?FLOC___Hour_FadingT826+0 
	GOTO        L_Hour_Fading593
L_Hour_Fading592:
	CLRF        ?FLOC___Hour_FadingT826+0 
L_Hour_Fading593:
	MOVF        ?FLOC___Hour_FadingT826+0, 0 
	MOVWF       FARG_WriteDisplay_Fading_F0+0 
	CLRF        FARG_WriteDisplay_Fading_N0+0 
	CLRF        FARG_WriteDisplay_Fading_F_N0+0 
	CLRF        FARG_WriteDisplay_Fading_N1+0 
	CLRF        FARG_WriteDisplay_Fading_F_N1+0 
	MOVF        Hour_Fading_new_Fading_L0+0, 0 
	MOVWF       FARG_WriteDisplay_Fading_ON+0 
	MOVF        Hour_Fading_new_Fading_L0+0, 0 
	SUBLW       100
	MOVWF       FARG_WriteDisplay_Fading_OFF+0 
	CALL        _WriteDisplay_Fading+0, 0
	GOTO        L_Hour_Fading594
L_Hour_Fading581:
;Nixie.c,1734 :: 		WriteDisplay_Fading((old_Data.hour >> 4),Data.PM,0,(old_Data.hour & 0xF0) != (Data.hour & 0xF0) ? 1 : 0,(old_Data.hour & 0x0F),0,0,old_Data.hour != Data.hour ? 1 : 0,(old_Data.minute >> 4),0,0,(old_Data.minute & 0xF0) != (Data.minute & 0xF0) ? 1 : 0,(old_Data.minute & 0x0F),0,0,old_Data.minute != Data.minute ? 1 : 0,(old_Data.second >> 4),0,0,(old_Data.second & 0xF0) != (Data.second & 0xF0) ? 1 : 0,(old_Data.second & 0x0F),0,(unsigned char)Alarm,old_Data.second != Data.second ? 1 : 0,0,0,0,0,old_Fading,(100-old_Fading));
	MOVF        _old_Data+2, 0 
	MOVWF       FARG_WriteDisplay_Fading_D5+0 
	RRCF        FARG_WriteDisplay_Fading_D5+0, 1 
	BCF         FARG_WriteDisplay_Fading_D5+0, 7 
	RRCF        FARG_WriteDisplay_Fading_D5+0, 1 
	BCF         FARG_WriteDisplay_Fading_D5+0, 7 
	RRCF        FARG_WriteDisplay_Fading_D5+0, 1 
	BCF         FARG_WriteDisplay_Fading_D5+0, 7 
	RRCF        FARG_WriteDisplay_Fading_D5+0, 1 
	BCF         FARG_WriteDisplay_Fading_D5+0, 7 
	MOVF        _Data+3, 0 
	MOVWF       FARG_WriteDisplay_Fading_D5_L_P+0 
	CLRF        FARG_WriteDisplay_Fading_D5_R_P+0 
	MOVLW       240
	ANDWF       _old_Data+2, 0 
	MOVWF       R2 
	MOVLW       240
	ANDWF       _Data+2, 0 
	MOVWF       R1 
	MOVF        R2, 0 
	XORWF       R1, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_Hour_Fading595
	MOVLW       1
	MOVWF       ?FLOC___Hour_FadingT832+0 
	GOTO        L_Hour_Fading596
L_Hour_Fading595:
	CLRF        ?FLOC___Hour_FadingT832+0 
L_Hour_Fading596:
	MOVF        ?FLOC___Hour_FadingT832+0, 0 
	MOVWF       FARG_WriteDisplay_Fading_F5+0 
	MOVLW       15
	ANDWF       _old_Data+2, 0 
	MOVWF       FARG_WriteDisplay_Fading_D4+0 
	CLRF        FARG_WriteDisplay_Fading_D4_L_P+0 
	CLRF        FARG_WriteDisplay_Fading_D4_R_P+0 
	MOVF        _old_Data+2, 0 
	XORWF       _Data+2, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_Hour_Fading597
	MOVLW       1
	MOVWF       ?FLOC___Hour_FadingT835+0 
	GOTO        L_Hour_Fading598
L_Hour_Fading597:
	CLRF        ?FLOC___Hour_FadingT835+0 
L_Hour_Fading598:
	MOVF        ?FLOC___Hour_FadingT835+0, 0 
	MOVWF       FARG_WriteDisplay_Fading_F4+0 
	MOVF        _old_Data+1, 0 
	MOVWF       FARG_WriteDisplay_Fading_D3+0 
	RRCF        FARG_WriteDisplay_Fading_D3+0, 1 
	BCF         FARG_WriteDisplay_Fading_D3+0, 7 
	RRCF        FARG_WriteDisplay_Fading_D3+0, 1 
	BCF         FARG_WriteDisplay_Fading_D3+0, 7 
	RRCF        FARG_WriteDisplay_Fading_D3+0, 1 
	BCF         FARG_WriteDisplay_Fading_D3+0, 7 
	RRCF        FARG_WriteDisplay_Fading_D3+0, 1 
	BCF         FARG_WriteDisplay_Fading_D3+0, 7 
	CLRF        FARG_WriteDisplay_Fading_D3_L_P+0 
	CLRF        FARG_WriteDisplay_Fading_D3_R_P+0 
	MOVLW       240
	ANDWF       _old_Data+1, 0 
	MOVWF       R2 
	MOVLW       240
	ANDWF       _Data+1, 0 
	MOVWF       R1 
	MOVF        R2, 0 
	XORWF       R1, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_Hour_Fading599
	MOVLW       1
	MOVWF       ?FLOC___Hour_FadingT840+0 
	GOTO        L_Hour_Fading600
L_Hour_Fading599:
	CLRF        ?FLOC___Hour_FadingT840+0 
L_Hour_Fading600:
	MOVF        ?FLOC___Hour_FadingT840+0, 0 
	MOVWF       FARG_WriteDisplay_Fading_F3+0 
	MOVLW       15
	ANDWF       _old_Data+1, 0 
	MOVWF       FARG_WriteDisplay_Fading_D2+0 
	CLRF        FARG_WriteDisplay_Fading_D2_L_P+0 
	CLRF        FARG_WriteDisplay_Fading_D2_R_P+0 
	MOVF        _old_Data+1, 0 
	XORWF       _Data+1, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_Hour_Fading601
	MOVLW       1
	MOVWF       ?FLOC___Hour_FadingT843+0 
	GOTO        L_Hour_Fading602
L_Hour_Fading601:
	CLRF        ?FLOC___Hour_FadingT843+0 
L_Hour_Fading602:
	MOVF        ?FLOC___Hour_FadingT843+0, 0 
	MOVWF       FARG_WriteDisplay_Fading_F2+0 
	MOVF        _old_Data+0, 0 
	MOVWF       FARG_WriteDisplay_Fading_D1+0 
	RRCF        FARG_WriteDisplay_Fading_D1+0, 1 
	BCF         FARG_WriteDisplay_Fading_D1+0, 7 
	RRCF        FARG_WriteDisplay_Fading_D1+0, 1 
	BCF         FARG_WriteDisplay_Fading_D1+0, 7 
	RRCF        FARG_WriteDisplay_Fading_D1+0, 1 
	BCF         FARG_WriteDisplay_Fading_D1+0, 7 
	RRCF        FARG_WriteDisplay_Fading_D1+0, 1 
	BCF         FARG_WriteDisplay_Fading_D1+0, 7 
	CLRF        FARG_WriteDisplay_Fading_D1_L_P+0 
	CLRF        FARG_WriteDisplay_Fading_D1_R_P+0 
	MOVLW       240
	ANDWF       _old_Data+0, 0 
	MOVWF       R2 
	MOVLW       240
	ANDWF       _Data+0, 0 
	MOVWF       R1 
	MOVF        R2, 0 
	XORWF       R1, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_Hour_Fading603
	MOVLW       1
	MOVWF       ?FLOC___Hour_FadingT848+0 
	GOTO        L_Hour_Fading604
L_Hour_Fading603:
	CLRF        ?FLOC___Hour_FadingT848+0 
L_Hour_Fading604:
	MOVF        ?FLOC___Hour_FadingT848+0, 0 
	MOVWF       FARG_WriteDisplay_Fading_F1+0 
	MOVLW       15
	ANDWF       _old_Data+0, 0 
	MOVWF       FARG_WriteDisplay_Fading_D0+0 
	CLRF        FARG_WriteDisplay_Fading_D0_L_P+0 
	MOVLW       0
	BTFSC       _Alarm+0, BitPos(_Alarm+0) 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_Fading_D0_R_P+0 
	MOVF        _old_Data+0, 0 
	XORWF       _Data+0, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_Hour_Fading605
	MOVLW       1
	MOVWF       ?FLOC___Hour_FadingT852+0 
	GOTO        L_Hour_Fading606
L_Hour_Fading605:
	CLRF        ?FLOC___Hour_FadingT852+0 
L_Hour_Fading606:
	MOVF        ?FLOC___Hour_FadingT852+0, 0 
	MOVWF       FARG_WriteDisplay_Fading_F0+0 
	CLRF        FARG_WriteDisplay_Fading_N0+0 
	CLRF        FARG_WriteDisplay_Fading_F_N0+0 
	CLRF        FARG_WriteDisplay_Fading_N1+0 
	CLRF        FARG_WriteDisplay_Fading_F_N1+0 
	MOVF        Hour_Fading_old_Fading_L0+0, 0 
	MOVWF       FARG_WriteDisplay_Fading_ON+0 
	MOVF        Hour_Fading_old_Fading_L0+0, 0 
	SUBLW       100
	MOVWF       FARG_WriteDisplay_Fading_OFF+0 
	CALL        _WriteDisplay_Fading+0, 0
L_Hour_Fading594:
;Nixie.c,1736 :: 		toggle_Fading = !toggle_Fading;
	BTG         _toggle_Fading+0, BitPos(_toggle_Fading+0) 
;Nixie.c,1738 :: 		} else
	GOTO        L_Hour_Fading607
L_Hour_Fading578:
;Nixie.c,1740 :: 		WriteDisplay_Fading((Data.hour >> 4),Data.PM,0,0,(Data.hour & 0x0F),0,0,0,(Data.minute >> 4),0,0,0,(Data.minute & 0x0F),0,0,0,(Data.second >> 4),0,0,0,(Data.second & 0x0F),0,(unsigned char)Alarm,0,1,0,1,0,ACESO,APAGADO);
	MOVF        _Data+2, 0 
	MOVWF       FARG_WriteDisplay_Fading_D5+0 
	RRCF        FARG_WriteDisplay_Fading_D5+0, 1 
	BCF         FARG_WriteDisplay_Fading_D5+0, 7 
	RRCF        FARG_WriteDisplay_Fading_D5+0, 1 
	BCF         FARG_WriteDisplay_Fading_D5+0, 7 
	RRCF        FARG_WriteDisplay_Fading_D5+0, 1 
	BCF         FARG_WriteDisplay_Fading_D5+0, 7 
	RRCF        FARG_WriteDisplay_Fading_D5+0, 1 
	BCF         FARG_WriteDisplay_Fading_D5+0, 7 
	MOVF        _Data+3, 0 
	MOVWF       FARG_WriteDisplay_Fading_D5_L_P+0 
	CLRF        FARG_WriteDisplay_Fading_D5_R_P+0 
	CLRF        FARG_WriteDisplay_Fading_F5+0 
	MOVLW       15
	ANDWF       _Data+2, 0 
	MOVWF       FARG_WriteDisplay_Fading_D4+0 
	CLRF        FARG_WriteDisplay_Fading_D4_L_P+0 
	CLRF        FARG_WriteDisplay_Fading_D4_R_P+0 
	CLRF        FARG_WriteDisplay_Fading_F4+0 
	MOVF        _Data+1, 0 
	MOVWF       FARG_WriteDisplay_Fading_D3+0 
	RRCF        FARG_WriteDisplay_Fading_D3+0, 1 
	BCF         FARG_WriteDisplay_Fading_D3+0, 7 
	RRCF        FARG_WriteDisplay_Fading_D3+0, 1 
	BCF         FARG_WriteDisplay_Fading_D3+0, 7 
	RRCF        FARG_WriteDisplay_Fading_D3+0, 1 
	BCF         FARG_WriteDisplay_Fading_D3+0, 7 
	RRCF        FARG_WriteDisplay_Fading_D3+0, 1 
	BCF         FARG_WriteDisplay_Fading_D3+0, 7 
	CLRF        FARG_WriteDisplay_Fading_D3_L_P+0 
	CLRF        FARG_WriteDisplay_Fading_D3_R_P+0 
	CLRF        FARG_WriteDisplay_Fading_F3+0 
	MOVLW       15
	ANDWF       _Data+1, 0 
	MOVWF       FARG_WriteDisplay_Fading_D2+0 
	CLRF        FARG_WriteDisplay_Fading_D2_L_P+0 
	CLRF        FARG_WriteDisplay_Fading_D2_R_P+0 
	CLRF        FARG_WriteDisplay_Fading_F2+0 
	MOVF        _Data+0, 0 
	MOVWF       FARG_WriteDisplay_Fading_D1+0 
	RRCF        FARG_WriteDisplay_Fading_D1+0, 1 
	BCF         FARG_WriteDisplay_Fading_D1+0, 7 
	RRCF        FARG_WriteDisplay_Fading_D1+0, 1 
	BCF         FARG_WriteDisplay_Fading_D1+0, 7 
	RRCF        FARG_WriteDisplay_Fading_D1+0, 1 
	BCF         FARG_WriteDisplay_Fading_D1+0, 7 
	RRCF        FARG_WriteDisplay_Fading_D1+0, 1 
	BCF         FARG_WriteDisplay_Fading_D1+0, 7 
	CLRF        FARG_WriteDisplay_Fading_D1_L_P+0 
	CLRF        FARG_WriteDisplay_Fading_D1_R_P+0 
	CLRF        FARG_WriteDisplay_Fading_F1+0 
	MOVLW       15
	ANDWF       _Data+0, 0 
	MOVWF       FARG_WriteDisplay_Fading_D0+0 
	CLRF        FARG_WriteDisplay_Fading_D0_L_P+0 
	MOVLW       0
	BTFSC       _Alarm+0, BitPos(_Alarm+0) 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_Fading_D0_R_P+0 
	CLRF        FARG_WriteDisplay_Fading_F0+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_Fading_N0+0 
	CLRF        FARG_WriteDisplay_Fading_F_N0+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_Fading_N1+0 
	CLRF        FARG_WriteDisplay_Fading_F_N1+0 
	MOVF        _ACESO+0, 0 
	MOVWF       FARG_WriteDisplay_Fading_ON+0 
	MOVF        _APAGADO+0, 0 
	MOVWF       FARG_WriteDisplay_Fading_OFF+0 
	CALL        _WriteDisplay_Fading+0, 0
L_Hour_Fading607:
;Nixie.c,1742 :: 		}
L_end_Hour_Fading:
	RETURN      0
; end of _Hour_Fading

_Hour_FadingFull:

;Nixie.c,1748 :: 		void Hour_FadingFull() {
;Nixie.c,1752 :: 		if (old_Data.second != Data.second) {
	MOVF        _old_Data+0, 0 
	XORWF       _Data+0, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_Hour_FadingFull608
;Nixie.c,1754 :: 		Flag_Fading = 1;
	BSF         _Flag_Fading+0, BitPos(_Flag_Fading+0) 
;Nixie.c,1756 :: 		if (Fading >= 0x00 && Fading <= 0x59) {
	MOVLW       0
	SUBWF       _Fading+0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_Hour_FadingFull611
	MOVF        _Fading+0, 0 
	SUBLW       89
	BTFSS       STATUS+0, 0 
	GOTO        L_Hour_FadingFull611
L__Hour_FadingFull996:
;Nixie.c,1758 :: 		new_Fading = (unsigned char)(((float)ACESO / 0x5A) * Fading);
	MOVF        _ACESO+0, 0 
	MOVWF       R0 
	CALL        _byte2double+0, 0
	MOVLW       0
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVLW       52
	MOVWF       R6 
	MOVLW       133
	MOVWF       R7 
	CALL        _Div_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       FLOC__Hour_FadingFull+0 
	MOVF        R1, 0 
	MOVWF       FLOC__Hour_FadingFull+1 
	MOVF        R2, 0 
	MOVWF       FLOC__Hour_FadingFull+2 
	MOVF        R3, 0 
	MOVWF       FLOC__Hour_FadingFull+3 
	MOVF        _Fading+0, 0 
	MOVWF       R0 
	CALL        _byte2double+0, 0
	MOVF        FLOC__Hour_FadingFull+0, 0 
	MOVWF       R4 
	MOVF        FLOC__Hour_FadingFull+1, 0 
	MOVWF       R5 
	MOVF        FLOC__Hour_FadingFull+2, 0 
	MOVWF       R6 
	MOVF        FLOC__Hour_FadingFull+3, 0 
	MOVWF       R7 
	CALL        _Mul_32x32_FP+0, 0
	CALL        _double2byte+0, 0
;Nixie.c,1759 :: 		old_Fading = ACESO - new_Fading;
	MOVF        R0, 0 
	SUBWF       _ACESO+0, 0 
	MOVWF       R1 
;Nixie.c,1761 :: 		WriteDisplay_Fading((old_Data.hour >> 4),Data.PM,0,1,(old_Data.hour & 0x0F),0,0,1,(old_Data.minute >> 4),0,0,1,(old_Data.minute & 0x0F),0,0,1,(old_Data.second >> 4),0,0,1,(old_Data.second & 0x0F),0,(unsigned char)Alarm,1,1,1,1,1,old_Fading,(100-old_Fading));
	MOVF        _old_Data+2, 0 
	MOVWF       FARG_WriteDisplay_Fading_D5+0 
	RRCF        FARG_WriteDisplay_Fading_D5+0, 1 
	BCF         FARG_WriteDisplay_Fading_D5+0, 7 
	RRCF        FARG_WriteDisplay_Fading_D5+0, 1 
	BCF         FARG_WriteDisplay_Fading_D5+0, 7 
	RRCF        FARG_WriteDisplay_Fading_D5+0, 1 
	BCF         FARG_WriteDisplay_Fading_D5+0, 7 
	RRCF        FARG_WriteDisplay_Fading_D5+0, 1 
	BCF         FARG_WriteDisplay_Fading_D5+0, 7 
	MOVF        _Data+3, 0 
	MOVWF       FARG_WriteDisplay_Fading_D5_L_P+0 
	CLRF        FARG_WriteDisplay_Fading_D5_R_P+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_Fading_F5+0 
	MOVLW       15
	ANDWF       _old_Data+2, 0 
	MOVWF       FARG_WriteDisplay_Fading_D4+0 
	CLRF        FARG_WriteDisplay_Fading_D4_L_P+0 
	CLRF        FARG_WriteDisplay_Fading_D4_R_P+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_Fading_F4+0 
	MOVF        _old_Data+1, 0 
	MOVWF       FARG_WriteDisplay_Fading_D3+0 
	RRCF        FARG_WriteDisplay_Fading_D3+0, 1 
	BCF         FARG_WriteDisplay_Fading_D3+0, 7 
	RRCF        FARG_WriteDisplay_Fading_D3+0, 1 
	BCF         FARG_WriteDisplay_Fading_D3+0, 7 
	RRCF        FARG_WriteDisplay_Fading_D3+0, 1 
	BCF         FARG_WriteDisplay_Fading_D3+0, 7 
	RRCF        FARG_WriteDisplay_Fading_D3+0, 1 
	BCF         FARG_WriteDisplay_Fading_D3+0, 7 
	CLRF        FARG_WriteDisplay_Fading_D3_L_P+0 
	CLRF        FARG_WriteDisplay_Fading_D3_R_P+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_Fading_F3+0 
	MOVLW       15
	ANDWF       _old_Data+1, 0 
	MOVWF       FARG_WriteDisplay_Fading_D2+0 
	CLRF        FARG_WriteDisplay_Fading_D2_L_P+0 
	CLRF        FARG_WriteDisplay_Fading_D2_R_P+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_Fading_F2+0 
	MOVF        _old_Data+0, 0 
	MOVWF       FARG_WriteDisplay_Fading_D1+0 
	RRCF        FARG_WriteDisplay_Fading_D1+0, 1 
	BCF         FARG_WriteDisplay_Fading_D1+0, 7 
	RRCF        FARG_WriteDisplay_Fading_D1+0, 1 
	BCF         FARG_WriteDisplay_Fading_D1+0, 7 
	RRCF        FARG_WriteDisplay_Fading_D1+0, 1 
	BCF         FARG_WriteDisplay_Fading_D1+0, 7 
	RRCF        FARG_WriteDisplay_Fading_D1+0, 1 
	BCF         FARG_WriteDisplay_Fading_D1+0, 7 
	CLRF        FARG_WriteDisplay_Fading_D1_L_P+0 
	CLRF        FARG_WriteDisplay_Fading_D1_R_P+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_Fading_F1+0 
	MOVLW       15
	ANDWF       _old_Data+0, 0 
	MOVWF       FARG_WriteDisplay_Fading_D0+0 
	CLRF        FARG_WriteDisplay_Fading_D0_L_P+0 
	MOVLW       0
	BTFSC       _Alarm+0, BitPos(_Alarm+0) 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_Fading_D0_R_P+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_Fading_F0+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_Fading_N0+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_Fading_F_N0+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_Fading_N1+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_Fading_F_N1+0 
	MOVF        R1, 0 
	MOVWF       FARG_WriteDisplay_Fading_ON+0 
	MOVF        R1, 0 
	SUBLW       100
	MOVWF       FARG_WriteDisplay_Fading_OFF+0 
	CALL        _WriteDisplay_Fading+0, 0
;Nixie.c,1763 :: 		} else
	GOTO        L_Hour_FadingFull612
L_Hour_FadingFull611:
;Nixie.c,1765 :: 		if (Fading >= 0x5A && Fading <= 0x69) {
	MOVLW       90
	SUBWF       _Fading+0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_Hour_FadingFull615
	MOVF        _Fading+0, 0 
	SUBLW       105
	BTFSS       STATUS+0, 0 
	GOTO        L_Hour_FadingFull615
L__Hour_FadingFull995:
;Nixie.c,1767 :: 		WriteDisplay_Fading(0x0F,0,0,0,0x0F,0,0,0,0x0F,0,0,0,0x0F,0,0,0,0x0F,0,0,0,0x0F,0,0,0,0,0,0,0,0,100);
	MOVLW       15
	MOVWF       FARG_WriteDisplay_Fading_D5+0 
	CLRF        FARG_WriteDisplay_Fading_D5_L_P+0 
	CLRF        FARG_WriteDisplay_Fading_D5_R_P+0 
	CLRF        FARG_WriteDisplay_Fading_F5+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_Fading_D4+0 
	CLRF        FARG_WriteDisplay_Fading_D4_L_P+0 
	CLRF        FARG_WriteDisplay_Fading_D4_R_P+0 
	CLRF        FARG_WriteDisplay_Fading_F4+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_Fading_D3+0 
	CLRF        FARG_WriteDisplay_Fading_D3_L_P+0 
	CLRF        FARG_WriteDisplay_Fading_D3_R_P+0 
	CLRF        FARG_WriteDisplay_Fading_F3+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_Fading_D2+0 
	CLRF        FARG_WriteDisplay_Fading_D2_L_P+0 
	CLRF        FARG_WriteDisplay_Fading_D2_R_P+0 
	CLRF        FARG_WriteDisplay_Fading_F2+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_Fading_D1+0 
	CLRF        FARG_WriteDisplay_Fading_D1_L_P+0 
	CLRF        FARG_WriteDisplay_Fading_D1_R_P+0 
	CLRF        FARG_WriteDisplay_Fading_F1+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_Fading_D0+0 
	CLRF        FARG_WriteDisplay_Fading_D0_L_P+0 
	CLRF        FARG_WriteDisplay_Fading_D0_R_P+0 
	CLRF        FARG_WriteDisplay_Fading_F0+0 
	CLRF        FARG_WriteDisplay_Fading_N0+0 
	CLRF        FARG_WriteDisplay_Fading_F_N0+0 
	CLRF        FARG_WriteDisplay_Fading_N1+0 
	CLRF        FARG_WriteDisplay_Fading_F_N1+0 
	CLRF        FARG_WriteDisplay_Fading_ON+0 
	MOVLW       100
	MOVWF       FARG_WriteDisplay_Fading_OFF+0 
	CALL        _WriteDisplay_Fading+0, 0
;Nixie.c,1769 :: 		} else
	GOTO        L_Hour_FadingFull616
L_Hour_FadingFull615:
;Nixie.c,1771 :: 		if (Fading >= 0x6A && Fading <= 0xC3) {
	MOVLW       106
	SUBWF       _Fading+0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_Hour_FadingFull619
	MOVF        _Fading+0, 0 
	SUBLW       195
	BTFSS       STATUS+0, 0 
	GOTO        L_Hour_FadingFull619
L__Hour_FadingFull994:
;Nixie.c,1773 :: 		new_Fading = (unsigned char)(((float)ACESO / 0x5A) * (Fading - 0x6A));
	MOVF        _ACESO+0, 0 
	MOVWF       R0 
	CALL        _byte2double+0, 0
	MOVLW       0
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVLW       52
	MOVWF       R6 
	MOVLW       133
	MOVWF       R7 
	CALL        _Div_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       FLOC__Hour_FadingFull+0 
	MOVF        R1, 0 
	MOVWF       FLOC__Hour_FadingFull+1 
	MOVF        R2, 0 
	MOVWF       FLOC__Hour_FadingFull+2 
	MOVF        R3, 0 
	MOVWF       FLOC__Hour_FadingFull+3 
	MOVLW       106
	SUBWF       _Fading+0, 0 
	MOVWF       R0 
	CLRF        R1 
	MOVLW       0
	SUBWFB      R1, 1 
	CALL        _int2double+0, 0
	MOVF        FLOC__Hour_FadingFull+0, 0 
	MOVWF       R4 
	MOVF        FLOC__Hour_FadingFull+1, 0 
	MOVWF       R5 
	MOVF        FLOC__Hour_FadingFull+2, 0 
	MOVWF       R6 
	MOVF        FLOC__Hour_FadingFull+3, 0 
	MOVWF       R7 
	CALL        _Mul_32x32_FP+0, 0
	CALL        _double2byte+0, 0
;Nixie.c,1776 :: 		WriteDisplay_Fading((Data.hour >> 4),Data.PM,0,1,(Data.hour & 0x0F),0,0,1,(Data.minute >> 4),0,0,1,(Data.minute & 0x0F),0,0,1,(Data.second >> 4),0,0,1,(Data.second & 0x0F),0,(unsigned char)Alarm,1,1,1,1,1,new_Fading,(100-new_Fading));
	MOVF        _Data+2, 0 
	MOVWF       FARG_WriteDisplay_Fading_D5+0 
	RRCF        FARG_WriteDisplay_Fading_D5+0, 1 
	BCF         FARG_WriteDisplay_Fading_D5+0, 7 
	RRCF        FARG_WriteDisplay_Fading_D5+0, 1 
	BCF         FARG_WriteDisplay_Fading_D5+0, 7 
	RRCF        FARG_WriteDisplay_Fading_D5+0, 1 
	BCF         FARG_WriteDisplay_Fading_D5+0, 7 
	RRCF        FARG_WriteDisplay_Fading_D5+0, 1 
	BCF         FARG_WriteDisplay_Fading_D5+0, 7 
	MOVF        _Data+3, 0 
	MOVWF       FARG_WriteDisplay_Fading_D5_L_P+0 
	CLRF        FARG_WriteDisplay_Fading_D5_R_P+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_Fading_F5+0 
	MOVLW       15
	ANDWF       _Data+2, 0 
	MOVWF       FARG_WriteDisplay_Fading_D4+0 
	CLRF        FARG_WriteDisplay_Fading_D4_L_P+0 
	CLRF        FARG_WriteDisplay_Fading_D4_R_P+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_Fading_F4+0 
	MOVF        _Data+1, 0 
	MOVWF       FARG_WriteDisplay_Fading_D3+0 
	RRCF        FARG_WriteDisplay_Fading_D3+0, 1 
	BCF         FARG_WriteDisplay_Fading_D3+0, 7 
	RRCF        FARG_WriteDisplay_Fading_D3+0, 1 
	BCF         FARG_WriteDisplay_Fading_D3+0, 7 
	RRCF        FARG_WriteDisplay_Fading_D3+0, 1 
	BCF         FARG_WriteDisplay_Fading_D3+0, 7 
	RRCF        FARG_WriteDisplay_Fading_D3+0, 1 
	BCF         FARG_WriteDisplay_Fading_D3+0, 7 
	CLRF        FARG_WriteDisplay_Fading_D3_L_P+0 
	CLRF        FARG_WriteDisplay_Fading_D3_R_P+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_Fading_F3+0 
	MOVLW       15
	ANDWF       _Data+1, 0 
	MOVWF       FARG_WriteDisplay_Fading_D2+0 
	CLRF        FARG_WriteDisplay_Fading_D2_L_P+0 
	CLRF        FARG_WriteDisplay_Fading_D2_R_P+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_Fading_F2+0 
	MOVF        _Data+0, 0 
	MOVWF       FARG_WriteDisplay_Fading_D1+0 
	RRCF        FARG_WriteDisplay_Fading_D1+0, 1 
	BCF         FARG_WriteDisplay_Fading_D1+0, 7 
	RRCF        FARG_WriteDisplay_Fading_D1+0, 1 
	BCF         FARG_WriteDisplay_Fading_D1+0, 7 
	RRCF        FARG_WriteDisplay_Fading_D1+0, 1 
	BCF         FARG_WriteDisplay_Fading_D1+0, 7 
	RRCF        FARG_WriteDisplay_Fading_D1+0, 1 
	BCF         FARG_WriteDisplay_Fading_D1+0, 7 
	CLRF        FARG_WriteDisplay_Fading_D1_L_P+0 
	CLRF        FARG_WriteDisplay_Fading_D1_R_P+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_Fading_F1+0 
	MOVLW       15
	ANDWF       _Data+0, 0 
	MOVWF       FARG_WriteDisplay_Fading_D0+0 
	CLRF        FARG_WriteDisplay_Fading_D0_L_P+0 
	MOVLW       0
	BTFSC       _Alarm+0, BitPos(_Alarm+0) 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_Fading_D0_R_P+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_Fading_F0+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_Fading_N0+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_Fading_F_N0+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_Fading_N1+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_Fading_F_N1+0 
	MOVF        R0, 0 
	MOVWF       FARG_WriteDisplay_Fading_ON+0 
	MOVF        R0, 0 
	SUBLW       100
	MOVWF       FARG_WriteDisplay_Fading_OFF+0 
	CALL        _WriteDisplay_Fading+0, 0
;Nixie.c,1778 :: 		} else
	GOTO        L_Hour_FadingFull620
L_Hour_FadingFull619:
;Nixie.c,1780 :: 		if (Fading >= 0xC4) {
	MOVLW       196
	SUBWF       _Fading+0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_Hour_FadingFull621
;Nixie.c,1782 :: 		Flag_Fading = 0;
	BCF         _Flag_Fading+0, BitPos(_Flag_Fading+0) 
;Nixie.c,1783 :: 		Fading = 0;
	CLRF        _Fading+0 
;Nixie.c,1784 :: 		old_Data = Data;
	MOVLW       9
	MOVWF       R0 
	MOVLW       _old_Data+0
	MOVWF       FSR1 
	MOVLW       hi_addr(_old_Data+0)
	MOVWF       FSR1H 
	MOVLW       _Data+0
	MOVWF       FSR0 
	MOVLW       hi_addr(_Data+0)
	MOVWF       FSR0H 
L_Hour_FadingFull622:
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
	DECF        R0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_Hour_FadingFull622
;Nixie.c,1786 :: 		}
L_Hour_FadingFull621:
L_Hour_FadingFull620:
L_Hour_FadingFull616:
L_Hour_FadingFull612:
;Nixie.c,1788 :: 		} else
	GOTO        L_Hour_FadingFull623
L_Hour_FadingFull608:
;Nixie.c,1790 :: 		WriteDisplay_Fading((Data.hour >> 4),Data.PM,0,0,(Data.hour & 0x0F),0,0,0,(Data.minute >> 4),0,0,0,(Data.minute & 0x0F),0,0,0,(Data.second >> 4),0,0,0,(Data.second & 0x0F),0,(unsigned char)Alarm,0,1,0,1,0,ACESO,APAGADO);
	MOVF        _Data+2, 0 
	MOVWF       FARG_WriteDisplay_Fading_D5+0 
	RRCF        FARG_WriteDisplay_Fading_D5+0, 1 
	BCF         FARG_WriteDisplay_Fading_D5+0, 7 
	RRCF        FARG_WriteDisplay_Fading_D5+0, 1 
	BCF         FARG_WriteDisplay_Fading_D5+0, 7 
	RRCF        FARG_WriteDisplay_Fading_D5+0, 1 
	BCF         FARG_WriteDisplay_Fading_D5+0, 7 
	RRCF        FARG_WriteDisplay_Fading_D5+0, 1 
	BCF         FARG_WriteDisplay_Fading_D5+0, 7 
	MOVF        _Data+3, 0 
	MOVWF       FARG_WriteDisplay_Fading_D5_L_P+0 
	CLRF        FARG_WriteDisplay_Fading_D5_R_P+0 
	CLRF        FARG_WriteDisplay_Fading_F5+0 
	MOVLW       15
	ANDWF       _Data+2, 0 
	MOVWF       FARG_WriteDisplay_Fading_D4+0 
	CLRF        FARG_WriteDisplay_Fading_D4_L_P+0 
	CLRF        FARG_WriteDisplay_Fading_D4_R_P+0 
	CLRF        FARG_WriteDisplay_Fading_F4+0 
	MOVF        _Data+1, 0 
	MOVWF       FARG_WriteDisplay_Fading_D3+0 
	RRCF        FARG_WriteDisplay_Fading_D3+0, 1 
	BCF         FARG_WriteDisplay_Fading_D3+0, 7 
	RRCF        FARG_WriteDisplay_Fading_D3+0, 1 
	BCF         FARG_WriteDisplay_Fading_D3+0, 7 
	RRCF        FARG_WriteDisplay_Fading_D3+0, 1 
	BCF         FARG_WriteDisplay_Fading_D3+0, 7 
	RRCF        FARG_WriteDisplay_Fading_D3+0, 1 
	BCF         FARG_WriteDisplay_Fading_D3+0, 7 
	CLRF        FARG_WriteDisplay_Fading_D3_L_P+0 
	CLRF        FARG_WriteDisplay_Fading_D3_R_P+0 
	CLRF        FARG_WriteDisplay_Fading_F3+0 
	MOVLW       15
	ANDWF       _Data+1, 0 
	MOVWF       FARG_WriteDisplay_Fading_D2+0 
	CLRF        FARG_WriteDisplay_Fading_D2_L_P+0 
	CLRF        FARG_WriteDisplay_Fading_D2_R_P+0 
	CLRF        FARG_WriteDisplay_Fading_F2+0 
	MOVF        _Data+0, 0 
	MOVWF       FARG_WriteDisplay_Fading_D1+0 
	RRCF        FARG_WriteDisplay_Fading_D1+0, 1 
	BCF         FARG_WriteDisplay_Fading_D1+0, 7 
	RRCF        FARG_WriteDisplay_Fading_D1+0, 1 
	BCF         FARG_WriteDisplay_Fading_D1+0, 7 
	RRCF        FARG_WriteDisplay_Fading_D1+0, 1 
	BCF         FARG_WriteDisplay_Fading_D1+0, 7 
	RRCF        FARG_WriteDisplay_Fading_D1+0, 1 
	BCF         FARG_WriteDisplay_Fading_D1+0, 7 
	CLRF        FARG_WriteDisplay_Fading_D1_L_P+0 
	CLRF        FARG_WriteDisplay_Fading_D1_R_P+0 
	CLRF        FARG_WriteDisplay_Fading_F1+0 
	MOVLW       15
	ANDWF       _Data+0, 0 
	MOVWF       FARG_WriteDisplay_Fading_D0+0 
	CLRF        FARG_WriteDisplay_Fading_D0_L_P+0 
	MOVLW       0
	BTFSC       _Alarm+0, BitPos(_Alarm+0) 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_Fading_D0_R_P+0 
	CLRF        FARG_WriteDisplay_Fading_F0+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_Fading_N0+0 
	CLRF        FARG_WriteDisplay_Fading_F_N0+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_Fading_N1+0 
	CLRF        FARG_WriteDisplay_Fading_F_N1+0 
	MOVF        _ACESO+0, 0 
	MOVWF       FARG_WriteDisplay_Fading_ON+0 
	MOVF        _APAGADO+0, 0 
	MOVWF       FARG_WriteDisplay_Fading_OFF+0 
	CALL        _WriteDisplay_Fading+0, 0
L_Hour_FadingFull623:
;Nixie.c,1792 :: 		}
L_end_Hour_FadingFull:
	RETURN      0
; end of _Hour_FadingFull

_Hour_Scroll:

;Nixie.c,1799 :: 		void Hour_Scroll() {
;Nixie.c,1801 :: 		if (old_Data.second != Data.second) {
	MOVF        _old_Data+0, 0 
	XORWF       _Data+0, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_Hour_Scroll624
;Nixie.c,1803 :: 		Flag_Scroll = 1;
	BSF         _Flag_Scroll+0, BitPos(_Flag_Scroll+0) 
;Nixie.c,1805 :: 		if (Scroll >=0 && Scroll <=12)
	MOVLW       0
	SUBWF       _Scroll+0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_Hour_Scroll627
	MOVF        _Scroll+0, 0 
	SUBLW       12
	BTFSS       STATUS+0, 0 
	GOTO        L_Hour_Scroll627
L__Hour_Scroll1004:
;Nixie.c,1806 :: 		WriteDisplay(0x0F,0,0,(old_Data.hour >> 4),Data.PM,0,(old_Data.hour & 0x0F),0,0,(old_Data.minute >> 4),0,0,(old_Data.minute & 0x0F),0,0,(old_Data.second >> 4),0,0,0,0);
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D5+0 
	CLRF        FARG_WriteDisplay_D5_L_P+0 
	CLRF        FARG_WriteDisplay_D5_R_P+0 
	MOVF        _old_Data+2, 0 
	MOVWF       FARG_WriteDisplay_D4+0 
	RRCF        FARG_WriteDisplay_D4+0, 1 
	BCF         FARG_WriteDisplay_D4+0, 7 
	RRCF        FARG_WriteDisplay_D4+0, 1 
	BCF         FARG_WriteDisplay_D4+0, 7 
	RRCF        FARG_WriteDisplay_D4+0, 1 
	BCF         FARG_WriteDisplay_D4+0, 7 
	RRCF        FARG_WriteDisplay_D4+0, 1 
	BCF         FARG_WriteDisplay_D4+0, 7 
	MOVF        _Data+3, 0 
	MOVWF       FARG_WriteDisplay_D4_L_P+0 
	CLRF        FARG_WriteDisplay_D4_R_P+0 
	MOVLW       15
	ANDWF       _old_Data+2, 0 
	MOVWF       FARG_WriteDisplay_D3+0 
	CLRF        FARG_WriteDisplay_D3_L_P+0 
	CLRF        FARG_WriteDisplay_D3_R_P+0 
	MOVF        _old_Data+1, 0 
	MOVWF       FARG_WriteDisplay_D2+0 
	RRCF        FARG_WriteDisplay_D2+0, 1 
	BCF         FARG_WriteDisplay_D2+0, 7 
	RRCF        FARG_WriteDisplay_D2+0, 1 
	BCF         FARG_WriteDisplay_D2+0, 7 
	RRCF        FARG_WriteDisplay_D2+0, 1 
	BCF         FARG_WriteDisplay_D2+0, 7 
	RRCF        FARG_WriteDisplay_D2+0, 1 
	BCF         FARG_WriteDisplay_D2+0, 7 
	CLRF        FARG_WriteDisplay_D2_L_P+0 
	CLRF        FARG_WriteDisplay_D2_R_P+0 
	MOVLW       15
	ANDWF       _old_Data+1, 0 
	MOVWF       FARG_WriteDisplay_D1+0 
	CLRF        FARG_WriteDisplay_D1_L_P+0 
	CLRF        FARG_WriteDisplay_D1_R_P+0 
	MOVF        _old_Data+0, 0 
	MOVWF       FARG_WriteDisplay_D0+0 
	RRCF        FARG_WriteDisplay_D0+0, 1 
	BCF         FARG_WriteDisplay_D0+0, 7 
	RRCF        FARG_WriteDisplay_D0+0, 1 
	BCF         FARG_WriteDisplay_D0+0, 7 
	RRCF        FARG_WriteDisplay_D0+0, 1 
	BCF         FARG_WriteDisplay_D0+0, 7 
	RRCF        FARG_WriteDisplay_D0+0, 1 
	BCF         FARG_WriteDisplay_D0+0, 7 
	CLRF        FARG_WriteDisplay_D0_L_P+0 
	CLRF        FARG_WriteDisplay_D0_R_P+0 
	CLRF        FARG_WriteDisplay_N0+0 
	CLRF        FARG_WriteDisplay_N1+0 
	CALL        _WriteDisplay+0, 0
	GOTO        L_Hour_Scroll628
L_Hour_Scroll627:
;Nixie.c,1808 :: 		if (Scroll >=13 && Scroll <=25)
	MOVLW       13
	SUBWF       _Scroll+0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_Hour_Scroll631
	MOVF        _Scroll+0, 0 
	SUBLW       25
	BTFSS       STATUS+0, 0 
	GOTO        L_Hour_Scroll631
L__Hour_Scroll1003:
;Nixie.c,1809 :: 		WriteDisplay(0x0F,0,0,0x0F,0,0,(old_Data.hour >> 4),Data.PM,0,(old_Data.hour & 0x0F),0,0,(old_Data.minute >> 4),0,0,(old_Data.minute & 0x0F),0,0,0,0);
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D5+0 
	CLRF        FARG_WriteDisplay_D5_L_P+0 
	CLRF        FARG_WriteDisplay_D5_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D4+0 
	CLRF        FARG_WriteDisplay_D4_L_P+0 
	CLRF        FARG_WriteDisplay_D4_R_P+0 
	MOVF        _old_Data+2, 0 
	MOVWF       FARG_WriteDisplay_D3+0 
	RRCF        FARG_WriteDisplay_D3+0, 1 
	BCF         FARG_WriteDisplay_D3+0, 7 
	RRCF        FARG_WriteDisplay_D3+0, 1 
	BCF         FARG_WriteDisplay_D3+0, 7 
	RRCF        FARG_WriteDisplay_D3+0, 1 
	BCF         FARG_WriteDisplay_D3+0, 7 
	RRCF        FARG_WriteDisplay_D3+0, 1 
	BCF         FARG_WriteDisplay_D3+0, 7 
	MOVF        _Data+3, 0 
	MOVWF       FARG_WriteDisplay_D3_L_P+0 
	CLRF        FARG_WriteDisplay_D3_R_P+0 
	MOVLW       15
	ANDWF       _old_Data+2, 0 
	MOVWF       FARG_WriteDisplay_D2+0 
	CLRF        FARG_WriteDisplay_D2_L_P+0 
	CLRF        FARG_WriteDisplay_D2_R_P+0 
	MOVF        _old_Data+1, 0 
	MOVWF       FARG_WriteDisplay_D1+0 
	RRCF        FARG_WriteDisplay_D1+0, 1 
	BCF         FARG_WriteDisplay_D1+0, 7 
	RRCF        FARG_WriteDisplay_D1+0, 1 
	BCF         FARG_WriteDisplay_D1+0, 7 
	RRCF        FARG_WriteDisplay_D1+0, 1 
	BCF         FARG_WriteDisplay_D1+0, 7 
	RRCF        FARG_WriteDisplay_D1+0, 1 
	BCF         FARG_WriteDisplay_D1+0, 7 
	CLRF        FARG_WriteDisplay_D1_L_P+0 
	CLRF        FARG_WriteDisplay_D1_R_P+0 
	MOVLW       15
	ANDWF       _old_Data+1, 0 
	MOVWF       FARG_WriteDisplay_D0+0 
	CLRF        FARG_WriteDisplay_D0_L_P+0 
	CLRF        FARG_WriteDisplay_D0_R_P+0 
	CLRF        FARG_WriteDisplay_N0+0 
	CLRF        FARG_WriteDisplay_N1+0 
	CALL        _WriteDisplay+0, 0
	GOTO        L_Hour_Scroll632
L_Hour_Scroll631:
;Nixie.c,1811 :: 		if (Scroll >=26 && Scroll <=38)
	MOVLW       26
	SUBWF       _Scroll+0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_Hour_Scroll635
	MOVF        _Scroll+0, 0 
	SUBLW       38
	BTFSS       STATUS+0, 0 
	GOTO        L_Hour_Scroll635
L__Hour_Scroll1002:
;Nixie.c,1812 :: 		WriteDisplay(0x0F,0,0,0x0F,0,0,0x0F,0,0,(old_Data.hour >> 4),Data.PM,0,(old_Data.hour & 0x0F),0,0,(old_Data.minute >> 4),0,0,0,0);
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D5+0 
	CLRF        FARG_WriteDisplay_D5_L_P+0 
	CLRF        FARG_WriteDisplay_D5_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D4+0 
	CLRF        FARG_WriteDisplay_D4_L_P+0 
	CLRF        FARG_WriteDisplay_D4_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D3+0 
	CLRF        FARG_WriteDisplay_D3_L_P+0 
	CLRF        FARG_WriteDisplay_D3_R_P+0 
	MOVF        _old_Data+2, 0 
	MOVWF       FARG_WriteDisplay_D2+0 
	RRCF        FARG_WriteDisplay_D2+0, 1 
	BCF         FARG_WriteDisplay_D2+0, 7 
	RRCF        FARG_WriteDisplay_D2+0, 1 
	BCF         FARG_WriteDisplay_D2+0, 7 
	RRCF        FARG_WriteDisplay_D2+0, 1 
	BCF         FARG_WriteDisplay_D2+0, 7 
	RRCF        FARG_WriteDisplay_D2+0, 1 
	BCF         FARG_WriteDisplay_D2+0, 7 
	MOVF        _Data+3, 0 
	MOVWF       FARG_WriteDisplay_D2_L_P+0 
	CLRF        FARG_WriteDisplay_D2_R_P+0 
	MOVLW       15
	ANDWF       _old_Data+2, 0 
	MOVWF       FARG_WriteDisplay_D1+0 
	CLRF        FARG_WriteDisplay_D1_L_P+0 
	CLRF        FARG_WriteDisplay_D1_R_P+0 
	MOVF        _old_Data+1, 0 
	MOVWF       FARG_WriteDisplay_D0+0 
	RRCF        FARG_WriteDisplay_D0+0, 1 
	BCF         FARG_WriteDisplay_D0+0, 7 
	RRCF        FARG_WriteDisplay_D0+0, 1 
	BCF         FARG_WriteDisplay_D0+0, 7 
	RRCF        FARG_WriteDisplay_D0+0, 1 
	BCF         FARG_WriteDisplay_D0+0, 7 
	RRCF        FARG_WriteDisplay_D0+0, 1 
	BCF         FARG_WriteDisplay_D0+0, 7 
	CLRF        FARG_WriteDisplay_D0_L_P+0 
	CLRF        FARG_WriteDisplay_D0_R_P+0 
	CLRF        FARG_WriteDisplay_N0+0 
	CLRF        FARG_WriteDisplay_N1+0 
	CALL        _WriteDisplay+0, 0
	GOTO        L_Hour_Scroll636
L_Hour_Scroll635:
;Nixie.c,1814 :: 		if (Scroll >=39 && Scroll <=51)
	MOVLW       39
	SUBWF       _Scroll+0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_Hour_Scroll639
	MOVF        _Scroll+0, 0 
	SUBLW       51
	BTFSS       STATUS+0, 0 
	GOTO        L_Hour_Scroll639
L__Hour_Scroll1001:
;Nixie.c,1815 :: 		WriteDisplay((Data.second & 0x0F),0,(unsigned char)Alarm,0x0F,0,0,0x0F,0,0,0x0F,0,0,(old_Data.hour >> 4),Data.PM,0,(old_Data.hour & 0x0F),0,0,0,0);
	MOVLW       15
	ANDWF       _Data+0, 0 
	MOVWF       FARG_WriteDisplay_D5+0 
	CLRF        FARG_WriteDisplay_D5_L_P+0 
	MOVLW       0
	BTFSC       _Alarm+0, BitPos(_Alarm+0) 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D5_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D4+0 
	CLRF        FARG_WriteDisplay_D4_L_P+0 
	CLRF        FARG_WriteDisplay_D4_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D3+0 
	CLRF        FARG_WriteDisplay_D3_L_P+0 
	CLRF        FARG_WriteDisplay_D3_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D2+0 
	CLRF        FARG_WriteDisplay_D2_L_P+0 
	CLRF        FARG_WriteDisplay_D2_R_P+0 
	MOVF        _old_Data+2, 0 
	MOVWF       FARG_WriteDisplay_D1+0 
	RRCF        FARG_WriteDisplay_D1+0, 1 
	BCF         FARG_WriteDisplay_D1+0, 7 
	RRCF        FARG_WriteDisplay_D1+0, 1 
	BCF         FARG_WriteDisplay_D1+0, 7 
	RRCF        FARG_WriteDisplay_D1+0, 1 
	BCF         FARG_WriteDisplay_D1+0, 7 
	RRCF        FARG_WriteDisplay_D1+0, 1 
	BCF         FARG_WriteDisplay_D1+0, 7 
	MOVF        _Data+3, 0 
	MOVWF       FARG_WriteDisplay_D1_L_P+0 
	CLRF        FARG_WriteDisplay_D1_R_P+0 
	MOVLW       15
	ANDWF       _old_Data+2, 0 
	MOVWF       FARG_WriteDisplay_D0+0 
	CLRF        FARG_WriteDisplay_D0_L_P+0 
	CLRF        FARG_WriteDisplay_D0_R_P+0 
	CLRF        FARG_WriteDisplay_N0+0 
	CLRF        FARG_WriteDisplay_N1+0 
	CALL        _WriteDisplay+0, 0
	GOTO        L_Hour_Scroll640
L_Hour_Scroll639:
;Nixie.c,1817 :: 		if (Scroll >=52 && Scroll <=64)
	MOVLW       52
	SUBWF       _Scroll+0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_Hour_Scroll643
	MOVF        _Scroll+0, 0 
	SUBLW       64
	BTFSS       STATUS+0, 0 
	GOTO        L_Hour_Scroll643
L__Hour_Scroll1000:
;Nixie.c,1818 :: 		WriteDisplay((Data.second >> 4),0,0,(Data.second & 0x0F),0,(unsigned char)Alarm,0x0F,0,0,0x0F,0,0,0x0F,0,0,(old_Data.hour >> 4),Data.PM,0,0,0);
	MOVF        _Data+0, 0 
	MOVWF       FARG_WriteDisplay_D5+0 
	RRCF        FARG_WriteDisplay_D5+0, 1 
	BCF         FARG_WriteDisplay_D5+0, 7 
	RRCF        FARG_WriteDisplay_D5+0, 1 
	BCF         FARG_WriteDisplay_D5+0, 7 
	RRCF        FARG_WriteDisplay_D5+0, 1 
	BCF         FARG_WriteDisplay_D5+0, 7 
	RRCF        FARG_WriteDisplay_D5+0, 1 
	BCF         FARG_WriteDisplay_D5+0, 7 
	CLRF        FARG_WriteDisplay_D5_L_P+0 
	CLRF        FARG_WriteDisplay_D5_R_P+0 
	MOVLW       15
	ANDWF       _Data+0, 0 
	MOVWF       FARG_WriteDisplay_D4+0 
	CLRF        FARG_WriteDisplay_D4_L_P+0 
	MOVLW       0
	BTFSC       _Alarm+0, BitPos(_Alarm+0) 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D4_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D3+0 
	CLRF        FARG_WriteDisplay_D3_L_P+0 
	CLRF        FARG_WriteDisplay_D3_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D2+0 
	CLRF        FARG_WriteDisplay_D2_L_P+0 
	CLRF        FARG_WriteDisplay_D2_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D1+0 
	CLRF        FARG_WriteDisplay_D1_L_P+0 
	CLRF        FARG_WriteDisplay_D1_R_P+0 
	MOVF        _old_Data+2, 0 
	MOVWF       FARG_WriteDisplay_D0+0 
	RRCF        FARG_WriteDisplay_D0+0, 1 
	BCF         FARG_WriteDisplay_D0+0, 7 
	RRCF        FARG_WriteDisplay_D0+0, 1 
	BCF         FARG_WriteDisplay_D0+0, 7 
	RRCF        FARG_WriteDisplay_D0+0, 1 
	BCF         FARG_WriteDisplay_D0+0, 7 
	RRCF        FARG_WriteDisplay_D0+0, 1 
	BCF         FARG_WriteDisplay_D0+0, 7 
	MOVF        _Data+3, 0 
	MOVWF       FARG_WriteDisplay_D0_L_P+0 
	CLRF        FARG_WriteDisplay_D0_R_P+0 
	CLRF        FARG_WriteDisplay_N0+0 
	CLRF        FARG_WriteDisplay_N1+0 
	CALL        _WriteDisplay+0, 0
	GOTO        L_Hour_Scroll644
L_Hour_Scroll643:
;Nixie.c,1820 :: 		if (Scroll >=65 && Scroll <=77)
	MOVLW       65
	SUBWF       _Scroll+0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_Hour_Scroll647
	MOVF        _Scroll+0, 0 
	SUBLW       77
	BTFSS       STATUS+0, 0 
	GOTO        L_Hour_Scroll647
L__Hour_Scroll999:
;Nixie.c,1821 :: 		WriteDisplay((Data.minute & 0x0F),0,0,(Data.second >> 4),0,0,(Data.second & 0x0F),0,(unsigned char)Alarm,0x0F,0,0,0x0F,0,0,0x0F,0,0,0,0);
	MOVLW       15
	ANDWF       _Data+1, 0 
	MOVWF       FARG_WriteDisplay_D5+0 
	CLRF        FARG_WriteDisplay_D5_L_P+0 
	CLRF        FARG_WriteDisplay_D5_R_P+0 
	MOVF        _Data+0, 0 
	MOVWF       FARG_WriteDisplay_D4+0 
	RRCF        FARG_WriteDisplay_D4+0, 1 
	BCF         FARG_WriteDisplay_D4+0, 7 
	RRCF        FARG_WriteDisplay_D4+0, 1 
	BCF         FARG_WriteDisplay_D4+0, 7 
	RRCF        FARG_WriteDisplay_D4+0, 1 
	BCF         FARG_WriteDisplay_D4+0, 7 
	RRCF        FARG_WriteDisplay_D4+0, 1 
	BCF         FARG_WriteDisplay_D4+0, 7 
	CLRF        FARG_WriteDisplay_D4_L_P+0 
	CLRF        FARG_WriteDisplay_D4_R_P+0 
	MOVLW       15
	ANDWF       _Data+0, 0 
	MOVWF       FARG_WriteDisplay_D3+0 
	CLRF        FARG_WriteDisplay_D3_L_P+0 
	MOVLW       0
	BTFSC       _Alarm+0, BitPos(_Alarm+0) 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D3_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D2+0 
	CLRF        FARG_WriteDisplay_D2_L_P+0 
	CLRF        FARG_WriteDisplay_D2_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D1+0 
	CLRF        FARG_WriteDisplay_D1_L_P+0 
	CLRF        FARG_WriteDisplay_D1_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D0+0 
	CLRF        FARG_WriteDisplay_D0_L_P+0 
	CLRF        FARG_WriteDisplay_D0_R_P+0 
	CLRF        FARG_WriteDisplay_N0+0 
	CLRF        FARG_WriteDisplay_N1+0 
	CALL        _WriteDisplay+0, 0
	GOTO        L_Hour_Scroll648
L_Hour_Scroll647:
;Nixie.c,1823 :: 		if (Scroll >=78 && Scroll <=90)
	MOVLW       78
	SUBWF       _Scroll+0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_Hour_Scroll651
	MOVF        _Scroll+0, 0 
	SUBLW       90
	BTFSS       STATUS+0, 0 
	GOTO        L_Hour_Scroll651
L__Hour_Scroll998:
;Nixie.c,1824 :: 		WriteDisplay((Data.minute >> 4),0,0,(Data.minute & 0x0F),0,0,(Data.second >> 4),0,0,(Data.second & 0x0F),0,(unsigned char)Alarm,0x0F,0,0,0x0F,0,0,0,0);
	MOVF        _Data+1, 0 
	MOVWF       FARG_WriteDisplay_D5+0 
	RRCF        FARG_WriteDisplay_D5+0, 1 
	BCF         FARG_WriteDisplay_D5+0, 7 
	RRCF        FARG_WriteDisplay_D5+0, 1 
	BCF         FARG_WriteDisplay_D5+0, 7 
	RRCF        FARG_WriteDisplay_D5+0, 1 
	BCF         FARG_WriteDisplay_D5+0, 7 
	RRCF        FARG_WriteDisplay_D5+0, 1 
	BCF         FARG_WriteDisplay_D5+0, 7 
	CLRF        FARG_WriteDisplay_D5_L_P+0 
	CLRF        FARG_WriteDisplay_D5_R_P+0 
	MOVLW       15
	ANDWF       _Data+1, 0 
	MOVWF       FARG_WriteDisplay_D4+0 
	CLRF        FARG_WriteDisplay_D4_L_P+0 
	CLRF        FARG_WriteDisplay_D4_R_P+0 
	MOVF        _Data+0, 0 
	MOVWF       FARG_WriteDisplay_D3+0 
	RRCF        FARG_WriteDisplay_D3+0, 1 
	BCF         FARG_WriteDisplay_D3+0, 7 
	RRCF        FARG_WriteDisplay_D3+0, 1 
	BCF         FARG_WriteDisplay_D3+0, 7 
	RRCF        FARG_WriteDisplay_D3+0, 1 
	BCF         FARG_WriteDisplay_D3+0, 7 
	RRCF        FARG_WriteDisplay_D3+0, 1 
	BCF         FARG_WriteDisplay_D3+0, 7 
	CLRF        FARG_WriteDisplay_D3_L_P+0 
	CLRF        FARG_WriteDisplay_D3_R_P+0 
	MOVLW       15
	ANDWF       _Data+0, 0 
	MOVWF       FARG_WriteDisplay_D2+0 
	CLRF        FARG_WriteDisplay_D2_L_P+0 
	MOVLW       0
	BTFSC       _Alarm+0, BitPos(_Alarm+0) 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D2_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D1+0 
	CLRF        FARG_WriteDisplay_D1_L_P+0 
	CLRF        FARG_WriteDisplay_D1_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D0+0 
	CLRF        FARG_WriteDisplay_D0_L_P+0 
	CLRF        FARG_WriteDisplay_D0_R_P+0 
	CLRF        FARG_WriteDisplay_N0+0 
	CLRF        FARG_WriteDisplay_N1+0 
	CALL        _WriteDisplay+0, 0
	GOTO        L_Hour_Scroll652
L_Hour_Scroll651:
;Nixie.c,1826 :: 		if (Scroll >=91 && Scroll <=103)
	MOVLW       91
	SUBWF       _Scroll+0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_Hour_Scroll655
	MOVF        _Scroll+0, 0 
	SUBLW       103
	BTFSS       STATUS+0, 0 
	GOTO        L_Hour_Scroll655
L__Hour_Scroll997:
;Nixie.c,1827 :: 		WriteDisplay((Data.hour & 0x0F),0,0,(Data.minute >> 4),0,0,(Data.minute & 0x0F),0,0,(Data.second >> 4),0,0,(Data.second & 0x0F),0,(unsigned char)Alarm,0x0F,0,0,0,0);
	MOVLW       15
	ANDWF       _Data+2, 0 
	MOVWF       FARG_WriteDisplay_D5+0 
	CLRF        FARG_WriteDisplay_D5_L_P+0 
	CLRF        FARG_WriteDisplay_D5_R_P+0 
	MOVF        _Data+1, 0 
	MOVWF       FARG_WriteDisplay_D4+0 
	RRCF        FARG_WriteDisplay_D4+0, 1 
	BCF         FARG_WriteDisplay_D4+0, 7 
	RRCF        FARG_WriteDisplay_D4+0, 1 
	BCF         FARG_WriteDisplay_D4+0, 7 
	RRCF        FARG_WriteDisplay_D4+0, 1 
	BCF         FARG_WriteDisplay_D4+0, 7 
	RRCF        FARG_WriteDisplay_D4+0, 1 
	BCF         FARG_WriteDisplay_D4+0, 7 
	CLRF        FARG_WriteDisplay_D4_L_P+0 
	CLRF        FARG_WriteDisplay_D4_R_P+0 
	MOVLW       15
	ANDWF       _Data+1, 0 
	MOVWF       FARG_WriteDisplay_D3+0 
	CLRF        FARG_WriteDisplay_D3_L_P+0 
	CLRF        FARG_WriteDisplay_D3_R_P+0 
	MOVF        _Data+0, 0 
	MOVWF       FARG_WriteDisplay_D2+0 
	RRCF        FARG_WriteDisplay_D2+0, 1 
	BCF         FARG_WriteDisplay_D2+0, 7 
	RRCF        FARG_WriteDisplay_D2+0, 1 
	BCF         FARG_WriteDisplay_D2+0, 7 
	RRCF        FARG_WriteDisplay_D2+0, 1 
	BCF         FARG_WriteDisplay_D2+0, 7 
	RRCF        FARG_WriteDisplay_D2+0, 1 
	BCF         FARG_WriteDisplay_D2+0, 7 
	CLRF        FARG_WriteDisplay_D2_L_P+0 
	CLRF        FARG_WriteDisplay_D2_R_P+0 
	MOVLW       15
	ANDWF       _Data+0, 0 
	MOVWF       FARG_WriteDisplay_D1+0 
	CLRF        FARG_WriteDisplay_D1_L_P+0 
	MOVLW       0
	BTFSC       _Alarm+0, BitPos(_Alarm+0) 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D1_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D0+0 
	CLRF        FARG_WriteDisplay_D0_L_P+0 
	CLRF        FARG_WriteDisplay_D0_R_P+0 
	CLRF        FARG_WriteDisplay_N0+0 
	CLRF        FARG_WriteDisplay_N1+0 
	CALL        _WriteDisplay+0, 0
	GOTO        L_Hour_Scroll656
L_Hour_Scroll655:
;Nixie.c,1830 :: 		if (Scroll >= 104) {
	MOVLW       104
	SUBWF       _Scroll+0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_Hour_Scroll657
;Nixie.c,1832 :: 		Flag_Scroll = 0;
	BCF         _Flag_Scroll+0, BitPos(_Flag_Scroll+0) 
;Nixie.c,1833 :: 		Scroll = 0;
	CLRF        _Scroll+0 
;Nixie.c,1834 :: 		old_Data = Data;
	MOVLW       9
	MOVWF       R0 
	MOVLW       _old_Data+0
	MOVWF       FSR1 
	MOVLW       hi_addr(_old_Data+0)
	MOVWF       FSR1H 
	MOVLW       _Data+0
	MOVWF       FSR0 
	MOVLW       hi_addr(_Data+0)
	MOVWF       FSR0H 
L_Hour_Scroll658:
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
	DECF        R0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_Hour_Scroll658
;Nixie.c,1836 :: 		}
L_Hour_Scroll657:
L_Hour_Scroll656:
L_Hour_Scroll652:
L_Hour_Scroll648:
L_Hour_Scroll644:
L_Hour_Scroll640:
L_Hour_Scroll636:
L_Hour_Scroll632:
L_Hour_Scroll628:
;Nixie.c,1838 :: 		} else
	GOTO        L_Hour_Scroll659
L_Hour_Scroll624:
;Nixie.c,1841 :: 		Hour(1);
	MOVLW       1
	MOVWF       FARG_Hour_Point+0 
	CALL        _Hour+0, 0
L_Hour_Scroll659:
;Nixie.c,1844 :: 		}
L_end_Hour_Scroll:
	RETURN      0
; end of _Hour_Scroll

_Date:

;Nixie.c,1850 :: 		void Date() {
;Nixie.c,1852 :: 		WriteDisplay((Data.day >> 4),1,0,(Data.day & 0x0F),0,1,(Data.month >> 4),1,0,(Data.month & 0x0F),0,1,(Data.year >> 4),1,0,(Data.year & 0x0F),0,1,0,0);
	MOVF        _Data+5, 0 
	MOVWF       FARG_WriteDisplay_D5+0 
	RRCF        FARG_WriteDisplay_D5+0, 1 
	BCF         FARG_WriteDisplay_D5+0, 7 
	RRCF        FARG_WriteDisplay_D5+0, 1 
	BCF         FARG_WriteDisplay_D5+0, 7 
	RRCF        FARG_WriteDisplay_D5+0, 1 
	BCF         FARG_WriteDisplay_D5+0, 7 
	RRCF        FARG_WriteDisplay_D5+0, 1 
	BCF         FARG_WriteDisplay_D5+0, 7 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D5_L_P+0 
	CLRF        FARG_WriteDisplay_D5_R_P+0 
	MOVLW       15
	ANDWF       _Data+5, 0 
	MOVWF       FARG_WriteDisplay_D4+0 
	CLRF        FARG_WriteDisplay_D4_L_P+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D4_R_P+0 
	MOVF        _Data+7, 0 
	MOVWF       FARG_WriteDisplay_D3+0 
	RRCF        FARG_WriteDisplay_D3+0, 1 
	BCF         FARG_WriteDisplay_D3+0, 7 
	RRCF        FARG_WriteDisplay_D3+0, 1 
	BCF         FARG_WriteDisplay_D3+0, 7 
	RRCF        FARG_WriteDisplay_D3+0, 1 
	BCF         FARG_WriteDisplay_D3+0, 7 
	RRCF        FARG_WriteDisplay_D3+0, 1 
	BCF         FARG_WriteDisplay_D3+0, 7 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D3_L_P+0 
	CLRF        FARG_WriteDisplay_D3_R_P+0 
	MOVLW       15
	ANDWF       _Data+7, 0 
	MOVWF       FARG_WriteDisplay_D2+0 
	CLRF        FARG_WriteDisplay_D2_L_P+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D2_R_P+0 
	MOVF        _Data+8, 0 
	MOVWF       FARG_WriteDisplay_D1+0 
	RRCF        FARG_WriteDisplay_D1+0, 1 
	BCF         FARG_WriteDisplay_D1+0, 7 
	RRCF        FARG_WriteDisplay_D1+0, 1 
	BCF         FARG_WriteDisplay_D1+0, 7 
	RRCF        FARG_WriteDisplay_D1+0, 1 
	BCF         FARG_WriteDisplay_D1+0, 7 
	RRCF        FARG_WriteDisplay_D1+0, 1 
	BCF         FARG_WriteDisplay_D1+0, 7 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D1_L_P+0 
	CLRF        FARG_WriteDisplay_D1_R_P+0 
	MOVLW       15
	ANDWF       _Data+8, 0 
	MOVWF       FARG_WriteDisplay_D0+0 
	CLRF        FARG_WriteDisplay_D0_L_P+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D0_R_P+0 
	CLRF        FARG_WriteDisplay_N0+0 
	CLRF        FARG_WriteDisplay_N1+0 
	CALL        _WriteDisplay+0, 0
;Nixie.c,1854 :: 		}
L_end_Date:
	RETURN      0
; end of _Date

_Temp:

;Nixie.c,1861 :: 		void Temp() {
;Nixie.c,1863 :: 		SeparaUnidade(Temp_Celsius);
	MOVF        _Temp_Celsius+0, 0 
	MOVWF       FARG_SeparaUnidade_Numero+0 
	MOVF        _Temp_Celsius+1, 0 
	MOVWF       FARG_SeparaUnidade_Numero+1 
	MOVLW       0
	MOVWF       FARG_SeparaUnidade_Numero+2 
	MOVWF       FARG_SeparaUnidade_Numero+3 
	CALL        _SeparaUnidade+0, 0
;Nixie.c,1865 :: 		WriteDisplay(0x0F,1,1,0x0F,1,1,centena,0,0,dezena,0,0,0x0F,1,1,0x0F,1,1,0,0);
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D5+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D5_L_P+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D5_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D4+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D4_L_P+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D4_R_P+0 
	MOVF        _centena+0, 0 
	MOVWF       FARG_WriteDisplay_D3+0 
	CLRF        FARG_WriteDisplay_D3_L_P+0 
	CLRF        FARG_WriteDisplay_D3_R_P+0 
	MOVF        _dezena+0, 0 
	MOVWF       FARG_WriteDisplay_D2+0 
	CLRF        FARG_WriteDisplay_D2_L_P+0 
	CLRF        FARG_WriteDisplay_D2_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D1+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D1_L_P+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D1_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D0+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D0_L_P+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D0_R_P+0 
	CLRF        FARG_WriteDisplay_N0+0 
	CLRF        FARG_WriteDisplay_N1+0 
	CALL        _WriteDisplay+0, 0
;Nixie.c,1867 :: 		}
L_end_Temp:
	RETURN      0
; end of _Temp

_High_Volt:

;Nixie.c,1874 :: 		void High_Volt() {
;Nixie.c,1876 :: 		SeparaUnidade(High_Voltage);
	MOVF        _High_Voltage+0, 0 
	MOVWF       FARG_SeparaUnidade_Numero+0 
	MOVF        _High_Voltage+1, 0 
	MOVWF       FARG_SeparaUnidade_Numero+1 
	MOVLW       0
	MOVWF       FARG_SeparaUnidade_Numero+2 
	MOVWF       FARG_SeparaUnidade_Numero+3 
	CALL        _SeparaUnidade+0, 0
;Nixie.c,1878 :: 		WriteDisplay(0x0F,0,0,0x0F,0,0,unidade_m,0,0,centena,0,0,dezena,0,0,unidade,1,0,0,0);
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D5+0 
	CLRF        FARG_WriteDisplay_D5_L_P+0 
	CLRF        FARG_WriteDisplay_D5_R_P+0 
	MOVLW       15
	MOVWF       FARG_WriteDisplay_D4+0 
	CLRF        FARG_WriteDisplay_D4_L_P+0 
	CLRF        FARG_WriteDisplay_D4_R_P+0 
	MOVF        _unidade_m+0, 0 
	MOVWF       FARG_WriteDisplay_D3+0 
	CLRF        FARG_WriteDisplay_D3_L_P+0 
	CLRF        FARG_WriteDisplay_D3_R_P+0 
	MOVF        _centena+0, 0 
	MOVWF       FARG_WriteDisplay_D2+0 
	CLRF        FARG_WriteDisplay_D2_L_P+0 
	CLRF        FARG_WriteDisplay_D2_R_P+0 
	MOVF        _dezena+0, 0 
	MOVWF       FARG_WriteDisplay_D1+0 
	CLRF        FARG_WriteDisplay_D1_L_P+0 
	CLRF        FARG_WriteDisplay_D1_R_P+0 
	MOVF        _unidade+0, 0 
	MOVWF       FARG_WriteDisplay_D0+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D0_L_P+0 
	CLRF        FARG_WriteDisplay_D0_R_P+0 
	CLRF        FARG_WriteDisplay_N0+0 
	CLRF        FARG_WriteDisplay_N1+0 
	CALL        _WriteDisplay+0, 0
;Nixie.c,1880 :: 		}
L_end_High_Volt:
	RETURN      0
; end of _High_Volt

_CathodePoisoning:

;Nixie.c,1886 :: 		void CathodePoisoning() {
;Nixie.c,1891 :: 		ON = ACESO;
	MOVF        _ACESO+0, 0 
	MOVWF       CathodePoisoning_ON_L0+0 
;Nixie.c,1892 :: 		OFF = APAGADO;
	MOVF        _APAGADO+0, 0 
	MOVWF       CathodePoisoning_OFF_L0+0 
;Nixie.c,1894 :: 		ACESO = 50;
	MOVLW       50
	MOVWF       _ACESO+0 
;Nixie.c,1895 :: 		APAGADO = 50;
	MOVLW       50
	MOVWF       _APAGADO+0 
;Nixie.c,1897 :: 		Flag_Cathode_Poisoning = 1;
	BSF         _Flag_Cathode_Poisoning+0, BitPos(_Flag_Cathode_Poisoning+0) 
;Nixie.c,1899 :: 		if (Cathode_Poisoning >= 0x50) {
	MOVLW       80
	SUBWF       _Cathode_Poisoning+0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_CathodePoisoning660
;Nixie.c,1900 :: 		Cathode_Poisoning = 0;
	CLRF        _Cathode_Poisoning+0 
;Nixie.c,1901 :: 		count++;
	INFSNZ      CathodePoisoning_count_L0+0, 1 
	INCF        CathodePoisoning_count_L0+1, 1 
;Nixie.c,1902 :: 		}
L_CathodePoisoning660:
;Nixie.c,1904 :: 		number_Cathode_Poisoning = Cathode_Poisoning / 8;
	MOVF        _Cathode_Poisoning+0, 0 
	MOVWF       FLOC__CathodePoisoning+0 
	RRCF        FLOC__CathodePoisoning+0, 1 
	BCF         FLOC__CathodePoisoning+0, 7 
	RRCF        FLOC__CathodePoisoning+0, 1 
	BCF         FLOC__CathodePoisoning+0, 7 
	RRCF        FLOC__CathodePoisoning+0, 1 
	BCF         FLOC__CathodePoisoning+0, 7 
;Nixie.c,1907 :: 		WriteDisplay((number_Cathode_Poisoning+2)%10,1,1,(number_Cathode_Poisoning+4)%10,1,1,(number_Cathode_Poisoning+6)%10,1,1,(number_Cathode_Poisoning+8)%10,1,1,(number_Cathode_Poisoning+3)%10,1,1,number_Cathode_Poisoning,1,1,0,0);
	MOVLW       2
	ADDWF       FLOC__CathodePoisoning+0, 0 
	MOVWF       R0 
	CLRF        R1 
	MOVLW       0
	ADDWFC      R1, 1 
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Div_16x16_S+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       FARG_WriteDisplay_D5+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D5_L_P+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D5_R_P+0 
	MOVLW       4
	ADDWF       FLOC__CathodePoisoning+0, 0 
	MOVWF       R0 
	CLRF        R1 
	MOVLW       0
	ADDWFC      R1, 1 
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Div_16x16_S+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       FARG_WriteDisplay_D4+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D4_L_P+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D4_R_P+0 
	MOVLW       6
	ADDWF       FLOC__CathodePoisoning+0, 0 
	MOVWF       R0 
	CLRF        R1 
	MOVLW       0
	ADDWFC      R1, 1 
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Div_16x16_S+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       FARG_WriteDisplay_D3+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D3_L_P+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D3_R_P+0 
	MOVLW       8
	ADDWF       FLOC__CathodePoisoning+0, 0 
	MOVWF       R0 
	CLRF        R1 
	MOVLW       0
	ADDWFC      R1, 1 
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Div_16x16_S+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       FARG_WriteDisplay_D2+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D2_L_P+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D2_R_P+0 
	MOVLW       3
	ADDWF       FLOC__CathodePoisoning+0, 0 
	MOVWF       R0 
	CLRF        R1 
	MOVLW       0
	ADDWFC      R1, 1 
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Div_16x16_S+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       FARG_WriteDisplay_D1+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D1_L_P+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D1_R_P+0 
	MOVF        FLOC__CathodePoisoning+0, 0 
	MOVWF       FARG_WriteDisplay_D0+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D0_L_P+0 
	MOVLW       1
	MOVWF       FARG_WriteDisplay_D0_R_P+0 
	CLRF        FARG_WriteDisplay_N0+0 
	CLRF        FARG_WriteDisplay_N1+0 
	CALL        _WriteDisplay+0, 0
;Nixie.c,1949 :: 		if (count >= 142 || awake || Botao_INC() || Botao_DEC() || Botao_ENT()) {
	MOVLW       0
	SUBWF       CathodePoisoning_count_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__CathodePoisoning1276
	MOVLW       142
	SUBWF       CathodePoisoning_count_L0+0, 0 
L__CathodePoisoning1276:
	BTFSC       STATUS+0, 0 
	GOTO        L__CathodePoisoning1005
	BTFSC       _awake+0, BitPos(_awake+0) 
	GOTO        L__CathodePoisoning1005
	CALL        _Botao_INC+0, 0
	MOVF        R0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L__CathodePoisoning1005
	CALL        _Botao_DEC+0, 0
	MOVF        R0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L__CathodePoisoning1005
	CALL        _Botao_ENT+0, 0
	MOVF        R0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L__CathodePoisoning1005
	GOTO        L_CathodePoisoning663
L__CathodePoisoning1005:
;Nixie.c,1950 :: 		Flag_Cathode_Poisoning = 0;
	BCF         _Flag_Cathode_Poisoning+0, BitPos(_Flag_Cathode_Poisoning+0) 
;Nixie.c,1951 :: 		Cathode_Poisoning = 0;
	CLRF        _Cathode_Poisoning+0 
;Nixie.c,1952 :: 		count = 0;
	CLRF        CathodePoisoning_count_L0+0 
	CLRF        CathodePoisoning_count_L0+1 
;Nixie.c,1953 :: 		MENU = 1;
	MOVLW       1
	MOVWF       _MENU+0 
	MOVLW       0
	MOVWF       _MENU+1 
;Nixie.c,1954 :: 		}
L_CathodePoisoning663:
;Nixie.c,1956 :: 		ACESO = ON;
	MOVF        CathodePoisoning_ON_L0+0, 0 
	MOVWF       _ACESO+0 
;Nixie.c,1957 :: 		APAGADO = OFF;
	MOVF        CathodePoisoning_OFF_L0+0, 0 
	MOVWF       _APAGADO+0 
;Nixie.c,1959 :: 		}
L_end_CathodePoisoning:
	RETURN      0
; end of _CathodePoisoning

_DisplayOFF:

;Nixie.c,1965 :: 		void DisplayOFF() {
;Nixie.c,1967 :: 		if (Botao_INC() || Botao_DEC() || Botao_ENT() || awake) {
	CALL        _Botao_INC+0, 0
	MOVF        R0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L__DisplayOFF1006
	CALL        _Botao_DEC+0, 0
	MOVF        R0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L__DisplayOFF1006
	CALL        _Botao_ENT+0, 0
	MOVF        R0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L__DisplayOFF1006
	BTFSC       _awake+0, BitPos(_awake+0) 
	GOTO        L__DisplayOFF1006
	GOTO        L_DisplayOFF666
L__DisplayOFF1006:
;Nixie.c,1968 :: 		MENU = 1;
	MOVLW       1
	MOVWF       _MENU+0 
	MOVLW       0
	MOVWF       _MENU+1 
;Nixie.c,1969 :: 		persistence_timer = 0;
	CLRF        _persistence_timer+0 
;Nixie.c,1970 :: 		if (BackLight == 1) BackLightRGB(&Led);
	MOVF        _BackLight+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_DisplayOFF667
	MOVLW       _Led+0
	MOVWF       FARG_BackLightRGB_ledRGB+0 
	MOVLW       hi_addr(_Led+0)
	MOVWF       FARG_BackLightRGB_ledRGB+1 
	CALL        _BackLightRGB+0, 0
	GOTO        L_DisplayOFF668
L_DisplayOFF667:
;Nixie.c,1971 :: 		else if (BackLight == 2) BackLightRGB(&Led_Week[Data.week]);
	MOVF        _BackLight+0, 0 
	XORLW       2
	BTFSS       STATUS+0, 2 
	GOTO        L_DisplayOFF669
	MOVLW       3
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        _Data+6, 0 
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _Led_Week+0
	ADDWF       R0, 0 
	MOVWF       FARG_BackLightRGB_ledRGB+0 
	MOVLW       hi_addr(_Led_Week+0)
	ADDWFC      R1, 0 
	MOVWF       FARG_BackLightRGB_ledRGB+1 
	CALL        _BackLightRGB+0, 0
L_DisplayOFF669:
L_DisplayOFF668:
;Nixie.c,1972 :: 		}
L_DisplayOFF666:
;Nixie.c,1974 :: 		}
L_end_DisplayOFF:
	RETURN      0
; end of _DisplayOFF

_main:

;Nixie.c,1980 :: 		void main() {
;Nixie.c,1982 :: 		unsigned char old_hour = 0, old_week = 0;
	CLRF        main_old_hour_L0+0 
	CLRF        main_old_week_L0+0 
	CLRF        main_Hour_Off_L0+0 
	CLRF        main_Hour_Off_L0+1 
	CLRF        main_Hour_On_L0+0 
	CLRF        main_Hour_On_L0+1 
	CLRF        main_Hour_Current_L0+0 
	CLRF        main_Hour_Current_L0+1 
	CLRF        main_count_cathode_L0+0 
	CLRF        main_count_cathode_L0+1 
;Nixie.c,1985 :: 		asm CLRWDT;
	CLRWDT
;Nixie.c,1987 :: 		Setup();
	CALL        _Setup+0, 0
;Nixie.c,1989 :: 		asm CLRWDT;
	CLRWDT
;Nixie.c,1991 :: 		Start();
	CALL        _Start+0, 0
;Nixie.c,1993 :: 		old_hour = Data.hour;
	MOVF        _Data+2, 0 
	MOVWF       main_old_hour_L0+0 
;Nixie.c,1994 :: 		old_week = Data.week;
	MOVF        _Data+6, 0 
	MOVWF       main_old_week_L0+0 
;Nixie.c,1996 :: 		while(1) {
L_main670:
;Nixie.c,1998 :: 		asm CLRWDT;
	CLRWDT
;Nixie.c,2001 :: 		if (MENU == 1)  {Menu_Show();                 }
	MOVLW       0
	XORWF       _MENU+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main1279
	MOVLW       1
	XORWF       _MENU+0, 0 
L__main1279:
	BTFSS       STATUS+0, 2 
	GOTO        L_main672
	CALL        _Menu_Show+0, 0
L_main672:
;Nixie.c,2003 :: 		if (MENU == 0)  {Menu_Exit();                 if(Botao_INC()){MENU = 11;} else  if(Botao_DEC()){MENU = 95;}  if(Botao_ENT()){MENU = 1; CountShowMode = 0;}}
	MOVLW       0
	XORWF       _MENU+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main1280
	MOVLW       0
	XORWF       _MENU+0, 0 
L__main1280:
	BTFSS       STATUS+0, 2 
	GOTO        L_main673
	CALL        _Menu_Exit+0, 0
	CALL        _Botao_INC+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main674
	MOVLW       11
	MOVWF       _MENU+0 
	MOVLW       0
	MOVWF       _MENU+1 
	GOTO        L_main675
L_main674:
	CALL        _Botao_DEC+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main676
	MOVLW       95
	MOVWF       _MENU+0 
	MOVLW       0
	MOVWF       _MENU+1 
L_main676:
L_main675:
	CALL        _Botao_ENT+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main677
	MOVLW       1
	MOVWF       _MENU+0 
	MOVLW       0
	MOVWF       _MENU+1 
	CLRF        _CountShowMode+0 
L_main677:
L_main673:
;Nixie.c,2005 :: 		if (MENU == 11) {Menu_TimeFormat();           if(Botao_INC()){MENU = 12;} else  if(Botao_DEC()){MENU = 0;}   if(Botao_ENT()){MENU = 110;}}
	MOVLW       0
	XORWF       _MENU+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main1281
	MOVLW       11
	XORWF       _MENU+0, 0 
L__main1281:
	BTFSS       STATUS+0, 2 
	GOTO        L_main678
	CALL        _Menu_TimeFormat+0, 0
	CALL        _Botao_INC+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main679
	MOVLW       12
	MOVWF       _MENU+0 
	MOVLW       0
	MOVWF       _MENU+1 
	GOTO        L_main680
L_main679:
	CALL        _Botao_DEC+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main681
	CLRF        _MENU+0 
	CLRF        _MENU+1 
L_main681:
L_main680:
	CALL        _Botao_ENT+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main682
	MOVLW       110
	MOVWF       _MENU+0 
	MOVLW       0
	MOVWF       _MENU+1 
L_main682:
L_main678:
;Nixie.c,2006 :: 		if (MENU == 12) {Menu_SetTime();              if(Botao_INC()){MENU = 21;} else  if(Botao_DEC()){MENU = 11;}  if(Botao_ENT()){MENU = 120; temp_Data = Data;}}
	MOVLW       0
	XORWF       _MENU+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main1282
	MOVLW       12
	XORWF       _MENU+0, 0 
L__main1282:
	BTFSS       STATUS+0, 2 
	GOTO        L_main683
	CALL        _Menu_SetTime+0, 0
	CALL        _Botao_INC+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main684
	MOVLW       21
	MOVWF       _MENU+0 
	MOVLW       0
	MOVWF       _MENU+1 
	GOTO        L_main685
L_main684:
	CALL        _Botao_DEC+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main686
	MOVLW       11
	MOVWF       _MENU+0 
	MOVLW       0
	MOVWF       _MENU+1 
L_main686:
L_main685:
	CALL        _Botao_ENT+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main687
	MOVLW       120
	MOVWF       _MENU+0 
	MOVLW       0
	MOVWF       _MENU+1 
	MOVLW       9
	MOVWF       R0 
	MOVLW       _temp_Data+0
	MOVWF       FSR1 
	MOVLW       hi_addr(_temp_Data+0)
	MOVWF       FSR1H 
	MOVLW       _Data+0
	MOVWF       FSR0 
	MOVLW       hi_addr(_Data+0)
	MOVWF       FSR0H 
L_main688:
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
	DECF        R0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_main688
L_main687:
L_main683:
;Nixie.c,2008 :: 		if (MENU == 21) {Menu_SetDate();              if(Botao_INC()){MENU = 22;} else  if(Botao_DEC()){MENU = 12;}  if(Botao_ENT()){MENU = 210; temp_Data = Data;}}
	MOVLW       0
	XORWF       _MENU+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main1283
	MOVLW       21
	XORWF       _MENU+0, 0 
L__main1283:
	BTFSS       STATUS+0, 2 
	GOTO        L_main689
	CALL        _Menu_SetDate+0, 0
	CALL        _Botao_INC+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main690
	MOVLW       22
	MOVWF       _MENU+0 
	MOVLW       0
	MOVWF       _MENU+1 
	GOTO        L_main691
L_main690:
	CALL        _Botao_DEC+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main692
	MOVLW       12
	MOVWF       _MENU+0 
	MOVLW       0
	MOVWF       _MENU+1 
L_main692:
L_main691:
	CALL        _Botao_ENT+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main693
	MOVLW       210
	MOVWF       _MENU+0 
	MOVLW       0
	MOVWF       _MENU+1 
	MOVLW       9
	MOVWF       R0 
	MOVLW       _temp_Data+0
	MOVWF       FSR1 
	MOVLW       hi_addr(_temp_Data+0)
	MOVWF       FSR1H 
	MOVLW       _Data+0
	MOVWF       FSR0 
	MOVLW       hi_addr(_Data+0)
	MOVWF       FSR0H 
L_main694:
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
	DECF        R0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_main694
L_main693:
L_main689:
;Nixie.c,2009 :: 		if (MENU == 22) {Menu_SetWeek();              if(Botao_INC()){MENU = 31;} else  if(Botao_DEC()){MENU = 21;}  if(Botao_ENT()){MENU = 220; temp_Data = Data;}}
	MOVLW       0
	XORWF       _MENU+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main1284
	MOVLW       22
	XORWF       _MENU+0, 0 
L__main1284:
	BTFSS       STATUS+0, 2 
	GOTO        L_main695
	CALL        _Menu_SetWeek+0, 0
	CALL        _Botao_INC+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main696
	MOVLW       31
	MOVWF       _MENU+0 
	MOVLW       0
	MOVWF       _MENU+1 
	GOTO        L_main697
L_main696:
	CALL        _Botao_DEC+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main698
	MOVLW       21
	MOVWF       _MENU+0 
	MOVLW       0
	MOVWF       _MENU+1 
L_main698:
L_main697:
	CALL        _Botao_ENT+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main699
	MOVLW       220
	MOVWF       _MENU+0 
	MOVLW       0
	MOVWF       _MENU+1 
	MOVLW       9
	MOVWF       R0 
	MOVLW       _temp_Data+0
	MOVWF       FSR1 
	MOVLW       hi_addr(_temp_Data+0)
	MOVWF       FSR1H 
	MOVLW       _Data+0
	MOVWF       FSR0 
	MOVLW       hi_addr(_Data+0)
	MOVWF       FSR0H 
L_main700:
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
	DECF        R0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_main700
L_main699:
L_main695:
;Nixie.c,2011 :: 		if (MENU == 31) {Menu_SetBackLight();         if(Botao_INC()){MENU = 32;} else  if(Botao_DEC()){MENU = 22;}  if(Botao_ENT()){MENU = 310;}}
	MOVLW       0
	XORWF       _MENU+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main1285
	MOVLW       31
	XORWF       _MENU+0, 0 
L__main1285:
	BTFSS       STATUS+0, 2 
	GOTO        L_main701
	CALL        _Menu_SetBackLight+0, 0
	CALL        _Botao_INC+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main702
	MOVLW       32
	MOVWF       _MENU+0 
	MOVLW       0
	MOVWF       _MENU+1 
	GOTO        L_main703
L_main702:
	CALL        _Botao_DEC+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main704
	MOVLW       22
	MOVWF       _MENU+0 
	MOVLW       0
	MOVWF       _MENU+1 
L_main704:
L_main703:
	CALL        _Botao_ENT+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main705
	MOVLW       54
	MOVWF       _MENU+0 
	MOVLW       1
	MOVWF       _MENU+1 
L_main705:
L_main701:
;Nixie.c,2012 :: 		if (MENU == 32) {Menu_SetR();                 if(Botao_INC()){MENU = 33;} else  if(Botao_DEC()){MENU = 31;}  if(Botao_ENT()){MENU = 320; BackLightRGB(&Led);}}
	MOVLW       0
	XORWF       _MENU+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main1286
	MOVLW       32
	XORWF       _MENU+0, 0 
L__main1286:
	BTFSS       STATUS+0, 2 
	GOTO        L_main706
	CALL        _Menu_SetR+0, 0
	CALL        _Botao_INC+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main707
	MOVLW       33
	MOVWF       _MENU+0 
	MOVLW       0
	MOVWF       _MENU+1 
	GOTO        L_main708
L_main707:
	CALL        _Botao_DEC+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main709
	MOVLW       31
	MOVWF       _MENU+0 
	MOVLW       0
	MOVWF       _MENU+1 
L_main709:
L_main708:
	CALL        _Botao_ENT+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main710
	MOVLW       64
	MOVWF       _MENU+0 
	MOVLW       1
	MOVWF       _MENU+1 
	MOVLW       _Led+0
	MOVWF       FARG_BackLightRGB_ledRGB+0 
	MOVLW       hi_addr(_Led+0)
	MOVWF       FARG_BackLightRGB_ledRGB+1 
	CALL        _BackLightRGB+0, 0
L_main710:
L_main706:
;Nixie.c,2013 :: 		if (MENU == 33) {Menu_SetG();                 if(Botao_INC()){MENU = 34;} else  if(Botao_DEC()){MENU = 32;}  if(Botao_ENT()){MENU = 330; BackLightRGB(&Led);}}
	MOVLW       0
	XORWF       _MENU+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main1287
	MOVLW       33
	XORWF       _MENU+0, 0 
L__main1287:
	BTFSS       STATUS+0, 2 
	GOTO        L_main711
	CALL        _Menu_SetG+0, 0
	CALL        _Botao_INC+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main712
	MOVLW       34
	MOVWF       _MENU+0 
	MOVLW       0
	MOVWF       _MENU+1 
	GOTO        L_main713
L_main712:
	CALL        _Botao_DEC+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main714
	MOVLW       32
	MOVWF       _MENU+0 
	MOVLW       0
	MOVWF       _MENU+1 
L_main714:
L_main713:
	CALL        _Botao_ENT+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main715
	MOVLW       74
	MOVWF       _MENU+0 
	MOVLW       1
	MOVWF       _MENU+1 
	MOVLW       _Led+0
	MOVWF       FARG_BackLightRGB_ledRGB+0 
	MOVLW       hi_addr(_Led+0)
	MOVWF       FARG_BackLightRGB_ledRGB+1 
	CALL        _BackLightRGB+0, 0
L_main715:
L_main711:
;Nixie.c,2014 :: 		if (MENU == 34) {Menu_SetB();                 if(Botao_INC()){MENU = 41;} else  if(Botao_DEC()){MENU = 33;}  if(Botao_ENT()){MENU = 340; BackLightRGB(&Led);}}
	MOVLW       0
	XORWF       _MENU+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main1288
	MOVLW       34
	XORWF       _MENU+0, 0 
L__main1288:
	BTFSS       STATUS+0, 2 
	GOTO        L_main716
	CALL        _Menu_SetB+0, 0
	CALL        _Botao_INC+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main717
	MOVLW       41
	MOVWF       _MENU+0 
	MOVLW       0
	MOVWF       _MENU+1 
	GOTO        L_main718
L_main717:
	CALL        _Botao_DEC+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main719
	MOVLW       33
	MOVWF       _MENU+0 
	MOVLW       0
	MOVWF       _MENU+1 
L_main719:
L_main718:
	CALL        _Botao_ENT+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main720
	MOVLW       84
	MOVWF       _MENU+0 
	MOVLW       1
	MOVWF       _MENU+1 
	MOVLW       _Led+0
	MOVWF       FARG_BackLightRGB_ledRGB+0 
	MOVLW       hi_addr(_Led+0)
	MOVWF       FARG_BackLightRGB_ledRGB+1 
	CALL        _BackLightRGB+0, 0
L_main720:
L_main716:
;Nixie.c,2016 :: 		if (MENU == 41) {Menu_LDR();                  if(Botao_INC()){MENU = 42;} else  if(Botao_DEC()){MENU = 34;}  if(Botao_ENT()){MENU = 410;}}
	MOVLW       0
	XORWF       _MENU+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main1289
	MOVLW       41
	XORWF       _MENU+0, 0 
L__main1289:
	BTFSS       STATUS+0, 2 
	GOTO        L_main721
	CALL        _Menu_LDR+0, 0
	CALL        _Botao_INC+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main722
	MOVLW       42
	MOVWF       _MENU+0 
	MOVLW       0
	MOVWF       _MENU+1 
	GOTO        L_main723
L_main722:
	CALL        _Botao_DEC+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main724
	MOVLW       34
	MOVWF       _MENU+0 
	MOVLW       0
	MOVWF       _MENU+1 
L_main724:
L_main723:
	CALL        _Botao_ENT+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main725
	MOVLW       154
	MOVWF       _MENU+0 
	MOVLW       1
	MOVWF       _MENU+1 
L_main725:
L_main721:
;Nixie.c,2017 :: 		if (MENU == 42) {Menu_SetBright();            if(Botao_INC()){MENU = 51;} else  if(Botao_DEC()){MENU = 41;}  if(Botao_ENT()){MENU = 420; LDR_Auto = 0; ACESO = ler_eeprom(0x07); APAGADO = 100-ACESO;}}
	MOVLW       0
	XORWF       _MENU+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main1290
	MOVLW       42
	XORWF       _MENU+0, 0 
L__main1290:
	BTFSS       STATUS+0, 2 
	GOTO        L_main726
	CALL        _Menu_SetBright+0, 0
	CALL        _Botao_INC+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main727
	MOVLW       51
	MOVWF       _MENU+0 
	MOVLW       0
	MOVWF       _MENU+1 
	GOTO        L_main728
L_main727:
	CALL        _Botao_DEC+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main729
	MOVLW       41
	MOVWF       _MENU+0 
	MOVLW       0
	MOVWF       _MENU+1 
L_main729:
L_main728:
	CALL        _Botao_ENT+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main730
	MOVLW       164
	MOVWF       _MENU+0 
	MOVLW       1
	MOVWF       _MENU+1 
	BCF         _LDR_Auto+0, BitPos(_LDR_Auto+0) 
	MOVLW       7
	MOVWF       FARG_ler_eeprom_address+0 
	CALL        _ler_eeprom+0, 0
	MOVF        R0, 0 
	MOVWF       _ACESO+0 
	MOVF        R0, 0 
	SUBLW       100
	MOVWF       _APAGADO+0 
L_main730:
L_main726:
;Nixie.c,2019 :: 		if (MENU == 51) {Menu_Presence();             if(Botao_INC()){MENU = 52;} else  if(Botao_DEC()){MENU = 42;}  if(Botao_ENT()){MENU = 510;}}
	MOVLW       0
	XORWF       _MENU+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main1291
	MOVLW       51
	XORWF       _MENU+0, 0 
L__main1291:
	BTFSS       STATUS+0, 2 
	GOTO        L_main731
	CALL        _Menu_Presence+0, 0
	CALL        _Botao_INC+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main732
	MOVLW       52
	MOVWF       _MENU+0 
	MOVLW       0
	MOVWF       _MENU+1 
	GOTO        L_main733
L_main732:
	CALL        _Botao_DEC+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main734
	MOVLW       42
	MOVWF       _MENU+0 
	MOVLW       0
	MOVWF       _MENU+1 
L_main734:
L_main733:
	CALL        _Botao_ENT+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main735
	MOVLW       254
	MOVWF       _MENU+0 
	MOVLW       1
	MOVWF       _MENU+1 
L_main735:
L_main731:
;Nixie.c,2020 :: 		if (MENU == 52) {Menu_TimePresence();         if(Botao_INC()){MENU = 53;} else  if(Botao_DEC()){MENU = 51;}  if(Botao_ENT()){MENU = 520;}}
	MOVLW       0
	XORWF       _MENU+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main1292
	MOVLW       52
	XORWF       _MENU+0, 0 
L__main1292:
	BTFSS       STATUS+0, 2 
	GOTO        L_main736
	CALL        _Menu_TimePresence+0, 0
	CALL        _Botao_INC+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main737
	MOVLW       53
	MOVWF       _MENU+0 
	MOVLW       0
	MOVWF       _MENU+1 
	GOTO        L_main738
L_main737:
	CALL        _Botao_DEC+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main739
	MOVLW       51
	MOVWF       _MENU+0 
	MOVLW       0
	MOVWF       _MENU+1 
L_main739:
L_main738:
	CALL        _Botao_ENT+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main740
	MOVLW       8
	MOVWF       _MENU+0 
	MOVLW       2
	MOVWF       _MENU+1 
L_main740:
L_main736:
;Nixie.c,2021 :: 		if (MENU == 53) {Menu_AutoPresence();         if(Botao_INC()){MENU = 61;} else  if(Botao_DEC()){MENU = 52;}  if(Botao_ENT()){MENU = 530;}}
	MOVLW       0
	XORWF       _MENU+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main1293
	MOVLW       53
	XORWF       _MENU+0, 0 
L__main1293:
	BTFSS       STATUS+0, 2 
	GOTO        L_main741
	CALL        _Menu_AutoPresence+0, 0
	CALL        _Botao_INC+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main742
	MOVLW       61
	MOVWF       _MENU+0 
	MOVLW       0
	MOVWF       _MENU+1 
	GOTO        L_main743
L_main742:
	CALL        _Botao_DEC+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main744
	MOVLW       52
	MOVWF       _MENU+0 
	MOVLW       0
	MOVWF       _MENU+1 
L_main744:
L_main743:
	CALL        _Botao_ENT+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main745
	MOVLW       18
	MOVWF       _MENU+0 
	MOVLW       2
	MOVWF       _MENU+1 
L_main745:
L_main741:
;Nixie.c,2023 :: 		if (MENU == 61) {Menu_SetDisplayEffect();     if(Botao_INC()){MENU = 62;} else  if(Botao_DEC()){MENU = 53;}  if(Botao_ENT()){MENU = 610;}}
	MOVLW       0
	XORWF       _MENU+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main1294
	MOVLW       61
	XORWF       _MENU+0, 0 
L__main1294:
	BTFSS       STATUS+0, 2 
	GOTO        L_main746
	CALL        _Menu_SetDisplayEffect+0, 0
	CALL        _Botao_INC+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main747
	MOVLW       62
	MOVWF       _MENU+0 
	MOVLW       0
	MOVWF       _MENU+1 
	GOTO        L_main748
L_main747:
	CALL        _Botao_DEC+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main749
	MOVLW       53
	MOVWF       _MENU+0 
	MOVLW       0
	MOVWF       _MENU+1 
L_main749:
L_main748:
	CALL        _Botao_ENT+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main750
	MOVLW       98
	MOVWF       _MENU+0 
	MOVLW       2
	MOVWF       _MENU+1 
L_main750:
L_main746:
;Nixie.c,2024 :: 		if (MENU == 62) {Menu_CathodePoisoning();     if(Botao_INC()){MENU = 63;} else  if(Botao_DEC()){MENU = 61;}  if(Botao_ENT()){MENU = 620;}}
	MOVLW       0
	XORWF       _MENU+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main1295
	MOVLW       62
	XORWF       _MENU+0, 0 
L__main1295:
	BTFSS       STATUS+0, 2 
	GOTO        L_main751
	CALL        _Menu_CathodePoisoning+0, 0
	CALL        _Botao_INC+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main752
	MOVLW       63
	MOVWF       _MENU+0 
	MOVLW       0
	MOVWF       _MENU+1 
	GOTO        L_main753
L_main752:
	CALL        _Botao_DEC+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main754
	MOVLW       61
	MOVWF       _MENU+0 
	MOVLW       0
	MOVWF       _MENU+1 
L_main754:
L_main753:
	CALL        _Botao_ENT+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main755
	MOVLW       108
	MOVWF       _MENU+0 
	MOVLW       2
	MOVWF       _MENU+1 
L_main755:
L_main751:
;Nixie.c,2025 :: 		if (MENU == 63) {Menu_TimeCathodePoisoning(); if(Botao_INC()){MENU = 71;} else  if(Botao_DEC()){MENU = 62;}  if(Botao_ENT()){MENU = 630;}}
	MOVLW       0
	XORWF       _MENU+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main1296
	MOVLW       63
	XORWF       _MENU+0, 0 
L__main1296:
	BTFSS       STATUS+0, 2 
	GOTO        L_main756
	CALL        _Menu_TimeCathodePoisoning+0, 0
	CALL        _Botao_INC+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main757
	MOVLW       71
	MOVWF       _MENU+0 
	MOVLW       0
	MOVWF       _MENU+1 
	GOTO        L_main758
L_main757:
	CALL        _Botao_DEC+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main759
	MOVLW       62
	MOVWF       _MENU+0 
	MOVLW       0
	MOVWF       _MENU+1 
L_main759:
L_main758:
	CALL        _Botao_ENT+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main760
	MOVLW       118
	MOVWF       _MENU+0 
	MOVLW       2
	MOVWF       _MENU+1 
L_main760:
L_main756:
;Nixie.c,2027 :: 		if (MENU == 71) {Menu_SetAutoOFFON();         if(Botao_INC()){MENU = 72;} else  if(Botao_DEC()){MENU = 63;}  if(Botao_ENT()){MENU = 710;}}
	MOVLW       0
	XORWF       _MENU+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main1297
	MOVLW       71
	XORWF       _MENU+0, 0 
L__main1297:
	BTFSS       STATUS+0, 2 
	GOTO        L_main761
	CALL        _Menu_SetAutoOFFON+0, 0
	CALL        _Botao_INC+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main762
	MOVLW       72
	MOVWF       _MENU+0 
	MOVLW       0
	MOVWF       _MENU+1 
	GOTO        L_main763
L_main762:
	CALL        _Botao_DEC+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main764
	MOVLW       63
	MOVWF       _MENU+0 
	MOVLW       0
	MOVWF       _MENU+1 
L_main764:
L_main763:
	CALL        _Botao_ENT+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main765
	MOVLW       198
	MOVWF       _MENU+0 
	MOVLW       2
	MOVWF       _MENU+1 
L_main765:
L_main761:
;Nixie.c,2028 :: 		if (MENU == 72) {Menu_SetAutoOFF();           if(Botao_INC()){MENU = 73;} else  if(Botao_DEC()){MENU = 71;}  if(Botao_ENT()){MENU = 720;}}
	MOVLW       0
	XORWF       _MENU+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main1298
	MOVLW       72
	XORWF       _MENU+0, 0 
L__main1298:
	BTFSS       STATUS+0, 2 
	GOTO        L_main766
	CALL        _Menu_SetAutoOFF+0, 0
	CALL        _Botao_INC+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main767
	MOVLW       73
	MOVWF       _MENU+0 
	MOVLW       0
	MOVWF       _MENU+1 
	GOTO        L_main768
L_main767:
	CALL        _Botao_DEC+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main769
	MOVLW       71
	MOVWF       _MENU+0 
	MOVLW       0
	MOVWF       _MENU+1 
L_main769:
L_main768:
	CALL        _Botao_ENT+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main770
	MOVLW       208
	MOVWF       _MENU+0 
	MOVLW       2
	MOVWF       _MENU+1 
L_main770:
L_main766:
;Nixie.c,2029 :: 		if (MENU == 73) {Menu_SetAutoON();            if(Botao_INC()){MENU = 81;} else  if(Botao_DEC()){MENU = 72;}  if(Botao_ENT()){MENU = 730;}}
	MOVLW       0
	XORWF       _MENU+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main1299
	MOVLW       73
	XORWF       _MENU+0, 0 
L__main1299:
	BTFSS       STATUS+0, 2 
	GOTO        L_main771
	CALL        _Menu_SetAutoON+0, 0
	CALL        _Botao_INC+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main772
	MOVLW       81
	MOVWF       _MENU+0 
	MOVLW       0
	MOVWF       _MENU+1 
	GOTO        L_main773
L_main772:
	CALL        _Botao_DEC+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main774
	MOVLW       72
	MOVWF       _MENU+0 
	MOVLW       0
	MOVWF       _MENU+1 
L_main774:
L_main773:
	CALL        _Botao_ENT+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main775
	MOVLW       218
	MOVWF       _MENU+0 
	MOVLW       2
	MOVWF       _MENU+1 
L_main775:
L_main771:
;Nixie.c,2031 :: 		if (MENU == 81) {Menu_SetAlarm();             if(Botao_INC()){MENU = 82;} else  if(Botao_DEC()){MENU = 73;}  if(Botao_ENT()){MENU = 810;}}
	MOVLW       0
	XORWF       _MENU+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main1300
	MOVLW       81
	XORWF       _MENU+0, 0 
L__main1300:
	BTFSS       STATUS+0, 2 
	GOTO        L_main776
	CALL        _Menu_SetAlarm+0, 0
	CALL        _Botao_INC+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main777
	MOVLW       82
	MOVWF       _MENU+0 
	MOVLW       0
	MOVWF       _MENU+1 
	GOTO        L_main778
L_main777:
	CALL        _Botao_DEC+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main779
	MOVLW       73
	MOVWF       _MENU+0 
	MOVLW       0
	MOVWF       _MENU+1 
L_main779:
L_main778:
	CALL        _Botao_ENT+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main780
	MOVLW       42
	MOVWF       _MENU+0 
	MOVLW       3
	MOVWF       _MENU+1 
L_main780:
L_main776:
;Nixie.c,2032 :: 		if (MENU == 82) {Menu_HourAlarm();            if(Botao_INC()){MENU = 91;} else  if(Botao_DEC()){MENU = 81;}  if(Botao_ENT()){MENU = 820;}}
	MOVLW       0
	XORWF       _MENU+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main1301
	MOVLW       82
	XORWF       _MENU+0, 0 
L__main1301:
	BTFSS       STATUS+0, 2 
	GOTO        L_main781
	CALL        _Menu_HourAlarm+0, 0
	CALL        _Botao_INC+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main782
	MOVLW       91
	MOVWF       _MENU+0 
	MOVLW       0
	MOVWF       _MENU+1 
	GOTO        L_main783
L_main782:
	CALL        _Botao_DEC+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main784
	MOVLW       81
	MOVWF       _MENU+0 
	MOVLW       0
	MOVWF       _MENU+1 
L_main784:
L_main783:
	CALL        _Botao_ENT+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main785
	MOVLW       52
	MOVWF       _MENU+0 
	MOVLW       3
	MOVWF       _MENU+1 
L_main785:
L_main781:
;Nixie.c,2034 :: 		if (MENU == 91) {Menu_HourBeep();             if(Botao_INC()){MENU = 92;} else  if(Botao_DEC()){MENU = 82;}  if(Botao_ENT()){MENU = 910;}}
	MOVLW       0
	XORWF       _MENU+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main1302
	MOVLW       91
	XORWF       _MENU+0, 0 
L__main1302:
	BTFSS       STATUS+0, 2 
	GOTO        L_main786
	CALL        _Menu_HourBeep+0, 0
	CALL        _Botao_INC+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main787
	MOVLW       92
	MOVWF       _MENU+0 
	MOVLW       0
	MOVWF       _MENU+1 
	GOTO        L_main788
L_main787:
	CALL        _Botao_DEC+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main789
	MOVLW       82
	MOVWF       _MENU+0 
	MOVLW       0
	MOVWF       _MENU+1 
L_main789:
L_main788:
	CALL        _Botao_ENT+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main790
	MOVLW       142
	MOVWF       _MENU+0 
	MOVLW       3
	MOVWF       _MENU+1 
L_main790:
L_main786:
;Nixie.c,2035 :: 		if (MENU == 92) {Menu_SecondBeep();           if(Botao_INC()){MENU = 93;} else  if(Botao_DEC()){MENU = 91;}  if(Botao_ENT()){MENU = 920;}}
	MOVLW       0
	XORWF       _MENU+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main1303
	MOVLW       92
	XORWF       _MENU+0, 0 
L__main1303:
	BTFSS       STATUS+0, 2 
	GOTO        L_main791
	CALL        _Menu_SecondBeep+0, 0
	CALL        _Botao_INC+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main792
	MOVLW       93
	MOVWF       _MENU+0 
	MOVLW       0
	MOVWF       _MENU+1 
	GOTO        L_main793
L_main792:
	CALL        _Botao_DEC+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main794
	MOVLW       91
	MOVWF       _MENU+0 
	MOVLW       0
	MOVWF       _MENU+1 
L_main794:
L_main793:
	CALL        _Botao_ENT+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main795
	MOVLW       152
	MOVWF       _MENU+0 
	MOVLW       3
	MOVWF       _MENU+1 
L_main795:
L_main791:
;Nixie.c,2036 :: 		if (MENU == 93) {Menu_ButtonBeep();            if(Botao_INC()){MENU = 94;} else  if(Botao_DEC()){MENU = 92;}  if(Botao_ENT()){MENU = 930;}}
	MOVLW       0
	XORWF       _MENU+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main1304
	MOVLW       93
	XORWF       _MENU+0, 0 
L__main1304:
	BTFSS       STATUS+0, 2 
	GOTO        L_main796
	CALL        _Menu_ButtonBeep+0, 0
	CALL        _Botao_INC+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main797
	MOVLW       94
	MOVWF       _MENU+0 
	MOVLW       0
	MOVWF       _MENU+1 
	GOTO        L_main798
L_main797:
	CALL        _Botao_DEC+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main799
	MOVLW       92
	MOVWF       _MENU+0 
	MOVLW       0
	MOVWF       _MENU+1 
L_main799:
L_main798:
	CALL        _Botao_ENT+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main800
	MOVLW       162
	MOVWF       _MENU+0 
	MOVLW       3
	MOVWF       _MENU+1 
L_main800:
L_main796:
;Nixie.c,2037 :: 		if (MENU == 94) {Menu_AjustTemp();            if(Botao_INC()){MENU = 95;} else  if(Botao_DEC()){MENU = 93;}  if(Botao_ENT()){MENU = 940;}}
	MOVLW       0
	XORWF       _MENU+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main1305
	MOVLW       94
	XORWF       _MENU+0, 0 
L__main1305:
	BTFSS       STATUS+0, 2 
	GOTO        L_main801
	CALL        _Menu_AjustTemp+0, 0
	CALL        _Botao_INC+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main802
	MOVLW       95
	MOVWF       _MENU+0 
	MOVLW       0
	MOVWF       _MENU+1 
	GOTO        L_main803
L_main802:
	CALL        _Botao_DEC+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main804
	MOVLW       93
	MOVWF       _MENU+0 
	MOVLW       0
	MOVWF       _MENU+1 
L_main804:
L_main803:
	CALL        _Botao_ENT+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main805
	MOVLW       172
	MOVWF       _MENU+0 
	MOVLW       3
	MOVWF       _MENU+1 
L_main805:
L_main801:
;Nixie.c,2038 :: 		if (MENU == 95) {Menu_HighVoltage();          if(Botao_INC()){MENU = 0;}  else  if(Botao_DEC()){MENU = 94;}  }
	MOVLW       0
	XORWF       _MENU+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main1306
	MOVLW       95
	XORWF       _MENU+0, 0 
L__main1306:
	BTFSS       STATUS+0, 2 
	GOTO        L_main806
	CALL        _Menu_HighVoltage+0, 0
	CALL        _Botao_INC+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main807
	CLRF        _MENU+0 
	CLRF        _MENU+1 
	GOTO        L_main808
L_main807:
	CALL        _Botao_DEC+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main809
	MOVLW       94
	MOVWF       _MENU+0 
	MOVLW       0
	MOVWF       _MENU+1 
L_main809:
L_main808:
L_main806:
;Nixie.c,2041 :: 		if (MENU == 110)  {Menu_11();      }
	MOVLW       0
	XORWF       _MENU+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main1307
	MOVLW       110
	XORWF       _MENU+0, 0 
L__main1307:
	BTFSS       STATUS+0, 2 
	GOTO        L_main810
	CALL        _Menu_11+0, 0
L_main810:
;Nixie.c,2042 :: 		if (MENU == 120)  {Menu_12_SEG();  }
	MOVLW       0
	XORWF       _MENU+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main1308
	MOVLW       120
	XORWF       _MENU+0, 0 
L__main1308:
	BTFSS       STATUS+0, 2 
	GOTO        L_main811
	CALL        _Menu_12_SEG+0, 0
L_main811:
;Nixie.c,2043 :: 		if (MENU == 121)  {Menu_12_MIN();  }
	MOVLW       0
	XORWF       _MENU+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main1309
	MOVLW       121
	XORWF       _MENU+0, 0 
L__main1309:
	BTFSS       STATUS+0, 2 
	GOTO        L_main812
	CALL        _Menu_12_MIN+0, 0
L_main812:
;Nixie.c,2044 :: 		if (MENU == 122)  {Menu_12_HOUR(); }
	MOVLW       0
	XORWF       _MENU+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main1310
	MOVLW       122
	XORWF       _MENU+0, 0 
L__main1310:
	BTFSS       STATUS+0, 2 
	GOTO        L_main813
	CALL        _Menu_12_HOUR+0, 0
L_main813:
;Nixie.c,2046 :: 		if (MENU == 210)  {Menu_21_DAY();  }
	MOVLW       0
	XORWF       _MENU+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main1311
	MOVLW       210
	XORWF       _MENU+0, 0 
L__main1311:
	BTFSS       STATUS+0, 2 
	GOTO        L_main814
	CALL        _Menu_21_DAY+0, 0
L_main814:
;Nixie.c,2047 :: 		if (MENU == 211)  {Menu_21_MON();  }
	MOVLW       0
	XORWF       _MENU+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main1312
	MOVLW       211
	XORWF       _MENU+0, 0 
L__main1312:
	BTFSS       STATUS+0, 2 
	GOTO        L_main815
	CALL        _Menu_21_MON+0, 0
L_main815:
;Nixie.c,2048 :: 		if (MENU == 212)  {Menu_21_YEAR(); }
	MOVLW       0
	XORWF       _MENU+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main1313
	MOVLW       212
	XORWF       _MENU+0, 0 
L__main1313:
	BTFSS       STATUS+0, 2 
	GOTO        L_main816
	CALL        _Menu_21_YEAR+0, 0
L_main816:
;Nixie.c,2049 :: 		if (MENU == 220)  {Menu_22();      }
	MOVLW       0
	XORWF       _MENU+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main1314
	MOVLW       220
	XORWF       _MENU+0, 0 
L__main1314:
	BTFSS       STATUS+0, 2 
	GOTO        L_main817
	CALL        _Menu_22+0, 0
L_main817:
;Nixie.c,2051 :: 		if (MENU == 310)  {Menu_31();      }
	MOVF        _MENU+1, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L__main1315
	MOVLW       54
	XORWF       _MENU+0, 0 
L__main1315:
	BTFSS       STATUS+0, 2 
	GOTO        L_main818
	CALL        _Menu_31+0, 0
L_main818:
;Nixie.c,2052 :: 		if (MENU == 320)  {Menu_32();      }
	MOVF        _MENU+1, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L__main1316
	MOVLW       64
	XORWF       _MENU+0, 0 
L__main1316:
	BTFSS       STATUS+0, 2 
	GOTO        L_main819
	CALL        _Menu_32+0, 0
L_main819:
;Nixie.c,2053 :: 		if (MENU == 330)  {Menu_33();      }
	MOVF        _MENU+1, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L__main1317
	MOVLW       74
	XORWF       _MENU+0, 0 
L__main1317:
	BTFSS       STATUS+0, 2 
	GOTO        L_main820
	CALL        _Menu_33+0, 0
L_main820:
;Nixie.c,2054 :: 		if (MENU == 340)  {Menu_34();      }
	MOVF        _MENU+1, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L__main1318
	MOVLW       84
	XORWF       _MENU+0, 0 
L__main1318:
	BTFSS       STATUS+0, 2 
	GOTO        L_main821
	CALL        _Menu_34+0, 0
L_main821:
;Nixie.c,2056 :: 		if (MENU == 410)  {Menu_41();      }
	MOVF        _MENU+1, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L__main1319
	MOVLW       154
	XORWF       _MENU+0, 0 
L__main1319:
	BTFSS       STATUS+0, 2 
	GOTO        L_main822
	CALL        _Menu_41+0, 0
L_main822:
;Nixie.c,2057 :: 		if (MENU == 420)  {Menu_42();      }
	MOVF        _MENU+1, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L__main1320
	MOVLW       164
	XORWF       _MENU+0, 0 
L__main1320:
	BTFSS       STATUS+0, 2 
	GOTO        L_main823
	CALL        _Menu_42+0, 0
L_main823:
;Nixie.c,2059 :: 		if (MENU == 510)  {Menu_51();      }
	MOVF        _MENU+1, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L__main1321
	MOVLW       254
	XORWF       _MENU+0, 0 
L__main1321:
	BTFSS       STATUS+0, 2 
	GOTO        L_main824
	CALL        _Menu_51+0, 0
L_main824:
;Nixie.c,2060 :: 		if (MENU == 520)  {Menu_52();      }
	MOVF        _MENU+1, 0 
	XORLW       2
	BTFSS       STATUS+0, 2 
	GOTO        L__main1322
	MOVLW       8
	XORWF       _MENU+0, 0 
L__main1322:
	BTFSS       STATUS+0, 2 
	GOTO        L_main825
	CALL        _Menu_52+0, 0
L_main825:
;Nixie.c,2061 :: 		if (MENU == 530)  {Menu_53();      }
	MOVF        _MENU+1, 0 
	XORLW       2
	BTFSS       STATUS+0, 2 
	GOTO        L__main1323
	MOVLW       18
	XORWF       _MENU+0, 0 
L__main1323:
	BTFSS       STATUS+0, 2 
	GOTO        L_main826
	CALL        _Menu_53+0, 0
L_main826:
;Nixie.c,2063 :: 		if (MENU == 610)  {Menu_61();      }
	MOVF        _MENU+1, 0 
	XORLW       2
	BTFSS       STATUS+0, 2 
	GOTO        L__main1324
	MOVLW       98
	XORWF       _MENU+0, 0 
L__main1324:
	BTFSS       STATUS+0, 2 
	GOTO        L_main827
	CALL        _Menu_61+0, 0
L_main827:
;Nixie.c,2064 :: 		if (MENU == 620)  {Menu_62();      }
	MOVF        _MENU+1, 0 
	XORLW       2
	BTFSS       STATUS+0, 2 
	GOTO        L__main1325
	MOVLW       108
	XORWF       _MENU+0, 0 
L__main1325:
	BTFSS       STATUS+0, 2 
	GOTO        L_main828
	CALL        _Menu_62+0, 0
L_main828:
;Nixie.c,2065 :: 		if (MENU == 630)  {Menu_63();      }
	MOVF        _MENU+1, 0 
	XORLW       2
	BTFSS       STATUS+0, 2 
	GOTO        L__main1326
	MOVLW       118
	XORWF       _MENU+0, 0 
L__main1326:
	BTFSS       STATUS+0, 2 
	GOTO        L_main829
	CALL        _Menu_63+0, 0
L_main829:
;Nixie.c,2067 :: 		if (MENU == 710)  {Menu_71();      }
	MOVF        _MENU+1, 0 
	XORLW       2
	BTFSS       STATUS+0, 2 
	GOTO        L__main1327
	MOVLW       198
	XORWF       _MENU+0, 0 
L__main1327:
	BTFSS       STATUS+0, 2 
	GOTO        L_main830
	CALL        _Menu_71+0, 0
L_main830:
;Nixie.c,2068 :: 		if (MENU == 720)  {Menu_72_MIN();  }
	MOVF        _MENU+1, 0 
	XORLW       2
	BTFSS       STATUS+0, 2 
	GOTO        L__main1328
	MOVLW       208
	XORWF       _MENU+0, 0 
L__main1328:
	BTFSS       STATUS+0, 2 
	GOTO        L_main831
	CALL        _Menu_72_MIN+0, 0
L_main831:
;Nixie.c,2069 :: 		if (MENU == 721)  {Menu_72_HOUR(); }
	MOVF        _MENU+1, 0 
	XORLW       2
	BTFSS       STATUS+0, 2 
	GOTO        L__main1329
	MOVLW       209
	XORWF       _MENU+0, 0 
L__main1329:
	BTFSS       STATUS+0, 2 
	GOTO        L_main832
	CALL        _Menu_72_HOUR+0, 0
L_main832:
;Nixie.c,2070 :: 		if (MENU == 730)  {Menu_73_MIN();  }
	MOVF        _MENU+1, 0 
	XORLW       2
	BTFSS       STATUS+0, 2 
	GOTO        L__main1330
	MOVLW       218
	XORWF       _MENU+0, 0 
L__main1330:
	BTFSS       STATUS+0, 2 
	GOTO        L_main833
	CALL        _Menu_73_MIN+0, 0
L_main833:
;Nixie.c,2071 :: 		if (MENU == 731)  {Menu_73_HOUR(); }
	MOVF        _MENU+1, 0 
	XORLW       2
	BTFSS       STATUS+0, 2 
	GOTO        L__main1331
	MOVLW       219
	XORWF       _MENU+0, 0 
L__main1331:
	BTFSS       STATUS+0, 2 
	GOTO        L_main834
	CALL        _Menu_73_HOUR+0, 0
L_main834:
;Nixie.c,2073 :: 		if (MENU == 810)  {Menu_81();      }
	MOVF        _MENU+1, 0 
	XORLW       3
	BTFSS       STATUS+0, 2 
	GOTO        L__main1332
	MOVLW       42
	XORWF       _MENU+0, 0 
L__main1332:
	BTFSS       STATUS+0, 2 
	GOTO        L_main835
	CALL        _Menu_81+0, 0
L_main835:
;Nixie.c,2074 :: 		if (MENU == 820)  {Menu_82_MIN();  }
	MOVF        _MENU+1, 0 
	XORLW       3
	BTFSS       STATUS+0, 2 
	GOTO        L__main1333
	MOVLW       52
	XORWF       _MENU+0, 0 
L__main1333:
	BTFSS       STATUS+0, 2 
	GOTO        L_main836
	CALL        _Menu_82_MIN+0, 0
L_main836:
;Nixie.c,2075 :: 		if (MENU == 821)  {Menu_82_HOUR(); }
	MOVF        _MENU+1, 0 
	XORLW       3
	BTFSS       STATUS+0, 2 
	GOTO        L__main1334
	MOVLW       53
	XORWF       _MENU+0, 0 
L__main1334:
	BTFSS       STATUS+0, 2 
	GOTO        L_main837
	CALL        _Menu_82_HOUR+0, 0
L_main837:
;Nixie.c,2077 :: 		if (MENU == 910)  {Menu_91();      }
	MOVF        _MENU+1, 0 
	XORLW       3
	BTFSS       STATUS+0, 2 
	GOTO        L__main1335
	MOVLW       142
	XORWF       _MENU+0, 0 
L__main1335:
	BTFSS       STATUS+0, 2 
	GOTO        L_main838
	CALL        _Menu_91+0, 0
L_main838:
;Nixie.c,2078 :: 		if (MENU == 920)  {Menu_92();      }
	MOVF        _MENU+1, 0 
	XORLW       3
	BTFSS       STATUS+0, 2 
	GOTO        L__main1336
	MOVLW       152
	XORWF       _MENU+0, 0 
L__main1336:
	BTFSS       STATUS+0, 2 
	GOTO        L_main839
	CALL        _Menu_92+0, 0
L_main839:
;Nixie.c,2079 :: 		if (MENU == 930)  {Menu_93();      }
	MOVF        _MENU+1, 0 
	XORLW       3
	BTFSS       STATUS+0, 2 
	GOTO        L__main1337
	MOVLW       162
	XORWF       _MENU+0, 0 
L__main1337:
	BTFSS       STATUS+0, 2 
	GOTO        L_main840
	CALL        _Menu_93+0, 0
L_main840:
;Nixie.c,2080 :: 		if (MENU == 940)  {Menu_94();      }
	MOVF        _MENU+1, 0 
	XORLW       3
	BTFSS       STATUS+0, 2 
	GOTO        L__main1338
	MOVLW       172
	XORWF       _MENU+0, 0 
L__main1338:
	BTFSS       STATUS+0, 2 
	GOTO        L_main841
	CALL        _Menu_94+0, 0
L_main841:
;Nixie.c,2082 :: 		if (MENU == 1000) {CathodePoisoning(); }
	MOVF        _MENU+1, 0 
	XORLW       3
	BTFSS       STATUS+0, 2 
	GOTO        L__main1339
	MOVLW       232
	XORWF       _MENU+0, 0 
L__main1339:
	BTFSS       STATUS+0, 2 
	GOTO        L_main842
	CALL        _CathodePoisoning+0, 0
L_main842:
;Nixie.c,2084 :: 		if (MENU == 2000) {DisplayOFF();   }
	MOVF        _MENU+1, 0 
	XORLW       7
	BTFSS       STATUS+0, 2 
	GOTO        L__main1340
	MOVLW       208
	XORWF       _MENU+0, 0 
L__main1340:
	BTFSS       STATUS+0, 2 
	GOTO        L_main843
	CALL        _DisplayOFF+0, 0
L_main843:
;Nixie.c,2088 :: 		if (reset_RTC) {
	BTFSS       _reset_RTC+0, BitPos(_reset_RTC+0) 
	GOTO        L_main844
;Nixie.c,2089 :: 		Write_RTC(Data);
	MOVLW       9
	MOVWF       R0 
	MOVLW       FARG_Write_RTC_Data+0
	MOVWF       FSR1 
	MOVLW       hi_addr(FARG_Write_RTC_Data+0)
	MOVWF       FSR1H 
	MOVLW       _Data+0
	MOVWF       FSR0 
	MOVLW       hi_addr(_Data+0)
	MOVWF       FSR0H 
L_main845:
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
	DECF        R0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_main845
	CALL        _Write_RTC+0, 0
;Nixie.c,2090 :: 		reset_RTC = 0;
	BCF         _reset_RTC+0, BitPos(_reset_RTC+0) 
;Nixie.c,2091 :: 		BEEP_ALARM();
	CALL        _BEEP_ALARM+0, 0
;Nixie.c,2092 :: 		}
L_main844:
;Nixie.c,2094 :: 		if (refresh_RTC) {
	BTFSS       _refresh_RTC+0, BitPos(_refresh_RTC+0) 
	GOTO        L_main846
;Nixie.c,2096 :: 		Data = Read_RTC();
	MOVLW       FLOC__main+0
	MOVWF       R0 
	MOVLW       hi_addr(FLOC__main+0)
	MOVWF       R1 
	CALL        _Read_RTC+0, 0
	MOVLW       9
	MOVWF       R0 
	MOVLW       _Data+0
	MOVWF       FSR1 
	MOVLW       hi_addr(_Data+0)
	MOVWF       FSR1H 
	MOVLW       FLOC__main+0
	MOVWF       FSR0 
	MOVLW       hi_addr(FLOC__main+0)
	MOVWF       FSR0H 
L_main847:
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
	DECF        R0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_main847
;Nixie.c,2098 :: 		if (SecondBeep && (MENU == 1)) BEEP;  // beep a cada segundo
	BTFSS       _SecondBeep+0, BitPos(_SecondBeep+0) 
	GOTO        L_main850
	MOVLW       0
	XORWF       _MENU+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main1341
	MOVLW       1
	XORWF       _MENU+0, 0 
L__main1341:
	BTFSS       STATUS+0, 2 
	GOTO        L_main850
L__main1024:
	BSF         RC7_bit+0, BitPos(RC7_bit+0) 
	MOVLW       27
	MOVWF       R13, 0
L_main851:
	DECFSZ      R13, 1, 1
	BRA         L_main851
	NOP
	NOP
	BCF         RC7_bit+0, BitPos(RC7_bit+0) 
L_main850:
;Nixie.c,2100 :: 		if (Data.hour != old_hour) {     // beep por hora
	MOVF        _Data+2, 0 
	XORWF       main_old_hour_L0+0, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_main852
;Nixie.c,2101 :: 		old_hour = Data.hour;
	MOVF        _Data+2, 0 
	MOVWF       main_old_hour_L0+0 
;Nixie.c,2102 :: 		if (HourBeep && (MENU == 1 || MENU == 1000)) BEEP_HOUR();
	BTFSS       _HourBeep+0, BitPos(_HourBeep+0) 
	GOTO        L_main857
	MOVLW       0
	XORWF       _MENU+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main1342
	MOVLW       1
	XORWF       _MENU+0, 0 
L__main1342:
	BTFSC       STATUS+0, 2 
	GOTO        L__main1023
	MOVF        _MENU+1, 0 
	XORLW       3
	BTFSS       STATUS+0, 2 
	GOTO        L__main1343
	MOVLW       232
	XORWF       _MENU+0, 0 
L__main1343:
	BTFSC       STATUS+0, 2 
	GOTO        L__main1023
	GOTO        L_main857
L__main1023:
L__main1022:
	CALL        _BEEP_HOUR+0, 0
L_main857:
;Nixie.c,2103 :: 		}
L_main852:
;Nixie.c,2105 :: 		if ((BackLight == 2) && (MENU != 2000) && (MENU != 310) && (MENU != 320) && (MENU != 330) && (MENU != 340)) {
	MOVF        _BackLight+0, 0 
	XORLW       2
	BTFSS       STATUS+0, 2 
	GOTO        L_main860
	MOVF        _MENU+1, 0 
	XORLW       7
	BTFSS       STATUS+0, 2 
	GOTO        L__main1344
	MOVLW       208
	XORWF       _MENU+0, 0 
L__main1344:
	BTFSC       STATUS+0, 2 
	GOTO        L_main860
	MOVF        _MENU+1, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L__main1345
	MOVLW       54
	XORWF       _MENU+0, 0 
L__main1345:
	BTFSC       STATUS+0, 2 
	GOTO        L_main860
	MOVF        _MENU+1, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L__main1346
	MOVLW       64
	XORWF       _MENU+0, 0 
L__main1346:
	BTFSC       STATUS+0, 2 
	GOTO        L_main860
	MOVF        _MENU+1, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L__main1347
	MOVLW       74
	XORWF       _MENU+0, 0 
L__main1347:
	BTFSC       STATUS+0, 2 
	GOTO        L_main860
	MOVF        _MENU+1, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L__main1348
	MOVLW       84
	XORWF       _MENU+0, 0 
L__main1348:
	BTFSC       STATUS+0, 2 
	GOTO        L_main860
L__main1021:
;Nixie.c,2106 :: 		if (Data.week != old_week) {old_week = Data.week; BackLightRGB(&Led_Week[Data.week]);}
	MOVF        _Data+6, 0 
	XORWF       main_old_week_L0+0, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_main861
	MOVF        _Data+6, 0 
	MOVWF       main_old_week_L0+0 
	MOVLW       3
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        _Data+6, 0 
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _Led_Week+0
	ADDWF       R0, 0 
	MOVWF       FARG_BackLightRGB_ledRGB+0 
	MOVLW       hi_addr(_Led_Week+0)
	ADDWFC      R1, 0 
	MOVWF       FARG_BackLightRGB_ledRGB+1 
	CALL        _BackLightRGB+0, 0
L_main861:
;Nixie.c,2107 :: 		}
L_main860:
;Nixie.c,2109 :: 		if (Cathode && MENU == 1) {
	BTFSS       _Cathode+0, BitPos(_Cathode+0) 
	GOTO        L_main864
	MOVLW       0
	XORWF       _MENU+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main1349
	MOVLW       1
	XORWF       _MENU+0, 0 
L__main1349:
	BTFSS       STATUS+0, 2 
	GOTO        L_main864
L__main1020:
;Nixie.c,2110 :: 		count_cathode++;
	INFSNZ      main_count_cathode_L0+0, 1 
	INCF        main_count_cathode_L0+1, 1 
;Nixie.c,2111 :: 		if (count_cathode >= CathodeTime*60) {MENU = 1000; count_cathode = 0;}
	MOVLW       60
	MULWF       _CathodeTime+0 
	MOVF        PRODL+0, 0 
	MOVWF       R1 
	MOVF        PRODH+0, 0 
	MOVWF       R2 
	MOVF        R2, 0 
	SUBWF       main_count_cathode_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main1350
	MOVF        R1, 0 
	SUBWF       main_count_cathode_L0+0, 0 
L__main1350:
	BTFSS       STATUS+0, 0 
	GOTO        L_main865
	MOVLW       232
	MOVWF       _MENU+0 
	MOVLW       3
	MOVWF       _MENU+1 
	CLRF        main_count_cathode_L0+0 
	CLRF        main_count_cathode_L0+1 
L_main865:
;Nixie.c,2112 :: 		} else count_cathode = 0;
	GOTO        L_main866
L_main864:
	CLRF        main_count_cathode_L0+0 
	CLRF        main_count_cathode_L0+1 
L_main866:
;Nixie.c,2114 :: 		CountShowMode++;
	INCF        _CountShowMode+0, 1 
;Nixie.c,2115 :: 		if (CountShowMode == 60) CountShowMode = 0;
	MOVF        _CountShowMode+0, 0 
	XORLW       60
	BTFSS       STATUS+0, 2 
	GOTO        L_main867
	CLRF        _CountShowMode+0 
L_main867:
;Nixie.c,2117 :: 		if (Alarm && (MENU == 1 || MENU == 1000 || MENU == 2000)) {
	BTFSS       _Alarm+0, BitPos(_Alarm+0) 
	GOTO        L_main872
	MOVLW       0
	XORWF       _MENU+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main1351
	MOVLW       1
	XORWF       _MENU+0, 0 
L__main1351:
	BTFSC       STATUS+0, 2 
	GOTO        L__main1019
	MOVF        _MENU+1, 0 
	XORLW       3
	BTFSS       STATUS+0, 2 
	GOTO        L__main1352
	MOVLW       232
	XORWF       _MENU+0, 0 
L__main1352:
	BTFSC       STATUS+0, 2 
	GOTO        L__main1019
	MOVF        _MENU+1, 0 
	XORLW       7
	BTFSS       STATUS+0, 2 
	GOTO        L__main1353
	MOVLW       208
	XORWF       _MENU+0, 0 
L__main1353:
	BTFSC       STATUS+0, 2 
	GOTO        L__main1019
	GOTO        L_main872
L__main1019:
L__main1018:
;Nixie.c,2118 :: 		if (Alarm_Hour == Data.hour && Alarm_Minute == Data.minute && Alarm_PM == Data.PM && Data.second == 0x00) {
	MOVF        _Alarm_Hour+0, 0 
	XORWF       _Data+2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L_main875
	MOVF        _Alarm_Minute+0, 0 
	XORWF       _Data+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L_main875
	MOVF        _Alarm_PM+0, 0 
	XORWF       _Data+3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L_main875
	MOVF        _Data+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_main875
L__main1017:
;Nixie.c,2119 :: 		awake = 1;
	BSF         _awake+0, BitPos(_awake+0) 
;Nixie.c,2120 :: 		} else
	GOTO        L_main876
L_main875:
;Nixie.c,2121 :: 		if (Alarm_Hour != Data.hour || Alarm_Minute != Data.minute || Alarm_PM != Data.PM) {
	MOVF        _Alarm_Hour+0, 0 
	XORWF       _Data+2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main1016
	MOVF        _Alarm_Minute+0, 0 
	XORWF       _Data+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main1016
	MOVF        _Alarm_PM+0, 0 
	XORWF       _Data+3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main1016
	GOTO        L_main879
L__main1016:
;Nixie.c,2122 :: 		awake = 0;
	BCF         _awake+0, BitPos(_awake+0) 
;Nixie.c,2123 :: 		}
L_main879:
L_main876:
;Nixie.c,2124 :: 		}
L_main872:
;Nixie.c,2126 :: 		if (awake) BEEP_ALARM();
	BTFSS       _awake+0, BitPos(_awake+0) 
	GOTO        L_main880
	CALL        _BEEP_ALARM+0, 0
L_main880:
;Nixie.c,2128 :: 		if (AutoOffOn && (MENU == 1 || MENU == 2000)) {
	BTFSS       _AutoOffOn+0, BitPos(_AutoOffOn+0) 
	GOTO        L_main885
	MOVLW       0
	XORWF       _MENU+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main1354
	MOVLW       1
	XORWF       _MENU+0, 0 
L__main1354:
	BTFSC       STATUS+0, 2 
	GOTO        L__main1015
	MOVF        _MENU+1, 0 
	XORLW       7
	BTFSS       STATUS+0, 2 
	GOTO        L__main1355
	MOVLW       208
	XORWF       _MENU+0, 0 
L__main1355:
	BTFSC       STATUS+0, 2 
	GOTO        L__main1015
	GOTO        L_main885
L__main1015:
L__main1014:
;Nixie.c,2130 :: 		if (persistence_timer < PresenceTime) persistence_timer++;
	MOVF        _PresenceTime+0, 0 
	SUBWF       _persistence_timer+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_main886
	INCF        _persistence_timer+0, 1 
L_main886:
;Nixie.c,2132 :: 		if (Mode12h) {
	BTFSS       _Mode12h+0, BitPos(_Mode12h+0) 
	GOTO        L_main887
;Nixie.c,2133 :: 		if (Display_Off_PM) Hour_Off = ((Display_Off_Hour == 0x12 ? 0x12 : Dec2Bcd(12 + Bcd2Dec(Display_Off_Hour))) << 8) + Display_Off_Minute;
	MOVF        _Display_Off_PM+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main888
	MOVF        _Display_Off_Hour+0, 0 
	XORLW       18
	BTFSS       STATUS+0, 2 
	GOTO        L_main889
	MOVLW       18
	MOVWF       ?FLOC___mainT1159+0 
	GOTO        L_main890
L_main889:
	MOVF        _Display_Off_Hour+0, 0 
	MOVWF       FARG_Bcd2Dec_bcdnum+0 
	CALL        _Bcd2Dec+0, 0
	MOVF        R0, 0 
	ADDLW       12
	MOVWF       FARG_Dec2Bcd_decnum+0 
	CALL        _Dec2Bcd+0, 0
	MOVF        R0, 0 
	MOVWF       ?FLOC___mainT1159+0 
L_main890:
	MOVF        ?FLOC___mainT1159+0, 0 
	MOVWF       main_Hour_Off_L0+1 
	CLRF        main_Hour_Off_L0+0 
	MOVF        _Display_Off_Minute+0, 0 
	ADDWF       main_Hour_Off_L0+0, 1 
	MOVLW       0
	ADDWFC      main_Hour_Off_L0+1, 1 
	GOTO        L_main891
L_main888:
;Nixie.c,2134 :: 		else                Hour_Off = ((Display_Off_Hour == 0x12 ? 0x00 : Display_Off_Hour) << 8) + Display_Off_Minute;
	MOVF        _Display_Off_Hour+0, 0 
	XORLW       18
	BTFSS       STATUS+0, 2 
	GOTO        L_main892
	CLRF        ?FLOC___mainT1164+0 
	GOTO        L_main893
L_main892:
	MOVF        _Display_Off_Hour+0, 0 
	MOVWF       ?FLOC___mainT1164+0 
L_main893:
	MOVF        ?FLOC___mainT1164+0, 0 
	MOVWF       main_Hour_Off_L0+1 
	CLRF        main_Hour_Off_L0+0 
	MOVF        _Display_Off_Minute+0, 0 
	ADDWF       main_Hour_Off_L0+0, 1 
	MOVLW       0
	ADDWFC      main_Hour_Off_L0+1, 1 
L_main891:
;Nixie.c,2136 :: 		if (Display_On_PM) Hour_On = ((Display_On_Hour == 0x12 ? 0x12 : Dec2Bcd(12 + Bcd2Dec(Display_On_Hour))) << 8) + Display_On_Minute;
	MOVF        _Display_On_PM+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main894
	MOVF        _Display_On_Hour+0, 0 
	XORLW       18
	BTFSS       STATUS+0, 2 
	GOTO        L_main895
	MOVLW       18
	MOVWF       ?FLOC___mainT1168+0 
	GOTO        L_main896
L_main895:
	MOVF        _Display_On_Hour+0, 0 
	MOVWF       FARG_Bcd2Dec_bcdnum+0 
	CALL        _Bcd2Dec+0, 0
	MOVF        R0, 0 
	ADDLW       12
	MOVWF       FARG_Dec2Bcd_decnum+0 
	CALL        _Dec2Bcd+0, 0
	MOVF        R0, 0 
	MOVWF       ?FLOC___mainT1168+0 
L_main896:
	MOVF        ?FLOC___mainT1168+0, 0 
	MOVWF       main_Hour_On_L0+1 
	CLRF        main_Hour_On_L0+0 
	MOVF        _Display_On_Minute+0, 0 
	ADDWF       main_Hour_On_L0+0, 1 
	MOVLW       0
	ADDWFC      main_Hour_On_L0+1, 1 
	GOTO        L_main897
L_main894:
;Nixie.c,2137 :: 		else               Hour_On = ((Display_On_Hour == 0x12 ? 0x00 : Display_On_Hour) << 8) + Display_On_Minute;
	MOVF        _Display_On_Hour+0, 0 
	XORLW       18
	BTFSS       STATUS+0, 2 
	GOTO        L_main898
	CLRF        ?FLOC___mainT1173+0 
	GOTO        L_main899
L_main898:
	MOVF        _Display_On_Hour+0, 0 
	MOVWF       ?FLOC___mainT1173+0 
L_main899:
	MOVF        ?FLOC___mainT1173+0, 0 
	MOVWF       main_Hour_On_L0+1 
	CLRF        main_Hour_On_L0+0 
	MOVF        _Display_On_Minute+0, 0 
	ADDWF       main_Hour_On_L0+0, 1 
	MOVLW       0
	ADDWFC      main_Hour_On_L0+1, 1 
L_main897:
;Nixie.c,2139 :: 		if (Data.PM) Hour_Current = ((Data.hour == 0x12 ? 0x12 : Dec2Bcd(12 + Bcd2Dec(Data.hour))) << 8) + Data.minute;
	MOVF        _Data+3, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main900
	MOVF        _Data+2, 0 
	XORLW       18
	BTFSS       STATUS+0, 2 
	GOTO        L_main901
	MOVLW       18
	MOVWF       ?FLOC___mainT1177+0 
	GOTO        L_main902
L_main901:
	MOVF        _Data+2, 0 
	MOVWF       FARG_Bcd2Dec_bcdnum+0 
	CALL        _Bcd2Dec+0, 0
	MOVF        R0, 0 
	ADDLW       12
	MOVWF       FARG_Dec2Bcd_decnum+0 
	CALL        _Dec2Bcd+0, 0
	MOVF        R0, 0 
	MOVWF       ?FLOC___mainT1177+0 
L_main902:
	MOVF        ?FLOC___mainT1177+0, 0 
	MOVWF       main_Hour_Current_L0+1 
	CLRF        main_Hour_Current_L0+0 
	MOVF        _Data+1, 0 
	ADDWF       main_Hour_Current_L0+0, 1 
	MOVLW       0
	ADDWFC      main_Hour_Current_L0+1, 1 
	GOTO        L_main903
L_main900:
;Nixie.c,2140 :: 		else         Hour_Current = ((Data.hour == 0x12 ? 0x00 : Data.hour) << 8) + Data.minute;
	MOVF        _Data+2, 0 
	XORLW       18
	BTFSS       STATUS+0, 2 
	GOTO        L_main904
	CLRF        ?FLOC___mainT1182+0 
	GOTO        L_main905
L_main904:
	MOVF        _Data+2, 0 
	MOVWF       ?FLOC___mainT1182+0 
L_main905:
	MOVF        ?FLOC___mainT1182+0, 0 
	MOVWF       main_Hour_Current_L0+1 
	CLRF        main_Hour_Current_L0+0 
	MOVF        _Data+1, 0 
	ADDWF       main_Hour_Current_L0+0, 1 
	MOVLW       0
	ADDWFC      main_Hour_Current_L0+1, 1 
L_main903:
;Nixie.c,2141 :: 		} else {
	GOTO        L_main906
L_main887:
;Nixie.c,2142 :: 		Hour_Off = (Display_Off_Hour << 8) + Display_Off_Minute;
	MOVF        _Display_Off_Hour+0, 0 
	MOVWF       main_Hour_Off_L0+1 
	CLRF        main_Hour_Off_L0+0 
	MOVF        _Display_Off_Minute+0, 0 
	ADDWF       main_Hour_Off_L0+0, 1 
	MOVLW       0
	ADDWFC      main_Hour_Off_L0+1, 1 
;Nixie.c,2143 :: 		Hour_On =  (Display_On_Hour << 8) + Display_On_Minute;
	MOVF        _Display_On_Hour+0, 0 
	MOVWF       main_Hour_On_L0+1 
	CLRF        main_Hour_On_L0+0 
	MOVF        _Display_On_Minute+0, 0 
	ADDWF       main_Hour_On_L0+0, 1 
	MOVLW       0
	ADDWFC      main_Hour_On_L0+1, 1 
;Nixie.c,2144 :: 		Hour_Current =  (Data.hour << 8) + Data.minute;
	MOVF        _Data+2, 0 
	MOVWF       main_Hour_Current_L0+1 
	CLRF        main_Hour_Current_L0+0 
	MOVF        _Data+1, 0 
	ADDWF       main_Hour_Current_L0+0, 1 
	MOVLW       0
	ADDWFC      main_Hour_Current_L0+1, 1 
;Nixie.c,2145 :: 		}
L_main906:
;Nixie.c,2147 :: 		if (Hour_Off < Hour_On) {
	MOVF        main_Hour_On_L0+1, 0 
	SUBWF       main_Hour_Off_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main1356
	MOVF        main_Hour_On_L0+0, 0 
	SUBWF       main_Hour_Off_L0+0, 0 
L__main1356:
	BTFSC       STATUS+0, 0 
	GOTO        L_main907
;Nixie.c,2148 :: 		if (Hour_Current >= Hour_Off && Hour_Current < Hour_On) {if (persistence_timer >= PresenceTime) {MENU = 2000; BackLightRGB(&LedOFF);}}
	MOVF        main_Hour_Off_L0+1, 0 
	SUBWF       main_Hour_Current_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main1357
	MOVF        main_Hour_Off_L0+0, 0 
	SUBWF       main_Hour_Current_L0+0, 0 
L__main1357:
	BTFSS       STATUS+0, 0 
	GOTO        L_main910
	MOVF        main_Hour_On_L0+1, 0 
	SUBWF       main_Hour_Current_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main1358
	MOVF        main_Hour_On_L0+0, 0 
	SUBWF       main_Hour_Current_L0+0, 0 
L__main1358:
	BTFSC       STATUS+0, 0 
	GOTO        L_main910
L__main1013:
	MOVF        _PresenceTime+0, 0 
	SUBWF       _persistence_timer+0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_main911
	MOVLW       208
	MOVWF       _MENU+0 
	MOVLW       7
	MOVWF       _MENU+1 
	MOVLW       _LedOFF+0
	MOVWF       FARG_BackLightRGB_ledRGB+0 
	MOVLW       hi_addr(_LedOFF+0)
	MOVWF       FARG_BackLightRGB_ledRGB+1 
	CALL        _BackLightRGB+0, 0
L_main911:
	GOTO        L_main912
L_main910:
;Nixie.c,2149 :: 		else {MENU = 1; if (BackLight == 1) BackLightRGB(&Led); else if (BackLight == 2) BackLightRGB(&Led_Week[Data.week]);}
	MOVLW       1
	MOVWF       _MENU+0 
	MOVLW       0
	MOVWF       _MENU+1 
	MOVF        _BackLight+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_main913
	MOVLW       _Led+0
	MOVWF       FARG_BackLightRGB_ledRGB+0 
	MOVLW       hi_addr(_Led+0)
	MOVWF       FARG_BackLightRGB_ledRGB+1 
	CALL        _BackLightRGB+0, 0
	GOTO        L_main914
L_main913:
	MOVF        _BackLight+0, 0 
	XORLW       2
	BTFSS       STATUS+0, 2 
	GOTO        L_main915
	MOVLW       3
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        _Data+6, 0 
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _Led_Week+0
	ADDWF       R0, 0 
	MOVWF       FARG_BackLightRGB_ledRGB+0 
	MOVLW       hi_addr(_Led_Week+0)
	ADDWFC      R1, 0 
	MOVWF       FARG_BackLightRGB_ledRGB+1 
	CALL        _BackLightRGB+0, 0
L_main915:
L_main914:
L_main912:
;Nixie.c,2150 :: 		} else
	GOTO        L_main916
L_main907:
;Nixie.c,2152 :: 		if (Hour_Off > Hour_On) {
	MOVF        main_Hour_Off_L0+1, 0 
	SUBWF       main_Hour_On_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main1359
	MOVF        main_Hour_Off_L0+0, 0 
	SUBWF       main_Hour_On_L0+0, 0 
L__main1359:
	BTFSC       STATUS+0, 0 
	GOTO        L_main917
;Nixie.c,2153 :: 		if (Hour_Current < Hour_Off && Hour_Current >= Hour_On) {MENU = 1; if (BackLight == 1) BackLightRGB(&Led); else if (BackLight == 2) BackLightRGB(&Led_Week[Data.week]);}
	MOVF        main_Hour_Off_L0+1, 0 
	SUBWF       main_Hour_Current_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main1360
	MOVF        main_Hour_Off_L0+0, 0 
	SUBWF       main_Hour_Current_L0+0, 0 
L__main1360:
	BTFSC       STATUS+0, 0 
	GOTO        L_main920
	MOVF        main_Hour_On_L0+1, 0 
	SUBWF       main_Hour_Current_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main1361
	MOVF        main_Hour_On_L0+0, 0 
	SUBWF       main_Hour_Current_L0+0, 0 
L__main1361:
	BTFSS       STATUS+0, 0 
	GOTO        L_main920
L__main1012:
	MOVLW       1
	MOVWF       _MENU+0 
	MOVLW       0
	MOVWF       _MENU+1 
	MOVF        _BackLight+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_main921
	MOVLW       _Led+0
	MOVWF       FARG_BackLightRGB_ledRGB+0 
	MOVLW       hi_addr(_Led+0)
	MOVWF       FARG_BackLightRGB_ledRGB+1 
	CALL        _BackLightRGB+0, 0
	GOTO        L_main922
L_main921:
	MOVF        _BackLight+0, 0 
	XORLW       2
	BTFSS       STATUS+0, 2 
	GOTO        L_main923
	MOVLW       3
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        _Data+6, 0 
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _Led_Week+0
	ADDWF       R0, 0 
	MOVWF       FARG_BackLightRGB_ledRGB+0 
	MOVLW       hi_addr(_Led_Week+0)
	ADDWFC      R1, 0 
	MOVWF       FARG_BackLightRGB_ledRGB+1 
	CALL        _BackLightRGB+0, 0
L_main923:
L_main922:
	GOTO        L_main924
L_main920:
;Nixie.c,2154 :: 		else if (persistence_timer >= PresenceTime) {MENU = 2000; BackLightRGB(&LedOFF);}
	MOVF        _PresenceTime+0, 0 
	SUBWF       _persistence_timer+0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_main925
	MOVLW       208
	MOVWF       _MENU+0 
	MOVLW       7
	MOVWF       _MENU+1 
	MOVLW       _LedOFF+0
	MOVWF       FARG_BackLightRGB_ledRGB+0 
	MOVLW       hi_addr(_LedOFF+0)
	MOVWF       FARG_BackLightRGB_ledRGB+1 
	CALL        _BackLightRGB+0, 0
L_main925:
L_main924:
;Nixie.c,2155 :: 		}
L_main917:
L_main916:
;Nixie.c,2157 :: 		} else persistence_timer = 0;
	GOTO        L_main926
L_main885:
	CLRF        _persistence_timer+0 
L_main926:
;Nixie.c,2161 :: 		MEDIA_TEMP -= MM_TEMP[INDICE_MM_TEMP];           // Média Móvel da TEMP
	MOVF        _INDICE_MM_TEMP+0, 0 
	MOVWF       R0 
	MOVF        _INDICE_MM_TEMP+1, 0 
	MOVWF       R1 
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	MOVLW       _MM_TEMP+0
	ADDWF       R0, 1 
	MOVLW       hi_addr(_MM_TEMP+0)
	ADDWFC      R1, 1 
	MOVFF       R0, FSR2
	MOVFF       R1, FSR2H
	MOVF        POSTINC2+0, 0 
	SUBWF       _MEDIA_TEMP+0, 1 
	MOVF        POSTINC2+0, 0 
	SUBWFB      _MEDIA_TEMP+1, 1 
	MOVF        POSTINC2+0, 0 
	SUBWFB      _MEDIA_TEMP+2, 1 
	MOVF        POSTINC2+0, 0 
	SUBWFB      _MEDIA_TEMP+3, 1 
;Nixie.c,2162 :: 		MM_TEMP[INDICE_MM_TEMP] = VALOR_ADC(0);
	MOVF        R0, 0 
	MOVWF       FLOC__main+0 
	MOVF        R1, 0 
	MOVWF       FLOC__main+1 
	CLRF        FARG_VALOR_ADC_CH+0 
	CALL        _VALOR_ADC+0, 0
	MOVFF       FLOC__main+0, FSR1
	MOVFF       FLOC__main+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
	MOVF        R1, 0 
	MOVWF       POSTINC1+0 
	MOVLW       0
	MOVWF       POSTINC1+0 
	MOVWF       POSTINC1+0 
;Nixie.c,2163 :: 		MEDIA_TEMP += MM_TEMP[INDICE_MM_TEMP];
	MOVF        _INDICE_MM_TEMP+0, 0 
	MOVWF       R0 
	MOVF        _INDICE_MM_TEMP+1, 0 
	MOVWF       R1 
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	MOVLW       _MM_TEMP+0
	ADDWF       R0, 0 
	MOVWF       FSR2 
	MOVLW       hi_addr(_MM_TEMP+0)
	ADDWFC      R1, 0 
	MOVWF       FSR2H 
	MOVF        POSTINC2+0, 0 
	ADDWF       _MEDIA_TEMP+0, 1 
	MOVF        POSTINC2+0, 0 
	ADDWFC      _MEDIA_TEMP+1, 1 
	MOVF        POSTINC2+0, 0 
	ADDWFC      _MEDIA_TEMP+2, 1 
	MOVF        POSTINC2+0, 0 
	ADDWFC      _MEDIA_TEMP+3, 1 
;Nixie.c,2165 :: 		MEDIA_LDR -= MM_LDR[INDICE_MM];                  // Média Móvel do LDR
	MOVF        _INDICE_MM+0, 0 
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	MOVLW       _MM_LDR+0
	ADDWF       R0, 1 
	MOVLW       hi_addr(_MM_LDR+0)
	ADDWFC      R1, 1 
	MOVFF       R0, FSR2
	MOVFF       R1, FSR2H
	MOVF        POSTINC2+0, 0 
	SUBWF       _MEDIA_LDR+0, 1 
	MOVF        POSTINC2+0, 0 
	SUBWFB      _MEDIA_LDR+1, 1 
	MOVF        POSTINC2+0, 0 
	SUBWFB      _MEDIA_LDR+2, 1 
	MOVF        POSTINC2+0, 0 
	SUBWFB      _MEDIA_LDR+3, 1 
;Nixie.c,2166 :: 		MM_LDR[INDICE_MM] = VALOR_ADC(1);
	MOVF        R0, 0 
	MOVWF       FLOC__main+0 
	MOVF        R1, 0 
	MOVWF       FLOC__main+1 
	MOVLW       1
	MOVWF       FARG_VALOR_ADC_CH+0 
	CALL        _VALOR_ADC+0, 0
	MOVFF       FLOC__main+0, FSR1
	MOVFF       FLOC__main+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
	MOVF        R1, 0 
	MOVWF       POSTINC1+0 
	MOVLW       0
	MOVWF       POSTINC1+0 
	MOVWF       POSTINC1+0 
;Nixie.c,2167 :: 		MEDIA_LDR += MM_LDR[INDICE_MM];
	MOVF        _INDICE_MM+0, 0 
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	MOVLW       _MM_LDR+0
	ADDWF       R0, 0 
	MOVWF       FSR2 
	MOVLW       hi_addr(_MM_LDR+0)
	ADDWFC      R1, 0 
	MOVWF       FSR2H 
	MOVF        POSTINC2+0, 0 
	ADDWF       _MEDIA_LDR+0, 1 
	MOVF        POSTINC2+0, 0 
	ADDWFC      _MEDIA_LDR+1, 1 
	MOVF        POSTINC2+0, 0 
	ADDWFC      _MEDIA_LDR+2, 1 
	MOVF        POSTINC2+0, 0 
	ADDWFC      _MEDIA_LDR+3, 1 
;Nixie.c,2169 :: 		MEDIA_HIGH_VOLT -= MM_HIGH_VOLT[INDICE_MM];      // Média Móvel da HIGH_VOLT
	MOVLW       _MM_HIGH_VOLT+0
	ADDWF       R0, 1 
	MOVLW       hi_addr(_MM_HIGH_VOLT+0)
	ADDWFC      R1, 1 
	MOVFF       R0, FSR2
	MOVFF       R1, FSR2H
	MOVF        POSTINC2+0, 0 
	SUBWF       _MEDIA_HIGH_VOLT+0, 1 
	MOVF        POSTINC2+0, 0 
	SUBWFB      _MEDIA_HIGH_VOLT+1, 1 
	MOVF        POSTINC2+0, 0 
	SUBWFB      _MEDIA_HIGH_VOLT+2, 1 
	MOVF        POSTINC2+0, 0 
	SUBWFB      _MEDIA_HIGH_VOLT+3, 1 
;Nixie.c,2170 :: 		MM_HIGH_VOLT[INDICE_MM] = VALOR_ADC(2);
	MOVF        R0, 0 
	MOVWF       FLOC__main+0 
	MOVF        R1, 0 
	MOVWF       FLOC__main+1 
	MOVLW       2
	MOVWF       FARG_VALOR_ADC_CH+0 
	CALL        _VALOR_ADC+0, 0
	MOVFF       FLOC__main+0, FSR1
	MOVFF       FLOC__main+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
	MOVF        R1, 0 
	MOVWF       POSTINC1+0 
	MOVLW       0
	MOVWF       POSTINC1+0 
	MOVWF       POSTINC1+0 
;Nixie.c,2171 :: 		MEDIA_HIGH_VOLT += MM_HIGH_VOLT[INDICE_MM];
	MOVF        _INDICE_MM+0, 0 
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	MOVLW       _MM_HIGH_VOLT+0
	ADDWF       R0, 0 
	MOVWF       FSR2 
	MOVLW       hi_addr(_MM_HIGH_VOLT+0)
	ADDWFC      R1, 0 
	MOVWF       FSR2H 
	MOVF        POSTINC2+0, 0 
	ADDWF       _MEDIA_HIGH_VOLT+0, 1 
	MOVF        POSTINC2+0, 0 
	ADDWFC      _MEDIA_HIGH_VOLT+1, 1 
	MOVF        POSTINC2+0, 0 
	ADDWFC      _MEDIA_HIGH_VOLT+2, 1 
	MOVF        POSTINC2+0, 0 
	ADDWFC      _MEDIA_HIGH_VOLT+3, 1 
;Nixie.c,2173 :: 		Temp_Celsius = (((MEDIA_TEMP / MEDIA_MOVEL_TEMP)* 4945)/1023) + Ajust_Temp;      // Converte ADC para TEMP
	MOVLW       44
	MOVWF       R4 
	MOVLW       1
	MOVWF       R5 
	MOVLW       0
	MOVWF       R6 
	MOVWF       R7 
	MOVF        _MEDIA_TEMP+0, 0 
	MOVWF       R0 
	MOVF        _MEDIA_TEMP+1, 0 
	MOVWF       R1 
	MOVF        _MEDIA_TEMP+2, 0 
	MOVWF       R2 
	MOVF        _MEDIA_TEMP+3, 0 
	MOVWF       R3 
	CALL        _Div_32x32_U+0, 0
	MOVLW       81
	MOVWF       R4 
	MOVLW       19
	MOVWF       R5 
	MOVLW       0
	MOVWF       R6 
	MOVWF       R7 
	CALL        _Mul_32x32_U+0, 0
	MOVLW       255
	MOVWF       R4 
	MOVLW       3
	MOVWF       R5 
	MOVLW       0
	MOVWF       R6 
	MOVWF       R7 
	CALL        _Div_32x32_U+0, 0
	MOVF        _Ajust_Temp+0, 0 
	ADDWF       R0, 0 
	MOVWF       R4 
	MOVLW       0
	BTFSC       _Ajust_Temp+0, 7 
	MOVLW       255
	ADDWFC      R1, 0 
	MOVWF       R5 
	MOVF        R4, 0 
	MOVWF       _Temp_Celsius+0 
	MOVF        R5, 0 
	MOVWF       _Temp_Celsius+1 
;Nixie.c,2175 :: 		if (Temp_Celsius > 65000) Temp_Celsius = 0;
	MOVF        R5, 0 
	SUBLW       253
	BTFSS       STATUS+0, 2 
	GOTO        L__main1362
	MOVF        R4, 0 
	SUBLW       232
L__main1362:
	BTFSC       STATUS+0, 0 
	GOTO        L_main927
	CLRF        _Temp_Celsius+0 
	CLRF        _Temp_Celsius+1 
L_main927:
;Nixie.c,2177 :: 		Light_Sensor = (((MEDIA_LDR / MEDIA_MOVEL)* 92)/1023) + 4;      // Converte ADC para LDR
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVWF       R6 
	MOVWF       R7 
	MOVF        _MEDIA_LDR+0, 0 
	MOVWF       R0 
	MOVF        _MEDIA_LDR+1, 0 
	MOVWF       R1 
	MOVF        _MEDIA_LDR+2, 0 
	MOVWF       R2 
	MOVF        _MEDIA_LDR+3, 0 
	MOVWF       R3 
	CALL        _Div_32x32_U+0, 0
	MOVLW       92
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVWF       R6 
	MOVWF       R7 
	CALL        _Mul_32x32_U+0, 0
	MOVLW       255
	MOVWF       R4 
	MOVLW       3
	MOVWF       R5 
	MOVLW       0
	MOVWF       R6 
	MOVWF       R7 
	CALL        _Div_32x32_U+0, 0
	MOVLW       4
	ADDWF       R0, 0 
	MOVWF       _Light_Sensor+0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       _Light_Sensor+1 
;Nixie.c,2179 :: 		High_Voltage = ((MEDIA_HIGH_VOLT / MEDIA_MOVEL)* 2980)/1023;    // Converte ADC para HIGH_VOLT
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVWF       R6 
	MOVWF       R7 
	MOVF        _MEDIA_HIGH_VOLT+0, 0 
	MOVWF       R0 
	MOVF        _MEDIA_HIGH_VOLT+1, 0 
	MOVWF       R1 
	MOVF        _MEDIA_HIGH_VOLT+2, 0 
	MOVWF       R2 
	MOVF        _MEDIA_HIGH_VOLT+3, 0 
	MOVWF       R3 
	CALL        _Div_32x32_U+0, 0
	MOVLW       164
	MOVWF       R4 
	MOVLW       11
	MOVWF       R5 
	MOVLW       0
	MOVWF       R6 
	MOVWF       R7 
	CALL        _Mul_32x32_U+0, 0
	MOVLW       255
	MOVWF       R4 
	MOVLW       3
	MOVWF       R5 
	MOVLW       0
	MOVWF       R6 
	MOVWF       R7 
	CALL        _Div_32x32_U+0, 0
	MOVF        R0, 0 
	MOVWF       _High_Voltage+0 
	MOVF        R1, 0 
	MOVWF       _High_Voltage+1 
;Nixie.c,2181 :: 		if (LDR_Auto) {
	BTFSS       _LDR_Auto+0, BitPos(_LDR_Auto+0) 
	GOTO        L_main928
;Nixie.c,2182 :: 		ACESO = Light_Sensor;
	MOVF        _Light_Sensor+0, 0 
	MOVWF       _ACESO+0 
;Nixie.c,2183 :: 		APAGADO = 100-ACESO;
	MOVF        _Light_Sensor+0, 0 
	SUBLW       100
	MOVWF       _APAGADO+0 
;Nixie.c,2184 :: 		}
L_main928:
;Nixie.c,2186 :: 		INDICE_MM++;
	INCF        _INDICE_MM+0, 1 
;Nixie.c,2187 :: 		INDICE_MM_TEMP++;
	INFSNZ      _INDICE_MM_TEMP+0, 1 
	INCF        _INDICE_MM_TEMP+1, 1 
;Nixie.c,2189 :: 		if (INDICE_MM_TEMP == MEDIA_MOVEL_TEMP) INDICE_MM_TEMP = 0;
	MOVF        _INDICE_MM_TEMP+1, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L__main1363
	MOVLW       44
	XORWF       _INDICE_MM_TEMP+0, 0 
L__main1363:
	BTFSS       STATUS+0, 2 
	GOTO        L_main929
	CLRF        _INDICE_MM_TEMP+0 
	CLRF        _INDICE_MM_TEMP+1 
L_main929:
;Nixie.c,2190 :: 		if (INDICE_MM == MEDIA_MOVEL) INDICE_MM = 0;
	MOVF        _INDICE_MM+0, 0 
	XORLW       10
	BTFSS       STATUS+0, 2 
	GOTO        L_main930
	CLRF        _INDICE_MM+0 
L_main930:
;Nixie.c,2192 :: 		refresh_RTC = 0;
	BCF         _refresh_RTC+0, BitPos(_refresh_RTC+0) 
;Nixie.c,2194 :: 		toggle_Point = !toggle_Point;
	BTG         _toggle_Point+0, BitPos(_toggle_Point+0) 
;Nixie.c,2196 :: 		if (MENU == 1 && BackLight == 3) {
	MOVLW       0
	XORWF       _MENU+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main1364
	MOVLW       1
	XORWF       _MENU+0, 0 
L__main1364:
	BTFSS       STATUS+0, 2 
	GOTO        L_main933
	MOVF        _BackLight+0, 0 
	XORLW       3
	BTFSS       STATUS+0, 2 
	GOTO        L_main933
L__main1011:
;Nixie.c,2198 :: 		if (ShowMode == 1 && CountShowMode <= 14) {
	MOVF        _ShowMode+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_main936
	MOVF        _CountShowMode+0, 0 
	SUBLW       14
	BTFSS       STATUS+0, 0 
	GOTO        L_main936
L__main1010:
;Nixie.c,2199 :: 		GIE_bit = 0;
	BCF         GIE_bit+0, BitPos(GIE_bit+0) 
;Nixie.c,2201 :: 		ws2812_send(&Led_Week[Data.year & 0x0F]);
	MOVLW       15
	ANDWF       _Data+8, 0 
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVLW       3
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _Led_Week+0
	ADDWF       R0, 0 
	MOVWF       FARG_ws2812_send_led+0 
	MOVLW       hi_addr(_Led_Week+0)
	ADDWFC      R1, 0 
	MOVWF       FARG_ws2812_send_led+1 
	CALL        _ws2812_send+0, 0
;Nixie.c,2202 :: 		ws2812_send(&Led_Week[Data.year & 0x0F]);
	MOVLW       15
	ANDWF       _Data+8, 0 
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVLW       3
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _Led_Week+0
	ADDWF       R0, 0 
	MOVWF       FARG_ws2812_send_led+0 
	MOVLW       hi_addr(_Led_Week+0)
	ADDWFC      R1, 0 
	MOVWF       FARG_ws2812_send_led+1 
	CALL        _ws2812_send+0, 0
;Nixie.c,2203 :: 		ws2812_send(&Led_Week[Data.month & 0x0F]);
	MOVLW       15
	ANDWF       _Data+7, 0 
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVLW       3
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _Led_Week+0
	ADDWF       R0, 0 
	MOVWF       FARG_ws2812_send_led+0 
	MOVLW       hi_addr(_Led_Week+0)
	ADDWFC      R1, 0 
	MOVWF       FARG_ws2812_send_led+1 
	CALL        _ws2812_send+0, 0
;Nixie.c,2204 :: 		ws2812_send(&Led_Week[Data.month & 0x0F]);
	MOVLW       15
	ANDWF       _Data+7, 0 
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVLW       3
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _Led_Week+0
	ADDWF       R0, 0 
	MOVWF       FARG_ws2812_send_led+0 
	MOVLW       hi_addr(_Led_Week+0)
	ADDWFC      R1, 0 
	MOVWF       FARG_ws2812_send_led+1 
	CALL        _ws2812_send+0, 0
;Nixie.c,2205 :: 		ws2812_send(&Led_Week[Data.day & 0x0F]);
	MOVLW       15
	ANDWF       _Data+5, 0 
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVLW       3
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _Led_Week+0
	ADDWF       R0, 0 
	MOVWF       FARG_ws2812_send_led+0 
	MOVLW       hi_addr(_Led_Week+0)
	ADDWFC      R1, 0 
	MOVWF       FARG_ws2812_send_led+1 
	CALL        _ws2812_send+0, 0
;Nixie.c,2206 :: 		ws2812_send(&Led_Week[Data.day & 0x0F]);
	MOVLW       15
	ANDWF       _Data+5, 0 
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVLW       3
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _Led_Week+0
	ADDWF       R0, 0 
	MOVWF       FARG_ws2812_send_led+0 
	MOVLW       hi_addr(_Led_Week+0)
	ADDWFC      R1, 0 
	MOVWF       FARG_ws2812_send_led+1 
	CALL        _ws2812_send+0, 0
;Nixie.c,2208 :: 		GIE_bit = 1;
	BSF         GIE_bit+0, BitPos(GIE_bit+0) 
;Nixie.c,2209 :: 		} else
	GOTO        L_main937
L_main936:
;Nixie.c,2211 :: 		if (ShowMode == 2 && CountShowMode <= 14) {
	MOVF        _ShowMode+0, 0 
	XORLW       2
	BTFSS       STATUS+0, 2 
	GOTO        L_main940
	MOVF        _CountShowMode+0, 0 
	SUBLW       14
	BTFSS       STATUS+0, 0 
	GOTO        L_main940
L__main1009:
;Nixie.c,2213 :: 		if (Temp_Celsius <= 200) { LedTemp.b = (100 - (Temp_Celsius*10/20)); }
	MOVLW       0
	MOVWF       R0 
	MOVF        _Temp_Celsius+1, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main1365
	MOVF        _Temp_Celsius+0, 0 
	SUBLW       200
L__main1365:
	BTFSS       STATUS+0, 0 
	GOTO        L_main941
	MOVF        _Temp_Celsius+0, 0 
	MOVWF       R0 
	MOVF        _Temp_Celsius+1, 0 
	MOVWF       R1 
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       20
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Div_16X16_U+0, 0
	MOVF        R0, 0 
	SUBLW       100
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       _LedTemp+1 
	GOTO        L_main942
L_main941:
;Nixie.c,2214 :: 		else LedTemp.b = 0;
	CLRF        _LedTemp+1 
L_main942:
;Nixie.c,2216 :: 		if (Temp_Celsius >= 200 && Temp_Celsius <= 400) { LedTemp.r = ((Temp_Celsius-200)*10/20); }
	MOVLW       0
	SUBWF       _Temp_Celsius+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main1366
	MOVLW       200
	SUBWF       _Temp_Celsius+0, 0 
L__main1366:
	BTFSS       STATUS+0, 0 
	GOTO        L_main945
	MOVF        _Temp_Celsius+1, 0 
	SUBLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L__main1367
	MOVF        _Temp_Celsius+0, 0 
	SUBLW       144
L__main1367:
	BTFSS       STATUS+0, 0 
	GOTO        L_main945
L__main1008:
	MOVLW       200
	SUBWF       _Temp_Celsius+0, 0 
	MOVWF       R0 
	MOVLW       0
	SUBWFB      _Temp_Celsius+1, 0 
	MOVWF       R1 
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       20
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Div_16X16_U+0, 0
	MOVF        R0, 0 
	MOVWF       _LedTemp+0 
	GOTO        L_main946
L_main945:
;Nixie.c,2217 :: 		else if (Temp_Celsius > 400) { LedTemp.r = 100; }
	MOVF        _Temp_Celsius+1, 0 
	SUBLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L__main1368
	MOVF        _Temp_Celsius+0, 0 
	SUBLW       144
L__main1368:
	BTFSC       STATUS+0, 0 
	GOTO        L_main947
	MOVLW       100
	MOVWF       _LedTemp+0 
	GOTO        L_main948
L_main947:
;Nixie.c,2218 :: 		else if (Temp_Celsius < 200) { LedTemp.r = 0; }
	MOVLW       0
	SUBWF       _Temp_Celsius+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main1369
	MOVLW       200
	SUBWF       _Temp_Celsius+0, 0 
L__main1369:
	BTFSC       STATUS+0, 0 
	GOTO        L_main949
	CLRF        _LedTemp+0 
L_main949:
L_main948:
L_main946:
;Nixie.c,2220 :: 		if (Temp_Celsius <= 200) { LedTemp.g = (Temp_Celsius*10/20); }
	MOVLW       0
	MOVWF       R0 
	MOVF        _Temp_Celsius+1, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main1370
	MOVF        _Temp_Celsius+0, 0 
	SUBLW       200
L__main1370:
	BTFSS       STATUS+0, 0 
	GOTO        L_main950
	MOVF        _Temp_Celsius+0, 0 
	MOVWF       R0 
	MOVF        _Temp_Celsius+1, 0 
	MOVWF       R1 
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       20
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Div_16X16_U+0, 0
	MOVF        R0, 0 
	MOVWF       _LedTemp+2 
	GOTO        L_main951
L_main950:
;Nixie.c,2221 :: 		else if (Temp_Celsius > 200 && Temp_Celsius <= 400) { LedTemp.g = (100 - ((Temp_Celsius-200)*10/20)); }
	MOVLW       0
	MOVWF       R0 
	MOVF        _Temp_Celsius+1, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main1371
	MOVF        _Temp_Celsius+0, 0 
	SUBLW       200
L__main1371:
	BTFSC       STATUS+0, 0 
	GOTO        L_main954
	MOVF        _Temp_Celsius+1, 0 
	SUBLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L__main1372
	MOVF        _Temp_Celsius+0, 0 
	SUBLW       144
L__main1372:
	BTFSS       STATUS+0, 0 
	GOTO        L_main954
L__main1007:
	MOVLW       200
	SUBWF       _Temp_Celsius+0, 0 
	MOVWF       R0 
	MOVLW       0
	SUBWFB      _Temp_Celsius+1, 0 
	MOVWF       R1 
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       20
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Div_16X16_U+0, 0
	MOVF        R0, 0 
	SUBLW       100
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       _LedTemp+2 
	GOTO        L_main955
L_main954:
;Nixie.c,2222 :: 		else LedTemp.g = 0;
	CLRF        _LedTemp+2 
L_main955:
L_main951:
;Nixie.c,2224 :: 		GIE_bit = 0;
	BCF         GIE_bit+0, BitPos(GIE_bit+0) 
;Nixie.c,2226 :: 		ws2812_send(&LedOFF);
	MOVLW       _LedOFF+0
	MOVWF       FARG_ws2812_send_led+0 
	MOVLW       hi_addr(_LedOFF+0)
	MOVWF       FARG_ws2812_send_led+1 
	CALL        _ws2812_send+0, 0
;Nixie.c,2227 :: 		ws2812_send(&LedOFF);
	MOVLW       _LedOFF+0
	MOVWF       FARG_ws2812_send_led+0 
	MOVLW       hi_addr(_LedOFF+0)
	MOVWF       FARG_ws2812_send_led+1 
	CALL        _ws2812_send+0, 0
;Nixie.c,2228 :: 		ws2812_send(&LedTemp);
	MOVLW       _LedTemp+0
	MOVWF       FARG_ws2812_send_led+0 
	MOVLW       hi_addr(_LedTemp+0)
	MOVWF       FARG_ws2812_send_led+1 
	CALL        _ws2812_send+0, 0
;Nixie.c,2229 :: 		ws2812_send(&LedTemp);
	MOVLW       _LedTemp+0
	MOVWF       FARG_ws2812_send_led+0 
	MOVLW       hi_addr(_LedTemp+0)
	MOVWF       FARG_ws2812_send_led+1 
	CALL        _ws2812_send+0, 0
;Nixie.c,2230 :: 		ws2812_send(&LedOFF);
	MOVLW       _LedOFF+0
	MOVWF       FARG_ws2812_send_led+0 
	MOVLW       hi_addr(_LedOFF+0)
	MOVWF       FARG_ws2812_send_led+1 
	CALL        _ws2812_send+0, 0
;Nixie.c,2231 :: 		ws2812_send(&LedOFF);
	MOVLW       _LedOFF+0
	MOVWF       FARG_ws2812_send_led+0 
	MOVLW       hi_addr(_LedOFF+0)
	MOVWF       FARG_ws2812_send_led+1 
	CALL        _ws2812_send+0, 0
;Nixie.c,2233 :: 		GIE_bit = 1;
	BSF         GIE_bit+0, BitPos(GIE_bit+0) 
;Nixie.c,2234 :: 		} else {
	GOTO        L_main956
L_main940:
;Nixie.c,2235 :: 		GIE_bit = 0;
	BCF         GIE_bit+0, BitPos(GIE_bit+0) 
;Nixie.c,2237 :: 		ws2812_send(&Led_Week[Data.second & 0x0F]);
	MOVLW       15
	ANDWF       _Data+0, 0 
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVLW       3
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _Led_Week+0
	ADDWF       R0, 0 
	MOVWF       FARG_ws2812_send_led+0 
	MOVLW       hi_addr(_Led_Week+0)
	ADDWFC      R1, 0 
	MOVWF       FARG_ws2812_send_led+1 
	CALL        _ws2812_send+0, 0
;Nixie.c,2238 :: 		ws2812_send(&Led_Week[(Data.second & 0xF0) >> 4]);
	MOVLW       240
	ANDWF       _Data+0, 0 
	MOVWF       R2 
	MOVF        R2, 0 
	MOVWF       R0 
	RRCF        R0, 1 
	BCF         R0, 7 
	RRCF        R0, 1 
	BCF         R0, 7 
	RRCF        R0, 1 
	BCF         R0, 7 
	RRCF        R0, 1 
	BCF         R0, 7 
	MOVLW       0
	MOVWF       R1 
	MOVLW       3
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _Led_Week+0
	ADDWF       R0, 0 
	MOVWF       FARG_ws2812_send_led+0 
	MOVLW       hi_addr(_Led_Week+0)
	ADDWFC      R1, 0 
	MOVWF       FARG_ws2812_send_led+1 
	CALL        _ws2812_send+0, 0
;Nixie.c,2239 :: 		ws2812_send(&Led_Week[Data.minute & 0x0F]);
	MOVLW       15
	ANDWF       _Data+1, 0 
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVLW       3
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _Led_Week+0
	ADDWF       R0, 0 
	MOVWF       FARG_ws2812_send_led+0 
	MOVLW       hi_addr(_Led_Week+0)
	ADDWFC      R1, 0 
	MOVWF       FARG_ws2812_send_led+1 
	CALL        _ws2812_send+0, 0
;Nixie.c,2240 :: 		ws2812_send(&Led_Week[(Data.minute & 0xF0) >> 4]);
	MOVLW       240
	ANDWF       _Data+1, 0 
	MOVWF       R2 
	MOVF        R2, 0 
	MOVWF       R0 
	RRCF        R0, 1 
	BCF         R0, 7 
	RRCF        R0, 1 
	BCF         R0, 7 
	RRCF        R0, 1 
	BCF         R0, 7 
	RRCF        R0, 1 
	BCF         R0, 7 
	MOVLW       0
	MOVWF       R1 
	MOVLW       3
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _Led_Week+0
	ADDWF       R0, 0 
	MOVWF       FARG_ws2812_send_led+0 
	MOVLW       hi_addr(_Led_Week+0)
	ADDWFC      R1, 0 
	MOVWF       FARG_ws2812_send_led+1 
	CALL        _ws2812_send+0, 0
;Nixie.c,2241 :: 		ws2812_send(&Led_Week[Data.hour & 0x0F]);
	MOVLW       15
	ANDWF       _Data+2, 0 
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVLW       3
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _Led_Week+0
	ADDWF       R0, 0 
	MOVWF       FARG_ws2812_send_led+0 
	MOVLW       hi_addr(_Led_Week+0)
	ADDWFC      R1, 0 
	MOVWF       FARG_ws2812_send_led+1 
	CALL        _ws2812_send+0, 0
;Nixie.c,2242 :: 		ws2812_send(&Led_Week[(Data.hour & 0xF0) >> 4]);
	MOVLW       240
	ANDWF       _Data+2, 0 
	MOVWF       R2 
	MOVF        R2, 0 
	MOVWF       R0 
	RRCF        R0, 1 
	BCF         R0, 7 
	RRCF        R0, 1 
	BCF         R0, 7 
	RRCF        R0, 1 
	BCF         R0, 7 
	RRCF        R0, 1 
	BCF         R0, 7 
	MOVLW       0
	MOVWF       R1 
	MOVLW       3
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _Led_Week+0
	ADDWF       R0, 0 
	MOVWF       FARG_ws2812_send_led+0 
	MOVLW       hi_addr(_Led_Week+0)
	ADDWFC      R1, 0 
	MOVWF       FARG_ws2812_send_led+1 
	CALL        _ws2812_send+0, 0
;Nixie.c,2244 :: 		GIE_bit = 1;
	BSF         GIE_bit+0, BitPos(GIE_bit+0) 
;Nixie.c,2245 :: 		}
L_main956:
L_main937:
;Nixie.c,2246 :: 		} else
	GOTO        L_main957
L_main933:
;Nixie.c,2248 :: 		if (BackLight == 3) BackLightRGB(&LedOFF);
	MOVF        _BackLight+0, 0 
	XORLW       3
	BTFSS       STATUS+0, 2 
	GOTO        L_main958
	MOVLW       _LedOFF+0
	MOVWF       FARG_BackLightRGB_ledRGB+0 
	MOVLW       hi_addr(_LedOFF+0)
	MOVWF       FARG_BackLightRGB_ledRGB+1 
	CALL        _BackLightRGB+0, 0
L_main958:
L_main957:
;Nixie.c,2251 :: 		}
L_main846:
;Nixie.c,2252 :: 		}
	GOTO        L_main670
;Nixie.c,2254 :: 		}
L_end_main:
	GOTO        $+0
; end of _main

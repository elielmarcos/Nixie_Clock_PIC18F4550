
_Read_RTC:

;ds1307.c,8 :: 		DateTime Read_RTC() {         // Rotina de leitura do DS1307
	MOVF        R0, 0 
	MOVWF       _Read_RTC_su_addr+0 
	MOVF        R1, 0 
	MOVWF       _Read_RTC_su_addr+1 
;ds1307.c,12 :: 		I2C1_Start();              // Inicializa comunicação i2c
	CALL        _I2C1_Start+0, 0
;ds1307.c,13 :: 		I2C1_Wr(0xD0);             // End. fixo para DS1307: 1101000X, onde x = 0 é para gravação
	MOVLW       208
	MOVWF       FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;ds1307.c,14 :: 		I2C1_Wr(0);                // End. onde começa a programação do relógio, end dos segundos.
	CLRF        FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;ds1307.c,15 :: 		I2C1_Repeated_Start();     // Issue I2C signal repeated start
	CALL        _I2C1_Repeated_Start+0, 0
;ds1307.c,16 :: 		I2C1_Wr(0xD1);             // End. fixo para DS1307: 1101000X, onde x=1 é para leitura
	MOVLW       209
	MOVWF       FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;ds1307.c,17 :: 		Data.second = I2C1_Rd(1);  // Lê o primeiro byte(segundos),informa que continua lendo
	MOVLW       1
	MOVWF       FARG_I2C1_Rd_ack+0 
	CALL        _I2C1_Rd+0, 0
	MOVF        R0, 0 
	MOVWF       Read_RTC_Data_L0+0 
;ds1307.c,18 :: 		Data.minute = I2C1_Rd(1);  // Lê o segundo byte(minutos)
	MOVLW       1
	MOVWF       FARG_I2C1_Rd_ack+0 
	CALL        _I2C1_Rd+0, 0
	MOVF        R0, 0 
	MOVWF       Read_RTC_Data_L0+1 
;ds1307.c,19 :: 		Data.hour = I2C1_Rd(1);    // Lê o terceiro byte(horas)
	MOVLW       1
	MOVWF       FARG_I2C1_Rd_ack+0 
	CALL        _I2C1_Rd+0, 0
	MOVF        R0, 0 
	MOVWF       Read_RTC_Data_L0+2 
;ds1307.c,20 :: 		Data.week = I2C1_Rd(1);    // Lê o dia da semana
	MOVLW       1
	MOVWF       FARG_I2C1_Rd_ack+0 
	CALL        _I2C1_Rd+0, 0
	MOVF        R0, 0 
	MOVWF       Read_RTC_Data_L0+6 
;ds1307.c,21 :: 		Data.day = I2C1_Rd(1);     // Lê o dia
	MOVLW       1
	MOVWF       FARG_I2C1_Rd_ack+0 
	CALL        _I2C1_Rd+0, 0
	MOVF        R0, 0 
	MOVWF       Read_RTC_Data_L0+5 
;ds1307.c,22 :: 		Data.month = I2C1_Rd(1);   // Lê o mês
	MOVLW       1
	MOVWF       FARG_I2C1_Rd_ack+0 
	CALL        _I2C1_Rd+0, 0
	MOVF        R0, 0 
	MOVWF       Read_RTC_Data_L0+7 
;ds1307.c,23 :: 		Data.year = I2C1_Rd(0);    // Lê o sétimo byte(ano),encerra as leituras de dados
	CLRF        FARG_I2C1_Rd_ack+0 
	CALL        _I2C1_Rd+0, 0
	MOVF        R0, 0 
	MOVWF       Read_RTC_Data_L0+8 
;ds1307.c,24 :: 		I2C1_Stop();               // Finaliza comunicação I2C
	CALL        _I2C1_Stop+0, 0
;ds1307.c,26 :: 		Data.mode12h = Data.hour.B6;    // Verifica o modo 12h ou 24h
	MOVLW       0
	BTFSC       Read_RTC_Data_L0+2, 6 
	MOVLW       1
	MOVWF       Read_RTC_Data_L0+4 
;ds1307.c,28 :: 		if (Data.mode12h) {             // Se modo 12h
	MOVF        Read_RTC_Data_L0+4, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Read_RTC0
;ds1307.c,29 :: 		Data.PM = Data.hour.B5;               // Verifica se AM ou PM
	MOVLW       0
	BTFSC       Read_RTC_Data_L0+2, 5 
	MOVLW       1
	MOVWF       Read_RTC_Data_L0+3 
;ds1307.c,30 :: 		Data.hour = Data.hour & 0b00011111;   // Ajusta a estrutura hour para formato BCD 12h
	MOVLW       31
	ANDWF       Read_RTC_Data_L0+2, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       Read_RTC_Data_L0+2 
;ds1307.c,31 :: 		} else Data.PM = 0;                      // Se não, PM = 0
	GOTO        L_Read_RTC1
L_Read_RTC0:
	CLRF        Read_RTC_Data_L0+3 
L_Read_RTC1:
;ds1307.c,33 :: 		return Data;
	MOVLW       9
	MOVWF       R0 
	MOVF        _Read_RTC_su_addr+0, 0 
	MOVWF       FSR1 
	MOVF        _Read_RTC_su_addr+1, 0 
	MOVWF       FSR1H 
	MOVLW       Read_RTC_Data_L0+0
	MOVWF       FSR0 
	MOVLW       hi_addr(Read_RTC_Data_L0+0)
	MOVWF       FSR0H 
L_Read_RTC2:
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
	DECF        R0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_Read_RTC2
;ds1307.c,34 :: 		}
L_end_Read_RTC:
	RETURN      0
; end of _Read_RTC

_Write_RTC:

;ds1307.c,41 :: 		void Write_RTC(DateTime Data){
;ds1307.c,42 :: 		I2C1_Init(400000);     // Iniciliza I2C com frequencia de 100KHz
	MOVLW       30
	MOVWF       SSPADD+0 
	CALL        _I2C1_Init+0, 0
;ds1307.c,43 :: 		I2C1_Start();          // Inicializa a comunicação I2c
	CALL        _I2C1_Start+0, 0
;ds1307.c,44 :: 		I2C1_Wr(0xD0);         // End. fixo para DS1307: 1101000X, onde x = 0 é para gravação
	MOVLW       208
	MOVWF       FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;ds1307.c,45 :: 		I2C1_Wr(0);            // End. onde começa a programação do relógio, end. dos segundos.
	CLRF        FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;ds1307.c,46 :: 		I2C1_Wr(Data.second);  // Inicializa com Data segundos
	MOVF        FARG_Write_RTC_Data+0, 0 
	MOVWF       FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;ds1307.c,47 :: 		I2C1_Wr(Data.minute);  // Inicializa com Data minutos
	MOVF        FARG_Write_RTC_Data+1, 0 
	MOVWF       FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;ds1307.c,48 :: 		if (Data.mode12h) {
	MOVF        FARG_Write_RTC_Data+4, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Write_RTC3
;ds1307.c,49 :: 		Data.hour.B6 = Data.mode12h;
	BTFSC       FARG_Write_RTC_Data+4, 0 
	GOTO        L__Write_RTC6
	BCF         FARG_Write_RTC_Data+2, 6 
	GOTO        L__Write_RTC7
L__Write_RTC6:
	BSF         FARG_Write_RTC_Data+2, 6 
L__Write_RTC7:
;ds1307.c,50 :: 		Data.hour.B5 = Data.PM;
	BTFSC       FARG_Write_RTC_Data+3, 0 
	GOTO        L__Write_RTC8
	BCF         FARG_Write_RTC_Data+2, 5 
	GOTO        L__Write_RTC9
L__Write_RTC8:
	BSF         FARG_Write_RTC_Data+2, 5 
L__Write_RTC9:
;ds1307.c,51 :: 		}
L_Write_RTC3:
;ds1307.c,52 :: 		I2C1_Wr(Data.hour);    // Inicializa com Data horas
	MOVF        FARG_Write_RTC_Data+2, 0 
	MOVWF       FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;ds1307.c,53 :: 		I2C1_Wr(Data.week);    // Inicializa com Data week
	MOVF        FARG_Write_RTC_Data+6, 0 
	MOVWF       FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;ds1307.c,54 :: 		I2C1_Wr(Data.day);     // Inicializa com Data dia
	MOVF        FARG_Write_RTC_Data+5, 0 
	MOVWF       FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;ds1307.c,55 :: 		I2C1_Wr(Data.month);   // Inicializa com Data mês
	MOVF        FARG_Write_RTC_Data+7, 0 
	MOVWF       FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;ds1307.c,56 :: 		I2C1_Wr(Data.year);    // Inicializa com Data ano
	MOVF        FARG_Write_RTC_Data+8, 0 
	MOVWF       FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;ds1307.c,57 :: 		I2C1_Wr(0x10);         // Inicializa control SQW 1Hz
	MOVLW       16
	MOVWF       FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;ds1307.c,58 :: 		I2C1_Stop();           // Finaliza comunicação I2C
	CALL        _I2C1_Stop+0, 0
;ds1307.c,59 :: 		}
L_end_Write_RTC:
	RETURN      0
; end of _Write_RTC

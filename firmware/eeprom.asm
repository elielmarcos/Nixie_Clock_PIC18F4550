
_ler_eeprom:

;eeprom.c,17 :: 		unsigned char ler_eeprom(unsigned char address) {
;eeprom.c,19 :: 		unsigned char DADO_EEPROM=0;
	CLRF        ler_eeprom_DADO_EEPROM_L0+0 
;eeprom.c,21 :: 		EEADR      = address;         // Seleciona o Endereço da Memória
	MOVF        FARG_ler_eeprom_address+0, 0 
	MOVWF       EEADR+0 
;eeprom.c,22 :: 		EEPGD_bit  = 0;               // Configura o Acesso a EEPROM
	BCF         EEPGD_bit+0, BitPos(EEPGD_bit+0) 
;eeprom.c,23 :: 		CFGS_bit   = 0;               // Configura o Acesso a EEPROM
	BCF         CFGS_bit+0, BitPos(CFGS_bit+0) 
;eeprom.c,24 :: 		FREE_bit   = 0;               // Desabilita a Limpeza da Memória
	BCF         FREE_bit+0, BitPos(FREE_bit+0) 
;eeprom.c,25 :: 		RD_bit     = 1;               // Inicia Leitura
	BSF         RD_bit+0, BitPos(RD_bit+0) 
;eeprom.c,26 :: 		DADO_EEPROM = EEDATA;         // Captura o Dado da Memória
	MOVF        EEDATA+0, 0 
	MOVWF       ler_eeprom_DADO_EEPROM_L0+0 
;eeprom.c,28 :: 		return DADO_EEPROM;           // Retorna resultado
	MOVF        ler_eeprom_DADO_EEPROM_L0+0, 0 
	MOVWF       R0 
;eeprom.c,30 :: 		}
L_end_ler_eeprom:
	RETURN      0
; end of _ler_eeprom

_escrever_eeprom:

;eeprom.c,35 :: 		void escrever_eeprom(unsigned char address, unsigned char DADO_EEPROM) {
;eeprom.c,37 :: 		EEADR      = address;             // Seleciona o Endereço da Memória
	MOVF        FARG_escrever_eeprom_address+0, 0 
	MOVWF       EEADR+0 
;eeprom.c,38 :: 		EEDATA     = DADO_EEPROM;         // Dado a ser Gravado na Memória
	MOVF        FARG_escrever_eeprom_DADO_EEPROM+0, 0 
	MOVWF       EEDATA+0 
;eeprom.c,39 :: 		EEPGD_bit  = 0;                   // Configura o Acesso a EEPROM
	BCF         EEPGD_bit+0, BitPos(EEPGD_bit+0) 
;eeprom.c,40 :: 		CFGS_bit   = 0;                   // Configura o Acesso a EEPROM
	BCF         CFGS_bit+0, BitPos(CFGS_bit+0) 
;eeprom.c,41 :: 		FREE_bit   = 0;                   // Desabilita a Limpeza da Memória
	BCF         FREE_bit+0, BitPos(FREE_bit+0) 
;eeprom.c,42 :: 		WREN_bit   = 1;                   // Habilita Gravação
	BSF         WREN_bit+0, BitPos(WREN_bit+0) 
;eeprom.c,43 :: 		GIE_bit    = 0;                   // Desabilita Interrupção Geral Para Gravação da Memória (Necessário para não gerar erro na gravação)
	BCF         GIE_bit+0, BitPos(GIE_bit+0) 
;eeprom.c,44 :: 		PEIE_bit   = 0;                   // Desabilita Interrupção Periféricos Para Gravação da Memória (Necessário para não gerar erro na gravação)
	BCF         PEIE_bit+0, BitPos(PEIE_bit+0) 
;eeprom.c,45 :: 		EECON2     = 0x55;                // Necessario Para Gravação
	MOVLW       85
	MOVWF       EECON2+0 
;eeprom.c,46 :: 		EECON2     = 0xAA;                // Necessario Para Gravação
	MOVLW       170
	MOVWF       EECON2+0 
;eeprom.c,47 :: 		WR_bit     = 1;                   // Inicia Gravação
	BSF         WR_bit+0, BitPos(WR_bit+0) 
;eeprom.c,48 :: 		while(WR_bit);                    // Aguarda Término da Gravação
L_escrever_eeprom0:
	BTFSS       WR_bit+0, BitPos(WR_bit+0) 
	GOTO        L_escrever_eeprom1
	GOTO        L_escrever_eeprom0
L_escrever_eeprom1:
;eeprom.c,49 :: 		GIE_bit    = 1;                   // Habilita Interrupção Geral
	BSF         GIE_bit+0, BitPos(GIE_bit+0) 
;eeprom.c,50 :: 		PEIE_bit   = 1;                   // Habilita Interrupção Periféricos
	BSF         PEIE_bit+0, BitPos(PEIE_bit+0) 
;eeprom.c,51 :: 		WREN_bit   = 0;                   // Desabilita Gravação
	BCF         WREN_bit+0, BitPos(WREN_bit+0) 
;eeprom.c,53 :: 		return;
;eeprom.c,55 :: 		}
L_end_escrever_eeprom:
	RETURN      0
; end of _escrever_eeprom

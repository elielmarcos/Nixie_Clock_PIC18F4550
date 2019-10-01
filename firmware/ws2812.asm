
_ws2812_send:

;ws2812.c,32 :: 		void ws2812_send(ws2812Led* led) {
;ws2812.c,48 :: 		val = (bitflipTable256(led->b) << 16) + (bitflipTable256(led->r) << 8) + (bitflipTable256(led->g));
	MOVLW       1
	ADDWF       FARG_ws2812_send_led+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_ws2812_send_led+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_bitflipTable256_b+0 
	CALL        _bitflipTable256+0, 0
	MOVF        R1, 0 
	MOVWF       FLOC__ws2812_send+3 
	MOVF        R0, 0 
	MOVWF       FLOC__ws2812_send+2 
	CLRF        FLOC__ws2812_send+0 
	CLRF        FLOC__ws2812_send+1 
	MOVFF       FARG_ws2812_send_led+0, FSR0
	MOVFF       FARG_ws2812_send_led+1, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_bitflipTable256_b+0 
	CALL        _bitflipTable256+0, 0
	MOVF        R2, 0 
	MOVWF       R7 
	MOVF        R1, 0 
	MOVWF       R6 
	MOVF        R0, 0 
	MOVWF       R5 
	CLRF        R4 
	MOVF        R4, 0 
	ADDWF       FLOC__ws2812_send+0, 1 
	MOVF        R5, 0 
	ADDWFC      FLOC__ws2812_send+1, 1 
	MOVF        R6, 0 
	ADDWFC      FLOC__ws2812_send+2, 1 
	MOVF        R7, 0 
	ADDWFC      FLOC__ws2812_send+3, 1 
	MOVLW       2
	ADDWF       FARG_ws2812_send_led+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_ws2812_send_led+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_bitflipTable256_b+0 
	CALL        _bitflipTable256+0, 0
	MOVF        R0, 0 
	ADDWF       FLOC__ws2812_send+0, 0 
	MOVWF       ws2812_send_val_L0+0 
	MOVF        R1, 0 
	ADDWFC      FLOC__ws2812_send+1, 0 
	MOVWF       ws2812_send_val_L0+1 
	MOVF        R2, 0 
	ADDWFC      FLOC__ws2812_send+2, 0 
	MOVWF       ws2812_send_val_L0+2 
	MOVF        R3, 0 
	ADDWFC      FLOC__ws2812_send+3, 0 
	MOVWF       ws2812_send_val_L0+3 
;ws2812.c,51 :: 		for(j = 0; j < 24; j++) {
	CLRF        ws2812_send_j_L0+0 
	CLRF        ws2812_send_j_L0+1 
L_ws2812_send0:
	MOVLW       128
	XORWF       ws2812_send_j_L0+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__ws2812_send6
	MOVLW       24
	SUBWF       ws2812_send_j_L0+0, 0 
L__ws2812_send6:
	BTFSC       STATUS+0, 0 
	GOTO        L_ws2812_send1
;ws2812.c,55 :: 		if (val & 1 == 1) {
	BTFSS       ws2812_send_val_L0+0, 0 
	GOTO        L_ws2812_send3
;ws2812.c,57 :: 		DIN_WS2812 = 1;
	BSF         LATC1_bit+0, BitPos(LATC1_bit+0) 
;ws2812.c,58 :: 		NOP();
	NOP
;ws2812.c,59 :: 		NOP();
	NOP
;ws2812.c,60 :: 		NOP();
	NOP
;ws2812.c,61 :: 		NOP();
	NOP
;ws2812.c,62 :: 		NOP();
	NOP
;ws2812.c,63 :: 		NOP();
	NOP
;ws2812.c,64 :: 		NOP();
	NOP
;ws2812.c,65 :: 		DIN_WS2812 = 0;
	BCF         LATC1_bit+0, BitPos(LATC1_bit+0) 
;ws2812.c,66 :: 		} else {
	GOTO        L_ws2812_send4
L_ws2812_send3:
;ws2812.c,68 :: 		DIN_WS2812 = 1;
	BSF         LATC1_bit+0, BitPos(LATC1_bit+0) 
;ws2812.c,69 :: 		NOP();
	NOP
;ws2812.c,70 :: 		NOP();
	NOP
;ws2812.c,71 :: 		NOP();
	NOP
;ws2812.c,72 :: 		DIN_WS2812 = 0;
	BCF         LATC1_bit+0, BitPos(LATC1_bit+0) 
;ws2812.c,73 :: 		}
L_ws2812_send4:
;ws2812.c,76 :: 		val = val >> (unsigned char)1;
	RRCF        ws2812_send_val_L0+3, 1 
	RRCF        ws2812_send_val_L0+2, 1 
	RRCF        ws2812_send_val_L0+1, 1 
	RRCF        ws2812_send_val_L0+0, 1 
	BCF         ws2812_send_val_L0+3, 7 
	BTFSC       ws2812_send_val_L0+3, 6 
	BSF         ws2812_send_val_L0+3, 7 
;ws2812.c,51 :: 		for(j = 0; j < 24; j++) {
	INFSNZ      ws2812_send_j_L0+0, 1 
	INCF        ws2812_send_j_L0+1, 1 
;ws2812.c,77 :: 		}
	GOTO        L_ws2812_send0
L_ws2812_send1:
;ws2812.c,78 :: 		}
L_end_ws2812_send:
	RETURN      0
; end of _ws2812_send

_bitflip:

;ws2812.c,81 :: 		unsigned long int bitflip(unsigned char b) {
;ws2812.c,82 :: 		b = (b & 0xF0) >> 4 | (b & 0x0F) << 4;
	MOVLW       240
	ANDWF       FARG_bitflip_b+0, 0 
	MOVWF       R1 
	MOVF        R1, 0 
	MOVWF       R4 
	RRCF        R4, 1 
	BCF         R4, 7 
	RRCF        R4, 1 
	BCF         R4, 7 
	RRCF        R4, 1 
	BCF         R4, 7 
	RRCF        R4, 1 
	BCF         R4, 7 
	MOVLW       15
	ANDWF       FARG_bitflip_b+0, 0 
	MOVWF       R3 
	MOVLW       4
	MOVWF       R2 
	MOVF        R3, 0 
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        R2, 0 
L__bitflip8:
	BZ          L__bitflip9
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	ADDLW       255
	GOTO        L__bitflip8
L__bitflip9:
	MOVF        R0, 0 
	IORWF       R4, 0 
	MOVWF       R2 
	MOVF        R2, 0 
	MOVWF       FARG_bitflip_b+0 
;ws2812.c,83 :: 		b = (b & 0xCC) >> 2 | (b & 0x33) << 2;
	MOVLW       204
	ANDWF       R2, 0 
	MOVWF       R1 
	MOVF        R1, 0 
	MOVWF       R4 
	RRCF        R4, 1 
	BCF         R4, 7 
	RRCF        R4, 1 
	BCF         R4, 7 
	MOVLW       51
	ANDWF       R2, 0 
	MOVWF       R3 
	MOVF        R3, 0 
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	MOVF        R0, 0 
	IORWF       R4, 0 
	MOVWF       R2 
	MOVF        R2, 0 
	MOVWF       FARG_bitflip_b+0 
;ws2812.c,84 :: 		b = (b & 0xAA) >> 1 | (b & 0x55) << 1;
	MOVLW       170
	ANDWF       R2, 0 
	MOVWF       R1 
	MOVF        R1, 0 
	MOVWF       R4 
	RRCF        R4, 1 
	BCF         R4, 7 
	MOVLW       85
	ANDWF       R2, 0 
	MOVWF       R3 
	MOVF        R3, 0 
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	MOVF        R4, 0 
	IORWF       R0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       FARG_bitflip_b+0 
;ws2812.c,85 :: 		return (unsigned long int)b;
	MOVLW       0
	MOVWF       R1 
	MOVWF       R2 
	MOVWF       R3 
;ws2812.c,86 :: 		}
L_end_bitflip:
	RETURN      0
; end of _bitflip

_bitflipTable256:

;ws2812.c,90 :: 		unsigned long int bitflipTable256(unsigned char b) {
;ws2812.c,92 :: 		return (unsigned long int)BitReverseTable256[b];
	MOVLW       ws2812_BitReverseTable256+0
	ADDWF       FARG_bitflipTable256_b+0, 0 
	MOVWF       TBLPTRL 
	MOVLW       hi_addr(ws2812_BitReverseTable256+0)
	MOVWF       TBLPTRH 
	MOVLW       0
	ADDWFC      TBLPTRH, 1 
	MOVLW       higher_addr(ws2812_BitReverseTable256+0)
	MOVWF       TBLPTRU 
	MOVLW       0
	ADDWFC      TBLPTRU, 1 
	TBLRD*+
	MOVFF       TABLAT+0, R0
	MOVLW       0
	MOVWF       R1 
	MOVWF       R2 
	MOVWF       R3 
;ws2812.c,94 :: 		}
L_end_bitflipTable256:
	RETURN      0
; end of _bitflipTable256

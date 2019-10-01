#line 1 "C:/NIXIE/soft/Nixie/eeprom.c"
#line 1 "c:/nixie/soft/nixie/eeprom.h"
#line 11 "c:/nixie/soft/nixie/eeprom.h"
unsigned char ler_eeprom(unsigned char address);

void escrever_eeprom(unsigned char address, unsigned char DADO_EEPROM);
#line 17 "C:/NIXIE/soft/Nixie/eeprom.c"
unsigned char ler_eeprom(unsigned char address) {

 unsigned char DADO_EEPROM=0;

 EEADR = address;
 EEPGD_bit = 0;
 CFGS_bit = 0;
 FREE_bit = 0;
 RD_bit = 1;
 DADO_EEPROM = EEDATA;

 return DADO_EEPROM;

}




void escrever_eeprom(unsigned char address, unsigned char DADO_EEPROM) {

 EEADR = address;
 EEDATA = DADO_EEPROM;
 EEPGD_bit = 0;
 CFGS_bit = 0;
 FREE_bit = 0;
 WREN_bit = 1;
 GIE_bit = 0;
 PEIE_bit = 0;
 EECON2 = 0x55;
 EECON2 = 0xAA;
 WR_bit = 1;
 while(WR_bit);
 GIE_bit = 1;
 PEIE_bit = 1;
 WREN_bit = 0;

 return;

}

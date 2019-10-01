/* 
 * File:   eeprom.h
 * Author: Eliel Marcos
 *
 * Created on 2 de Novembro de 2018, 13:01
 */

#ifndef EEPROM_H
#define        EEPROM_H

unsigned char ler_eeprom(unsigned char address);

void escrever_eeprom(unsigned char address, unsigned char DADO_EEPROM);

#endif        /* EEPROM_H */
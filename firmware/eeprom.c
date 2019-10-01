/* 
 * File:   eeprom.c
 * Author: Eliel Marcos
 *
 * Created on 2 de Novembro de 2018, 12:02
 * 
 * Rotinas para EEPROM
 * 
 * */

#include "eeprom.h"



// ==== L� Dado da EEPROM ====

unsigned char ler_eeprom(unsigned char address) {

     unsigned char DADO_EEPROM=0;

     EEADR      = address;         // Seleciona o Endere�o da Mem�ria
     EEPGD_bit  = 0;               // Configura o Acesso a EEPROM
     CFGS_bit   = 0;               // Configura o Acesso a EEPROM
     FREE_bit   = 0;               // Desabilita a Limpeza da Mem�ria
     RD_bit     = 1;               // Inicia Leitura
     DADO_EEPROM = EEDATA;         // Captura o Dado da Mem�ria

     return DADO_EEPROM;           // Retorna resultado

}


// ==== Escreda Dado na EEPROM ====

void escrever_eeprom(unsigned char address, unsigned char DADO_EEPROM) {

     EEADR      = address;             // Seleciona o Endere�o da Mem�ria
     EEDATA     = DADO_EEPROM;         // Dado a ser Gravado na Mem�ria
     EEPGD_bit  = 0;                   // Configura o Acesso a EEPROM
     CFGS_bit   = 0;                   // Configura o Acesso a EEPROM
     FREE_bit   = 0;                   // Desabilita a Limpeza da Mem�ria
     WREN_bit   = 1;                   // Habilita Grava��o
     GIE_bit    = 0;                   // Desabilita Interrup��o Geral Para Grava��o da Mem�ria (Necess�rio para n�o gerar erro na grava��o)
     PEIE_bit   = 0;                   // Desabilita Interrup��o Perif�ricos Para Grava��o da Mem�ria (Necess�rio para n�o gerar erro na grava��o)
     EECON2     = 0x55;                // Necessario Para Grava��o
     EECON2     = 0xAA;                // Necessario Para Grava��o
     WR_bit     = 1;                   // Inicia Grava��o
     while(WR_bit);                    // Aguarda T�rmino da Grava��o
     GIE_bit    = 1;                   // Habilita Interrup��o Geral
     PEIE_bit   = 1;                   // Habilita Interrup��o Perif�ricos
     WREN_bit   = 0;                   // Desabilita Grava��o

     return;

}
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



// ==== Lê Dado da EEPROM ====

unsigned char ler_eeprom(unsigned char address) {

     unsigned char DADO_EEPROM=0;

     EEADR      = address;         // Seleciona o Endereço da Memória
     EEPGD_bit  = 0;               // Configura o Acesso a EEPROM
     CFGS_bit   = 0;               // Configura o Acesso a EEPROM
     FREE_bit   = 0;               // Desabilita a Limpeza da Memória
     RD_bit     = 1;               // Inicia Leitura
     DADO_EEPROM = EEDATA;         // Captura o Dado da Memória

     return DADO_EEPROM;           // Retorna resultado

}


// ==== Escreda Dado na EEPROM ====

void escrever_eeprom(unsigned char address, unsigned char DADO_EEPROM) {

     EEADR      = address;             // Seleciona o Endereço da Memória
     EEDATA     = DADO_EEPROM;         // Dado a ser Gravado na Memória
     EEPGD_bit  = 0;                   // Configura o Acesso a EEPROM
     CFGS_bit   = 0;                   // Configura o Acesso a EEPROM
     FREE_bit   = 0;                   // Desabilita a Limpeza da Memória
     WREN_bit   = 1;                   // Habilita Gravação
     GIE_bit    = 0;                   // Desabilita Interrupção Geral Para Gravação da Memória (Necessário para não gerar erro na gravação)
     PEIE_bit   = 0;                   // Desabilita Interrupção Periféricos Para Gravação da Memória (Necessário para não gerar erro na gravação)
     EECON2     = 0x55;                // Necessario Para Gravação
     EECON2     = 0xAA;                // Necessario Para Gravação
     WR_bit     = 1;                   // Inicia Gravação
     while(WR_bit);                    // Aguarda Término da Gravação
     GIE_bit    = 1;                   // Habilita Interrupção Geral
     PEIE_bit   = 1;                   // Habilita Interrupção Periféricos
     WREN_bit   = 0;                   // Desabilita Gravação

     return;

}
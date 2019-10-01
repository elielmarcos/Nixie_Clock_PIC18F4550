#include "ds1307.h"


// =============================================================
// ===============      LEITURA DO RTC     =====================
// =============================================================

DateTime Read_RTC() {         // Rotina de leitura do DS1307
   
   DateTime Data;             // Variavel

   I2C1_Start();              // Inicializa comunica��o i2c
   I2C1_Wr(0xD0);             // End. fixo para DS1307: 1101000X, onde x = 0 � para grava��o
   I2C1_Wr(0);                // End. onde come�a a programa��o do rel�gio, end dos segundos.
   I2C1_Repeated_Start();     // Issue I2C signal repeated start
   I2C1_Wr(0xD1);             // End. fixo para DS1307: 1101000X, onde x=1 � para leitura
   Data.second = I2C1_Rd(1);  // L� o primeiro byte(segundos),informa que continua lendo
   Data.minute = I2C1_Rd(1);  // L� o segundo byte(minutos)
   Data.hour = I2C1_Rd(1);    // L� o terceiro byte(horas)
   Data.week = I2C1_Rd(1);    // L� o dia da semana
   Data.day = I2C1_Rd(1);     // L� o dia
   Data.month = I2C1_Rd(1);   // L� o m�s
   Data.year = I2C1_Rd(0);    // L� o s�timo byte(ano),encerra as leituras de dados
   I2C1_Stop();               // Finaliza comunica��o I2C
   
   Data.mode12h = Data.hour.B6;    // Verifica o modo 12h ou 24h
   
   if (Data.mode12h) {             // Se modo 12h
      Data.PM = Data.hour.B5;               // Verifica se AM ou PM
      Data.hour = Data.hour & 0b00011111;   // Ajusta a estrutura hour para formato BCD 12h
   } else Data.PM = 0;                      // Se n�o, PM = 0

   return Data;
}


// =============================================================
// ===============      ESCRITA NO RTC     =====================
// =============================================================

void Write_RTC(DateTime Data){
   I2C1_Init(400000);     // Iniciliza I2C com frequencia de 100KHz
   I2C1_Start();          // Inicializa a comunica��o I2c
   I2C1_Wr(0xD0);         // End. fixo para DS1307: 1101000X, onde x = 0 � para grava��o
   I2C1_Wr(0);            // End. onde come�a a programa��o do rel�gio, end. dos segundos.
   I2C1_Wr(Data.second);  // Inicializa com Data segundos
   I2C1_Wr(Data.minute);  // Inicializa com Data minutos
   if (Data.mode12h) {
      Data.hour.B6 = Data.mode12h;
      Data.hour.B5 = Data.PM;
   }
   I2C1_Wr(Data.hour);    // Inicializa com Data horas
   I2C1_Wr(Data.week);    // Inicializa com Data week
   I2C1_Wr(Data.day);     // Inicializa com Data dia
   I2C1_Wr(Data.month);   // Inicializa com Data m�s
   I2C1_Wr(Data.year);    // Inicializa com Data ano
   I2C1_Wr(0x10);         // Inicializa control SQW 1Hz
   I2C1_Stop();           // Finaliza comunica��o I2C
}
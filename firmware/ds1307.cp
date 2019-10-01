#line 1 "C:/NIXIE/soft/Nixie/ds1307.c"
#line 1 "c:/nixie/soft/nixie/ds1307.h"



typedef struct DateTime {
 unsigned char second;
 unsigned char minute;
 unsigned char hour;
 unsigned char PM;
 unsigned char mode12h;
 unsigned char day;
 unsigned char week;
 unsigned char month;
 unsigned char year;
}DateTime;


DateTime Read_RTC();
void Write_RTC(DateTime Data);
#line 8 "C:/NIXIE/soft/Nixie/ds1307.c"
DateTime Read_RTC() {

 DateTime Data;

 I2C1_Start();
 I2C1_Wr(0xD0);
 I2C1_Wr(0);
 I2C1_Repeated_Start();
 I2C1_Wr(0xD1);
 Data.second = I2C1_Rd(1);
 Data.minute = I2C1_Rd(1);
 Data.hour = I2C1_Rd(1);
 Data.week = I2C1_Rd(1);
 Data.day = I2C1_Rd(1);
 Data.month = I2C1_Rd(1);
 Data.year = I2C1_Rd(0);
 I2C1_Stop();

 Data.mode12h = Data.hour.B6;

 if (Data.mode12h) {
 Data.PM = Data.hour.B5;
 Data.hour = Data.hour & 0b00011111;
 } else Data.PM = 0;

 return Data;
}






void Write_RTC(DateTime Data){
 I2C1_Init(400000);
 I2C1_Start();
 I2C1_Wr(0xD0);
 I2C1_Wr(0);
 I2C1_Wr(Data.second);
 I2C1_Wr(Data.minute);
 if (Data.mode12h) {
 Data.hour.B6 = Data.mode12h;
 Data.hour.B5 = Data.PM;
 }
 I2C1_Wr(Data.hour);
 I2C1_Wr(Data.week);
 I2C1_Wr(Data.day);
 I2C1_Wr(Data.month);
 I2C1_Wr(Data.year);
 I2C1_Wr(0x10);
 I2C1_Stop();
}

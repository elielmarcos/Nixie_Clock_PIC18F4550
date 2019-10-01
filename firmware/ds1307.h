#ifndef DS1307_H
#define        DS1307_H

typedef struct DateTime {
        unsigned char second;
        unsigned char minute;
        unsigned char hour;
        unsigned char PM;        // Quando modo 12h -> 0 = AM, 1 = PM
        unsigned char mode12h;   // 0 = modo 24h, 1 = modo 12h
        unsigned char day;
        unsigned char week;
        unsigned char month;
        unsigned char year;
}DateTime;

// I2C RTC ds1307
DateTime Read_RTC();
void Write_RTC(DateTime Data);

#endif        /* DS1307_H */
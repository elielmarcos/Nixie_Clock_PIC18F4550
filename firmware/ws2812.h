#ifndef WS2812_H
#define        WS2812_H

typedef struct {
    unsigned char   r;
    unsigned char   b;
    unsigned char   g;
} ws2812Led;

// transmit a single WS2812
void ws2812_send(ws2812Led* led);

#endif        /* WS2812_H */
/*
 *	rect.h
 *	rectangle type
 *
 *	tomaz stih mon oct 7 2013
 */
#ifndef _RECT_H
#define _RECT_H

#include "types.h"

typedef struct rect_s {
	byte x;
	byte y;
	byte w;
	byte h;
} rect_t;

extern byte rect_intersect(rect_t* r3, rect_t* r1, rect_t* r2);
extern byte rect_contains_point(rect_t *rect, byte x, byte y);

#endif /* _RECT_H */

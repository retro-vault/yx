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
	byte x0;
	byte y0;
	byte x1;
	byte y1;
} rect_t;

extern boolean rect_overlap(rect_t *a, rect_t *b);
extern rect_t* rect_intersect(rect_t *a, rect_t *b, rect_t *intersect);
extern rect_t* rect_rel2abs(rect_t* abs, rect_t* rel, rect_t* out) __naked;
extern void rect_subtract(rect_t *outer, rect_t *inner, rect_t *result,	byte *num);

#endif /* _RECT_H */

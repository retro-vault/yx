/*
 *	bitmap.h
 *	bitmap structures and functions
 *
 *	tomaz stih wed apr 29 2015
 */
#ifndef _BITMAP_H
#define _BITMAP_H

#include "types.h"
#include "rect.h"

typedef struct bitmap_s {
	byte x1;	/* 0..x1 */
	byte y1;	/* 0..y1 */
	byte data;	/* followed by data */
} bitmap_t;

extern bitmap_t* bmp_get(rect_t *rect, void *mem);
extern void bmp_put(
	void *data,	/* raw data */ 
	byte x, 	/* screen x */
	byte y, 	/* screen y */
	byte rows, 	/* how many roads */
	byte cols, 	/* how many bits i.e. cols */
	byte shift,	/* shift each col right by... */ 
	byte skip);	/* how many bytes of data to skip at the end of a row */

#endif /* _BITMAP_H */

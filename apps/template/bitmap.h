/*
 *	bitmap.h
 *	bitmap structures and functions
 *
 *	tomaz stih wed apr 29 2015
 */
#ifndef _BITMAP_H
#define _BITMAP_H

#include "types.h"

typedef struct bitmap_s {
	byte x1;	/* 0..x1 */
	byte y1;	/* 0..y1 */
	/* followed by data *
/
} bitmap_t;

#endif

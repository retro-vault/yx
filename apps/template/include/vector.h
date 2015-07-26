/*
 *	vector.h
 *	vector routines
 *
 *	tomaz stih sat jun 6 2015
 */
#ifndef _VECTOR_H
#define _VECTOR_H

#include "types.h"

extern void vector_plotxy(byte x, byte y);
extern void vector_vertline(byte x, byte y0, byte y1, byte pattern);
extern void vector_horzline(byte y, byte x0, byte x1, byte pattern);

#endif /* _VECTOR_H */

/*
 *	rect.h
 *	rectangle object
 *
 *	tomaz stih tue jun 5 2012
 */
#ifndef _RECT_H
#define _RECT_H

#define POPULATE_RECT(_rect_ptr, _x0, _y0, _x1, _y1)	\
	_rect_ptr->x0=_x0;				\
	_rect_ptr->y0=_y0;				\
	_rect_ptr->x1=_x1;				\
	_rect_ptr->y1=_y1;

typedef struct rect_s {
	byte x0;
	byte y0;
	byte x1;
	byte y1;
} rect_t;

extern boolean rct_intersect(rect_t *r1, rect_t *r2) __naked;

#endif

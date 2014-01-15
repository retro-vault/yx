/*
 *	rect.c
 *	rectangle type implementation
 *
 *	tomaz stih mon oct 7 2013
 */
#include "rect.h"

byte rect_intersect(rect_t* r3, rect_t* r1, rect_t* r2)
{
	byte r1_right=r1->x + r1->w;
	byte r2_right=r2->x + r2->w;
	byte r1_bottom=r1->y + r1->h;
	byte r2_bottom=r2->y + r2->h;

	byte intersect =  ( 
		r2->x < r1_right
		&& r2_right > r1->x
		&& r2->y < r1_bottom
		&& r2_bottom > r1->y
	);

 	if (intersect) {
		r3->x=MAX(r1->x, r2->x);
		r3->y=MAX(r1->y, r2->y);
		r3->w=MIN(r1_right, r2_right);
		r3->h=MIN(r1_bottom, r2_bottom);
	}

	return intersect;
}

byte rect_contains_point(rect_t *rect, byte x, byte y) {
	byte contains=
		x >= rect->x && 
		x <= rect->x + rect->w &&
		y >= rect->y && 
		y <= rect->y + rect->h;
	return contains;		
}

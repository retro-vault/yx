/*
 *	rect.c
 *	rectangle object
 *
 *	tomaz stih tue jun 5 2012
 */
#include "test.h"

boolean rct_intersect(rect_t *r1, rect_t *r2) __naked {
	__asm
		/* sp to iy */
		ld	iy,#0x0000
		add	iy,sp

		/* r1 to hl, r2 to de */
		ld	l,2(iy)
		ld	h,3(iy)
		ld	e,4(iy)
		ld	d,5(iy)

		/*
		 * rct_intersect_raw
		 * do r1 and r2 intersect?
		 * input
		 *	hl	... rect_t *r1
		 *	de	... rect_t *r2
		 * output
		 *	l	... TRUE or FALSE
		 * effects
		 *	af
		 */	
rct_intersect_raw::
		push	ix
		/* ix=hl, iy=de */
		push	hl
		push	de
		pop	iy
		pop	ix
		/* do the comparision */
		ld	a,(ix)		/* a=r1.x0 */
		cp	2(iy)		/* compare to r2.x1 */
		jr	nc, ri_false	/* ? r1.x0 > r2.x1 */
		ld	a,2(ix)		/* a=r1.x1 */
		cp	(iy)		/* compare to r2.x0 */
		jr	c, ri_false	/* ? r1.x1 < r2.x0 */
		ld	a,1(ix)		/* a=r1.y0 */
		cp	3(iy)		/* compare to r2.y1 */
		jr	nc, ri_false	/* ? r1.y0 > r2.y1 */
		ld	a,3(ix)		/* a=r1.y1 */
		cp	1(iy)		/* compare to r2.y0 */
		jr	c,ri_false	/* ? r1.y1 < r2.y0 */
		
		/* rects intersect */
		ld	l,#TRUE	
		jr	ri_end

ri_false:
		ld	l,#FALSE
ri_end:
		pop	ix		/* restore ix */
		ret
	__endasm;
}


/*
 *	rect.c
 *	rectangle type implementation
 *
 *	tomaz stih mon oct 7 2013
 */
#include "rect.h"

boolean rect_overlap(rect_t *a, rect_t *b) {
	return !(a->y1 < b->y0 || a->y0 > b->y1 || a->x1 < b->x0 || a->x0 > b->x1);
}

rect_t* rect_intersect(rect_t *a, rect_t *b, rect_t *intersect) {
	if (rect_overlap(a,b)) {
		intersect->x0=MAX(a->x0,b->x0);
		intersect->y0=MAX(a->y0,b->y0);
		intersect->x1=MIN(a->x1,b->x1);
		intersect->y1=MIN(a->y1,b->y1);
		return intersect;
	} else return NULL;
}

rect_t* rect_rel2abs(rect_t* abs, rect_t* rel, rect_t* out) __naked {
	abs, rel, out;
	__asm
		/* store index regs */
		push	ix
		push	iy
		ld	hl,#6		/* we'll jump the stack */
		add	hl,sp		/* hl points to abs */
		ld	sp,hl
		
		/* get args */
		pop	ix		/* abs ptr */
		pop	iy		/* rel ptr */
		pop	de		/* de= out */

		/* restore stack */
		ld	hl,#-12
		add	hl,sp
		ld	sp,hl
		ex	de,hl		/* hl= de */
		
		/* x0 */		
		ld	a,(ix)		/* a=abs.x0 */
		add	(iy)		/* abs.x0 + rel.x0 */
		jr	c,r2a_err
		cp	2 (ix)		/* cp to abs.x1 */
		jr	nc,r2a_err	
		ld	e,a		/* e=new x0 */

		/* y0 */
		ld	a,1 (ix)	/* a=abs.y0 */
		add	1 (iy)		/* abs.y0 + rel.y0 */
		jr	c,r2a_err
		cp	3 (ix)		/* cp to abs.y1 */
		jr	nc,r2a_err
		ld	d,a		/* d=new y0 */

		/* x1 */
r2a_x1:
		ld	a,(ix)		/* a=abs.x0 */
		add	2 (iy)		/* abs.x0 + rel.x1 */
		jr	c,r2a_fix_x1
		cp	2 (ix)		/* cp to abs.x1 */
		jr	nc,r2a_fix_x1
		ld	c,a		/* c=new x1 */
		jr	r2a_y1
r2a_fix_x1:	
		ld	c,2 (ix)	/* c=new x1 */

		/* y1 */
r2a_y1:
		ld	a,1 (ix)	/* a=abs.y0 */
		add	3 (iy)		/* abs.y0 + rel.y1 */
		jr	c,r2a_fix_y1
		cp	3 (ix)		/* cp to abs.y1 */
		jr	nc,r2a_fix_y1
		ld	b,a		/* b=new y1 */
		jr	r2a_done
r2a_fix_y1:	
		ld	b,3 (ix)	/* b=new y1 */			
r2a_done:
		/* de=y0x0, bc=y1x1, hl=out address */
		push	hl
		pop	ix		/* ld ix,hl */
		ld	(ix),e
		ld	1 (ix),d
		ld	2 (ix),c
		ld	3 (ix),b
		jr	r2a_end
r2a_err:		
		ld	hl,#0		/* result is null */
r2a_end:
		/* restore index regs */
		pop	iy
		pop	ix
		ret
	__endasm;
}

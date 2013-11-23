/*
 *	interrupt.c
 *	interrupt related routines
 *
 *	tomaz stih wed apr 10 2013
 */
#include "yx.h"

word dicount=0;

void di() __naked {
	__asm
		/* disable interrupts with ref counting */
		di
		ld	hl,#_dicount
		inc	(hl)
		ret
	__endasm;
}

void ei() __naked {
	__asm
		/* enable interrupts with ref counting */
		ld	a,(#_dicount)
		or	a
		jr	z,do_ei			/* if a==0 then just ei */
		dec	a			/* if a<>0 then dec a */
		ld	(#_dicount),a		/* write back to counter */
		or	a			/* and check for ei */
		jr	nz,dont_ei		/* not yet... */
do_ei:		ei
dont_ei:	ret
	__endasm;
}

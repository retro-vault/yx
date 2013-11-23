/*
 *	hires.c
 *	high resolution graphics (256x192)
 *
 *	tomaz stih wed mar 20 2013
 */
#include "yx.h"

/* 
 * clear screen
 */
void hires_cls(color_t back, color_t fore, color_t border, color_mask_t cm) __naked {
	__asm
		ld	iy,#0x0000	
		add	iy,sp

		/* 
		 * first graphics 
		 */
		ld	hl,#0x4000	/* vmemory */
		ld	bc,#0x1800	/* vmem size */
		ld	(hl),l		/* l = 0 */
		ld	d,h
		ld	e,#1
		ldir			/* clear screen */

		/*
		 * now attributes
		 */
		ld	a,2(iy)		/* paper color to */
		rlca			/* bits 3-5 */
		rlca
		rlca	
		or	3(iy)		/* ink color to bits 0-2 */
		or	5(iy)		/* or mask */
		ld	(hl),a
		ld	bc,#0x02ff	/* size of attr */
		ldir

		/*
		 * and the border
		 */
		ld	a,4(iy)
		out	(#0xfe),a	/* set border */

		ret
	__endasm;
}

word hires_vmem_nextrow_addr(word addr) __naked {

	__asm
		/* get current address to hl */
		ld	iy,#0x0000	
		add	iy,sp
		ld	l,2(iy)
		ld	h,3(iy)

		/*
		 * vmem_nextrow_addr_raw
		 * based on address in vmem, calculate next row address in vmem
		 * input
		 *	hl	address in vmem
		 * output
		 *	hl	next row address in vmem
		 * effects
		 *	a, flags, c, hl
		 */	
hires_vmem_nextrow_addr_raw::
		/* calc. next line to hl */
		inc	h
		ld	a,h
		and	#7
		jr	nz,nextrow_done
		ld	a,l
		add	a,#32
		ld	l,a
		jr	c, nextrow_done
		ld	a,h
		sub	#8
		ld	h,a
nextrow_done:
		ret
	__endasm;
}

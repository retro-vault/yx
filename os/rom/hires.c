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
		/*
		 * get parameters off stack
		 */
		pop	af		/* ret address */
		pop	de		/* e=paper, d=ink */
		pop	bc		/* c=border, b=mask */
		
		/* restore stack */
		push	bc
		push	de
		push	af

		/*
		 * set the the border
		 */
		ld	a,c
		out	(#0xfe),a	/* set border */

		/* prepare attr in a */
		ld	a,e		/* paper color to a */
		rlca			/* bits 3-5 */
		rlca
		rlca	
		or	d		/* ink color to bits 0-2 */
		or	b		/* or mask */

		/* 
		 * first graphics 
		 */
		ld	hl,#0x4000	/* vmemory */
		ld	bc,#0x1800	/* vmem size */
		ld	(hl),l		/* l = 0 */
		ld	d,h
		ld	e,#1
		ldir			/* clear screen */
		ld	(hl),a		/* attr to source */
		ld	bc,#0x02ff	/* size of attr */
		ldir

		ret
	__endasm;
}

/* 
 * calculate next screen row address given address
 */
word hires_vmem_nextrow_addr(word addr) __naked {

	__asm
		/* get current address to hl */
		pop	af
		pop	hl
		push	hl
		push	af

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

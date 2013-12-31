/*
 *	video.c
 *	low level graphics routines
 *
 *	tomaz stih mon dec 30 2013 ... yey ... today's my birthday :)
 */
#include "video.h"

word video_addr(byte x, byte y) __naked {

	__asm
		/* get function parameters from stack */
		ld	iy,#0x0000
		add	iy,sp		/* iy=sp */
		ld	b,2(iy)		/* b=x */
		ld	c,3(iy)		/* c=y */

		/*
		 * video_addr_raw
		 * based on x and y, calculate screen address
		 * input
		 *	b	x
		 *	c	y
		 * output
		 *	hl	screen address of byte 
		 * effects
		 *	a, flags, c, hl
		 */	
video_addr_raw::
		/* 
		 * calculate the high byte of the 
		 * screen addressand store in H reg.
		 */
		ld	a,c
		and	#0b00000111
		ld	h,a
		ld	a,c
		rra
		rra
		rra
		and	#0b00011000
		or	h
		or	#0b01000000
		ld	h,a

		/* 
		 * calculate the low byte of the 
		 * screen address and store in L reg.
		 */
		ld	a,b
		rra
		rra
		rra
		and	#0b00011111
		ld	l,a
		ld	a,c
		rla
		rla
		and 	#0b11100000
		or	l
		ld	l,a

		/*
		 * calculate pixel postion 
		 * and store in A reg.
		 */
		ld	a,b
		and	#0b00000111

		ret
	__endasm;

}

word video_nextrow_addr(word addr) __naked {

	__asm
		/* get current address to hl */
		ld	iy,#0x0000	
		add	iy,sp
		ld	l,2(iy)
		ld	h,3(iy)

		/*
		 * video_nextrow_addr
		 * based on screen address, calculate next row address
		 * input
		 *	hl	screen address
		 * output
		 *	hl	next row address
		 * effects
		 *	a, flags, c, hl
		 */	
video_nextrow_addr_raw::
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

void video_cls(color_t back, color_t fore, color_t border, color_mask_t cm) __naked {
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

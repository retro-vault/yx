/*
 *	lores.h
 *	low resolution graphics (text mode)
 *
 *	tomaz stih wed mar 20 2013
 */
#include "yx.h"

int lores_x=0, lores_y=23;

/*
 * print string
 */
void lores_puts(string s) {
	while(*s) { 
		switch(*s) {
			case '\n':
				lores_x=0;
				lores_y++;
				break;
			default:
				lores_putc_xy(*s, lores_x++, lores_y);		
		}
		if (lores_x>31) {
			lores_x=0;
			lores_y++;
		}
		if (lores_y>23) {
			lores_y=23;
			lores_scrollup();
		}
		s++;	
	}
}

/*
 * print char at x, y using system font 
 */
void lores_putc_xy(byte c, byte x, byte y) __naked {
	__asm
		ld	iy,#0x0000
		add	iy,sp	

		/*
		 * calculate character inside system font
		 */
		ld	a,2(iy)		/* get character */
		sub	#32		/* a = a-32 */
		ld	h,#0x00		/* h=0 */
		ld	l,a		/* hl=a */
		add	hl,hl		/* hl=hl*2 */
		add	hl,hl		/* hl=hl*4 */
		add	hl,hl		/* hl=hl*8 */
		ld	de,#sysfont8x8	/* font address */
		add	hl,de		/* hl=character address */
		ex	de,hl		/* into de */

		/*
		 * calculate char position in vmem
		 */
		ld	b,3(iy)		/* b <- x */
		ld	c,4(iy)		/* c <- y */
					/* vmem address to hl */
		call	lores_vmem_addr_raw

		/* 
		 * loop it 
		 */
		ld	b,#8		/* eight lines */
lpxy_loop:	ld	a,(de)		/* get character byte */
		inc	de		/* next byte */
		ld	(hl),a		/* transfer to screen */

					/* next hires screen line */
		call	hires_vmem_nextrow_addr_raw

		djnz	lpxy_loop
		
		ret

	__endasm;	
}

/*
 * scroll up 8 lines
 */
void lores_scrollup() __naked {
	__asm
		ld	de,#0x4000	/* scan line 1 */
		ld	hl,#0x4020	/* scan line 8, diff is 1 char */
		ld	bc,#0x0020	/* bytes to transfer */

		/*
		 * move 184 lines (192 - 8)
		 */
		ld	a,#184
ls_loop:	
		push	af		
		push	bc
		push	de		
		push	hl
		ldir			/* move scan line */
		pop	hl
		pop	de
		call	hires_vmem_nextrow_addr_raw
		ex	de,hl
		call	hires_vmem_nextrow_addr_raw
		ex	de,hl
		pop	bc
		pop	af

		dec	a
		jr	nz,ls_loop

		/*
		 * fill last line with zeroes
		 * note: de already points to correct line
		 */
		ld	a,#8		/* 8 lines */
		ex 	de,hl		/* correct line to hl */
ls_clr_loop:
		push	hl		/* store hl */		
		ld	b,#32		/* chars */
ls_clrlne_loop:	
		ld	(hl),#0
		inc	hl
		djnz	ls_clrlne_loop
		pop	hl
		push	af
		call	hires_vmem_nextrow_addr_raw
		pop	af
		dec	a
		jr	nz,ls_clr_loop

		ret

	__endasm;
}

word lores_vmem_addr(byte x, byte y) __naked {

	__asm
		;; get function parameters from stack
		ld	iy,#0x0000
		add	iy,sp		/* iy=sp */
		ld	b,2(iy)		/* b=x */
		ld	c,3(iy)		/* c=y */

		/*
		 * directg_vmem_addr_raw
		 * based on hires x and hires y, calculate vmem address
		 * input
		 *	b	hires x
		 *	c	hires y
		 * output
		 *	hl	cell address in vmem
		 * effects
		 *	a, flags, c, hl
		 */	
lores_vmem_addr_raw::
		ld	a,c		/* get y to acc. */
		and	#0x18		/* get bits 3 - 4 */
		add	a,#0x40		/* add start of vmem */
		ld	h,a		/* to high */
		ld	a,c		/* y to acc. again */
		and	#0x07		/* get bits 0 - 2 */
		rrca			/* multiply * 32 */
		rrca
		rrca
		add	a,b		/* to high */
		ld	l,a		/* and add x */
		ret
		
	__endasm;

}

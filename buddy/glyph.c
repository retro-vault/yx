/*
 *	glyph.c
 *	glyph type
 *
 *	tomaz stih sun dec 5 2014
 */
#include "glyph.h"

void glyph_draw(graphics_t *g, glyph_t *glyph, byte x, byte y) {
	byte* vaddr;
	register byte linecount;
	byte nbytes;
	byte *dataptr;
	register byte b;
	byte shift;
	byte next_or;
	byte xoffset, yoffset;

	__asm;
		/* 
		 * convert x and y 
		 * to absolute coordinates 
		 */
		
		/* get graphics area */
		ld	l,2 (ix)	/* graphics to hl */
		ld	h,3 (ix)
		ld	a,(hl)		/* pointer to area to hl */
		inc	hl
		ld	h,(hl)
		ld	l,a

		/* increase x... */
		ld	a,(hl)
		add	6 (ix)
		ld	6 (ix),a
		
		/* ...and y */
		inc	hl
		ld	a,(hl)
		add	7 (ix)
		ld	7 (ix), a

		/* 
		 * handle vertical clipping 
		 */
		

		/* 
		 * handle horizontal clipping 
		 */
	__endasm;

	/* handle vertical clipping 
	yoffset=0;
	if (g->clip->y > y) {
		yoffset = g->clip->y - y;
		y=g->clip->y;
	}
	*/

	/* handle horizontal clipping */
	xoffset=0;

	/* do the drawing */
	shift=x%8; /* if not on a 8 bit boundary */
	vaddr=video_addr(x,y); /* get row address */
	linecount=glyph->glyph_lines;
	nbytes=glyph->bytes_per_glyph_line;
	dataptr=(byte*) (glyph->data);
	while (linecount--) {
		next_or=0;
		for(b=0;b<nbytes;b++) {
			/* or contents to screen and add next or */
			vaddr[b]|=(*dataptr>>shift)|next_or;
			/* if shifted out of bounds */
			next_or=*dataptr++<<(8-shift);
		}		
		if (shift) /* last one, if data shifted... */
			vaddr[nbytes]|=next_or;
		/* get next row address */
		vaddr=video_nextrow_addr((word)vaddr);
	}
}

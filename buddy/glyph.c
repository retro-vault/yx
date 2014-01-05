/*
 *	glyph.c
 *	glyph type
 *
 *	tomaz stih sun dec 5 2014
 */
#include "glyph.h"

void glyph_draw(graphics_t *g, glyph_t *glyph, byte x, byte y) {
	byte* vaddr;
	byte linecount;
	register byte nbytes;
	byte *dataptr;
	byte b;
	byte shift;
	byte next_or;

	shift=x%8;
	vaddr=video_addr(x,y);
	linecount=glyph->glyph_lines;
	nbytes=glyph->bytes_per_glyph_line;
	dataptr=(byte*) (glyph->data);
	while (linecount--) {
		next_or=0;
		for(b=0;b<nbytes;b++) {
			vaddr[b]|=(*dataptr>>shift)|next_or;
			next_or=*dataptr++<<(8-shift);
		}		
		if (shift) 
			vaddr[nbytes]|=next_or;
		vaddr=video_nextrow_addr((word)vaddr);
	}
}

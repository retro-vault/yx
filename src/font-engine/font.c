/*
 *	font.c
 *	fonts
 *
 *	notes: metrics described at http://en.wikipedia.org/wiki/X-height
 *
 *	tomaz stih mon jul 9 2012
 */
#include "test.h"

void fnt_get_font_info(
	font_t *font,
	byte *bytes_per_glyph_line,
	byte *glyph_lines,
	byte *xmax,
	byte *descent,
	byte *xmin,
	word *first_glyph_addr,
	word *glyph_size_in_bytes) 
{

	/*
	 * defaults for generation 0
	 */
	(*bytes_per_glyph_line)	=	1;
	(*glyph_lines)		=	8;
	(*xmax)			=	0;
	(*descent)		=	0;
	(*xmin)			=	0;

	switch(font->font_generation) {
		case FGEN_2:
			(*xmin)=font->xmin;
		case FGEN_1: 
			(*bytes_per_glyph_line)=font->bytes_per_glyph_line;
			(*glyph_lines)=font->glyph_lines;
			(*xmax)=font->xmax;
			(*descent)=font->descent;
			break;
	}

	(*first_glyph_addr) = ((word)font) + (font->font_generation);
	(*glyph_size_in_bytes) = ( (*glyph_lines) + 1 ) * (*bytes_per_glyph_line) + 1 ;
	
}

void fnt_measure_string(font_t *font, string string, byte *widths)
{
	byte bpg, gl, xmax, descent, xmin;
	word addr0, glyph_size;

	/*
	 * first get font info
	 */
	fnt_get_font_info(font, &bpg, &gl, &xmax, &descent, &xmin, &addr0, &glyph_size);

	/*
	 * calculate glyph position
	 */
	
}



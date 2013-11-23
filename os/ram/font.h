/*
 *	font.h
 *	fonts
 *
 *	notes: metrics described at http://en.wikipedia.org/wiki/X-height
 *
 *	tomaz stih sat jun 16 2012
 */
#ifndef _FONT_H
#define _FONT_H

typedef struct font_s {

	/* quick info */
	byte font_generation; /* 0=fixed 8x8, 1=yeah system fonts, 2=advanced proportional fonts */

	/* scope */
	byte first_ascii;
	byte last_ascii;

	/*
	 * --- ONLY FONT GENERATION 1 AND LATER --- 
	 */
	byte bytes_per_glyph_line;
	byte glyph_lines;
	byte xmax;
	byte descent;
	
	/* 
	 * --- ONLY FONT GENERATION 2 AND LATER --- 
	 */
	/* advance = xmin+width+xmax, width is per char data */
	byte xmin;

	/* vertical aspects */
	byte ascent;		/* font ascent */
	byte cap_height;	/* cap height */
	byte x_height;		/* corpus size */
	byte baseline;		/* baseline */

} font_t;

/* 
 * each glyph starts with a mask 
 * followed by glyph data and concluding
 * with glyph width 
 */	

/* ------------------------------------------------------------ */

/*
 * get basic metrics
 */
extern void fnt_get_font_info(
	font_t *font,
	byte *bytes_per_glyph,
	byte *glyph_lines,
	byte *xmax,
	byte *descent,
	byte *xmin,
	word *first_glyph_addr,
	word *glyph_size_in_bytes);

/*
 * measure string
 */
extern void fnt_measure_string(font_t *font, string string, byte *widths);



#endif

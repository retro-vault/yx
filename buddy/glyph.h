/*
 *	glyph.h
 *	glyph type
 *
 *	tomaz stih mon oct 14 2013
 */
#ifndef _GLYPH_H
#define _GLYPH_H

#include "types.h"
#include "graphics.h"
#include "video.h"

typedef struct glyph_s {
	byte bytes_per_glyph_line;
	byte glyph_lines;
	byte data[0];
} glyph_t;

extern void glyph_draw(
	graphics_t *g, 
	glyph_t *glyph, 
	byte x, 
	byte y);

#endif /* _GLYPH_H */

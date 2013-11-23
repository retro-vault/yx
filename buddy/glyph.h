/*
 *	glyph.h
 *	glyph type
 *
 *	tomaz stih mon oct 14 2013
 */
#ifndef _GLYPH_H
#define _GLYPH_H

#include "types.h"

typedef struct glyph_s {
	byte bytes_per_glyph_line;
	byte glyph_lines;
} glyph_t;

#endif /* _GLYPH_H */

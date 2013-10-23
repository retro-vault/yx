/*
 *	graphics.c
 *	graphics context
 *
 *	tomaz stih mon oct 14 2013
 */
#include "graphics.h"

graphics_t* graphics_create(window_t *wnd, byte flags) {
	return NULL;
}

void graphics_destroy(graphics_t* graphics) {
}

void graphics_set_pen() {
}

void graphics_set_fill_mask() {
}

void graphics_set_combine_mode() {
}

void graphics_draw_line(graphics_t* graphics, byte x0, byte y0, byte x1, byte y1) {
}

void graphics_draw_rect(graphics_t* graphics, rect_t* rect) {
}

void graphics_fill_rect(graphics_t* graphics, rect_t* rect) {
}

void graphics_draw_glyph(graphics_t *graphics, glyph_t *mask, glyph_t* glyph, byte x0, byte y0) {
}
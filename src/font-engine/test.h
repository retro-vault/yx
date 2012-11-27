/*
 *	test.h
 *	test code (under limited conditions)
 *
 *	tomaz stih sat jun 16 2012
 */
#ifndef _TEST_H
#define _TEST_H

#define	NULL		(word)0
#define MAX_X		255
#define MAX_Y		191

#define VIDEO_MEM_SIZE	0x1800
#define VIDEO_MEM_ADDR	0x4000
#define ATTR_MEM_SIZE	0x0300
#define ATTR_MEM_ADDR	0x5800

#define GLYPH_GET	0x01
#define GLYPH_PUT	0x02

#define FGEN_FIXED8X8	3
#define FGEN_1		7
#define FGEN_2		12

/* unsigned  */
typedef unsigned char           uint8_t;
typedef unsigned short int      uint16_t;
typedef unsigned long int       uint32_t;

/* usual */
typedef uint8_t byte;
typedef uint16_t word;
typedef byte * string;

typedef byte result;

#define RESULT_SUCCESS			00
#define RESULT_DONT_OWN			01
#define RESULT_NO_MEMORY_LEFT		02
#define RESULT_CANT_LOCK		03
#define RESULT_INVALID_PARAMETER	04
#define RESULT_NOT_FOUND		05

typedef byte boolean;
#define TRUE				1
#define FALSE				0

extern result last_error; /* last error, 0 = success */

#include "rect.h"

typedef struct margins_s {
	byte left;
	byte top;
	byte right;
	byte bottom;
} margins_t;

typedef struct coord_sys_s {
	byte origin_x;
	byte origin_y;
} coord_sys_t;

typedef struct graphics_s {
	rect_t *clip_rect; 	/* always absolute */
	word delta_g;		/* shadow_screen - screen */
	coord_sys_t *coord_sys;	/* offsets for relative 2 absolute positioning */
} graphics_t;

#include "font.h"

extern void mem_set(byte *dest, byte val, word count) __naked;
extern void mem_copy(byte *dest, byte *src, word count) __naked;
extern void shift_buffer_right(word start_addr, byte len, byte bits, byte lmask) __naked;
extern word string_length(string s) __naked;

extern void directg_realize(rect_t *r) __naked;
extern word directg_vmem_addr(byte x, byte y) __naked;
extern word directg_vmem_nextrow_addr(word addr) __naked;
extern void directg_aligned_glyph_16x16(byte x, byte y, byte *glyph, byte op) __naked;
extern void directg_render_masked_glyph_16x16(byte x, byte y, byte *glyph, byte* mask) __naked;

extern byte *shadow_screen;
extern byte *screen;
extern word delta_g;
extern rect_t screen_rect;

extern void g_init();
extern void g_draw_text(graphics_t *g, font_t *font, string text, rect_t *target_rect);

extern word chicago_font();
extern word envy_font();
extern word cour_new_font();
extern word c60s_font();
extern word c64_font();
extern word liquid_font();
extern word sinserif_font();
extern word ocra_font();

#endif

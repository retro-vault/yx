/*
 *	video.h
 *	low level graphics routines
 *
 *	tomaz stih mon dec 30 2013 ... yey ... today's my birthday :)
 */
#ifndef _VIDEO_H
#define _VIDEO_H

#include "types.h"

/*
 * color masks, use 'or' to merge
 */
#define CM_NONE		0x00
#define CM_BRIGHT	0x40
#define CM_FLASH	0x80

/* 
 * colors
 */
#define BLACK		0x00
#define BLUE		0x01
#define RED		0x02
#define	MAGENTA		0x03
#define GREEN		0x04
#define CYAN		0x05
#define	YELLOW		0x06
#define WHITE		0x07

typedef byte color_t;
typedef byte color_mask_t;

extern word video_addr(byte x, byte y) __naked;
extern word video_nextrow_addr(word addr) __naked;
extern void video_cls(
	color_t back, 
	color_t fore, 
	color_t border, 
	color_mask_t cm) __naked; 

#endif

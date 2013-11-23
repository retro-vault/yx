/*
 *	color.h
 *	color definitions
 *
 *	tomaz stih tue may 29 2012
 */
#ifndef _COLOR_H
#define _COLOR_H

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

#endif

/*
 *	types.h
 *	common types used in code (based on stdint.h)
 *
 *	notes:	based on sdcc compiler, use stdint.h types for
 *			platform independency.
 *
 *	tomaz stih mon oct 7 2013
 */
#ifndef _TYPES_H
#define _TYPES_H

#include <stdint.h>

#define	NULL	(word)0

/* signed  */
typedef int8_t		i8;
typedef int16_t		i16;
typedef int32_t		i32;

/* unsigned  */
typedef uint8_t		u8;
typedef uint16_t	u16;
typedef uint32_t	u32;

/* usual */
typedef u8		byte;
typedef u16		word;
typedef u8*		string;
typedef u8		result;

#endif

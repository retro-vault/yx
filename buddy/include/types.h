/*
 *	types.h
 *	common types used in code (do not include stdint.h!)
 *
 *	tomaz stih fri may 25 2012
 */
#ifndef _TYPES_H
#define _TYPES_H

#define	NULL	( (word)0 )
#define TRUE	( (byte)1 )
#define FALSE	( (byte)0 )

/* signed  */
typedef signed char             int8_t;
typedef short int               int16_t;
typedef long int                int32_t;

/* unsigned  */
typedef unsigned char           uint8_t;
typedef unsigned short int      uint16_t;
typedef unsigned long int       uint32_t;

/* usual */
typedef uint8_t			boolean;
typedef uint8_t 		byte;
typedef uint16_t 		word;
typedef uint8_t* 		string;
typedef uint8_t 		result;
typedef uint16_t		handle;

/* general purpose macros */
#define MAX(a,b) ( (a>b?a:b) )
#define MIN(a,b) ( (a<b?a:b) )

#endif

/*
 *	yx.h
 *	include file for yx os and api
 *
 *	tomaz stih wed mar 20 2013
 */
#ifndef _YX_H
#define _YX_H

#define	NULL	(word)0

/* signed  */
typedef signed char             int8_t;
typedef short int               int16_t;
typedef long int                int32_t;

/* unsigned  */
typedef unsigned char           uint8_t;
typedef unsigned short int      uint16_t;
typedef unsigned long int       uint32_t;

/* usual */
typedef uint8_t			byte;
typedef uint16_t		word;
typedef uint8_t*		string;
typedef uint8_t			result;

extern void query_api(string api);	/* defined in crt0.s */

typedef struct yx_s {
	string signature();		/* api signature */
	void (*exit)(word code);	/* exit application */
	void* (*malloc)(word bytes);	/* allocate memory */
	void (*free)(void *ptr);	/* free memory */
} yx_t;

#endif

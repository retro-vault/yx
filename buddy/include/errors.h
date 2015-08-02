/*
 *	errors.h
 *	system error definitions
 *
 *	tomaz stih tue may 29 2012
 */
#ifndef _ERRORS_H
#define _ERRORS_H

#include "types.h"

#define SUCCESS			00
#define DONT_OWN		01
#define OUT_OF_MEMORY		02
#define CANT_LOCK		03
#define INVALID_PARAMETER	04
#define NOT_FOUND		05

extern result last_error; /* last error, 0 = success */

#endif

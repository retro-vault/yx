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
#define NOT_PROCESSED		01
#define DONT_OWN		02
#define OUT_OF_MEMORY		03
#define CANT_LOCK		04
#define INVALID_PARAMETER	05
#define NOT_FOUND		06

extern result last_error; /* last error, 0 = success */

#endif

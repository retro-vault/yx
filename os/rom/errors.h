/*
 *	errors.h
 *	system error definitions
 *
 *	tomaz stih tue may 29 2012
 */
#ifndef _ERRORS_H
#define _ERRORS_H

#define RESULT_SUCCESS			00
#define RESULT_DONT_OWN			01
#define RESULT_NO_MEMORY_LEFT		02
#define RESULT_CANT_LOCK		03
#define RESULT_INVALID_PARAMETER	04
#define RESULT_NOT_FOUND		05

extern result last_error; /* last error, 0 = success */

#endif

/*
 *	util.c
 *	misc functions
 *
 *	tomaz stih tue jun 5 2012
 */
#include "yeah.h"

/* 
 * cause we want no dependency on std lib
 */
byte strcmp(string s1, string s2)
{
	while((*s1 && *s2) && (*s1++ == *s2++));
	return *(--s1) - *(--s2);
}

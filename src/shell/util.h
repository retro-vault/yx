/*
 *	util.h
 *	misc functions
 *
 *	tomaz stih tue jun 5 2012
 */
#ifndef _UTIL_H
#define _UTIL_H

typedef struct bpair_s {
	byte low;
	byte high;
} bpair_t;

extern byte strcmp(string s1, string s2);

#endif

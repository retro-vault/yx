/*
 *	string.c
 *	string functions
 *
 *	tomaz stih wed apr 10 2013
 */
#include "yx.h"

/* compare two strings */
byte strcmp(string s1, string s2)
{
	while((*s1 && *s2) && (*s1++ == *s2++));
	return *(--s1) - *(--s2);
}

/* copy string to destination strings */
void strcpy(string dest, string src) {
	while (*src) (*dest++ = *src++);
	(*dest)=0; /* terminate string */
}

/* calc string len */
word strlen(char *str)
{
	const char *s;
        for (s = str; *s; ++s) /* do nothing */;
        return (s - str);
}

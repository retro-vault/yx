/*
 *	buddy.c
 *	desktop for zx spectrum
 *
 *	tomaz stih mon oct 14 2013
 */
#include "buddy.h"

void harvest_events() {

}

int main(int argn,char **argv)
{
	char* screen=16384;
	int len=6912;
	while(len--) *screen++=0x55;

	return 0;
}

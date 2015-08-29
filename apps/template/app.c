/*
 *	app.c
 *	application backbone
 *
 *	tomaz stih sun aug 2 2015
 */
#include "types.h"
#include "app.h"
#include "console.h"

void main() {

	string s="YX OPERATING SYSTEM FOR ZX SPECTRUM 48K\nREADY.\n";

	con_clrscr();
	con_puts(s);
}

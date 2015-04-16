/*
 *	app.c
 *	backbone of yeah application
 *
 *	tomaz stih thu apr 16 2015
 */
#include "app.h"



void main() {

	/*
		vmem=16384
		end=22530

	/*
	__asm
		ld	b,#191
		ld 	c,#0
loop:
		push	bc
		call vid_plotxy
		pop	bc
		inc	c
		jr	nz,loop
		djnz	loop
		
	__endasm;
	*/
	
	/*
	__asm
		ld	c,#0
		ld	b,#0
		ld	e,#191
loop:		
		push	bc
		call	vid_vertline
		pop	bc
		inc	c
		jr	nz,loop
	__endasm;
	*/
}

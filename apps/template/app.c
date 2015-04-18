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

	/* sample 00100111 */
	__asm
		ld	b,#191
		ld	c,#191
		ld	e,#0x55
loop:
		push	bc
		push	de	
		ld	d,c
		ld	c,#0
		call	vid_horzline
		pop	de
		pop	bc
		dec	c
		djnz	loop
	__endasm;
	
	
	/*
	__asm
		ld	b,#0
		ld	c,#2
		ld	d,#2
		ld	e,#0xAA
		call	vid_horzline
	__endasm;
	*/
	
}

/*
 *	system.c
 *	system specifics 
 *
 *	tomaz stih wed apr 3 2013
 */
#include "yx.h"

/*
 * system heap 
 */
word get_sysheap() __naked {
	__asm
		ld	hl,#sysheap
		ret
	__endasm;
}

/*
 * user heap
 */
word get_usrheap() __naked {
	__asm
		ld	hl,#0x8000
		ret
	__endasm;
}

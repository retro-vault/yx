/*
 *	debug.c
 *	diagnostics
 *
 *	tomaz stih wed apr 3 2013
 */
#include "yx.h"

void dbg_wtox(word w, string destination) {
	byte *p;
	int i;

	byte hex[16]={'0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'};

	p=(byte *)&w;

	for(i = 0; i < 2; i++)	{
		destination[i*2] = hex[((p[1-i] >> 4) & 0x0F)];
		destination[(i*2) + 1] = hex[(p[1-i]) & 0x0F];
	}
	destination[i*2]=0;
}

void dbg_memdump(void *heap) {

	byte buff[6];
	block_t *b;

	buff[0]=0;

	lores_puts("MEMORY DUMP:\n");
	lores_puts("block owner stat data size next\n");
	lores_puts("===== ===== ==== ==== ==== ====\n");

	b=heap;
	while (b) {
	
		dbg_wtox((word)b,buff);
		lores_puts(" "); lores_puts(buff); lores_puts(" ");
		dbg_wtox((word)(b->hdr.owner),buff);
		lores_puts(" "); lores_puts(buff); lores_puts(" ");
		dbg_wtox(b->stat,buff);
		lores_puts(buff); lores_puts(" ");
		dbg_wtox((word)(b->data),buff);
		lores_puts(buff); lores_puts(" ");
		dbg_wtox((word)(b->size),buff);
		lores_puts(buff); lores_puts(" ");
		dbg_wtox((word)(b->hdr.next),buff);
		lores_puts(buff); lores_puts("\n");
		b=b->hdr.next;
	}
	 
}

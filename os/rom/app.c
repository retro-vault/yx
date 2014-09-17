/*
 *	app.c
 *	yx application 
 *
 *	tomaz stih wed sep 17 2014
 */
#include "yx.h"

word app_relocate(app_file_hdr_t *app_file_hdr) {
	word rel;
	word prog_start;
	word *entry;
	
	/* calculate program start address */
	prog_start=((word)(&(app_file_hdr->rel_table))) + 2*(app_file_hdr->rel_entries);

	/* relocate */
	for(rel=0;rel < app_file_hdr->rel_entries;rel++) {
		entry=(word *)(prog_start + app_file_hdr->rel_table[rel]);
		(*entry)=(*entry) + prog_start;
	}

	return app_file_hdr->entry_point + prog_start;
}

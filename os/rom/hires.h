/*
 *	hires.h
 *	high resolution graphics (256x192)
 *
 *	tomaz stih wed mar 20 2013
 */
#ifndef _HIRES_H
#define _HIRES_H

extern void hires_cls(
	color_t back, 
	color_t fore, 
	color_t border, 
	color_mask_t cm) __naked;
extern word hires_vmem_nextrow_addr(word addr) __naked;

#endif

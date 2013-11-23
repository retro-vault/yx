/*
 *	system.h
 *	system specifics 
 *
 *	tomaz stih wed apr 3 2013
 */
#ifndef _SYSTEM_H
#define _SYSTEM_H

/* 
 * system owner ID 
 */
#define SYS		0x0000
#define KERNEL		SYS

/* 
 * system and user heap definitison
 */
#define SYSHEAP_TOP	0x8000
#define USRHEAP_TOP	0xffff
extern word get_sysheap() __naked;
extern word get_usrheap() __naked;

#endif

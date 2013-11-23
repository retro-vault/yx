/*
 *	ukernel.c
 *	yx micro kernel header file
 *
 *	tomaz stih thu mar 21 2013
 */
#ifndef _UKERNEL_H
#define _UKERNEL_H

/* outputs */
extern void welcome();
extern void panic(string s);
extern void scheduler() __naked;

#endif

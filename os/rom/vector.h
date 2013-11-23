/*
 *	vector.h
 *	vector table
 *
 *	tomaz stih wed mar 20 2013
 */
#ifndef _VECTOR_H
#define _VECTOR_H

#define	RST08	0
#define	RST10	1
#define	RST18	2
#define	RST20	3
#define	RST28	4
#define	RST30	5
#define	RST38	6
#define NMI	7

extern void ei();
extern void di();
extern void setvect(byte vec_num, void (*handler)(), void(*initfn)());

#endif

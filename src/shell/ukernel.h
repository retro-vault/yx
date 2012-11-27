/*
 *	ukernel.h
 *
 *	micro kernel header file
 *
 */
#ifndef _UKERNEL_H
#define _UKERNEL_H

#define	RST08	0
#define	RST10	1
#define	RST18	2
#define	RST20	3
#define	RST28	4
#define	RST30	5
#define	RST38	6
#define NMI	7

extern word vec_tbl;
extern void set_vector(byte vec_num, void (*handler)(), void(*initfn)());
extern void ei();
extern void di();
extern void executive() __naked;
extern void main();
extern word api() __naked;

#endif

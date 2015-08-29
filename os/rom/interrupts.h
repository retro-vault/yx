/*
 *	interrupts.h
 *	interrupts
 *
 *	tomaz stih wed mar 20 2013
 */
#ifndef _INTERRUPTS_H
#define _INTERRUPTS_H

#include "types.h"

#define	RST08	0
#define	RST10	1
#define	RST18	2
#define	RST20	3
#define	RST28	4
#define	RST30	5
#define	RST38	6
#define NMI	7

extern void intr_enable();
extern void intr_disable();
extern void intr_set_vect(void (*handler)(), byte vec_num);

#endif /* _INTERRUPTS_H */

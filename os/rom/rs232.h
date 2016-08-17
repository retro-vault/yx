/*
 *	rs232.h
 *	serial communication
 *
 *	tomaz stih, sun sep 6 2015
 */
#ifndef _RS232_H
#define _RS232_H

#include "types.h"

/* buffer size */
#define	RS232_IBUFF_SIZE	0x14

/* for buffered input */
extern byte rs232_ibuff[];

/* raw serial functions */
extern word rs232_buffered_input(byte* buffer) __naked;
extern word rs232_putb(byte b);

#endif /* _RS232_H */

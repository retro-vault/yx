/*
 *	serial.h
 *	serial communication
 *
 *	tomaz stih sun jul 29 2012
 */
#ifndef _SERIAL_H
#define _SERIAL_H

/* buffer size */
#define	RS232_IBUFF_SIZE	0x14

/* errors */
#define RESULT_RS232_NODATA	0xe0

/* types */
typedef unsigned char byte;
typedef unsigned int word;

/* for buffered input */
extern byte rs232_ibuff[];
extern word rs232_ib_end;
extern word rs232_ib_beg;

/* stack pointer storage */
extern word rs232_sp;

/* raw serial functions */
extern word rs232_buffered_input(byte* buffer) __naked;
extern word rs232_getb(byte *b);
extern word rs232_putb(byte b);

#endif

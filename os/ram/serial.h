/*
 *	serial.h
 *	serial communication & 115.200-8-N-2
 *
 *	tomaz stih sun jul 29 2012
 */
#ifndef _SERIAL_H
#define _SERIAL_H

/* ports */
#define RS232_CTL		0xef
#define RS232_DTA		0xf7

#define	RS232_IBUFF_SIZE	0x14

/* errors */
#define RESULT_RS232_NODATA	0xe0

/* for buffered input */
extern byte rs232_ibuff[];
extern word rs232_ib_end;
extern word rs232_ib_beg;

/* stack pointer storage */
extern word rs232_sp;

/* raw serial functions */
extern word rs232_buffered_input(byte* buffer) __naked;
extern result rs232_getb(byte *b);
extern result rs232_putb(byte b);

#endif

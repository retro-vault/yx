/*
 *	serial.c
 *	serial communication
 *
 *	tomaz stih sun jul 29 2012
 */
#include "serial.h"

/* input and output buffers */
byte rs232_ibuff[RS232_IBUFF_SIZE];
word rs232_ib_beg=0;
word rs232_ib_end=0;

/* for storing stack pointer */
word rs232_sp;

word rs232_getb(byte *b) {
	/* buffer empty */
	if (rs232_ib_beg==rs232_ib_end) {
		rs232_ib_beg = 0;
		rs232_ib_end = rs232_buffered_input(rs232_ibuff);
	}
	
	if (!rs232_ib_end)	
		return 1;
	else {
		(*b) = rs232_ibuff[rs232_ib_beg];
		rs232_ib_beg++;
		return 0;
	}
}

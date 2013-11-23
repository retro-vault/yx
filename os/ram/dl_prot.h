/*
 *	dl_prot.h
 *	data link protocol implementation 
 *	
 *	tomaz stih thu jul 26 2012
 */
#ifndef _DL_PROT_H
#define _DL_PROT_H

#define DLP_FRAME_LEN	32

#define ACK		0b00000001
#define NAK		0b00000010
#define	DATA		0b00000100

typedef struct dlp_frame_hdr_s {
	byte		cmd;
} dlp_frame_hdr_t;

typedef struct dlp_frame_s {
	byte		sequence;
	byte		data[DLP_FRAME_LEN];
	word		crc16;
} dlp_frame_t;

extern word crc16(byte *buffer, word length) __naked;

#endif
/*
 *	datalink.h
 *	data link protocol
 *
 *	tomaz stih tue jul 31 2012
 */
#ifndef _DATALINK_H
#define _DATALINK_H

#define	DL_ACK			0x88
#define DL_NAK			0x11
#define DL_YOU                  0x24

#define	DL_FRAME_DLEN		32      /* frame + header + body = 32 bytes */
#define DL_IBUFFER_FRAMES       8       /* input buffer is 8 frames */

#define DL_TIMEOUT_HEADER	3
#define DL_TIMEOUT_BODY		3

typedef struct dl_ibuffer_s {
        list_header_t hdr;
        byte data[DL_FRAME_LEN];
} dl_ibuffer_t;

typedef struct dl_link_s {
        list_header_t hdr;
        dl_read_t *pending_reads;
        dl_write_t *pending_writes;
        dl_ibuffer_t *ibuffer;
} dl_link_t;

extern dl_link_t *dl_link_connect(void *owner, word ibuffer_size);
extern dl_link_t *dl_link_disconnect(dl_link_t *l);
extern dl_write(void *owner, byte *data, word size, event_t *write_done);
extern dl_read(void *owner, byte *data, word size, event_t *read_done);

typedef struct dl_frame_header_s {
	byte sequence;
	byte response;
} dl_frame_header_t;

typedef struct dl_frame_body_s {
        dl_link_t *link;                /* identifier */
	byte size;
	byte data[DL_FRAME_DLEN];
	word crc16;
} dl_frame_body_t;

extern dl_link_t *dl_link_first;        /* start of linked list of data links*/

#endif

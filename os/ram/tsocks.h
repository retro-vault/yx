/*
 *	tsocks.h
 *	tiny sockets interface is a lightweight interface enabling 
 *	zx spectrum 48K to connect to internet via interface 1 / rs232.
 *	
 *	tomaz stih thu jul 26 2012
 */
#ifndef _TSOCKS_H
#define _TSOCKS_H

/*
 *	public interface
 */

#define MAX_SBUFF_SIZE 256

typedef sockaddr_s {
	byte		ip[4];
	word		port;
} sockaddr_t;

typedef struct socket_s {
	sockaddr_t	saddr;
	byte 		obuffer[MAX_SBUFF_SIZE];
	word		ohead;
	word		otail;
	byte 		ibuffer[MAX_SBUFF_SIZE];
	word		ihead;
	word		itail;
} socket_t;

extern result connect(socket_t* s, string address, word port);
extern close(socket_t *s);
extern result send(socket_t* s, byte* buffer, word length);
extern result recv(socket_t* s, byte* buffer, word length, word *rlength);

/*
 *	private interface
 */

#define BLK_DATA_SIZE		32
 
#define	CMD_ACK			1	/* no block data */
#define CMD_NAK			2	/* no block data */
#define CMD_CONNECT		3
#define CMD_CLOSE		4	/* no block data */
#define CMD_SEND		5
#define CMD_RECV		6
#define CMD_DATA		7
 
typedef struct blk_hdr_s {
	word		owner;	/* owner id = socket address */
	byte		seq;	/* sequence counter (0..0xff) for this owner */
	byte		cmd;	/* command */
} blk_hdr_t;

typedef struct blk_data_s {
	byte		data[BLK_DATA_SIZE];
	word		crc16;	/* data + header */
} blk_data_s;

#endif
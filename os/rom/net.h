/*
 *	net.h
 *	network routines
 *
 *	tomaz stih sun sep 6 2015
 */
#ifndef _NET_H
#define _NET_H

#include "types.h"
#include "list.h"

typedef struct net_buff_s net_buff_t;
typedef struct net_block_s net_block_t;

struct net_buff_s {
	list_header_t hdr;
	byte *buffer;
	word size;
	word pos;
};

struct net_block_s {
	byte connection:4;
	byte block:4;
	byte body[14];
	byte status:4;
	byte control:4;
};

/* input and output buffer queues */
extern net_buff_t *ifirst;
extern net_buff_t *ofirst;

/* burst exchange 20 bytes with the "other side" */
extern void net_burst();
extern byte net_connect(string address, word port);
extern void net_disconnect(byte cid);

#endif /* _NET_H */
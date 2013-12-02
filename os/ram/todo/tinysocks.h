#ifndef _TINYSOCKS_H
#define _TINYSOCKS_H

/* function codes */
#define FN_CONNECT      1
#define FN_DISCONNECT   2
#define FN_SEND	        3
#define FN_RECV         4

typedef struct ipaddr_s {
	byte		ip[4];
	word		port;
} ipaddr_t;

typedef struct connection_s {
        byte            id;             /* remote connection identifier */
	ipaddr_t	ipaddr;         /* address (nice to have) */
} connection_t;

typedef struct rpc_s {
        byte            fn;
} rpc_t;

extern connection_t *connect(ipaddr_t *addr);
extern void disconnect(connection_t *c);

extern byte send(connection_t* c, byte* buffer, word length);
extern byte recv(connection_t* c, byte* buffer, word length, word *rlength);

#endif // _TINYSOCKS_H

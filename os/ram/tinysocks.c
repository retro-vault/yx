#include "main.h"

connection_t *connect(ipaddr_t *addr) {
        rpc_t rpc;
        rpc.fn=FN_CONNECT;
        /* pack 6 bytes of addr */

}

void disconnect(connection_t *c) {
        rpc_t rpc;
        rpc.fn=FN_DISCONNECT;
}

byte send(connection_t* c, byte* buffer, word length) {
        rpc_t rpc;
        rpc.fn=FN_SEND;
}

byte recv(connection_t* c, byte* buffer, word length, word *rlength) {
        rpc_t rpc;
        rpc.fn=FN_RECV;
}

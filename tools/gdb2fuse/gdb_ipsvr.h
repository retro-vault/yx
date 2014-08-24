#ifndef _GDB_IPSVR_H
#define _GDB_IPSVR_H

#include <sys/socket.h>
#include <sys/types.h>
#include <arpa/inet.h>
#include <sys/ioctl.h>
#include <unistd.h>

#include <cstdio>
#include <cstring>
#include <cstdlib>
#include <iostream>

using namespace std;

class gdb_ipsvr
{
    public:
        static gdb_ipsvr* create(char *sport);
        virtual ~gdb_ipsvr();
        int write(const char *buffer, int len);
        int read(char *buffer, int len);
    protected:
    private:
        gdb_ipsvr() : port(9999), list_sock(0), conn_sock(0) {}
        short int port;
        int list_sock;
        int conn_sock;
};

#endif // _GDB_IPSVR_H

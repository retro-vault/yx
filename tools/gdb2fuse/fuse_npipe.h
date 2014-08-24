#ifndef _FUSE_NPIPE_H
#define _FUSE_NPIPE_H

#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <iostream>

class fuse_npipe
{
    public:
        virtual ~fuse_npipe();
        static fuse_npipe* create(char *ifname, char *ofname);
        int write(char* buffer, int len);
        int read(char *buffer, int len);
    private:
        int ihandle, ohandle;
        int escaped;
        fuse_npipe() : ihandle(0), ohandle(0), escaped(0) { }
        int readbyte();
};

#endif // _FUSE_NPIPE_H

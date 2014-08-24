#ifndef _APP_H
#define _APP_H

#include <string>

#include "fuse_npipe.h"
#include "gdb_ipsvr.h"

using namespace std;

class app
{
    public:
        app();
        virtual ~app();

        void run(int argc, char *argv[]);
        void usage();
        void error(const string& msg, int code);

        enum { BUFSIZE = 64 }; // Enum hack.
};

#endif // _APP_H

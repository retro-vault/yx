#include <iostream>
#include <cstdio>

#include "app.h"

using namespace std;

app::app()
{
    cout << "gdb2fuse 1.0" << endl;
}

app::~app()
{
    cout << "bye." << endl;
}

void app::run(int argc, char *argv[])
{
    if (argc!=4) { // Check number of arguments.
        usage();
        error("invalid argument(s).", 1);
    }

    cout << "initializing..." << endl;

    gdb_ipsvr* ipsvr=gdb_ipsvr::create(argv[1]);
    fuse_npipe* npipe=fuse_npipe::create(argv[2],argv[3]);

    // Talk, talk, talk...
    char buffer[BUFSIZE];
    int len=0;
    while(1) {
        if ((len=npipe->read(buffer,BUFSIZE))<0) break;     // Read named pipe.
        if (len>0) ipsvr->write(buffer,len);                // Write ip.
        if ((len=ipsvr->read(buffer,BUFSIZE))<0) break;     // Read ip.
        if (len>0) npipe->write(buffer,len);                // Write named pipe.
    }

    // If we are here / we have an error.
    if (len==-1)
        cout << "connection closed..." << endl;
    else
        cout << "fatal error..." << endl;
}

void app::usage() {
    cout << "usage: gdb2fuse <port> <rxfile> <txfile>" << endl;
    cout << "       <port>   ... ip port number to listen (i.e. 8080)" << endl;
    cout << "       <rxfile> ... input named pipe file" << endl;
    cout << "       <txfile> ... toutput named pipe file" << endl;
}

void app::error(const string& msg, int code)
{
    cerr << "error: " << msg << endl;
    exit(code);
}

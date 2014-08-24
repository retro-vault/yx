#include "main.h"

using namespace std;

app *gdb2fuse;

int main(int argc, char *argv[])
{
    atexit(handle_exit);
    gdb2fuse = new app();
    gdb2fuse->run(argc, argv);
    return 0;
}

void handle_exit (void)
{
    delete gdb2fuse;
}

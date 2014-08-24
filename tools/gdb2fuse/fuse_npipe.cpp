#include "fuse_npipe.h"

using namespace std;

fuse_npipe* fuse_npipe::create(char *ifname, char *ofname) {

    cout << "opening named pipes..." << endl;

    // for writing first!
    cout << "\topening " << ofname << " for writing" << endl;
    int output=open(ofname,O_WRONLY);
    if (output==-1) { // error.
        cout << "\t\terror" << endl;
        return nullptr;
    } else
        cout << "\t\tok" << endl;

    // open file for reading, block.
    cout << "\topening " << ifname << " for reading" << endl;
    int input=open(ifname, O_RDONLY);
    if (input==-1) {
        cout << "\t\terror" << endl;
        close(output); // already opened.
        return nullptr; // error.
    } else
        cout << "\t\tok" << endl;

    // set as non-blocking for read commands.
    fcntl(input, F_SETFL,
        fcntl(input, F_GETFL)
        | O_NONBLOCK);
    cout << "\t\tset " << ifname << " to non-blocking mode" << endl;

    // if everything cool then create fuse_npipe and pass handles.
    fuse_npipe* fnp=new fuse_npipe();
    fnp->ihandle=input;
    fnp->ohandle=output;

    return fnp;
}

fuse_npipe::~fuse_npipe()
{
    // Close all pipe handles.
    cout << "closing named pipes" << endl;
    if (ihandle!=0) close(ihandle);
    if (ohandle!=0) close(ohandle);
}

int fuse_npipe::readbyte() {
    int b=0;
    int n=::read(ihandle,&b,1);
    if (n==0) { // pipe not opened on the other side
        return -2;
    } else if (n==EAGAIN) { // data not available
        return -1;
    } else if (n==1) { // success
        return b;
    } else { // error
        return -3;
    }
}

int fuse_npipe::read(char *buffer, int len) {
    int b=0;
    int n=0;
    while (n < len && b >= 0) {
        int result=readbyte();
        switch(result) {
        case -3: // No more data avail. -3
            return n;
        case -2: // Pipe closed.
            if (n==0)
                return -1; // No data.
            else
                return n; // Last data.
            break;
        default:
            if (escaped) {
                if ((char)b=='*') buffer[n]=0;
                n++;
            } else if (result==0) {
                escaped=1;
            } else {
                buffer[n]=result;
                n++;
            }
        }
    }
    return n;
}

int fuse_npipe::write(char* buffer,int len) {
    static char esc0='*';
    char b;
    int n=0;
    int result;
    while (n<len) {
        b=buffer[n];
        if ((result=::write(ohandle,&b,1))!=1) { // error.
            if (n==0) return -1; else return n;
        }
        if (b==0) // escape it
            if ((result=::write(ohandle,&esc0,1))!=1) { // error.
                if (n==0) return -1; else return n;
            }
        n++;
    }
    return n;
}

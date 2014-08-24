#include "gdb_ipsvr.h"

gdb_ipsvr* gdb_ipsvr::create(char *sport) {

    int list_s, conn_s;
    short int port;
    struct sockaddr_in servaddr;
    int imode=1;

    cout << "configuring tcp/ip server..." << endl;
    port = atol(sport);

    // create socket
    cout << "\tcreating socket, port=" << port << endl;
    if ( (list_s = socket(AF_INET, SOCK_STREAM, 0)) < 0 ) {
        cout << "\t\terror" << endl;
        return nullptr;
    } else
        cout << "\t\tok" << endl;

    // bind socket
    memset(&servaddr, 0, sizeof(servaddr));
    servaddr.sin_family      = AF_INET;
    servaddr.sin_addr.s_addr = htonl(INADDR_ANY);
    servaddr.sin_port        = htons(port);
    cout << "\tbinding socket" << endl;
    if ( bind(list_s, (struct sockaddr *) &servaddr, sizeof(servaddr)) < 0 ) {
        cout << "\t\terror" << endl;
        close(list_s);
        return nullptr;
    } else
        cout << "\t\tok" << endl;

    cout << "\tentering listening mode" << endl;
    if ( listen(list_s, 1) < 0 ) {
	cout << "\t\terror" << endl;
        close(list_s);
        return nullptr;
    } else
        cout << "\t\tok" << endl;

    cout << "\twaiting for connection" << endl;
    if ( (conn_s = accept(list_s, NULL, NULL) ) < 0 ) {
	cout << "\t\terror" << endl;
        close(list_s);
        return nullptr;
    } else
        cout << "\t\tok" << endl;

    cout << "\tset non-blocking mode" << endl;
    ioctl(conn_s, FIONBIO, &imode);

    // if everything cool then create fuse_npipe and pass.
    gdb_ipsvr* gisvr=new gdb_ipsvr();
    gisvr->port=port;
    gisvr->list_sock=list_s;
    gisvr->conn_sock=conn_s;
    return gisvr;
}

gdb_ipsvr::~gdb_ipsvr()
{
    // Close all pipe handles.
    cout << "closing server socket" << endl;
    ::close(list_sock);
    ::close(conn_sock);
}


int gdb_ipsvr::write(const char *buffer, int len) {
    int nleft;
    int nwritten;
    const char *pbuff;

    pbuff = buffer;
    nleft  = len;

    while ( nleft > 0 ) {
        if ( (nwritten = ::write(conn_sock, pbuff, nleft)) <= 0 ) {
                return -1;
        }
        nleft -= nwritten;
        pbuff += nwritten;
    }

    return len;
}

int gdb_ipsvr::read(char *buffer, int len) {
    int n, rc;
    char c, *pbuff;

    pbuff = buffer;

    for ( n = 1; n < len; n++ ) {

        if ( (rc = ::read(conn_sock, &c, 1)) == 1 ) {
            *pbuff++ = c;
        }
        else {
            if ( rc == 0 ) {
                if ( n == 1 )
                    return -1; // Closed socket, no data.
                else
                    break; // Closed socket in the middle of read. Don't lose data.
            }
            else {
                if ( errno == EAGAIN ) // No data.
                    break;
                return -2; // Other error.
            }
        }
    }
    return n-1;
}

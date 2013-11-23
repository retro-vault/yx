// Compile with
// gcc -o specput specput.c

#include <stdio.h>	/* Standard input/output definitions */
#include <stdlib.h>	/* Standard library */
#include <string.h>	/* String function definitions */
#include <unistd.h>	/* UNIX standard function definitions */
#include <fcntl.h>	/* File control definitions */
#include <errno.h>	/* Error number definitions */
#include <termios.h>	/* POSIX terminal control definitions */
#include <sys/ioctl.h>

/* Convenience macros for the flush cmd argument */
#define FLUSH_IN   0
#define FLUSH_OUT  1
#define FLUSH_BOTH 2

int open_port(char *device)
{
	int fd;
	struct termios options;

	fd = open(device, O_RDWR | O_NOCTTY | O_NDELAY);
	if (fd != -1) { /* Configure port */
		fcntl(fd, F_SETFL, 0);
		tcgetattr(fd, &options);

		/* Baud rate for input and output is 2400, doesn't work faster */
		cfsetispeed(&options, B2400);
		cfsetospeed(&options, B2400);

		options.c_cflag &= ~PARENB; /* No parity */
		options.c_cflag &= ~CSTOPB; /* One stop bit */
		options.c_cflag &= ~CSIZE; /* Mask char size bits */
		options.c_cflag |= CS8; /* 8 bit */
		options.c_cflag |= CRTSCTS; /*switch off CTS/RTS handshake */
		options.c_oflag &= ~OPOST; /* Raw */

		/* Apply settings now! */
		tcsetattr(fd, TCSANOW, &options);
	}
	return (fd);
}

/* Send bytes using manual CTS/RTS */
void sendbytes(int fd, void *bytes, int len, int logging) {
	
	register int count=0;
	if (logging) printf("sending data...\n");
	while (len--) {
		write(fd,bytes++,1);
	}

	if(logging) printf("complete\n");
}

int main(int argc, char **argv) {

	// Check arguments
	if (argc!=4) {
		printf("usage: specput <device> <file> <addr>\n");
		return 1;
	}
	
	int fd=open_port(argv[1]);
	if (fd==-1) {
		printf("unable to open device %s\n",argv[1]);
		return 2;
	}

	/* Get the file */	
	unsigned short datalen;	
	struct stat st;
	stat(argv[2], &st);
	datalen = st.st_size;
	unsigned char *pblock=malloc(datalen);
	int ofd=open(argv[2], O_RDONLY|O_SYNC);
	int bytes=read(ofd,(void *)pblock,datalen);
	printf("Read file %s\n",argv[2]);
	close(ofd);

	/* Get load address */
	short int addr=atoi(argv[3]);
	printf ("Load address is %d, file length is %d\n",addr, bytes);

	/* File type is 3 (code) */
	unsigned char type=3;
	printf("Sending file type CODE\n");
	sendbytes(fd,(void *)&type,1,0);

	/* Send data len */
	printf("Sending file len %d\n",datalen);
	sendbytes(fd,(void *)&datalen,2,0);

	/* Send two parameters */
	unsigned short par1=addr,par2=65535;
	printf("Sending par1 (%d) and par2 (%d)\n",par1, par2);
	sendbytes(fd,(void *)&par1,2,0);
	sendbytes(fd,(void *)&par2,2,0);

	/* Don't know what to think of this one ... */
	unsigned short dummy=0;
	sendbytes(fd,(void *)&dummy,2,0);

	/* and file... */
	sendbytes(fd,pblock,datalen,1);

	printf("Sent bytes %d\n",bytes);

	/* Close serial port */
	close(fd);

	/* Free memory */
	free(pblock);	

	printf("The end\n");
}

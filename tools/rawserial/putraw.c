// Compile with
// gcc -o putraw putraw.c

#include <stdio.h>	/* Standard input/output definitions */
#include <stdlib.h>	/* Standard library */
#include <string.h>	/* String function definitions */
#include <unistd.h>	/* UNIX standard function definitions */
#include <fcntl.h>	/* File control definitions */
#include <errno.h>	/* Error number definitions */
#include <termios.h>	/* POSIX terminal control definitions */
#include <sys/ioctl.h>

int open_port(char *device)
{
	int fd;
	struct termios options;

	fd = open(device, O_RDWR | O_NOCTTY | O_NDELAY);
	if (fd != -1) { /* Configure port */
		fcntl(fd, F_SETFL, 0);
		tcgetattr(fd, &options);

		/* Baud rate for input and output is 115200 or 57600, doesn't work faster */
		cfsetispeed(&options, B57600);
		cfsetospeed(&options, B57600);

		options.c_cflag &= ~PARENB; /* No parity */
		options.c_cflag |= CSTOPB; /* Two stop bits! */
		options.c_cflag &= ~CSIZE; /* Mask char size bits */
		options.c_cflag |= CRTSCTS; /* Enable rts cts */
		options.c_cflag |= CS8; /* 8 bit */
		options.c_oflag &= ~OPOST; /* Raw */

		/* Apply settings now! */
		tcsetattr(fd, TCSANOW, &options);
	}
	return (fd);
}

/* Send bytes using manual CTS/RTS */
void sendbytes(int fd, void *bytes, int len) {	
	write(fd,bytes,len);
}

int main(int argc, char **argv) {

	// Check arguments
	if (argc!=3) {
		printf("usage: putraw <device> <file>\n");
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
	printf("Read file %s, length %d\n",argv[2],bytes);
	close(ofd);

	/* and file... */
	sendbytes(fd,pblock,datalen);

	printf("Sent bytes %d\n",bytes);

	/* Close serial port */
	close(fd);

	/* Free memory */
	free(pblock);	

	printf("The end\n");
}

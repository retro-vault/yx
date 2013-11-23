// Compile with
// gcc -o specget specget.c

#include <stdio.h>	/* Standard input/output definitions */
#include <stdlib.h>	/* Standard library */
#include <string.h>	/* String function definitions */
#include <unistd.h>	/* UNIX standard function definitions */
#include <fcntl.h>	/* File control definitions */
#include <errno.h>	/* Error number definitions */
#include <termios.h>	/* POSIX terminal control definitions */

int open_port(char *device)
{
	int fd;
	struct termios options;

	fd = open(device, O_RDWR | O_NOCTTY | O_NDELAY);
	if (fd != -1) { /* Configure port */
		fcntl(fd, F_SETFL, 0);
		tcgetattr(fd, &options);

		/* Baud rate for input and output */
		cfsetispeed(&options, B2400);
		cfsetospeed(&options, B2400);

		options.c_cflag &= ~PARENB; /* No parity */
		options.c_cflag &= ~CSTOPB; /* One stop bit */
		options.c_cflag &= ~CSIZE; /* Mask char side bits */
		options.c_cflag |= CS8; /* 8 bit */
		options.c_cflag |= CRTSCTS; /* RTS CTS handshake */
		options.c_lflag &= ~(ICANON | ECHO | ECHOE | ISIG); /* Raw */

		/* Apply settings now! */
		tcsetattr(fd, TCSANOW, &options);
	}
	return (fd);
}

void read_block(int fd, void *p,int len) {
	int bytes;
	while (len) {	
		bytes=read(fd,p,len);
		p+=bytes;
		len-=bytes;
	}
}

int main(int argc, char **argv) {

	// Check arguments
	if (argc!=3) {
		printf("usage: specget <device> <file>\n");
		return 1;
	}
	
	int fd=open_port(argv[1]);
	if (fd==-1) {
		printf("unable to open device %s\n",argv[1]);
		return 2;
	}

	/* Get file type (byte 1) */
	unsigned char type;
	read(fd,&type,1);
	
	/* Get data len */
	unsigned short datalen;
	read(fd,&datalen,2);

	printf("received zx header\n\ttype=%d\n\tsize=%d\n",type,datalen);

	/* Get two parameters */
	unsigned short par1,par2;
	read(fd,&par1,2);
	read(fd,&par2,2);

	printf("parameters\n\tpar1=%d\n\tpar2=%d\n",par1,par2);

	/* and data block... */
	unsigned char *pblock=malloc(datalen);
	read_block(fd, (void*)pblock,datalen);

	int ofd=open(argv[2], O_RDWR|O_CREAT);
	write(ofd,(void *)pblock,datalen);
	close(ofd);
	printf("file saved\n");

	/* Close serial port */
	close(fd);

	/* Free memory */
	free(pblock);	
	
}

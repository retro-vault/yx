/*
 *	makezxbin.c
 *	fix for makebin to produce proper 
 *	zx spectrum ram image from .IHX
 *	(intel hex file)
 *
 *	notes:	build:	gcc -o makezxbin.exe makezxbin.c
 *			use:	makezxbin <app.ihx >app.bin
 *
 *	tomaz stih mon oct 21 2013
 */
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>

#define FILL_BYTE 0xFF

uint8_t getnibble(char **p) {
	int ret = *((*p)++) - '0';
	if (ret > 9)
		ret -= 'A' - '9' - 1;
	return ret;
}

uint8_t getbyte(char **p)
{
	return (getnibble(p) << 4) | getnibble(p);
}

int main(int argc, char **argv)
{
	int size = 65536;
	uint8_t *rom;
	char line[256];
	char *p;
	int minaddr = -1, maxaddr = -1;

	rom = malloc(size);
	if (rom == NULL) {
		fprintf(stderr, "error: couldn't allocate room for the image.\n");
		return -1;
	}

	memset(rom, FILL_BYTE, size);
	while (fgets(line, 256, stdin) != NULL) {
		int nbytes;
		int addr;
		if (*line != ':') {
			fprintf(stderr, "error: invalid IHX line.\n");
			return -2;
		}
		p = line+1;
		nbytes = getbyte(&p);
		addr = getbyte(&p)<<8 | getbyte(&p);
		getbyte(&p);

		while (nbytes--) {
			if (addr < size) {
				rom[addr++] = getbyte(&p);
				if (addr<minaddr || minaddr<0) minaddr=addr;
				if (addr>maxaddr || maxaddr<0) maxaddr=addr;
			} /* if addr < size */
		} /* while (nbytes--) */
	} /* while (fgets) */

	fwrite(&(rom[minaddr-1]), 1, maxaddr - minaddr + 1, stdout);
    
	return 0;
}
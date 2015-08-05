/*
 *	app.c
 *	application backbone
 *
 *	tomaz stih sun aug 2 2015
 */
#include "types.h"
#include "vector.h"
#include "app.h"


void sleep(int n) {
	byte i=0xff;
	while(n--)
		while(i--);
}

void squares(byte mode1, byte mode2) {
	vector_vertline(9, 9, 181, 0xaa, mode1);
	vector_vertline(245, 9, 181, 0xaa, mode1);
	vector_horzline(9,9,245,0xaa, mode1);
	vector_horzline(181,9,245,0xaa, mode1);

	vector_vertline(12, 12, 179, 0x33, mode2);
	vector_vertline(243, 12, 179, 0x33, mode2);
	vector_horzline(12,12,243,0x33, mode2);
	vector_horzline(179,12,243,0x33, mode2);
}

void main() {

	int i;
	for (i=0;i<192;i++) vector_horzline(i,0,255,0xff,MODE_XOR);

	squares(MODE_XOR, MODE_XOR);
	
	vector_horzline(10,10,25,0xaa,MODE_XOR);

	sleep(500);

	vector_horzline(10,10,25,0xaa,MODE_XOR);

	squares(MODE_XOR, MODE_XOR);

}

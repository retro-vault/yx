/*
 *	app.c
 *	backbone of yeah application
 *
 *	tomaz stih thu jul 26 2012
 */

char prev_scan[8];

extern void kbd_scan() __naked;
extern void kbd_init() __naked;

void main() {
	kbd_init();
	while(1) kbd_scan();	
}

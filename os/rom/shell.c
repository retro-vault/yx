/*
 *	shell.c
 *	micro shell
 *
 *	tomaz stih tue jun 5 2012
 */
#include "types.h"
#include "kbd.h"
#include "console.h"

char shell_get_char() {
	static byte *map=(byte *)&kbd_map; /* current map */
	byte key;
	char ch;
	
	if (key=kbd_read()) {	
		ch=map[key&0b00111111]; /* get char */
		if (key&KEY_DOWN_BIT) { /* key down */
			switch(ch) {
				case 0x01: /* symbol */
					map=(byte *)&kbd_map_symbol;
					break;
				case 0x02: /* caps */
					map=(byte *)&kbd_map_shift;
					break;
			}
			return 0; /* no key down shall be propagated */
		} else { /* key up */
			switch(ch) {
				case 0x01: /* symbol */
				case 0x02: /* caps */
					map=(byte *)&kbd_map;
					return 0;
				default:
					return ch;
			}
		}
	} else return 0; /* no keys */
}

void shell() {

	char ch[]=" ";

	con_clrscr();
	con_puts("YX OS 1.0 FOR SINCLAIR ZX SPECTRUM 48K\nREADY?\n");
	while(TRUE) {
		if (ch[0]=shell_get_char()) { /* there are keys in the buffer */
			switch(ch[0]) {
				case 0x08:
					con_back();
					break;
				case 0x0d:
					ch[0]='\n';
					con_puts(ch);
					break;
				default:
					con_puts(ch);
			}
		}
	}
}

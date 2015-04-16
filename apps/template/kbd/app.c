/*
 *	app.c
 *	backbone of yeah application
 *
 *	tomaz stih thu jul 26 2012
 */

typedef struct kbd_buff_s {
	char head;
	char tail;
	char buffer[32];
} kbd_buff_t;

kbd_buff_t kbd_buff;
char prev_scan[8];

extern void kbd_scan() __naked;
extern void kbd_init() __naked;

void test(char ch) {
	ch='A';
}

void main() {
	test('c');
	kbd_init();
	while(1) kbd_scan();	
}

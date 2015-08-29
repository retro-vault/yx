/*
 *	system.c
 *	operating system main (inc. entry point)
 *
 *	tomaz stih thu mar 21 2013
 */
#include "types.h"
#include "system.h"
#include "memory.h"
#include "interrupts.h"
#include "task.h"
#include "timer.h"
#include "keyboard.h"
#include "console.h"

void shell() {
	con_clrscr();
	con_puts("YX OS 1.0 FOR SINCLAIR ZX SPECTRUM 48K\nREADY?\n_");
	while(TRUE);
}

void fire() {
	if (kbd_buff.head>kbd_buff.tail+1) {
		con_putcharxy(100,100,kbd_buff.buffer[kbd_buff.tail]);
		kbd_buff.tail=kbd_buff.tail+1;
	}
}

void main() {

	/* 
	 * initialize operating system and user heap 
	 */
	mem_init(&sys_heap, SYS_HEAP_END - &sys_heap + 1);
	mem_init((void*)USR_HEAP_START, USR_HEAP_END - USR_HEAP_START + 1);

	/*
	 * scheduler RST38
	 */
	intr_set_vect(tsk_switch, RST38);

	/*
	 * initialize devices
	 */
	kbd_init();
	tmr_install(kbd_scan, EVERYTIME, SYS);

	/*
	 * shell, stack size=512
	 */
	tmr_install(fire, 20, SYS);
	tsk_create(shell, 512); 
}

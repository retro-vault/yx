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
#include "kbd.h"
#include "net.h"
#include "shell.h"

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
	 * install keyboard scanner
	 */
	tmr_install(kbd_scan, EVERYTIME, SYS);

	/*
	 * install network listener
	 */
	tmr_install(net_burst, EVERYTIME, SYS);

	/*
	 * shell, stack size=512
	 */
	tsk_create(shell, 512); 
}

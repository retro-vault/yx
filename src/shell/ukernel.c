/*
 *	ukernel.c
 *
 *	yeah core
 *
 */
#include "yeah.h"

void executive() __naked {

	/*
	 * we're in di mode, just call switch task
	 */
	__asm
		jp	_tsk_switch
	__endasm;
}

void supervisor() {
	/* supervisor task, does nothing at present */
	while (1==1);
}

void shell() {

	event_t *key_avail;
	char cmd[40];
	byte cmdndx;
	char ch[2];
	word handle;
	byte key;
	driver_t *d=drv_query('K','B','D');
	handle=d->open(d,NULL,0);
	key_avail=evt_create(KERNEL);

	dbg_cls();
	dbg_say("welcome to yeah\n");
	dbg_say("ready?\n_\b");

	while (1==1) { /* endless loop */

		/* read command */
		key=0;
		cmdndx=0;
		while (key!=13) {

			d->read_async(handle, &key, 1, key_avail);
			tsk_wait4events(&key_avail, 1);

			cmd[cmdndx]=key;
			cmdndx++;

			evt_set(key_avail,nonsignaled);	

			if (key!=13) {
				ch[0]=key; ch[1]=0;
				dbg_say(ch);
				dbg_say("_\b");
			} else 
				dbg_say(" \n");		

		}
		cmd[cmdndx]=0;

		/* execute command */
		if (cmd[0]=='m' && cmd[1]=='e' && cmd[2]=='m')
			dbg_memdump();
		else if (cmd[0]=='t' && cmd[1]=='a')
			dbg_taskdump();
		else if (cmd[0]=='e' && cmd[1]=='v')
			dbg_eventdump();
		else if (cmd[0]=='t' && cmd[1]=='i')
			dbg_timerdump();
		else if (cmd[0]=='c' && cmd[1]=='l')
			dbg_cls();
		else
			dbg_say("unknown command\n");

		/* and repeat */
		dbg_say("ready?\n_\b");
		
	}
}

void main() {
	
	/*
	 * ----- take over 50Hz interrupt and install api (sort of bios) -----
	 */
	set_vector(RST38,executive,NULL);

	/* 
	 * ----- initialize memory management -----
	 */
	mem_init();
	
	/* 
	 * ----- initialize device drivers -----
	 */

	/* keyboard device driver */
	drv_register('K','B','D',	
		kbd_open,
		kbd_close,
		kbd_read_async,
		NULL,
		NULL,
		kbd_timer_hook,
		NULL);

	/*
	 * ----- root task -----
	 */
	tsk_create(supervisor,1024,256);
	tsk_create(shell,1024,256);
}

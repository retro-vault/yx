/*
 *	debug.c
 *
 *	debugging
 *
 */
#include "yeah.h"

byte x=0;
byte y=23;

/* 
 * clear screen
 */
void dbg_cls() __naked {
	__asm
		;; first clear contents of vmemory		
		ld	hl,#0x4000	; vmemory
		ld	bc,#0x1800	; vmem size
		ld	(hl),l		; l = 0
		ld	d,h
		ld	e,#1
		ldir			; clear screen

		;; now the attributes
		ld	(hl),#0b00111000
		ld	bc,#0x02ff	; size of attr
		ldir

		;; and the border
		ld	a,#0b00000111	; gray border
		out	(0xfe),a	; set border

		ret
	__endasm;
}

/* disable unused arguments warning */
#pragma disable_warning 85
/*
 * print char at x, y using system font 
 */
void dbg_putc_xy(byte c, byte x, byte y) __naked {
	__asm
		ld	iy,#0x0000
		add	iy,sp	

		;; convert y to hires
		ld	b,3(iy)		; get x coordinate into b
		ld	c,4(iy)		; get y coordinate into a
		sla	c		
		sla	c		
		sla	c		; c=c*8 (hires y coordinate 0..191)

		;; calculate character inside font
		ld	a,2(iy)		; get character
		sub	#32		; a = a-32
		ld	h,#0x00		; h=0
		ld	l,a		; hl=a
		add	hl,hl		; hl=hl*2
		add	hl,hl		; hl=hl*4
		add	hl,hl		; hl=hl*8
		ld	de,#sysfont8x8	; font address
		add	hl,de		; hl=character address
		ex	de,hl		; into de
		
		;; calculate row memory address
		ld	a,c		; get y
                and	#0x07 		; leave only bits 0-2
                ld	h,a		; to high
                ld	a,c		; y back to acc.
		and	#0x38		; bits 3-5 need to be 
		rla			; shifted left
		rla			; twice
		ld	l,a		; and placed into l
                ld	a,c		; y back to acc.
		and	#0xc0		; bits 6-7
		rra			; shifted...
		rra			; ...three...
		rra			; ...times
		or	h		; ored into high
		or	#0x40		; or video memory address to h
		ld	h,a		; hl = row addr
		
		;; add x offset
		ld	a,l
		add	b		; add x to l
		jr	nc,nocarry	; no carry
		inc	h
nocarry:
		ld	l,a

		;; and now loop it
		ld	b,#8		; eight lines
loop:		ld	a,(de)		; get character byte
		inc	de		; next byte
		ld	(hl),a		; transfer to screen

		;; next line
		inc	h
		ld	a,h
		and	#7
		jr	nz,next_line
		ld	a,l
		add	a,#32
		ld	l,a
		jr	c, next_line
		ld	a,h
		sub	#8
		ld	h,a
next_line:
		djnz	loop
		
		ret

	__endasm;	
}

/*
 * scroll up 8 lines (1 char line)
 */
void dbg_scroll() __naked {
	__asm
		ld	b,#8		; 8 lines
scroll_up:	push 	bc		; store

		push 	af
		ld	a,#192		; lines to move
		ld	de,#0x4000	; start here
loopscroll:	push	de		; store de
		push	af
		
		;; calculate next line de=next_line(de)
		inc	d
		ld	a,d
		and	#7
		jr	nz,nl_done
		ld	a,e
		add	a,#32
		ld	e,a
		jr	c,nl_done
		ld	a,d
		sub	#8
		ld	d,a
nl_done:
		pop	af
		ex	de,hl		; de to hl
		pop	de		; previous line to de
		ld	bc,#32		; 32 bytes to move
		push	hl		; store new line
		ldir			; move one line
		pop	de		; restore new line to de
		dec	a		; reduce line count
		jr	z,endscroll	; is it zero?
		jr 	loopscroll
endscroll:	pop	af

		ld	hl,#0x57e0	; last line address
		ld	b,#32
clear_line:	ld	(hl),#0
		inc	hl
		djnz	clear_line
		
		pop	bc
		djnz	scroll_up	

		ret
	__endasm;
}

/*
 * print string at current x and y, manage x and y, handle newline
 */
void dbg_say(string msg) {
	while(*msg) { 
		switch(*msg) {
			case '\n':
				x=0;
				y++;
				break;
			case '\b':
				if (x>0) x--;
				break;
			default:
				dbg_putc_xy(*msg, x++, y);		
		}
		if (x>31) {
			x=0;
			y++;
		}
		if (y>23) {
			y=23;
			dbg_scroll();
		}
		msg++;	
	}
}

#ifdef DEBUG
void dbg_wtox(word w, string destination) {
	byte *p;
	int i;

	byte hex[16]={'0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'};

	p=(byte *)&w;

	for(i = 0; i < 2; i++)	{
		destination[i*2] = hex[((p[1-i] >> 4) & 0x0F)];
		destination[(i*2) + 1] = hex[(p[1-i]) & 0x0F];
	}
	destination[i*2]=0;
}

void dbg_memdump() {

	byte buff[6];
	block_t *b;

	buff[0]=0;

	dbg_say("MEMORY DUMP:\n");

	dbg_say("first last break\n");
	dbg_say("===== ==== =====\n");
	dbg_wtox((word)mem_first,buff);
	dbg_say(" "); dbg_say(buff); dbg_say(" ");
	dbg_wtox((word)mem_last,buff);
	dbg_say(buff); dbg_say(" ");
	dbg_wtox((word)brk_addr,buff);
	dbg_say(" "); dbg_say(buff); dbg_say("\n");


	dbg_say("block owner size next prev\n");
	dbg_say("===== ===== ==== ==== ====\n");

	b=mem_first;
	while (b) {
	
		dbg_wtox((word)b,buff);
		dbg_say(" "); dbg_say(buff); dbg_say(" ");
		dbg_wtox((word)b->owner,buff);
		dbg_say(" "); dbg_say(buff); dbg_say(" ");
		dbg_wtox(b->size,buff);
		dbg_say(buff); dbg_say(" ");
		dbg_wtox((word)b->next,buff);
		dbg_say(buff); dbg_say(" ");
		dbg_wtox((word)b->prev,buff);
		dbg_say(buff); dbg_say("\n");
		b=b->next;
	}
	 
}

void dbg_taskdump() {
	byte buff[6];
	task_t *t;

	buff[0]=0;

	dbg_say("TASKS:\n");
	dbg_say("task next stck state \n");
	dbg_say("==== ==== ==== ======= \n");

	t=tsk_first_running;
	while (t) {
		
		dbg_wtox((word)t,buff);
		dbg_say(buff); dbg_say(" ");
		dbg_wtox((word)t->next,buff);
		dbg_say(buff); dbg_say(" ");
		dbg_wtox((word)t->sp,buff);
		dbg_say(buff); dbg_say(" ");
		if (t->state == TASK_STATE_RUNNING)
			dbg_say("running\n");
		else
			dbg_say("waiting\n");

		t=t->next;
	}
}

void dbg_timerdump() {
	byte buff[6];
	timer_t *tmr;

	buff[0]=0;

	dbg_say("TIMERS:\n");
	dbg_say("timer tick tc   next\n");
	dbg_say("===== ==== ==== ====\n");

	tmr=tmr_first;
	while (tmr) {
		
		dbg_wtox((word)tmr,buff);
		dbg_say(" "); dbg_say(buff); dbg_say(" ");
		dbg_wtox((word)tmr->ticks,buff);
		dbg_say(buff); dbg_say(" ");
		dbg_wtox((word)tmr->_tick_count,buff);
		dbg_say(buff); dbg_say(" ");
		dbg_wtox((word)tmr->next,buff);
		dbg_say(buff); dbg_say("\n");
		
		tmr=tmr->next;
	}
}

void dbg_eventdump() {
	byte buff[6];
	event_t *e;

	buff[0]=0;

	dbg_say("EVENTS:\n");
	dbg_say("event next state\n");
	dbg_say("===== ==== =====\n");

	e=evt_first;
	while (e) {
		
		dbg_wtox((word)e,buff);
		dbg_say(" "); dbg_say(buff); dbg_say(" ");
		dbg_wtox((word)e->next,buff);
		dbg_say(buff); dbg_say(" ");
		if (e->state==signaled)
			dbg_say("signaled\n");
		else
			dbg_say("nonsignaled\n");		
				
		e = e->next;
	}
}

#endif

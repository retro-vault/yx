/*
 *	ball.h
 *	character balls demo
 *
 *	tomaz stih tue may 29 2012
 *
 */
#include "yeah.h"

event_t *b1=NULL;
event_t *b2=NULL;
event_t *done=NULL;

void timer1() {
	evt_set(b1,signaled);
}

void timer2() {
	evt_set(b2,signaled);
}

void init_balls() {
	timer_t *t;
	b1=evt_create(KERNEL);
	b2=evt_create(KERNEL);
	done=evt_create(KERNEL);
	tmr_install(timer1,0x05); 
	tmr_install(timer2,0x0a);
}

void wait(word pause) {
	int n;
	for (n=0;n<pause;n++);
}

void ball() {
	int x,y;
	int old_x, old_y;
	int dx,dy;
	
	dbg_cls();

	x=5;
	y=0;
	dx=dy=1;
	
	while (1) {
		dbg_putc_xy('o',x,y);
		old_x=x;
		old_y=y;
		x=x+dx;
		y=y+dy;
		if (x>31) { x=31; dx=-1; }
		if (x<0) { x=0; dx=1; }
		if (y>23) { y=23; dy=-1; }
		if (y<0) { y=0; dy=1; }
		tsk_wait4events(&b1,1);
		evt_set(b1,nonsignaled);
		dbg_putc_xy(' ',old_x,old_y);
	}
}

void ball2() {
	int x,y;
	int old_x, old_y;
	int dx,dy;
	
	dbg_cls();

	x=0;
	y=15;
	dx=1;
	dy=-1;
	
	while (1) {
		dbg_putc_xy('O',x,y);
		old_x=x;
		old_y=y;
		x=x+dx;
		y=y+dy;
		if (x>31) { x=31; dx=-1; }
		if (x<0) { x=0; dx=1; }
		if (y>23) { y=23; dy=-1; }
		if (y<0) { y=0; dy=1; }
		tsk_wait4events(&b2,1);
		evt_set(b2,nonsignaled);
		dbg_putc_xy(' ',old_x,old_y);
	}
}

/* 
 * without timer, calls wait(200), eats resources
 */
void ball3() {
	int x,y;
	int old_x, old_y;
	int dx,dy;
	
	dbg_cls();

	x=31;
	y=5;
	dx=1;
	dy=1;
	
	while (1) {
		dbg_putc_xy('0',x,y);
		old_x=x;
		old_y=y;
		x=x+dx;
		y=y+dy;
		if (x>31) { x=31; dx=-1; }
		if (x<0) { x=0; dx=1; }
		if (y>23) { y=23; dy=-1; }
		if (y<0) { y=0; dy=1; }
		wait(1000);
		dbg_putc_xy(' ',old_x,old_y);
	}
}

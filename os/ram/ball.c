/*
 *	ball.h
 *	character balls demo
 *
 *	tomaz stih tue may 29 2012
 *
 */
#include "yx.h"

event_t *ball_timeout;
event_t *ball2_timeout;

byte x=5,y=0;
byte old_x=5, old_y=0;
byte dx=1,dy=1;

void set_ball_timeout() {
	evt_set(ball_timeout, signaled);
}

void set_ball2_timeout() {
	evt_set(ball2_timeout, signaled);
}

void ball() {
	
	old_x=x;
	old_y=y;
	x=x+dx;
	y=y+dy;

	if (x>31) { x=31; dx=-1; }
	if (x==0) { x=0; dx=1; }
	if (y>23) { y=23; dy=-1; }
	if (y==0) { y=0; dy=1; }
	
	lores_putc_xy('o', x, y); 
	lores_putc_xy(' ', old_x, old_y);
}

void ball_task() {

	byte x=0,y=7;
	byte old_x=0, old_y=7;
	byte dx=1,dy=1;
	
	while (1) {
		old_x=x;
		old_y=y;
		x=x+dx;
		y=y+dy;
		if (x>31) { x=31; dx=-1; }
		if (x==0) { x=0; dx=1; }
		if (y>23) { y=23; dy=-1; }
		if (y==0) { y=0; dy=1; }
		lores_putc_xy('o', x, y); 
		lores_putc_xy(' ', old_x, old_y);
		tsk_wait4events(&ball_timeout, 1);  
		evt_set(ball_timeout,nonsignaled);
	}
}

void ball2_task() {

	byte x=20,y=20;
	byte old_x=0, old_y=7;
	byte dx=-1,dy=1;
	
	while (1) {
		old_x=x;
		old_y=y;
		x=x+dx;
		y=y+dy;
		if (x>31) { x=31; dx=-1; }
		if (x==0) { x=0; dx=1; }
		if (y>23) { y=23; dy=-1; }
		if (y==0) { y=0; dy=1; }
		lores_putc_xy('o', x, y); 
		lores_putc_xy(' ', old_x, old_y);
		tsk_wait4events(&ball2_timeout, 1);  
		evt_set(ball2_timeout,nonsignaled);
	}
}

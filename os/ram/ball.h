/*
 *	ball.h
 *	character balls demo
 *
 *	tomaz stih tue may 29 2012
 *
 */
#ifndef _BALL_H
#define _BALL_H

extern event_t *ball_timeout;
extern event_t *ball2_timeout;

extern void ball();
extern void ball_task();
extern void ball2_task();
extern void set_ball_timeout();
extern void set_ball2_timeout();

#endif

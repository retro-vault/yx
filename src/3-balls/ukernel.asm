;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 3.1.0 #7066 (Jun 14 2012) (Linux)
; This file was generated Tue Nov 27 20:21:18 2012
;--------------------------------------------------------
	.module ukernel
	.optsdcc -mz80
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _set_vector
	.globl _ball3
	.globl _ball2
	.globl _ball
	.globl _init_balls
	.globl _kbd_timer_hook
	.globl _kbd_read_async
	.globl _kbd_close
	.globl _kbd_open
	.globl _drv_register
	.globl _tsk_create
	.globl _executive
	.globl _main
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
;--------------------------------------------------------
;  ram data
;--------------------------------------------------------
	.area _DATA
;--------------------------------------------------------
; overlayable items in  ram 
;--------------------------------------------------------
	.area _OVERLAY
;--------------------------------------------------------
; external initialized ram data
;--------------------------------------------------------
;--------------------------------------------------------
; global & static initialisations
;--------------------------------------------------------
	.area _HOME
	.area _GSINIT
	.area _GSFINAL
	.area _GSINIT
;--------------------------------------------------------
; Home
;--------------------------------------------------------
	.area _HOME
	.area _HOME
;--------------------------------------------------------
; code
;--------------------------------------------------------
	.area _CODE
;ukernel.c:9: void executive() __naked {
;	---------------------------------
; Function executive
; ---------------------------------
_executive_start::
_executive:
;ukernel.c:16: __endasm;
	jp	_tsk_switch
_executive_end::
;ukernel.c:19: void main() {
;	---------------------------------
; Function main
; ---------------------------------
_main_start::
_main:
;ukernel.c:24: set_vector(RST38,executive,NULL);
	ld	hl,#0x0000
	push	hl
	ld	hl,#_executive
	push	hl
	ld	a,#0x06
	push	af
	inc	sp
	call	_set_vector
	pop	af
	pop	af
	inc	sp
;ukernel.c:30: mem_init();
	call	_mem_init
;ukernel.c:37: drv_register('K','B','D',	
	ld	hl,#0x0000
	push	hl
	ld	hl,#_kbd_timer_hook
	push	hl
	ld	hl,#0x0000
	push	hl
	ld	l, #0x00
	push	hl
	ld	hl,#_kbd_read_async
	push	hl
	ld	hl,#_kbd_close
	push	hl
	ld	hl,#_kbd_open
	push	hl
	ld	hl,#0x4442
	push	hl
	ld	a,#0x4B
	push	af
	inc	sp
	call	_drv_register
	ld	hl,#0x0011
	add	hl,sp
	ld	sp,hl
;ukernel.c:49: init_balls();
	call	_init_balls
;ukernel.c:50: tsk_create(ball, 1024, 256);
	ld	hl,#0x0100
	push	hl
	ld	h, #0x04
	push	hl
	ld	hl,#_ball
	push	hl
	call	_tsk_create
	pop	af
	pop	af
	pop	af
;ukernel.c:51: tsk_create(ball2, 1024, 256);
	ld	hl,#0x0100
	push	hl
	ld	h, #0x04
	push	hl
	ld	hl,#_ball2
	push	hl
	call	_tsk_create
	pop	af
	pop	af
	pop	af
;ukernel.c:52: tsk_create(ball3, 1024, 256);
	ld	hl,#0x0100
	push	hl
	ld	h, #0x04
	push	hl
	ld	hl,#_ball3
	push	hl
	call	_tsk_create
	pop	af
	pop	af
	pop	af
	ret
_main_end::
	.area _CODE
	.area _CABS

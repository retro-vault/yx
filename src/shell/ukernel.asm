;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 3.1.0 #7066 (Jun 14 2012) (Linux)
; This file was generated Tue Nov 27 20:32:56 2012
;--------------------------------------------------------
	.module ukernel
	.optsdcc -mz80
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _shell
	.globl _supervisor
	.globl _set_vector
	.globl _kbd_timer_hook
	.globl _kbd_read_async
	.globl _kbd_close
	.globl _kbd_open
	.globl _drv_query
	.globl _drv_register
	.globl _tsk_wait4events
	.globl _tsk_create
	.globl _evt_set
	.globl _evt_create
	.globl _dbg_eventdump
	.globl _dbg_timerdump
	.globl _dbg_taskdump
	.globl _dbg_memdump
	.globl _dbg_cls
	.globl _dbg_say
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
;ukernel.c:19: void supervisor() {
;	---------------------------------
; Function supervisor
; ---------------------------------
_supervisor_start::
_supervisor:
;ukernel.c:21: while (1==1);
00102$:
	jr	00102$
_supervisor_end::
;ukernel.c:24: void shell() {
;	---------------------------------
; Function shell
; ---------------------------------
_shell_start::
_shell:
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl,#-56
	add	hl,sp
	ld	sp,hl
;ukernel.c:32: driver_t *d=drv_query('K','B','D');
	ld	hl,#0x4442
	push	hl
	ld	a,#0x4B
	push	af
	inc	sp
	call	_drv_query
	pop	af
	inc	sp
;ukernel.c:33: handle=d->open(d,NULL,0);
	ld	-50 (ix),l
	ld	-49 (ix),h
	inc	hl
	inc	hl
	inc	hl
	ld	d,(hl)
	inc	hl
	ld	e,(hl)
	ld	hl,#0x0000
	push	hl
	ld	l, #0x00
	push	hl
	ld	l,-50 (ix)
	ld	h,-49 (ix)
	push	hl
	ld	l,d
	ld	h,e
	call	__sdcc_call_hl
	pop	af
	pop	af
	pop	af
	ld	-47 (ix),l
	ld	-46 (ix),h
;ukernel.c:34: key_avail=evt_create(KERNEL);
	ld	hl,#0x0100
	push	hl
	call	_evt_create
	pop	af
	ld	-2 (ix),l
	ld	-1 (ix),h
;ukernel.c:36: dbg_cls();
	call	_dbg_cls
;ukernel.c:37: dbg_say("welcome to yeah\n");
	ld	hl,#__str_0
	push	hl
	call	_dbg_say
;ukernel.c:38: dbg_say("ready?\n_\b");
	ld	hl, #__str_1
	ex	(sp),hl
	call	_dbg_say
	pop	af
;ukernel.c:40: while (1==1) { /* endless loop */
00129$:
;ukernel.c:43: key=0;
	ld	-48 (ix),#0x00
;ukernel.c:45: while (key!=13) {
	ld	a,-50 (ix)
	add	a, #0x07
	ld	-52 (ix),a
	ld	a,-49 (ix)
	adc	a, #0x00
	ld	-51 (ix),a
	ld	hl,#0x000E
	add	hl,sp
	ld	-54 (ix),l
	ld	-53 (ix),h
	ld	-43 (ix),#0x00
00104$:
	ld	a,-48 (ix)
	sub	a, #0x0D
	jp	Z,00106$
;ukernel.c:47: d->read_async(handle, &key, 1, key_avail);
	ld	l,-52 (ix)
	ld	h,-51 (ix)
	ld	d,(hl)
	inc	hl
	ld	e,(hl)
	ld	hl,#0x0008
	add	hl,sp
	ld	c,l
	ld	b,h
	ld	l,-2 (ix)
	ld	h,-1 (ix)
	push	hl
	ld	hl,#0x0001
	push	hl
	push	bc
	ld	l,-47 (ix)
	ld	h,-46 (ix)
	push	hl
	ld	l,d
	ld	h,e
	call	__sdcc_call_hl
	pop	af
	pop	af
	pop	af
	pop	af
;ukernel.c:48: tsk_wait4events(&key_avail, 1);
	ld	hl,#0x0036
	add	hl,sp
	ex	de,hl
	ld	a,#0x01
	push	af
	inc	sp
	push	de
	call	_tsk_wait4events
	pop	af
	inc	sp
;ukernel.c:50: cmd[cmdndx]=key;
	ld	a,-54 (ix)
	add	a, -43 (ix)
	ld	l,a
	ld	a,-53 (ix)
	adc	a, #0x00
	ld	h,a
	ld	a,-48 (ix)
	ld	(hl),a
;ukernel.c:51: cmdndx++;
	inc	-43 (ix)
;ukernel.c:53: evt_set(key_avail,nonsignaled);	
	ld	a,#0x00
	push	af
	inc	sp
	ld	l,-2 (ix)
	ld	h,-1 (ix)
	push	hl
	call	_evt_set
	pop	af
	inc	sp
;ukernel.c:55: if (key!=13) {
	ld	a,-48 (ix)
	sub	a, #0x0D
	jr	Z,00102$
;ukernel.c:56: ch[0]=key; ch[1]=0;
	ld	hl,#0x000B
	add	hl,sp
	ld	-56 (ix),l
	ld	-55 (ix),h
	ld	a,-48 (ix)
	ld	l,-56 (ix)
	ld	h,-55 (ix)
	ld	(hl),a
	ld	l,-56 (ix)
	ld	h,-55 (ix)
	inc	hl
	ld	(hl),#0x00
;ukernel.c:57: dbg_say(ch);
	ld	l,-56 (ix)
	ld	h,-55 (ix)
	push	hl
	call	_dbg_say
;ukernel.c:58: dbg_say("_\b");
	ld	hl, #__str_2
	ex	(sp),hl
	call	_dbg_say
	pop	af
	jp	00104$
00102$:
;ukernel.c:60: dbg_say(" \n");		
	ld	hl,#__str_3
	push	hl
	call	_dbg_say
	pop	af
	jp	00104$
00106$:
;ukernel.c:63: cmd[cmdndx]=0;
	ld	a,-43 (ix)
	add	a, -54 (ix)
	ld	l,a
	ld	a,#0x00
	adc	a, -53 (ix)
	ld	h,a
	ld	(hl),#0x00
;ukernel.c:66: if (cmd[0]=='m' && cmd[1]=='e' && cmd[2]=='m')
	ld	l,-54 (ix)
	ld	h,-53 (ix)
	ld	a,(hl)
	sub	a, #0x6D
	jr	NZ,00124$
	ld	a,-54 (ix)
	add	a, #0x01
	ld	-56 (ix),a
	ld	a,-53 (ix)
	adc	a, #0x00
	ld	-55 (ix),a
	ld	l,-56 (ix)
	ld	h,-55 (ix)
	ld	a,(hl)
	sub	a, #0x65
	jr	NZ,00124$
	ld	l,-54 (ix)
	ld	h,-53 (ix)
	inc	hl
	inc	hl
	ld	a,(hl)
	sub	a, #0x6D
	jr	NZ,00124$
;ukernel.c:67: dbg_memdump();
	call	_dbg_memdump
	jp	00125$
00124$:
;ukernel.c:68: else if (cmd[0]=='t' && cmd[1]=='a')
	ld	l,-54 (ix)
	ld	h,-53 (ix)
	ld	a,(hl)
	sub	a, #0x74
	jr	NZ,00120$
	ld	l,-54 (ix)
	ld	h,-53 (ix)
	inc	hl
	ld	a,(hl)
	sub	a, #0x61
	jr	NZ,00120$
;ukernel.c:69: dbg_taskdump();
	call	_dbg_taskdump
	jr	00125$
00120$:
;ukernel.c:70: else if (cmd[0]=='e' && cmd[1]=='v')
	ld	l,-54 (ix)
	ld	h,-53 (ix)
	ld	a,(hl)
	sub	a, #0x65
	jr	NZ,00116$
	ld	l,-54 (ix)
	ld	h,-53 (ix)
	inc	hl
	ld	a,(hl)
	sub	a, #0x76
	jr	NZ,00116$
;ukernel.c:71: dbg_eventdump();
	call	_dbg_eventdump
	jr	00125$
00116$:
;ukernel.c:72: else if (cmd[0]=='t' && cmd[1]=='i')
	ld	l,-54 (ix)
	ld	h,-53 (ix)
	ld	a,(hl)
	sub	a, #0x74
	jr	NZ,00112$
	ld	l,-54 (ix)
	ld	h,-53 (ix)
	inc	hl
	ld	a,(hl)
	sub	a, #0x69
	jr	NZ,00112$
;ukernel.c:73: dbg_timerdump();
	call	_dbg_timerdump
	jr	00125$
00112$:
;ukernel.c:74: else if (cmd[0]=='c' && cmd[1]=='l')
	ld	l,-54 (ix)
	ld	h,-53 (ix)
	ld	a,(hl)
	sub	a, #0x63
	jr	NZ,00108$
	ld	l,-54 (ix)
	ld	h,-53 (ix)
	inc	hl
	ld	a,(hl)
	sub	a, #0x6C
	jr	NZ,00108$
;ukernel.c:75: dbg_cls();
	call	_dbg_cls
	jr	00125$
00108$:
;ukernel.c:77: dbg_say("unknown command\n");
	ld	hl,#__str_4
	push	hl
	call	_dbg_say
	pop	af
00125$:
;ukernel.c:80: dbg_say("ready?\n_\b");
	ld	hl,#__str_1
	push	hl
	call	_dbg_say
	pop	af
	jp	00129$
_shell_end::
__str_0:
	.ascii "welcome to yeah"
	.db 0x0A
	.db 0x00
__str_1:
	.ascii "ready?"
	.db 0x0A
	.ascii "_"
	.db 0x08
	.db 0x00
__str_2:
	.ascii "_"
	.db 0x08
	.db 0x00
__str_3:
	.ascii " "
	.db 0x0A
	.db 0x00
__str_4:
	.ascii "unknown command"
	.db 0x0A
	.db 0x00
;ukernel.c:85: void main() {
;	---------------------------------
; Function main
; ---------------------------------
_main_start::
_main:
;ukernel.c:90: set_vector(RST38,executive,NULL);
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
;ukernel.c:95: mem_init();
	call	_mem_init
;ukernel.c:102: drv_register('K','B','D',	
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
;ukernel.c:114: tsk_create(supervisor,1024,256);
	ld	hl,#0x0100
	push	hl
	ld	h, #0x04
	push	hl
	ld	hl,#_supervisor
	push	hl
	call	_tsk_create
	pop	af
	pop	af
	pop	af
;ukernel.c:115: tsk_create(shell,1024,256);
	ld	hl,#0x0100
	push	hl
	ld	h, #0x04
	push	hl
	ld	hl,#_shell
	push	hl
	call	_tsk_create
	pop	af
	pop	af
	pop	af
	ret
_main_end::
	.area _CODE
	.area _CABS

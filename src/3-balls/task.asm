;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 3.1.0 #7066 (Jun 14 2012) (Linux)
; This file was generated Tue Nov 27 20:21:23 2012
;--------------------------------------------------------
	.module task
	.optsdcc -mz80
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _di
	.globl _ei
	.globl _tmr_chain
	.globl _mem_allocate
	.globl _lst_delete
	.globl _lst_insert
	.globl _tsk_first_waiting
	.globl _tsk_first_running
	.globl _tsk_current
	.globl _tsk_create
	.globl _tsk_wait4events
	.globl _tsk_roundrobin
	.globl _tsk_switch
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
;--------------------------------------------------------
;  ram data
;--------------------------------------------------------
	.area _DATA
_tsk_current::
	.ds 2
_tsk_first_running::
	.ds 2
_tsk_first_waiting::
	.ds 2
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
;task.c:10: task_t *tsk_current=NULL;
	ld	iy,#_tsk_current
	ld	0 (iy),#0x00
	ld	1 (iy),#0x00
;task.c:13: task_t *tsk_first_running=NULL;
	ld	iy,#_tsk_first_running
	ld	0 (iy),#0x00
	ld	1 (iy),#0x00
;task.c:14: task_t *tsk_first_waiting=NULL;
	ld	iy,#_tsk_first_waiting
	ld	0 (iy),#0x00
	ld	1 (iy),#0x00
;--------------------------------------------------------
; Home
;--------------------------------------------------------
	.area _HOME
	.area _HOME
;--------------------------------------------------------
; code
;--------------------------------------------------------
	.area _CODE
;task.c:24: task_t * tsk_create(void (*entry_point)(), uint16_t heap_size, uint16_t stack_size) {
;	---------------------------------
; Function tsk_create
; ---------------------------------
_tsk_create_start::
_tsk_create:
	push	ix
	ld	ix,#0
	add	ix,sp
	push	af
;task.c:30: t=(task_t *)lst_insert((list_header_t **)&tsk_first_running, sizeof(task_t), KERNEL);
	ld	de,#_tsk_first_running
	ld	hl,#0x0100
	push	hl
	ld	hl,#0x000C
	push	hl
	push	de
	call	_lst_insert
	pop	af
	pop	af
	pop	af
	ld	c,l
	ld	b,h
;task.c:31: if (!t) {
	ld	a,b
	or	a,c
	jr	NZ,00105$
;task.c:32: last_error=RESULT_NO_MEMORY_LEFT;
	ld	hl,#_last_error + 0
	ld	(hl), #0x02
;task.c:33: t=NULL;
	ld	bc,#0x0000
	jp	00106$
00105$:
;task.c:35: stack=mem_allocate(stack_size,(word)t); 
	ld	l,c
	ld	h,b
	push	bc
	push	hl
	ld	l,8 (ix)
	ld	h,9 (ix)
	push	hl
	call	_mem_allocate
	pop	af
	pop	af
	pop	bc
	ex	de,hl
;task.c:36: if (!stack) {
	ld	a,d
	or	a,e
	jr	NZ,00102$
;task.c:37: lst_delete((list_header_t **)&tsk_first_running, (list_header_t *)t, 1); /* was allocated so free it. */
	ld	de,#_tsk_first_running
	ld	a,#0x01
	push	af
	inc	sp
	push	bc
	push	de
	call	_lst_delete
	pop	af
	pop	af
	inc	sp
;task.c:38: last_error=RESULT_NO_MEMORY_LEFT;
	ld	hl,#_last_error + 0
	ld	(hl), #0x02
;task.c:39: t=NULL;
	ld	bc,#0x0000
	jr	00106$
00102$:
;task.c:41: t->wait=NULL;
	ld	hl,#0x0006
	add	hl,bc
	xor	a, a
	ld	(hl), a
	inc	hl
	ld	(hl), a
;task.c:42: t->state=TASK_STATE_RUNNING;
	ld	hl,#0x0009
	add	hl,bc
	ld	(hl),#0x00
;task.c:43: t->heap_size=heap_size;
	ld	hl,#0x000A
	add	hl,bc
	ld	a,6 (ix)
	ld	(hl),a
	inc	hl
	ld	a,7 (ix)
	ld	(hl),a
;task.c:46: t->sp=(word)stack + stack_size - CONTEXT_SIZE;
	ld	iy,#0x0004
	add	iy, bc
	ld	a,e
	add	a, 8 (ix)
	ld	e,a
	ld	a,d
	adc	a, 9 (ix)
	ld	d,a
	ld	a,e
	add	a,#0xEA
	ld	-2 (ix),a
	ld	a,d
	adc	a,#0xFF
	ld	-1 (ix),a
	ld	a,-2 (ix)
	ld	0 (iy),a
	ld	a,-1 (ix)
	ld	1 (iy),a
;task.c:49: ret_addr=t->sp + CONTEXT_SIZE - 2;
	ld	hl,#0xFFFFFFFE
	add	hl,de
;task.c:50: (*ret_addr)=(word)entry_point;	
	ld	d,4 (ix)
	ld	e,5 (ix)
	ld	(hl),d
	inc	hl
	ld	(hl),e
;task.c:52: last_error=RESULT_SUCCESS; 
	ld	hl,#_last_error + 0
	ld	(hl), #0x00
00106$:
;task.c:55: return t;
	ld	l,c
	ld	h,b
	ld	sp,ix
	pop	ix
	ret
_tsk_create_end::
;task.c:61: result tsk_wait4events(event_t **e, byte num_events) {
;	---------------------------------
; Function tsk_wait4events
; ---------------------------------
_tsk_wait4events_start::
_tsk_wait4events:
	push	ix
	ld	ix,#0
	add	ix,sp
;task.c:64: di();
	call	_di
;task.c:67: tsk_current->wait=e;
	ld	hl,(_tsk_current)
	ld	bc,#0x0006
	add	hl,bc
	ld	a,4 (ix)
	ld	(hl),a
	inc	hl
	ld	a,5 (ix)
	ld	(hl),a
;task.c:68: tsk_current->num_events=num_events;
	ld	hl,(_tsk_current)
	ld	bc,#0x0008
	add	hl,bc
	ld	a,6 (ix)
	ld	(hl),a
;task.c:69: tsk_current->state = TASK_STATE_WAITING;
	ld	hl,(_tsk_current)
	ld	bc,#0x0009
	add	hl,bc
	ld	(hl),#0x01
;task.c:72: lst_delete((list_header_t **)&tsk_first_running, (list_header_t *)tsk_current, 0);
	ld	bc,(_tsk_current)
	ld	de,#_tsk_first_running
	ld	a,#0x00
	push	af
	inc	sp
	push	bc
	push	de
	call	_lst_delete
	pop	af
	pop	af
	inc	sp
;task.c:73: tsk_current->next=tsk_first_waiting;
	ld	hl,(_tsk_current)
	ld	iy,#_tsk_first_waiting
	ld	a,0 (iy)
	ld	(hl),a
	inc	hl
	ld	a,1 (iy)
	ld	(hl),a
;task.c:74: tsk_first_waiting=tsk_current;
	ld	a,(#_tsk_current + 0)
	ld	(#_tsk_first_waiting + 0),a
	ld	a,(#_tsk_current + 1)
	ld	(#_tsk_first_waiting + 1),a
;task.c:77: tsk_switch();
	call	_tsk_switch
;task.c:80: ei();
	call	_ei
;task.c:82: return last_error=RESULT_SUCCESS;
	ld	hl,#_last_error + 0
	ld	(hl), #0x00
	ld	l,#0x00
	pop	ix
	ret
_tsk_wait4events_end::
;task.c:90: void tsk_roundrobin() {
;	---------------------------------
; Function tsk_roundrobin
; ---------------------------------
_tsk_roundrobin_start::
_tsk_roundrobin:
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl,#-5
	add	hl,sp
	ld	sp,hl
;task.c:97: curr=tsk_first_waiting;
	ld	iy,#_tsk_first_waiting
	ld	a,0 (iy)
	ld	-3 (ix),a
	ld	a,1 (iy)
	ld	-2 (ix),a
;task.c:98: while (curr) {
00105$:
	ld	a,-2 (ix)
	or	a,-3 (ix)
	jp	Z,00107$
;task.c:99: found=NULL;
	ld	bc,#0x0000
;task.c:100: for (n=0;n < curr->num_events && !found;n++)
	ld	a,-3 (ix)
	add	a, #0x06
	ld	l,a
	ld	a,-2 (ix)
	adc	a, #0x00
	ld	h,a
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
	ld	a,-3 (ix)
	add	a, #0x08
	ld	-5 (ix),a
	ld	a,-2 (ix)
	adc	a, #0x00
	ld	-4 (ix),a
	ld	-1 (ix),#0x00
00116$:
	ld	l,-5 (ix)
	ld	h,-4 (ix)
	ld	a,-1 (ix)
	sub	a,(hl)
	jr	NC,00119$
	ld	a,b
	or	a,c
	jr	NZ,00119$
;task.c:101: if (((curr->wait)[n])->state==signaled)
	ld	l,-1 (ix)
	ld	h,#0x00
	add	hl, hl
	add	hl,de
	ld	a,(hl)
	inc	hl
	ld	h,(hl)
	ld	l,a
	inc	hl
	inc	hl
	inc	hl
	inc	hl
	ld	a,(hl)
	sub	a, #0x01
	jr	NZ,00118$
;task.c:102: found=curr;
	ld	c,-3 (ix)
	ld	b,-2 (ix)
00118$:
;task.c:100: for (n=0;n < curr->num_events && !found;n++)
	inc	-1 (ix)
	jr	00116$
00119$:
;task.c:103: curr=curr->next;
	ld	l,-3 (ix)
	ld	h,-2 (ix)
	ld	a,(hl)
	ld	-3 (ix),a
	inc	hl
	ld	a,(hl)
	ld	-2 (ix),a
;task.c:105: if (found) { /* move to running list */
	ld	a,b
	or	a,c
	jp	Z,00105$
;task.c:106: lst_delete((list_header_t **)&tsk_first_waiting, (list_header_t *)found, 0);
	ld	-5 (ix),c
	ld	-4 (ix),b
	ld	de,#_tsk_first_waiting
	push	bc
	ld	a,#0x00
	push	af
	inc	sp
	ld	l,-5 (ix)
	ld	h,-4 (ix)
	push	hl
	push	de
	call	_lst_delete
	pop	af
	pop	af
	inc	sp
	pop	bc
;task.c:107: found->next=tsk_first_running;
	ld	l,c
	ld	h,b
	ld	iy,#_tsk_first_running
	ld	a,0 (iy)
	ld	(hl),a
	inc	hl
	ld	a,1 (iy)
	ld	(hl),a
;task.c:108: found->state = TASK_STATE_RUNNING;
	ld	hl,#0x0009
	add	hl,bc
	ld	(hl),#0x00
;task.c:109: tsk_first_running=found;
	ld	0 (iy),c
	ld	1 (iy),b
	jp	00105$
00107$:
;task.c:114: if (tsk_first_running==NULL) return; /* no running tasks yet */
	ld	iy,#_tsk_first_running
	ld	a,1 (iy)
	or	a,0 (iy)
	jr	Z,00120$
;task.c:117: if (tsk_current==NULL || 
	ld	iy,#_tsk_current
	ld	a,1 (iy)
	or	a,0 (iy)
	jr	Z,00110$
;task.c:118: tsk_current->state==TASK_STATE_WAITING || 
	ld	hl,(_tsk_current)
	ld	bc,#0x0009
	add	hl,bc
	ld	a,(hl)
	sub	a, #0x01
	jr	Z,00110$
;task.c:119: tsk_current->next==NULL) 
	ld	hl,(_tsk_current)
	ld	d,(hl)
	inc	hl
	ld	a, (hl)
	or	a,d
	jr	NZ,00111$
00110$:
;task.c:120: tsk_current=tsk_first_running;
	ld	a,(#_tsk_first_running + 0)
	ld	(#_tsk_current + 0),a
	ld	a,(#_tsk_first_running + 1)
	ld	(#_tsk_current + 1),a
	jr	00120$
00111$:
;task.c:122: tsk_current=tsk_current->next;
	ld	hl,(_tsk_current)
	ld	a,(hl)
	ld	iy,#_tsk_current
	ld	0 (iy),a
	inc	hl
	ld	a,(hl)
	ld	1 (iy),a
00120$:
	ld	sp,ix
	pop	ix
	ret
_tsk_roundrobin_end::
;task.c:129: void tsk_switch() __naked {
;	---------------------------------
; Function tsk_switch
; ---------------------------------
_tsk_switch_start::
_tsk_switch:
;task.c:181: __endasm;
;;	store registers
	push	af
	push	bc
	push	de
	push	hl
	push	ix
	push	iy
;;	store alternative registers
	ex	af,af'
	exx
	push	af
	push	bc
	push	de
	push	hl
;;	store stack pointer
	ld	iy,#_tsk_current ; address of tsk_current to iy
	ld	l,(iy) ; value of tsk_current to hl
	ld	h,1(iy)
	ld	a,l ; is tsk_current==(word)0?
	or	h
	jr	z,no_tsk_current ; no tsk_current, don't store sp
	ex	de,hl ; store value of tsk_current to de
	ld	hl,#0 ; value of sp to hl
	add	hl,sp
	ex	de,hl ; de=sp, hl=value of tsk_current
	inc	hl ; mote to 4th word of task_t structure
	inc	hl
	inc	hl
	inc	hl
	ld	(hl),e ; store sp there
	inc	hl
	ld	(hl),d
	jr	has_tsk_current
;;	there is no current task
;;	clean stack and return
	no_tsk_current:
	ld	hl,#0
	add	hl,sp
	ld	d,#0
	ld	e,#20
	sbc	hl,de
	ld	sp,hl
	has_tsk_current:
;task.c:183: tmr_chain(); /* call timer hooks (mostly device drivers) */
	call	_tmr_chain
;task.c:184: tsk_roundrobin(); /* round robin to next task */
	call	_tsk_roundrobin
;task.c:228: __endasm;
;;	restore stack pointer
	ld	iy,#_tsk_current
	ld	l,(iy)
	ld	h,1(iy)
	ld	a,h
	or	l ; tsk_current==(word)0?
	jr	z,end_switch
	inc	hl
	inc	hl
	inc	hl
	inc	hl
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
	ex	de,hl
	ld	sp,hl
;;	restore alternate registers
	pop	hl
	pop	de
	pop	bc
	pop	af
;;	restore registers
	ex	af,af'
	exx
	pop	iy
	pop	ix
	pop	hl
	pop	de
	pop	bc
	pop	af
	end_switch:
	ei
	reti
_tsk_switch_end::
	.area _CODE
	.area _CABS

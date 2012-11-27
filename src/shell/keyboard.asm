;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 3.1.0 #7066 (Jun 14 2012) (Linux)
; This file was generated Tue Nov 27 20:33:03 2012
;--------------------------------------------------------
	.module keyboard
	.optsdcc -mz80
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _kbd_scan
	.globl _kbd_get_key
	.globl _evt_set
	.globl _mem_free
	.globl _mem_allocate
	.globl _sym_kbd_map
	.globl _caps_kbd_map
	.globl _kbd_map
	.globl _kbd_lastkey
	.globl _kbd_buff_tail
	.globl _kbd_buff_head
	.globl _kbd_buffer
	.globl _kbd_exclusive_handle
	.globl _kbd_open
	.globl _kbd_close
	.globl _kbd_read_async
	.globl _kbd_timer_hook
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
;--------------------------------------------------------
;  ram data
;--------------------------------------------------------
	.area _DATA
_kbd_exclusive_handle::
	.ds 2
_kbd_buffer::
	.ds 32
_kbd_buff_head::
	.ds 1
_kbd_buff_tail::
	.ds 1
_kbd_lastkey::
	.ds 1
_kbd_map::
	.ds 40
_caps_kbd_map::
	.ds 40
_sym_kbd_map::
	.ds 40
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
;keyboard.c:9: kbd_handle_t *kbd_exclusive_handle=NULL;
	ld	iy,#_kbd_exclusive_handle
	ld	0 (iy),#0x00
	ld	1 (iy),#0x00
;keyboard.c:11: byte kbd_buff_head=0;
	ld	iy,#_kbd_buff_head
	ld	0 (iy),#0x00
;keyboard.c:12: byte kbd_buff_tail=0;
	ld	iy,#_kbd_buff_tail
	ld	0 (iy),#0x00
;keyboard.c:13: byte kbd_lastkey=0;
	ld	iy,#_kbd_lastkey
	ld	0 (iy),#0x00
;keyboard.c:18: byte kbd_map[]={
	ld	hl,#_kbd_map
	ld	(hl),#0x01
	inc	hl
	ld	(hl),#0x7A
	ld	hl,#_kbd_map + 2
	ld	(hl),#0x78
	ld	hl,#_kbd_map + 3
	ld	(hl),#0x63
	ld	hl,#_kbd_map + 4
	ld	(hl),#0x76
	ld	hl,#_kbd_map + 5
	ld	(hl),#0x61
	ld	hl,#_kbd_map + 6
	ld	(hl),#0x73
	ld	hl,#_kbd_map + 7
	ld	(hl),#0x64
	ld	hl,#_kbd_map + 8
	ld	(hl),#0x66
	ld	hl,#_kbd_map + 9
	ld	(hl),#0x67
	ld	hl,#_kbd_map + 10
	ld	(hl),#0x71
	ld	hl,#_kbd_map + 11
	ld	(hl),#0x77
	ld	hl,#_kbd_map + 12
	ld	(hl),#0x65
	ld	hl,#_kbd_map + 13
	ld	(hl),#0x72
	ld	hl,#_kbd_map + 14
	ld	(hl),#0x74
	ld	hl,#_kbd_map + 15
	ld	(hl),#0x31
	ld	hl,#_kbd_map + 16
	ld	(hl),#0x32
	ld	hl,#_kbd_map + 17
	ld	(hl),#0x33
	ld	hl,#_kbd_map + 18
	ld	(hl),#0x34
	ld	hl,#_kbd_map + 19
	ld	(hl),#0x35
	ld	hl,#_kbd_map + 20
	ld	(hl),#0x30
	ld	hl,#_kbd_map + 21
	ld	(hl),#0x39
	ld	hl,#_kbd_map + 22
	ld	(hl),#0x38
	ld	hl,#_kbd_map + 23
	ld	(hl),#0x37
	ld	hl,#_kbd_map + 24
	ld	(hl),#0x36
	ld	hl,#_kbd_map + 25
	ld	(hl),#0x70
	ld	hl,#_kbd_map + 26
	ld	(hl),#0x6F
	ld	hl,#_kbd_map + 27
	ld	(hl),#0x69
	ld	hl,#_kbd_map + 28
	ld	(hl),#0x75
	ld	hl,#_kbd_map + 29
	ld	(hl),#0x79
	ld	hl,#_kbd_map + 30
	ld	(hl),#0x0D
	ld	hl,#_kbd_map + 31
	ld	(hl),#0x6C
	ld	hl,#_kbd_map + 32
	ld	(hl),#0x6B
	ld	hl,#_kbd_map + 33
	ld	(hl),#0x6A
	ld	hl,#_kbd_map + 34
	ld	(hl),#0x68
	ld	hl,#_kbd_map + 35
	ld	(hl),#0x20
	ld	hl,#_kbd_map + 36
	ld	(hl),#0x02
	ld	hl,#_kbd_map + 37
	ld	(hl),#0x6D
	ld	hl,#_kbd_map + 38
	ld	(hl),#0x6E
	ld	hl,#_kbd_map + 39
	ld	(hl),#0x62
;keyboard.c:29: byte caps_kbd_map[]= {
	ld	hl,#_caps_kbd_map
	ld	(hl),#0xFF
	inc	hl
	ld	(hl),#0x5A
	ld	hl,#_caps_kbd_map + 2
	ld	(hl),#0x58
	ld	hl,#_caps_kbd_map + 3
	ld	(hl),#0x43
	ld	hl,#_caps_kbd_map + 4
	ld	(hl),#0x56
	ld	hl,#_caps_kbd_map + 5
	ld	(hl),#0x41
	ld	hl,#_caps_kbd_map + 6
	ld	(hl),#0x53
	ld	hl,#_caps_kbd_map + 7
	ld	(hl),#0x44
	ld	hl,#_caps_kbd_map + 8
	ld	(hl),#0x46
	ld	hl,#_caps_kbd_map + 9
	ld	(hl),#0x47
	ld	hl,#_caps_kbd_map + 10
	ld	(hl),#0x51
	ld	hl,#_caps_kbd_map + 11
	ld	(hl),#0x57
	ld	hl,#_caps_kbd_map + 12
	ld	(hl),#0x45
	ld	hl,#_caps_kbd_map + 13
	ld	(hl),#0x52
	ld	hl,#_caps_kbd_map + 14
	ld	(hl),#0x54
	ld	hl,#_caps_kbd_map + 15
	ld	(hl),#0x31
	ld	hl,#_caps_kbd_map + 16
	ld	(hl),#0x32
	ld	hl,#_caps_kbd_map + 17
	ld	(hl),#0x33
	ld	hl,#_caps_kbd_map + 18
	ld	(hl),#0x34
	ld	hl,#_caps_kbd_map + 19
	ld	(hl),#0x08
	ld	hl,#_caps_kbd_map + 20
	ld	(hl),#0x0C
	ld	hl,#_caps_kbd_map + 21
	ld	(hl),#0x39
	ld	hl,#_caps_kbd_map + 22
	ld	(hl),#0x09
	ld	hl,#_caps_kbd_map + 23
	ld	(hl),#0x0B
	ld	hl,#_caps_kbd_map + 24
	ld	(hl),#0x0A
	ld	hl,#_caps_kbd_map + 25
	ld	(hl),#0x50
	ld	hl,#_caps_kbd_map + 26
	ld	(hl),#0x4F
	ld	hl,#_caps_kbd_map + 27
	ld	(hl),#0x49
	ld	hl,#_caps_kbd_map + 28
	ld	(hl),#0x55
	ld	hl,#_caps_kbd_map + 29
	ld	(hl),#0x59
	ld	hl,#_caps_kbd_map + 30
	ld	(hl),#0x0D
	ld	hl,#_caps_kbd_map + 31
	ld	(hl),#0x4C
	ld	hl,#_caps_kbd_map + 32
	ld	(hl),#0x4B
	ld	hl,#_caps_kbd_map + 33
	ld	(hl),#0x4A
	ld	hl,#_caps_kbd_map + 34
	ld	(hl),#0x48
	ld	hl,#_caps_kbd_map + 35
	ld	(hl),#0x04
	ld	hl,#_caps_kbd_map + 36
	ld	(hl),#0x03
	ld	hl,#_caps_kbd_map + 37
	ld	(hl),#0x4D
	ld	hl,#_caps_kbd_map + 38
	ld	(hl),#0x4E
	ld	hl,#_caps_kbd_map + 39
	ld	(hl),#0x42
;keyboard.c:40: byte sym_kbd_map[]={
	ld	hl,#_sym_kbd_map
	ld	(hl),#0x03
	inc	hl
	ld	(hl),#0x3A
	ld	hl,#_sym_kbd_map + 2
	ld	(hl),#0x60
	ld	hl,#_sym_kbd_map + 3
	ld	(hl),#0x3F
	ld	hl,#_sym_kbd_map + 4
	ld	(hl),#0x2F
	ld	hl,#_sym_kbd_map + 5
	ld	(hl),#0x7E
	ld	hl,#_sym_kbd_map + 6
	ld	(hl),#0x7C
	ld	hl,#_sym_kbd_map + 7
	ld	(hl),#0x5C
	ld	hl,#_sym_kbd_map + 8
	ld	(hl),#0x7B
	ld	hl,#_sym_kbd_map + 9
	ld	(hl),#0x7D
	ld	hl,#_sym_kbd_map + 10
	ld	(hl),#0xFF
	ld	hl,#_sym_kbd_map + 11
	ld	(hl),#0xFF
	ld	hl,#_sym_kbd_map + 12
	ld	(hl),#0xFF
	ld	hl,#_sym_kbd_map + 13
	ld	(hl),#0x3C
	ld	hl,#_sym_kbd_map + 14
	ld	(hl),#0x3E
	ld	hl,#_sym_kbd_map + 15
	ld	(hl),#0x21
	ld	hl,#_sym_kbd_map + 16
	ld	(hl),#0x40
	ld	hl,#_sym_kbd_map + 17
	ld	(hl),#0x23
	ld	hl,#_sym_kbd_map + 18
	ld	(hl),#0x24
	ld	hl,#_sym_kbd_map + 19
	ld	(hl),#0x25
	ld	hl,#_sym_kbd_map + 20
	ld	(hl),#0x5F
	ld	hl,#_sym_kbd_map + 21
	ld	(hl),#0x29
	ld	hl,#_sym_kbd_map + 22
	ld	(hl),#0x28
	ld	hl,#_sym_kbd_map + 23
	ld	(hl),#0x27
	ld	hl,#_sym_kbd_map + 24
	ld	(hl),#0x26
	ld	hl,#_sym_kbd_map + 25
	ld	(hl),#0x22
	ld	hl,#_sym_kbd_map + 26
	ld	(hl),#0x3B
	ld	hl,#_sym_kbd_map + 27
	ld	(hl),#0x7F
	ld	hl,#_sym_kbd_map + 28
	ld	(hl),#0x5D
	ld	hl,#_sym_kbd_map + 29
	ld	(hl),#0x5B
	ld	hl,#_sym_kbd_map + 30
	ld	(hl),#0x0D
	ld	hl,#_sym_kbd_map + 31
	ld	(hl),#0x3D
	ld	hl,#_sym_kbd_map + 32
	ld	(hl),#0x2B
	ld	hl,#_sym_kbd_map + 33
	ld	(hl),#0x2D
	ld	hl,#_sym_kbd_map + 34
	ld	(hl),#0x5E
	ld	hl,#_sym_kbd_map + 35
	ld	(hl),#0x05
	ld	hl,#_sym_kbd_map + 36
	ld	(hl),#0xFF
	ld	hl,#_sym_kbd_map + 37
	ld	(hl),#0x2E
	ld	hl,#_sym_kbd_map + 38
	ld	(hl),#0x2C
	ld	hl,#_sym_kbd_map + 39
	ld	(hl),#0x2A
;--------------------------------------------------------
; Home
;--------------------------------------------------------
	.area _HOME
	.area _HOME
;--------------------------------------------------------
; code
;--------------------------------------------------------
	.area _CODE
;keyboard.c:54: word kbd_open(struct driver_s *drv, uint8_t *hint, uint16_t attr) {
;	---------------------------------
; Function kbd_open
; ---------------------------------
_kbd_open_start::
_kbd_open:
	push	ix
	ld	ix,#0
	add	ix,sp
;keyboard.c:55: if (kbd_exclusive_handle!=NULL) {
	ld	iy,#_kbd_exclusive_handle
	ld	a,1 (iy)
	or	a,0 (iy)
	jr	Z,00102$
;keyboard.c:56: last_error=RESULT_CANT_LOCK;
	ld	hl,#_last_error + 0
	ld	(hl), #0x03
;keyboard.c:57: return NULL;
	ld	hl,#0x0000
	jr	00104$
00102$:
;keyboard.c:59: kbd_exclusive_handle=mem_allocate(sizeof(kbd_handle_t), (word)tsk_current);
	ld	hl,(_tsk_current)
	push	hl
	ld	hl,#0x0008
	push	hl
	call	_mem_allocate
	pop	af
	pop	af
	ld	iy,#_kbd_exclusive_handle
	ld	0 (iy),l
	ld	1 (iy),h
;keyboard.c:60: kbd_exclusive_handle->driver=drv;
	ld	hl,(_kbd_exclusive_handle)
	ld	a,4 (ix)
	ld	(hl),a
	inc	hl
	ld	a,5 (ix)
	ld	(hl),a
;keyboard.c:61: kbd_exclusive_handle->owner=tsk_current;
	ld	hl,(_kbd_exclusive_handle)
	inc	hl
	inc	hl
	ld	iy,#_tsk_current
	ld	a,0 (iy)
	ld	(hl),a
	inc	hl
	ld	a,1 (iy)
	ld	(hl),a
;keyboard.c:62: kbd_exclusive_handle->read_done=NULL;
	ld	hl,(_kbd_exclusive_handle)
	ld	bc,#0x0006
	add	hl,bc
	xor	a, a
	ld	(hl), a
	inc	hl
	ld	(hl), a
;keyboard.c:63: kbd_exclusive_handle->ret_char=NULL;
	ld	hl,(_kbd_exclusive_handle)
	ld	bc,#0x0004
	add	hl,bc
	xor	a, a
	ld	(hl), a
	inc	hl
	ld	(hl), a
;keyboard.c:64: last_error=RESULT_SUCCESS;
	ld	hl,#_last_error + 0
	ld	(hl), #0x00
;keyboard.c:66: return (word)kbd_exclusive_handle;
	ld	hl,(_kbd_exclusive_handle)
00104$:
	pop	ix
	ret
_kbd_open_end::
;keyboard.c:69: void kbd_close(word handle) {
;	---------------------------------
; Function kbd_close
; ---------------------------------
_kbd_close_start::
_kbd_close:
	push	ix
	ld	ix,#0
	add	ix,sp
;keyboard.c:70: if (handle!=(word)kbd_exclusive_handle)
	ld	de,(_kbd_exclusive_handle)
	ld	a,4 (ix)
	sub	a, e
	jr	NZ,00107$
	ld	a,5 (ix)
	sub	a, d
	jr	Z,00102$
00107$:
;keyboard.c:71: last_error=RESULT_DONT_OWN;
	ld	hl,#_last_error + 0
	ld	(hl), #0x01
	jr	00104$
00102$:
;keyboard.c:73: mem_free(kbd_exclusive_handle);
	ld	hl,(_kbd_exclusive_handle)
	push	hl
	call	_mem_free
	pop	af
;keyboard.c:74: kbd_exclusive_handle=NULL;
	ld	iy,#_kbd_exclusive_handle
	ld	0 (iy),#0x00
	ld	1 (iy),#0x00
;keyboard.c:75: last_error=RESULT_SUCCESS;
	ld	hl,#_last_error + 0
	ld	(hl), #0x00
00104$:
	pop	ix
	ret
_kbd_close_end::
;keyboard.c:79: result kbd_read_async(word handle, uint8_t *buffer, uint16_t count, event_t *done) {
;	---------------------------------
; Function kbd_read_async
; ---------------------------------
_kbd_read_async_start::
_kbd_read_async:
	push	ix
	ld	ix,#0
	add	ix,sp
;keyboard.c:80: if (handle!=(word)kbd_exclusive_handle)
	ld	de,(_kbd_exclusive_handle)
	ld	a,4 (ix)
	sub	a, e
	jr	NZ,00115$
	ld	a,5 (ix)
	sub	a, d
	jr	Z,00108$
00115$:
;keyboard.c:81: return last_error=RESULT_DONT_OWN;
	ld	hl,#_last_error + 0
	ld	(hl), #0x01
	ld	l,#0x01
	jr	00110$
00108$:
;keyboard.c:83: if (kbd_exclusive_handle->read_done!=NULL)
	ld	hl,(_kbd_exclusive_handle)
	ld	bc,#0x0006
	add	hl,bc
	ld	d,(hl)
	inc	hl
	ld	a, (hl)
	or	a,d
	jr	Z,00105$
;keyboard.c:84: return last_error=RESULT_CANT_LOCK;
	ld	hl,#_last_error + 0
	ld	(hl), #0x03
	ld	l,#0x03
	jr	00110$
00105$:
;keyboard.c:85: else if (count!=1) /* can only read single byte from driver */
	ld	a,8 (ix)
	sub	a, #0x01
	jr	NZ,00116$
	ld	a,9 (ix)
	or	a, a
	jr	Z,00102$
00116$:
;keyboard.c:86: return last_error=RESULT_INVALID_PARAMETER;
	ld	hl,#_last_error + 0
	ld	(hl), #0x04
	ld	l,#0x04
	jr	00110$
00102$:
;keyboard.c:88: kbd_exclusive_handle->read_done=done;
	ld	hl,(_kbd_exclusive_handle)
	ld	bc,#0x0006
	add	hl,bc
	ld	a,10 (ix)
	ld	(hl),a
	inc	hl
	ld	a,11 (ix)
	ld	(hl),a
;keyboard.c:89: kbd_exclusive_handle->ret_char=buffer;
	ld	hl,(_kbd_exclusive_handle)
	ld	bc,#0x0004
	add	hl,bc
	ld	a,6 (ix)
	ld	(hl),a
	inc	hl
	ld	a,7 (ix)
	ld	(hl),a
;keyboard.c:90: return last_error=RESULT_SUCCESS;
	ld	hl,#_last_error + 0
	ld	(hl), #0x00
	ld	l,#0x00
00110$:
	pop	ix
	ret
_kbd_read_async_end::
;keyboard.c:95: void kbd_timer_hook() {
;	---------------------------------
; Function kbd_timer_hook
; ---------------------------------
_kbd_timer_hook_start::
_kbd_timer_hook:
;keyboard.c:100: kbd_scan();
	call	_kbd_scan
;keyboard.c:103: if (kbd_exclusive_handle!=NULL &&
	ld	iy,#_kbd_exclusive_handle
	ld	a,1 (iy)
	or	a,0 (iy)
	ret	Z
;keyboard.c:104: kbd_exclusive_handle->read_done!=NULL && 
	ld	hl,(_kbd_exclusive_handle)
	ld	bc,#0x0006
	add	hl,bc
	ld	e,(hl)
	inc	hl
	ld	a, (hl)
	or	a,e
	ret	Z
;keyboard.c:105: kbd_exclusive_handle->ret_char!=NULL) {
	ld	hl,(_kbd_exclusive_handle)
	ld	bc,#0x0004
	add	hl,bc
	ld	e,(hl)
	inc	hl
	ld	a, (hl)
	or	a,e
	ret	Z
;keyboard.c:107: the_key=kbd_get_key();
	call	_kbd_get_key
	ld	e,l
;keyboard.c:108: if (the_key) {
	ld	a, h
	or	a,e
	ret	Z
;keyboard.c:109: *(kbd_exclusive_handle->ret_char)=the_key;
	ld	hl,(_kbd_exclusive_handle)
	ld	bc,#0x0004
	add	hl,bc
	ld	a,(hl)
	inc	hl
	ld	h,(hl)
	ld	l,a
	ld	(hl),e
;keyboard.c:110: evt_set(kbd_exclusive_handle->read_done,signaled);
	ld	hl,(_kbd_exclusive_handle)
	ld	bc,#0x0006
	add	hl,bc
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
	ld	a,#0x01
	push	af
	inc	sp
	push	de
	call	_evt_set
	pop	af
	inc	sp
	ret
_kbd_timer_hook_end::
;keyboard.c:115: word kbd_get_key() __naked {
;	---------------------------------
; Function kbd_get_key
; ---------------------------------
_kbd_get_key_start::
_kbd_get_key:
;keyboard.c:140: __endasm;
	ld	hl,#_kbd_buff_tail ; end of kbd buffer
	ld	b,(hl) ; to b
	ld	hl,#_kbd_buff_head ; start of kbd buffer
	ld	a,(hl) ; to a
	cp	b ; kbd buffer empty?
	jr	nz,key_avail
	ld	hl,#0 ; return 0 in hl
	ret
	key_avail:
	ld	d,#0
	ld	e,a
	inc	a ; next position in buffer
	cp	#32 ; end of buffer?
	jr	z,resetbstart
	jr	updatebstart
	resetbstart:
	ld	a,#0 ; buffer overflow
	updatebstart:
	ld	(hl),a ; write to tail
	ld	hl,#_kbd_buffer
	add	hl,de ; hl points to next key
	ld	a,(hl) ; get the key
	ld	h,#0
	ld	l,a ; and store to hl
	endread:
	ret
_kbd_get_key_end::
;keyboard.c:143: word kbd_scan() {
;	---------------------------------
; Function kbd_scan
; ---------------------------------
_kbd_scan_start::
_kbd_scan:
;keyboard.c:278: __endasm;
	ld	l,#1
	ld	bc,#0xfefe ; first line to scan
	ld	de,#0x0000 ; de holds "downed" keys
	scanline:
	in	a,(c) ; read kbd
	or	#0xe0 ; set bits 5-7 of a
	cp	#0xff ; all bits set?
	jr	nz,testbits ; no key down
	inc	l
	inc	l
	inc	l
	inc	l
	inc	l
	jr	nextscan
;	manualy test bits 0-4
	testbits:
	bit	0,a
	call	z,keydown
	inc	l
	bit	1,a
	call	z,keydown
	inc	l
	bit	2,a
	call	z,keydown
	inc	l
	bit	3,a
	call	z,keydown
	inc	l
	bit	4,a
	call	z,keydown
	inc	l
	jr	nextscan
;	store keys to d and e
	keydown:
	ex	af,af'			; alternate accu.
	ld	a,d ; d already contains key?
	cp	#0
	jr	nz,keytoe
	ld	d,l
	jr	endofscan
	keytoe:
	ld	a,e
	cp	#0
	jr	nz,ghosting
	ld	e,l
	jr	endofscan
	ghosting:
	ld	de,#0x0000 ; reset de
	endofscan:
	ex	af,af'			; restore a to in a,(c) result
	ret
;	cont with scan
	nextscan:
	ld	a,b
	scf	; carry flag on
	rla	; next line
	ld	b,a
	cp	#0xff ; the end?
	jr	nz, scanline
	kbd_process:
	ld	a,d
	cp	e
	jr	z,nokeys ; no keys to process, de=0
	ld	a,d ; get first key
	dec	a ; minus 1 to get offset
	cp	#0x00 ; caps shift?
	jr	z,caps
	cp	#0x24 ; symbol shift?
	jr	z,sym_
	ld	a,e ; check symbol again
	dec	a
	cp	#0x24 ; second key could be symbol?
	jr	z,symbole
	ld	a,d
	ld	hl,#_kbd_map
	jr	prockey
	caps:
	ld	a,e
	cp	#0 ; is there another key?
	jr	z,keyprocend
	ld	hl,#_caps_kbd_map
	jr	prockey
	sym_:
	ld	a,e
	cp	#0
	jr	z,keyprocend
	jr	gosymbol
	symbole:
	ld	a,d ; d is key and we know it is not 0
	gosymbol:
	ld	hl,#_sym_kbd_map
	jr	prockey
	prockey:
	dec	a
	ld	d,#0 ; get to key code
	ld	e,a
	add	hl,de
	ld	a,(hl) ; a now has key code
	ld	iy,#_kbd_lastkey
	ld	d,a
	ld	a,(iy)
	cp	d
	jr	z,keyprocend ; key is the same as previous...
	ld	a,d
	ld	(iy),a ; store new key code to previous
	ld	b,a ; store key code
	ld	iy,#_kbd_buff_tail
	ld	a,(iy) ; get end buffer
	ld	d,#0
	ld	e,a
	ld	hl,#_kbd_buffer
	add	hl,de ; hl points to kbd buffer
	inc	a ; increase end of buffer
	cp	#32 ; end of buffer?
	jr	z,resetbend
	jr	updatebend
	resetbend:
	ld	a,#0 ; buffer overflow
	updatebend:
	ld	(iy),a ; write to _kbdbend
	ld	a,b ; restore key code and...
	ld	(hl),a ; ...insert to kbd buffer
	jr	keyprocend
	nokeys:
	ld	iy,#_kbd_lastkey
	ld	(iy),#0x00 ; clear previous key
	keyprocend:
	ex	de,hl ; result from de to hl
	ret
	ret
_kbd_scan_end::
	.area _CODE
	.area _CABS

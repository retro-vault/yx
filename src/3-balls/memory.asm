;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 3.1.0 #7066 (Jun 14 2012) (Linux)
; This file was generated Tue Nov 27 20:21:22 2012
;--------------------------------------------------------
	.module memory
	.optsdcc -mz80
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _mem_init
	.globl _merge_with_next
	.globl _split
	.globl _brk
	.globl _sbrk
	.globl _find_block
	.globl _get_heap
	.globl _mem_last
	.globl _mem_first
	.globl _brk_addr
	.globl _mem_allocate
	.globl _mem_free
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
;--------------------------------------------------------
;  ram data
;--------------------------------------------------------
	.area _DATA
_brk_addr::
	.ds 2
_mem_first::
	.ds 2
_mem_last::
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
;memory.c:15: block_t *mem_first=NULL;
	ld	iy,#_mem_first
	ld	0 (iy),#0x00
	ld	1 (iy),#0x00
;memory.c:16: block_t *mem_last=NULL;
	ld	iy,#_mem_last
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
;memory.c:21: block_t *find_block(word size) {
;	---------------------------------
; Function find_block
; ---------------------------------
_find_block_start::
_find_block:
	push	ix
	ld	ix,#0
	add	ix,sp
;memory.c:23: if (mem_first==NULL) /* virgin heap */
	ld	iy,#_mem_first
	ld	a,1 (iy)
	or	a,0 (iy)
	jr	NZ,00107$
;memory.c:24: return NULL;
	ld	hl,#0x0000
	jr	00109$
00107$:
;memory.c:26: b=mem_first;
	ld	de,(_mem_first)
;memory.c:27: while (b && !(b->owner==NULL && b->size >= size ))
00103$:
	ld	a,d
	or	a,e
	jr	Z,00108$
	ld	l,e
	ld	h,d
	ld	b,(hl)
	inc	hl
	ld	a, (hl)
	or	a,b
	jr	NZ,00104$
	ld	l,e
	ld	h,d
	inc	hl
	inc	hl
	ld	b,(hl)
	inc	hl
	ld	h,(hl)
	ld	a,b
	sub	a, 4 (ix)
	ld	a,h
	sbc	a, 5 (ix)
	jr	NC,00108$
00104$:
;memory.c:28: b = b->next;
	ld	hl,#0x0004
	add	hl,de
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
	jr	00103$
00108$:
;memory.c:30: return b;
	ex	de,hl
00109$:
	pop	ix
	ret
_find_block_end::
;memory.c:33: void * sbrk (word incr) {
;	---------------------------------
; Function sbrk
; ---------------------------------
_sbrk_start::
_sbrk:
	push	ix
	ld	ix,#0
	add	ix,sp
;memory.c:34: word old_brk=brk_addr;
	ld	de,(_brk_addr)
;memory.c:35: if (0xffff - brk_addr < incr )
	ld	hl,#_brk_addr
	ld	a,#0xFF
	sub	a, (hl)
	ld	b,a
	ld	a,#0xFF
	inc	hl
	sbc	a, (hl)
	ld	c,a
	ld	a,b
	sub	a, 4 (ix)
	ld	a,c
	sbc	a, 5 (ix)
	jr	NC,00102$
;memory.c:36: return NULL; /* safe value for zx spectrum, but not standard! */
	ld	hl,#0x0000
	jr	00104$
00102$:
;memory.c:38: brk_addr += incr;
	ld	hl,#_brk_addr
	ld	a,(hl)
	add	a, 4 (ix)
	ld	(hl),a
	inc	hl
	ld	a,(hl)
	adc	a, 5 (ix)
	ld	(hl),a
;memory.c:39: return (void *)old_brk;
	ex	de,hl
00104$:
	pop	ix
	ret
_sbrk_end::
;memory.c:43: void brk(void *addr) {
;	---------------------------------
; Function brk
; ---------------------------------
_brk_start::
_brk:
	push	ix
	ld	ix,#0
	add	ix,sp
;memory.c:44: brk_addr=(word)addr;
	ld	a,4 (ix)
	ld	iy,#_brk_addr
	ld	0 (iy),a
	ld	a,5 (ix)
	ld	1 (iy),a
	pop	ix
	ret
_brk_end::
;memory.c:47: void split ( block_t *b, word size) {
;	---------------------------------
; Function split
; ---------------------------------
_split_start::
_split:
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl,#-6
	add	hl,sp
	ld	sp,hl
;memory.c:50: new = (word) b->data + (word) size;
	ld	e,4 (ix)
	ld	d,5 (ix)
	ld	hl,#0x0008
	add	hl,de
	ld	c,l
	ld	b,h
	ld	a,6 (ix)
	add	a, c
	ld	c,a
	ld	a,7 (ix)
	adc	a, b
	ld	b,a
;memory.c:51: new->owner=NULL;
	ld	l,c
	ld	h,b
	xor	a, a
	ld	(hl), a
	inc	hl
	ld	(hl), a
;memory.c:52: new->size = b->size - (size + BLK_SIZE);
	push	bc
	pop	iy
	inc	iy
	inc	iy
	ld	hl,#0x0002
	add	hl,de
	ld	-2 (ix),l
	ld	-1 (ix),h
	ld	a,(hl)
	ld	-4 (ix),a
	inc	hl
	ld	a,(hl)
	ld	-3 (ix),a
	ld	a,6 (ix)
	add	a, #0x08
	ld	-6 (ix),a
	ld	a,7 (ix)
	adc	a, #0x00
	ld	-5 (ix),a
	ld	a,-4 (ix)
	sub	a, -6 (ix)
	ld	-6 (ix),a
	ld	a,-3 (ix)
	sbc	a, -5 (ix)
	ld	-5 (ix),a
	ld	a,-6 (ix)
	ld	0 (iy),a
	ld	a,-5 (ix)
	ld	1 (iy),a
;memory.c:53: new->next = b->next;
	ld	iy,#0x0004
	add	iy, bc
	ld	hl,#0x0004
	add	hl,de
	ld	-6 (ix),l
	ld	-5 (ix),h
	ld	a,(hl)
	ld	-4 (ix),a
	inc	hl
	ld	a,(hl)
	ld	-3 (ix),a
	ld	a,-4 (ix)
	ld	0 (iy),a
	ld	a,-3 (ix)
	ld	1 (iy),a
;memory.c:54: new->prev=b;
	ld	hl,#0x0006
	add	hl,bc
	ld	(hl),e
	inc	hl
	ld	(hl),d
;memory.c:56: b->size = size;
	ld	l,-2 (ix)
	ld	h,-1 (ix)
	ld	a,6 (ix)
	ld	(hl),a
	inc	hl
	ld	a,7 (ix)
	ld	(hl),a
;memory.c:57: if (b->next) 
	ld	a,-3 (ix)
	or	a,-4 (ix)
	jr	Z,00102$
;memory.c:58: b->next->prev=new;
	ld	a,-4 (ix)
	add	a, #0x06
	ld	l,a
	ld	a,-3 (ix)
	adc	a, #0x00
	ld	h,a
	ld	(hl),c
	inc	hl
	ld	(hl),b
	jr	00103$
00102$:
;memory.c:60: mem_last=new;
	ld	iy,#_mem_last
	ld	0 (iy),c
	ld	1 (iy),b
00103$:
;memory.c:61: b->next = new;
	ld	l,-6 (ix)
	ld	h,-5 (ix)
	ld	(hl),c
	inc	hl
	ld	(hl),b
	ld	sp,ix
	pop	ix
	ret
_split_end::
;memory.c:64: block_t * merge_with_next ( block_t *b ) {
;	---------------------------------
; Function merge_with_next
; ---------------------------------
_merge_with_next_start::
_merge_with_next:
	push	ix
	ld	ix,#0
	add	ix,sp
	push	af
	push	af
;memory.c:66: b->size += ( BLK_SIZE + b->next->size );
	ld	c,4 (ix)
	ld	b,5 (ix)
	ld	hl,#0x0002
	add	hl,bc
	ld	-2 (ix),l
	ld	-1 (ix),h
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
	ld	iy,#0x0004
	add	iy, bc
	ld	a,0 (iy)
	ld	-4 (ix),a
	ld	a,1 (iy)
	ld	-3 (ix),a
	ld	l,-4 (ix)
	ld	h,-3 (ix)
	inc	hl
	inc	hl
	ld	a,(hl)
	inc	hl
	ld	h,(hl)
	add	a, #0x08
	ld	l,a
	ld	a,h
	adc	a, #0x00
	ld	h,a
	add	hl,de
	ex	de,hl
	ld	l,-2 (ix)
	ld	h,-1 (ix)
	ld	(hl),e
	inc	hl
	ld	(hl),d
;memory.c:67: b->next = b->next->next;
	ld	a,-4 (ix)
	add	a, #0x04
	ld	l,a
	ld	a,-3 (ix)
	adc	a, #0x00
	ld	h,a
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
	ld	0 (iy),e
	ld	1 (iy),d
;memory.c:68: if (b->next)
	ld	l,0 (iy)
	ld	h,1 (iy)
	ld	a,d
	or	a,e
	jr	Z,00102$
;memory.c:69: b->next->prev=b;
	ld	de,#0x0006
	add	hl,de
	ld	(hl),c
	inc	hl
	ld	(hl),b
	jr	00103$
00102$:
;memory.c:71: mem_last=b;
	ld	iy,#_mem_last
	ld	0 (iy),c
	ld	1 (iy),b
00103$:
;memory.c:73: return b;
	ld	l,c
	ld	h,b
	ld	sp,ix
	pop	ix
	ret
_merge_with_next_end::
;memory.c:84: void mem_init() {
;	---------------------------------
; Function mem_init
; ---------------------------------
_mem_init_start::
_mem_init:
;memory.c:85: brk_addr=get_heap();
	call	_get_heap
	ld	iy,#_brk_addr
	ld	0 (iy),l
	ld	1 (iy),h
	ret
_mem_init_end::
;memory.c:91: void *mem_allocate(word size, word owner) {
;	---------------------------------
; Function mem_allocate
; ---------------------------------
_mem_allocate_start::
_mem_allocate:
	push	ix
	ld	ix,#0
	add	ix,sp
;memory.c:93: if (!mem_first) {
	ld	iy,#_mem_first
	ld	a,1 (iy)
	or	a,0 (iy)
	jr	NZ,00107$
;memory.c:94: mem_first = mem_last = b = (block_t *)sbrk(size + BLK_SIZE);
	ld	a,4 (ix)
	add	a, #0x08
	ld	e,a
	ld	a,5 (ix)
	adc	a, #0x00
	ld	d,a
	push	de
	call	_sbrk
	pop	af
	ex	de,hl
	ld	c,e
	ld	b,d
	ld	iy,#_mem_last
	ld	0 (iy),e
	ld	1 (iy),d
	ld	iy,#_mem_first
	ld	0 (iy),e
	ld	1 (iy),d
;memory.c:95: b->prev=b->next=NULL;
	ld	iy,#0x0006
	add	iy, bc
	ld	hl,#0x0004
	add	hl,bc
	xor	a, a
	ld	(hl), a
	inc	hl
	ld	(hl), a
	ld	0 (iy),#0x00
	ld	1 (iy),#0x00
;memory.c:96: b->owner=owner;		
	ld	d,6 (ix)
	ld	e,7 (ix)
	ld	l,c
	ld	h,b
	ld	(hl),d
	inc	hl
	ld	(hl),e
;memory.c:97: b->size=size;
	ld	l,c
	ld	h,b
	inc	hl
	inc	hl
	ld	a,4 (ix)
	ld	(hl),a
	inc	hl
	ld	a,5 (ix)
	ld	(hl),a
	jp	00108$
00107$:
;memory.c:99: b=find_block(size);
	ld	l,4 (ix)
	ld	h,5 (ix)
	push	hl
	call	_find_block
	pop	af
	ld	c,l
	ld	b,h
;memory.c:100: if (b) {
	ld	a,b
	or	a,c
	jr	Z,00104$
;memory.c:101: if (b->size > BLK_SIZE + MIN_CHUNK_SIZE)
	ld	l,c
	ld	h,b
	inc	hl
	inc	hl
	ld	d,(hl)
	inc	hl
	ld	h,(hl)
	ld	a,#0x0C
	sub	a, d
	ld	a,#0x00
	sbc	a, h
	jr	NC,00102$
;memory.c:102: split(b, size);
	push	bc
	ld	l,4 (ix)
	ld	h,5 (ix)
	push	hl
	push	bc
	call	_split
	pop	af
	pop	af
	pop	bc
00102$:
;memory.c:103: b->owner=owner;
	ld	d,6 (ix)
	ld	e,7 (ix)
	ld	l,c
	ld	h,b
	ld	(hl),d
	inc	hl
	ld	(hl),e
	jr	00108$
00104$:
;memory.c:105: b = (block_t *)sbrk(size + BLK_SIZE);
	ld	a,4 (ix)
	add	a, #0x08
	ld	e,a
	ld	a,5 (ix)
	adc	a, #0x00
	ld	d,a
	push	de
	call	_sbrk
	pop	af
	ld	c,l
	ld	b,h
;memory.c:106: mem_last->next=b;
	ld	hl,(_mem_last)
	ld	de,#0x0004
	add	hl,de
	ld	(hl),c
	inc	hl
	ld	(hl),b
;memory.c:107: b->prev=mem_last;
	ld	hl,#0x0006
	add	hl,bc
	ld	iy,#_mem_last
	ld	a,0 (iy)
	ld	(hl),a
	inc	hl
	ld	a,1 (iy)
	ld	(hl),a
;memory.c:108: b->owner=owner;
	ld	d,6 (ix)
	ld	e,7 (ix)
	ld	l,c
	ld	h,b
	ld	(hl),d
	inc	hl
	ld	(hl),e
;memory.c:109: b->size=size;
	ld	l,c
	ld	h,b
	inc	hl
	inc	hl
	ld	a,4 (ix)
	ld	(hl),a
	inc	hl
	ld	a,5 (ix)
	ld	(hl),a
;memory.c:110: b->next=NULL;
	ld	hl,#0x0004
	add	hl,bc
	xor	a, a
	ld	(hl), a
	inc	hl
	ld	(hl), a
;memory.c:111: mem_last=b;
	ld	0 (iy),c
	ld	1 (iy),b
00108$:
;memory.c:114: if (!b)
	ld	a,b
	or	a,c
	jr	NZ,00110$
;memory.c:115: return NULL;
	ld	hl,#0x0000
	jr	00112$
00110$:
;memory.c:117: return (void *)(b->data);
	ld	hl,#0x0008
	add	hl,bc
00112$:
	pop	ix
	ret
_mem_allocate_end::
;memory.c:123: void mem_free(void *p) {
;	---------------------------------
; Function mem_free
; ---------------------------------
_mem_free_start::
_mem_free:
	push	ix
	ld	ix,#0
	add	ix,sp
;memory.c:129: baddr=(word)p;
;memory.c:130: baddr-=BLK_SIZE;
	ld	a, 4 (ix)
	ld	b, 5 (ix)
	add	a,#0xF8
	ld	c,a
	ld	a,b
	adc	a,#0xFF
	ld	b,a
;memory.c:131: b=baddr;
;memory.c:133: b->owner=NULL; /* release block */
	ld	l,c
	ld	h,b
	xor	a, a
	ld	(hl), a
	inc	hl
	ld	(hl), a
;memory.c:138: if (b->prev && b->prev->owner==NULL) /* try previous */
	ld	hl,#0x0006
	add	hl,bc
	ld	a,(hl)
	inc	hl
	ld	h,(hl)
	ld	l,a
	or	a,h
	jr	Z,00102$
	ld	d,(hl)
	inc	hl
	ld	e,(hl)
	dec	hl
	ld	a,e
	or	a,d
	jr	NZ,00102$
;memory.c:139: b = merge_with_next(b->prev);
	push	hl
	call	_merge_with_next
	pop	af
	ld	c,l
	ld	b,h
00102$:
;memory.c:140: if (b->next && b->next->owner==NULL) /* try next */
	ld	hl,#0x0004
	add	hl,bc
	ld	d,l
	ld	e,h
	ld	a,(hl)
	inc	hl
	ld	h,(hl)
	ld	l,a
	or	a,h
	jr	Z,00105$
	ld	a,(hl)
	inc	hl
	or	a,(hl)
	jr	NZ,00105$
;memory.c:141: merge_with_next(b);
	push	bc
	push	de
	push	bc
	call	_merge_with_next
	pop	af
	pop	de
	pop	bc
00105$:
;memory.c:143: if (b->next==NULL) { /* are we at the end of the heap? */
	ld	l,d
	ld	h,e
	ld	d,(hl)
	inc	hl
	ld	a, (hl)
	or	a,d
	jr	NZ,00112$
;memory.c:144: if (b->prev==NULL) /* mem_first? */
	ld	hl,#0x0006
	add	hl,bc
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
	ld	a,d
	or	a,e
	jr	NZ,00108$
;memory.c:145: mem_first=mem_last=NULL;
	ld	iy,#_mem_last
	ld	0 (iy),#0x00
	ld	1 (iy),#0x00
	ld	iy,#_mem_first
	ld	0 (iy),#0x00
	ld	1 (iy),#0x00
	jr	00109$
00108$:
;memory.c:147: b->prev->next = NULL;
	ld	hl,#0x0004
	add	hl,de
	xor	a, a
	ld	(hl), a
	inc	hl
	ld	(hl), a
;memory.c:148: mem_last=b->prev;
	ld	iy,#_mem_last
	ld	0 (iy),e
	ld	1 (iy),d
00109$:
;memory.c:150: brk(b);
	push	bc
	call	_brk
	pop	af
00112$:
	pop	ix
	ret
_mem_free_end::
	.area _CODE
	.area _CABS

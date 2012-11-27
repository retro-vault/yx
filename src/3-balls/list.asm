;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 3.1.0 #7066 (Jun 14 2012) (Linux)
; This file was generated Tue Nov 27 20:21:22 2012
;--------------------------------------------------------
	.module list
	.optsdcc -mz80
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _mem_free
	.globl _mem_allocate
	.globl _lst_insert
	.globl _lst_delete
	.globl _lst_match
	.globl _lst_find
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
;list.c:12: list_header_t* lst_insert(list_header_t** first, word size, void* owner) {
;	---------------------------------
; Function lst_insert
; ---------------------------------
_lst_insert_start::
_lst_insert:
	push	ix
	ld	ix,#0
	add	ix,sp
;list.c:13: list_header_t *el=mem_allocate(size, (word)owner);
	ld	l,8 (ix)
	ld	h,9 (ix)
	push	hl
	ld	l,6 (ix)
	ld	h,7 (ix)
	push	hl
	call	_mem_allocate
	pop	af
	pop	af
	ex	de,hl
;list.c:14: if (el==NULL) 
	ld	a,d
	or	a,e
	jr	NZ,00102$
;list.c:15: last_error=RESULT_NO_MEMORY_LEFT;
	ld	hl,#_last_error + 0
	ld	(hl), #0x02
	jr	00103$
00102$:
;list.c:17: el->next=*first;
	ld	c,4 (ix)
	ld	b,5 (ix)
	push	bc
	pop	iy
	ld	c,0 (iy)
	ld	b,1 (iy)
	ld	l,e
	ld	h,d
	ld	(hl),c
	inc	hl
	ld	(hl),b
;list.c:18: el->owner=owner;
	ld	l,e
	ld	h,d
	inc	hl
	inc	hl
	ld	a,8 (ix)
	ld	(hl),a
	inc	hl
	ld	a,9 (ix)
	ld	(hl),a
;list.c:19: *first=el;
	ld	0 (iy),e
	ld	1 (iy),d
;list.c:20: last_error=RESULT_SUCCESS;
	ld	hl,#_last_error + 0
	ld	(hl), #0x00
00103$:
;list.c:22: return el;
	ex	de,hl
	pop	ix
	ret
_lst_insert_end::
;list.c:28: result lst_delete(list_header_t **first, list_header_t *element, byte free) {
;	---------------------------------
; Function lst_delete
; ---------------------------------
_lst_delete_start::
_lst_delete:
	push	ix
	ld	ix,#0
	add	ix,sp
;list.c:31: if (element==NULL)
	ld	a,7 (ix)
	or	a,6 (ix)
	jr	NZ,00116$
;list.c:32: return last_error=RESULT_INVALID_PARAMETER;
	ld	hl,#_last_error + 0
	ld	(hl), #0x04
	ld	l,#0x04
	jp	00118$
00116$:
;list.c:33: else if (element==*first) {
	ld	c,4 (ix)
	ld	b,5 (ix)
	ld	l,c
	ld	h,b
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
	ld	a,6 (ix)
	sub	a, e
	jr	NZ,00113$
	ld	a,7 (ix)
	sub	a, d
	jr	NZ,00113$
;list.c:34: *first=element->next;
	ld	l,6 (ix)
	ld	h,7 (ix)
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
	ld	l,c
	ld	h,b
	ld	(hl),e
	inc	hl
	ld	(hl),d
;list.c:35: if (free) mem_free(element);
	ld	a,8 (ix)
	or	a, a
	jr	Z,00117$
	ld	l,6 (ix)
	ld	h,7 (ix)
	push	hl
	call	_mem_free
	pop	af
	jr	00117$
00113$:
;list.c:37: prev=*first;
;list.c:38: curr=prev->next;
	ld	l,e
	ld	h,d
	ld	c,(hl)
	inc	hl
	ld	b,(hl)
;list.c:39: while (curr && curr!=element) {
00104$:
	ld	a,b
	or	a,c
	jr	Z,00106$
	ld	a,c
	sub	a, 6 (ix)
	jr	NZ,00130$
	ld	a,b
	sub	a, 7 (ix)
	jr	Z,00106$
00130$:
;list.c:40: prev=curr;
	ld	e,c
	ld	d,b
;list.c:41: curr=curr->next;
	ld	l,c
	ld	h,b
	ld	a,(hl)
	inc	hl
	ld	b, (hl)
	ld	c, a
	jr	00104$
00106$:
;list.c:43: if (!curr) 
	ld	a,b
	or	a,c
	jr	NZ,00110$
;list.c:44: return last_error=RESULT_NOT_FOUND;
	ld	hl,#_last_error + 0
	ld	(hl), #0x05
	ld	l,#0x05
	jr	00118$
00110$:
;list.c:46: prev->next=curr->next;
	ld	l,c
	ld	h,b
	ld	c,(hl)
	inc	hl
	ld	b,(hl)
	ex	de,hl
	ld	(hl),c
	inc	hl
	ld	(hl),b
;list.c:47: if (free) mem_free(element);
	ld	a,8 (ix)
	or	a, a
	jr	Z,00117$
	ld	l,6 (ix)
	ld	h,7 (ix)
	push	hl
	call	_mem_free
	pop	af
00117$:
;list.c:50: return last_error=RESULT_SUCCESS;
	ld	hl,#_last_error + 0
	ld	(hl), #0x00
	ld	l,#0x00
00118$:
	pop	ix
	ret
_lst_delete_end::
;list.c:58: list_header_t* lst_match(list_header_t *first, list_header_t **last, byte (*match)(list_header_t *element)) {
;	---------------------------------
; Function lst_match
; ---------------------------------
_lst_match_start::
_lst_match:
	push	ix
	ld	ix,#0
	add	ix,sp
	push	af
;list.c:62: if (first==NULL)
	ld	a,5 (ix)
	or	a,4 (ix)
	jr	NZ,00109$
;list.c:63: last_error=RESULT_NOT_FOUND;
	ld	hl,#_last_error + 0
	ld	(hl), #0x05
	jr	00110$
00109$:
;list.c:65: curr=first;
	ld	e,4 (ix)
	ld	d,5 (ix)
;list.c:66: while (curr && !match(curr)) {
00102$:
	ld	a,d
	or	a,e
	jr	Z,00104$
	push	de
	push	de
	ld	l,8 (ix)
	ld	h,9 (ix)
	call	__sdcc_call_hl
	pop	af
	ld	a,l
	pop	de
	or	a, a
	jr	NZ,00104$
;list.c:67: *last=curr;
	ld	l,6 (ix)
	ld	h,7 (ix)
	ld	(hl),e
	inc	hl
	ld	(hl),d
;list.c:68: curr=curr->next;
	ex	de,hl
	ld	b,(hl)
	inc	hl
	ld	d, (hl)
	ld	e, b
	jr	00102$
00104$:
;list.c:70: if (!curr)
	ld	a,d
	or	a,e
	jr	NZ,00106$
;list.c:71: last_error=RESULT_NOT_FOUND;
	ld	hl,#_last_error + 0
	ld	(hl), #0x05
	jr	00110$
00106$:
;list.c:73: last_error=RESULT_SUCCESS;
	ld	hl,#_last_error + 0
	ld	(hl), #0x00
00110$:
;list.c:75: return curr;
	ex	de,hl
	ld	sp,ix
	pop	ix
	ret
_lst_match_end::
;list.c:81: result lst_find(list_header_t *first, list_header_t **last, list_header_t *element) {
;	---------------------------------
; Function lst_find
; ---------------------------------
_lst_find_start::
_lst_find:
	push	ix
	ld	ix,#0
	add	ix,sp
;list.c:86: if (first==NULL)
	ld	a,5 (ix)
	or	a,4 (ix)
	jr	NZ,00109$
;list.c:87: return last_error=RESULT_NOT_FOUND;
	ld	hl,#_last_error + 0
	ld	(hl), #0x05
	ld	l,#0x05
	jr	00111$
00109$:
;list.c:89: curr=first;
	ld	d,4 (ix)
	ld	e,5 (ix)
;list.c:90: while (curr && curr!=element) {
00102$:
	ld	a,e
	or	a,d
	jr	Z,00104$
	ld	a,d
	sub	a, 8 (ix)
	jr	NZ,00118$
	ld	a,e
	sub	a, 9 (ix)
	jr	Z,00104$
00118$:
;list.c:91: *last=curr;
	ld	l,6 (ix)
	ld	h,7 (ix)
	ld	(hl),d
	inc	hl
	ld	(hl),e
;list.c:92: curr=curr->next;
	ld	l,d
	ld	h,e
	ld	c,(hl)
	inc	hl
	ld	e, (hl)
	ld	d, c
	jr	00102$
00104$:
;list.c:94: if (!curr)
	ld	a,e
	or	a,d
	jr	NZ,00106$
;list.c:95: return last_error=RESULT_NOT_FOUND;
	ld	hl,#_last_error + 0
	ld	(hl), #0x05
	ld	l,#0x05
	jr	00111$
00106$:
;list.c:97: return last_error=RESULT_SUCCESS;
	ld	hl,#_last_error + 0
	ld	(hl), #0x00
	ld	l,#0x00
00111$:
	pop	ix
	ret
_lst_find_end::
	.area _CODE
	.area _CABS

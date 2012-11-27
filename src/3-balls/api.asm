;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 3.1.0 #7066 (Jun 14 2012) (Linux)
; This file was generated Tue Nov 27 20:21:27 2012
;--------------------------------------------------------
	.module api
	.optsdcc -mz80
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _api_version
	.globl _api_query
	.globl _strcmp
	.globl _fn_table
	.globl _api
	.globl _api_init
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
;--------------------------------------------------------
;  ram data
;--------------------------------------------------------
	.area _DATA
_fn_table::
	.ds 4
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
;api.c:15: word api() __naked {
;	---------------------------------
; Function api
; ---------------------------------
_api_start::
_api:
;api.c:19: __endasm;
	ld	hl,#_fn_table
	reti
_api_end::
;api.c:26: void *api_query(string name) {
;	---------------------------------
; Function api_query
; ---------------------------------
_api_query_start::
_api_query:
	push	ix
	ld	ix,#0
	add	ix,sp
;api.c:30: if (!strcmp(name,"yeah"))
	ld	hl,#__str_0
	push	hl
	ld	l,4 (ix)
	ld	h,5 (ix)
	push	hl
	call	_strcmp
	pop	af
	pop	af
	ld	a,l
	or	a, a
	jr	NZ,00110$
;api.c:31: return NULL;
	ld	hl,#0x0000
	jr	00112$
00110$:
;api.c:32: else if (!strcmp(name,"buddy"))
	ld	hl,#__str_1
	push	hl
	ld	l,4 (ix)
	ld	h,5 (ix)
	push	hl
	call	_strcmp
	pop	af
	pop	af
	ld	a,l
	or	a, a
	jr	NZ,00107$
;api.c:33: return NULL;
	ld	hl,#0x0000
	jr	00112$
00107$:
;api.c:34: else if (!strcmp(name,"net"))
	ld	hl,#__str_2
	push	hl
	ld	l,4 (ix)
	ld	h,5 (ix)
	push	hl
	call	_strcmp
	pop	af
	pop	af
	ld	a,l
	or	a, a
	jr	NZ,00104$
;api.c:35: return NULL;
	ld	hl,#0x0000
	jr	00112$
00104$:
;api.c:36: else if (!strcmp(name,"filesys"))
	ld	hl,#__str_3
	push	hl
	ld	l,4 (ix)
	ld	h,5 (ix)
	push	hl
	call	_strcmp
	pop	af
	pop	af
	ld	a,l
	or	a, a
	jr	NZ,00112$
;api.c:37: return NULL;
	ld	hl,#0x0000
00112$:
	pop	ix
	ret
_api_query_end::
__str_0:
	.ascii "yeah"
	.db 0x00
__str_1:
	.ascii "buddy"
	.db 0x00
__str_2:
	.ascii "net"
	.db 0x00
__str_3:
	.ascii "filesys"
	.db 0x00
;api.c:43: word api_version() {
;	---------------------------------
; Function api_version
; ---------------------------------
_api_version_start::
_api_version:
;api.c:44: return VERSION; 
	ld	hl,#0x0003
	ret
_api_version_end::
;api.c:50: void api_init() {
;	---------------------------------
; Function api_init
; ---------------------------------
_api_init_start::
_api_init:
;api.c:51: fn_table.version=api_version;
	ld	hl,#_fn_table
	ld	(hl),#<(_api_version)
	inc	hl
	ld	(hl),#>(_api_version)
;api.c:52: fn_table.query=api_query;
	ld	hl,#_fn_table + 2
	ld	(hl),#<(_api_query)
	inc	hl
	ld	(hl),#>(_api_query)
	ret
_api_init_end::
	.area _CODE
	.area _CABS

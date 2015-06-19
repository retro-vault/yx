		;; clipping.s
		;; clipping utility routines
		;;
		;; tomaz stih, tue jun 9 2015
		.module	clipping

		.globl	_clip_1d
		.globl	_clip_offset

		.area	_CODE

;;void clip_offset(byte ofsx, byte ofsy, byte* maskin, byte* maskout)
_clip_offset::
		pop	hl		; return address
		exx			; alt. set
		pop	bc		; c'=ofsx, b'=ofsy
		pop	hl		; hl'=maskin
		pop	de		; de'=maskout
		;; restore stack, ignore order
		push	bc
		push	hl		
		push	de
		;; raw clip offset. 
		;; NOTES: alt reg set on
_clip_offset_raw::
		ld	a,b		; ofsy
		cp	#0		; finished?
		jr	nz,_cof_1part
		;; just copy data to maskout
		push	bc
		ld	bc,#8
		ldir	
		pop	bc
_cof_rot:	;; do the rotate
		dec	de
		dec	de
		dec	de
		dec	de
		dec	de
		dec	de
		dec	de
		dec	de
		ld	a,c		; a=rotate counter
		cp	#0		; no rotation?
		jr	z,_cof_theend	; we're done
		;; we'll need to rotate
		ld	h,#8		; 8 rows
_cof_row:
		ld	b,c		; number of rotations to b
		ld	a,(de)		; value to a
_cof_col:	;; do the actual rotation
		rlca			
		djnz	_cof_col
		ld	(de),a		; rotated value back
		inc	de
		dec	h
		jr	nz,_cof_row	; next row
		jr	_cof_theend
_cof_1part:
		inc	hl
		dec	a
		jr	nz,_cof_1part
		;; de points to correct byte, copy 1st half
		;; b=ofsy
		ld	a,#8
		sub	b
		ld	b,a		; first half offses
_cof_1p_cont:	
		ld	a,(hl)
		ld	(de),a
		inc	hl
		inc	de
		djnz	_cof_1p_cont
	
		;; de value is correct, hl is destroyed
		pop	hl		; get de but ignore it
		pop	hl		; get real hl
		pop 	bc		; all counters are back
		push	bc
		push	hl
		push	hl		; stack restored
_cof_2part:
		ld	a,(hl)
		ld	(de),a
		inc	hl
		inc	de
		djnz	_cof_2part
		;; shift 'em all
		jr	_cof_rot		
_cof_theend:	;; the very end.
		exx			; back to normal set
		push	hl		; ret. address
		ret



;;void clip_1d(byte l0, byte l1, byte r0, byte r1, byte *c0, byte *c1)
_clip_1d::
		pop	hl		; return address
		pop	bc		; c=l0, b=l1
		pop	de		; e=r0, d=r1
		exx			; alt set
		pop	hl		; hl=*c0
		pop	de		; de=*c1
		;; restore stack		
		push	de
		push	hl
		exx
		push	de
		push	bc
		push	hl
clip_1d_raw::
		;; is l0 < r0
		ld	a,c
		cp	e
		jr	c,clip_leftout
		ld	l,c		; l=correct coord 0
		jr	clip_coord2
clip_leftout:
		ld	l,e		; l=correct coord 0		
clip_coord2:		
		ld	a,b		
		cp	d		
		jr	c,clip_rightin	; l1 < r1
		ld	h,d		; h=correct coord 1
		jr	clip_1d_done
clip_rightin:	
		ld	h,e		; h=correct coord 1
clip_1d_done:	;; hl has coorect coords
		push	hl
		exx
		pop	bc		; get results to bc
		ld	(hl),c
		ex	de,hl
		ld	(hl),b
		exx		
		ret

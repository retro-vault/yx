		;; kempston.s
		;; kempston mouse driver
		;;
		;; based on Andrey Rachkin code
		;; http://8bit.yarek.pl/hardware/zx.mouse/kmouse.html
		;;
		;; tomaz stih, tue apr 28 2015
		.module	kempston

		.globl	_mouse_calibrate
		.globl	_mouse_scan

		.globl	kmp_scan_raw
		.globl	kmp_calib_raw

			

		KMP_BTN_PORT	= 0xfadf
		KMP_X_PORT	= 0xfbdf
		KMP_Y_PORT	= 0xffdf

		.area	_CODE


		;; extern void mouse_calibrate(byte x, byte y)
_mouse_calibrate::
		pop	hl		; return address
		pop	bc		; c=y, b=y

		;; restore stack		
		push	bc
		push	hl
		
		;; calibrate
		;; input:	b=start y, c=start x (hint:center)
		;; affets:	a, flags, hl, bc
kmp_calib_raw::
		ld	hl,#kmp_mcurxy	
		ld	a,c		; x to a
		ld	(hl),a		; to low cursor pos
		inc	hl
		ld	a,b		; y to a
		ld	(hl),a		; to high cursor pos
		inc	hl
		ld	bc,#KMP_X_PORT
		in	a,(c)		; x to a
		ld	(hl),a		; and to low hw pos
		inc	hl
		ld	bc,#KMP_Y_PORT
		in	a,(c)		; y to a
		ld	(hl),a		; to high hw pos
		ret

		;; extern void mouse_scan(mouse_info_t *mi)
_mouse_scan:
		call	kmp_scan_raw	; scan it
		ex	af,af'	
		ld	a,d		; store d to a'
		ex	af,af'
		pop	de		; return address
		pop	hl		; pointer to mi
		push	hl
		push	de		; restore it all
		ex	af,af'
		ld	d,a
		ex 	af,af'
		ld	(hl),c
		inc	hl
		ld	(hl),b
		inc	hl
		ld	(hl),a
		inc	hl
		ld	(hl),d
		ret
	
		;; scan kempston mouse
		;; input:	
		;;	(kmp_mcurxy)	... last cursor coords
		;;	(kmp_mbtn)	... last button status
		;; output:
		;;	a=mouse buttons
		;;	b=y
		;;	c=x
		;;	d=button chang flags (1=change, 0=no chg.)
		;; affects:	flags, a, bc, hl, de
kmp_scan_raw::
		;; first scan buttons for changes
		ld	bc,#KMP_BTN_PORT
		in	a,(c)		; buttons to a
		cpl			; complement (so that ... 1=pressed)
		and	#0x07		; just the bottom three
		ld	b,a		; store current buttons
		ld	a,(kmp_mhwbtn)
		xor	b		; xor with current buttons
		ld	(kmp_mbtnchg),a	; store change flags
		ld	a,b		; a=new button state
		ld	(kmp_mhwbtn),a	; store

		;; now scan position for changes
kmp_scanpos:	ld      hl,(kmp_mcurxy)	; last cursor coords
		ld      de,(kmp_mhwxy) 	; last hardware coords
		ld      bc,#KMP_X_PORT
		in      a,(c) 		; read x from hw
		ld      (kmp_mhwxy),a	; immediately write
		sub     e		; minus prev. coord
		jr      z,kmp_x_done	; no change to x
		jp      p,kmp_x_right	; move right
		;; left or overflow
		add    	a,l		; a=old x-new x
		jr      c,kmp_l_norm	; normal left
		xor     a        	; overflow, a=0
kmp_l_norm:	ld      l,a		; to l
		jr      kmp_x_done
kmp_x_right:	add     a,l		; a=old x + dx
		jr      c,kmp_r_over	; overflow?
		cp      #0xff      	; max x?
		jr      c,kmp_r_norm
kmp_r_over:	ld      a,#0xff		; max x (should it be fe?)
kmp_r_norm:	ld      l,a		; to l
kmp_x_done:	ld      b,#0xff
		in      a,(c) 		; read y from hw
		ld      (kmp_mhwxy+1),a	; immediately write
		sub	d		; minus old hw y
		jr      z,kmp_y_done
		neg			; reverse coord.
		jp      p,kmp_u
		add     a,h		; how much up?
		jr      c,kmp_u_norm
		xor     a        	; min y coor
kmp_u_norm:	ld      h,a
		jr     	kmp_y_done
kmp_u:		add     a,h
		jr      c,kmp_d_over	; y overflow
		cp      #0xbf      	; 191 (max y)
		jr      c,kmp_d_norm
kmp_d_over:	ld      a,#0xbf    	; y=max y
kmp_d_norm:	ld      h,a		; store to h
kmp_y_done:	ld      (kmp_mcurxy),hl	; store new cursor pos
		push	hl
		pop	bc		; bc=hl
		ld	a,(kmp_mbtnchg)
		ld	d,a
		ld	a,(kmp_mhwbtn)	; button state to a
		ret

		.area	_DATA

kmp_mcurxy:	.word	0		; last cursor coords
kmp_mhwxy:	.word	0		; last mouse hardware read
kmp_mhwbtn:	.byte	0		; last mouse buttons hardware read
kmp_mbtnchg:	.byte	0		; mouse button changes

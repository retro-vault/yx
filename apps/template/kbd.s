		;;	kbc.c
		;;	zx spectrum kbd scanning code
		;;
		;;	tomaz stih wed sep 17 2014
		.module kbd
		
		.globl _kbd_scan
		.globl _kbd_init

_kbd_init::
		ld	hl,#0x1f1f
		ld	a,l
		ld	(#_prev_scan),hl
		ld	(#_prev_scan + 2),hl
		ld	(#_prev_scan + 4),hl
		ld	(#_prev_scan + 6),hl
		ret

		.area _CODE
_kbd_scan::		
		ld	hl,#_prev_scan
		
		ld	d,#0			; scan lines counter 
		ld	bc,#0xf7fe		; first scan line
scan_line:
		in	a,(c)			; get it in
		and	#0b00011111		; just interested in bits 0-4
		cp	(hl)			; compare to previous scan 
		jr	z,next_line		; nothing has changed

		;; ah-ha...we have a change!
		;; d=byte counter
		ld	e,a			; store curr state
		xor	(hl)			; xor prev state
		push	af			; store a
		and	e			; a...released buttons
		call	nz, released_keys
		pop	af			; back a
		and	(hl)			; a...pressed buttons
		call	nz, pressed_keys

		ld	(hl),e			; update prev scan

next_line:	
		;; next scan line addr to b
		ld	a,b			
		rlc	a			
		ld	b,a			

		
		
		inc	d
		ld	a,d			; get counter to a 
		cp	#8			; max scan lines reached?
		jr	z,end_scan		; no more lines to scan?

		inc	hl			; inc prev scan line pointer
		jr	scan_line		; scan another one

end_scan:
		ret

pressed_keys::
released_keys:
		ret

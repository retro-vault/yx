		;;	kbd.s
		;;	zx spectrum kbd scanning code
		;;
		;;	tomaz stih wed sep 17 2014
		.module kbd
		
		.globl _kbd_scan
		.globl _kbd_read
		.globl _kbd_map
		.globl _kbd_map_symbol
		.globl _kbd_map_shift
		.globl _kbd_prev_scan
		
	
		BUFSIZE			= 0x20	; 32 bytes of keyb. buffer


		.area	_CODE
_kbd_scan::		
		ld	hl,#_kbd_prev_scan
		ld	d,#0			; scan lines counter 
		ld	bc,#0xf7fe		; first scan line
scan_line:
		in	a,(c)			; get it in
		push	bc			; store b and c
		and	#0b00011111		; just interested in bits 0-4
		cp	(hl)			; compare to previous scan 
		jr	z,next_line		; nothing has changed
		;; ah-ha...we have a change!
		;; d=byte counter
		ld	e,a			; store curr state
		xor	(hl)			; xor prev state
		push	af			; store a
		ld	b,#0b00000000		; bit 6 is 0
		and	e			; a...released buttons
		call	nz, key_change
		pop	af			; back a
		ld	b,#0b01000000		; bit 6 is 1
		and	(hl)			; a...pressed buttons	
		call	nz, key_change
		ld	(hl),e			; update prev scan
next_line:	
		;; next scan line addr to b
		pop	bc			; restore b and c
		rlc	b						
		inc	d
		ld	a,d			; get counter to a 
		cp	#8			; max scan lines reached?
		jr	z,end_scan		; no more lines to scan?
		inc	hl			; inc prev scan line pointer
		jr	scan_line		; scan another one
end_scan:
		ret
		;; d is line number 0-7
		;; a holds bits 0..4 (5 bits), bit 6 is 1...pressed, 0...not pressed
		;; formula for key number is d*5 + set_bit(a)
key_change:	
		push	de			; store D,E
		ld	e,a			; store a
		ld	a,d			; get d into a
		rlc	d			; d=d*2
		rlc	d			; d=d*4
		add	d			; a=a+d*4=5*d
		ld	d,a			; d=d*5
		ld	a,#5			; 5 bits
rotate_keymsk:	
		sra	e			; bit into carry
		jr	nc,next_key
		push	af
		add	d			; a=correct key code
		dec	a
		or	b	
		call	queue_key
		pop	af
		sub	d			; back to a
next_key:
		dec	a
		jr 	nz,rotate_keymsk
		pop	de		
		ret
		;; queue key in a 
queue_key::
		push	bc
		push	de
		push	hl
		ld	c,a			; store a to c
		ld	a,(#_kbd_buff+2)	; a=count
		cp	#BUFSIZE		; is full?
		jr	z,qkey_end		; unfortunately we lost the key...
		ld	hl,(#_kbd_buff)		; l=start, h=end
		ld	de,#_kbd_buff+3		; de is start of kbd buffer
		ld	l,h			; l=end
		ld	h,#0			; hl=end
		add	hl,de			; hl=buffer address
		ld	(hl),c			; key to buffer
		inc	a			; count++
		ld	(#_kbd_buff+2),a	; store count
		ld	a,(#_kbd_buff+1)	; a=end
		inc	a			; end++
		cp	#BUFSIZE		; beyond the edge?
		jr	nz,qk_proceed
		xor	a			; a=0
qk_proceed:
		ld	(#_kbd_buff+1),a	; store end
qkey_end:
		pop	hl
		pop	de
		pop	bc
		ret

		;; -----------------------
		;; extern byte kbd_read();
		;; -----------------------
_kbd_read::
		call	_intr_disable		; could be interrupted by _kbd_scan
		ld	a,(#_kbd_buff+2)	; a=count
		cp	#0			; is it zero?
		jr	z,kr_empty		; no data in buffer
		; get the char
		ld	hl,(#_kbd_buff)		; l=start, h=end
		ld	de,#_kbd_buff+3		; de is start of kbd buffer
		ld	h,#0x00			; l=start, h=0
		add	hl,de			; hl points to correct place
		ld	b,(hl)			; get char to b
		; decrease counter, increase start
		dec	a
		ld	(#_kbd_buff+2),a
		ld	a,(#_kbd_buff)		; a=start
		inc	a
		cp 	#BUFSIZE		; end of buffer?
		jr	nz,kr_proceed
		xor	a			; reset start
kr_proceed:
		ld	(#_kbd_buff),a		; ...and store
		ld	l,b			; return char
		jr	kr_end			; game over
kr_empty:
		ld	l,#0x00			; key not found
kr_end:	
		call	_intr_enable		; enable (again)
		ret

		;; keyboard map		
		;; 0x0d ... enter
		;; 0x20 ... space
		;; 0x01 ... symbol shift
		;; 0x02 ... caps shift
		;; 0x03 ... symbol + undefined
		;; 0x04 ... caps + undefined
		;; 0x08 ... backspace
		;; 0x09 ... left
		;; 0x0a ... down
		;; 0x0b ... up
		;; 0x0c ... right
		;; 0x61 ... pound symbol
		;; 0x21 ... single quote
_kbd_map:	
		.byte '5',   '4',   '3',   '2',   '1'
		.byte '6',   '7',   '8',   '9',   '0'
		.byte 'y',   'u',   'i',   'o',   'p'
		.byte 'h',   'j',   'k',   'l',   0x0d 	
		.byte 'b',   'n',   'm',    0x01, 0x20
		.byte 'v',   'c',   'x',   'z',   0x02
		.byte 'g',   'f',   'd',   's',   'a'
		.byte 't',   'r',   'e',   'w',   'q'

_kbd_map_symbol:	
		.byte '%',   '$',   '#',   '@',   '!'
		.byte '&',   0x27,  '(',   ')',   '_'
		.byte '[',   ']',   0x80,  ';',   '"'
		.byte 0x5e,  '-',   '+',   '=',   0x0d 
		.byte '*',   ',',   '.',   0x01,  0x20	
		.byte '/',   '?',   0x61,  ':',   0x02
		.byte '}',   '{',   0x5d,  '|',   '~'
		.byte '>',   '<',   0x60,  0x03,  0x03

_kbd_map_shift:	
		.byte 0x09,  '4',   '3',   '2',   '1'
		.byte 0x0a,  0x0b,  0x0c,  '9',   0x08
		.byte 'Y',   'U',   'I',   'O',   'P'
		.byte 'H',   'J',   'K',   'L',   0x04 
		.byte 'B',   'N',   'M',   0x01,  0x20
		.byte 'V',   'C',   'X',   'Z',   0x02
		.byte 'G',   'F',   'D',   'S',   'A'
		.byte 'T',   'R',   'E',   'W',   'Q'



		.area _INITIALIZED
_kbd_prev_scan:
		.ds	8
_kbd_buff:
		.ds	3 + BUFSIZE


		.area _INITIALIZER
__xinit__kbd_prev_scan:
		.byte	0x1f, 0x1f, 0x1f, 0x1f, 0x1f, 0x1f, 0x1f, 0x1f
__xinit__kbd_buff:
		.byte	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		.area _CABS (ABS)


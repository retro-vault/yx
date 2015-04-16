		;;	kbc.c
		;;	zx spectrum kbd scanning code
		;;
		;;	tomaz stih wed sep 17 2014
		.module kbd
		
		.globl _kbd_scan
		.globl _kbd_init
	
		BUFSIZE			= 0x20	; 32 bytes of keyb. buffer

		.area	_CODE
_kbd_init::
		ld	hl,#0x1f1f
		ld	a,l
		ld	(#_prev_scan),hl
		ld	(#_prev_scan + 2),hl
		ld	(#_prev_scan + 4),hl
		ld	(#_prev_scan + 6),hl
		ld	hl,#0x0001		; head=1, tail=0
		ld	(#_kbd_buff),hl
		ret

		.area _CODE
_kbd_scan::		
		ld	hl,#_prev_scan
		
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
		;; a holds bits 0..4 (5 bits), 1...pressed, 0...not pressed
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
rotate_keymsk:	sra	e			; bit into carry
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
queue_key:
		push	bc
		push	de
		push	hl

		ld	hl,(#_kbd_buff)		; l=head, h=tail
		ld	c,a			; store a	
		ld	a,h
		cp	l
		jr	z,qkey_end		; buffer is full

		ld	de,#_kbd_buff+2		; de is start of kbd buffer
		push	hl			; store hl
		ld	h,#0			; no high, just low byte		
		add	hl,de			; hl is now char position
		ld	(hl),c			; store key
		pop	hl			; l=head, h=tail				

		ld	a,l
		inc	a
		cp 	#BUFSIZE		; if end of buffer...
		jr	nz,proceed		
		xor	a			; ...then zero it
proceed:	ld	l,a			; back to l
		ld	(#_kbd_buff),hl		; and store new state

qkey_end:
		pop	hl
		pop	de
		pop	bc
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

kbd_map:	.byte '5',   '4',   '3',   '2',   '1'
		.byte '6',   '7',   '8',   '9',   '0'
		.byte 'y',   'u',   'i',   'o',   'p'
		.byte 'h',   'j',   'k',   'l',   0x0d 	
		.byte 'b',   'n',   'm',    0x01, 0x20
		.byte 'v',   'c',   'x',   'z',   0x02
		.byte 'g',   'f',   'd',   's',   'a'
		.byte 't',   'r',   'e',   'w',   'q'

symbol_kbd_map:	.byte '%',   '$',   '#',   '@',   '!'
		.byte '&',   0x27,  '(',   ')',   '_'
		.byte '[',   ']',   0x80,  ';',   '"'
		.byte 0x5e,  '-',   '+',   '=',   0x0d 
		.byte '*',   ',',   '.',   0x01,  0x20	
		.byte '/',   '?',   0x61,  ':',   0x02
		.byte '}',   '{',   0x5d,  '|',   '~'
		.byte '>',   '<',   0x60,  0x03,  0x03

shift_kbd_map:	.byte 0x09,  '4',   '3',   '2',   '1'
		.byte 0x0a,  0x0b,  0x0c,  '9',   0x08
		.byte 'Y',   'U',   'I',   'O',   'P'
		.byte 'H',   'J',   'K',   'L',   0x04 
		.byte 'B',   'N',   'M',   0x01,  0x20
		.byte 'V',   'C',   'X',   'Z',   0x02
		.byte 'G',   'F',   'D',   'S',   'A'
		.byte 'T',   'R',   'E',   'W',   'Q'



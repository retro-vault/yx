		;; srecv57k.s
		;; rs232 receive @ 57.600-8-N-2 baud
		;;
		;; tomaz stih, thu aug 2 2012

		.module srecv57k
		.globl	_rs232_buffered_input

		;; consts
		RS232_IBUFF_SIZE 	= 0x14
		RS232_CTL		= 0xef
		RS232_DTA		= 0xf7
		CTS_ON			= 0xff
		CTS_OFF			= 0xef
		BITS			= 0x08

		.area	_CODE
	
_rs232_buffered_input::
		di

		ld	iy,#0x0000
		add	iy,sp
		ld	l,2(iy)
		ld	h,3(iy)
		push	hl			; store original buffer

		ld	b,#RS232_IBUFF_SIZE
		ld	c,#RS232_DTA
		
		;; intialize SP
		ld	(#_rs232_sp),sp		; store SP
		
		;; pulse cts
		ld	a,#CTS_ON		; xxx0xxxx - CTS | 7 t-states
		out	(RS232_CTL),a		; CTS 11 t-states

start_bit:	
		ld	sp,#retm_table		; 10 t-states

		;; get start bit, try 20 times before giving up 
		in	a,(c)			; read rs232 bit | 12 t-states
		ret	m			; if start bit | 5/11 t-states
		in	a,(c)
		ret	m
		in	a,(c)
		ret	m
		in	a,(c)
		ret	m
		in	a,(c)
		ret	m
		in	a,(c)
		ret	m
		in	a,(c)
		ret	m
		in	a,(c)
		ret	m
		in	a,(c)
		ret	m
		in	a,(c)
		ret	m
		in	a,(c)
		ret	m
		in	a,(c)
		ret	m
		in	a,(c)
		ret	m
		in	a,(c)
		ret	m
		in	a,(c)
		ret	m
		in	a,(c)
		ret	m
		in	a,(c)
		ret	m
		in	a,(c)
		ret	m
		in	a,(c)
		ret	m
		in	a,(c)
		ret	m
		in	a,(c)
		ret	m
		in	a,(c)
		ret	m
		in	a,(c)
		ret	m
		in	a,(c)
		ret	m
		in	a,(c)
		ret	m
		in	a,(c)
		ret	m
		in	a,(c)
		ret	m
		in	a,(c)
		ret	m
		in	a,(c)
		ret	m
		in	a,(c)
		ret	m
		in	a,(c)
		ret	m
		in	a,(c)
		ret	m
		in	a,(c)
		ret	m
		in	a,(c)
		ret	m

		;; no start bit, assume no more data 
		ld	a,#CTS_OFF		; xxx1xxxx (cts) | 7 t-states 
		out	(RS232_CTL),a		; deactivate CTS | 11 t-states

		ld 	sp,(#_rs232_sp)		; restore stack

		pop	de			; original buffer to de
		or	a			; clear carry
		sbc	hl,de			; count of bytes to hl

		ei				; enable interrupts
		ret

data_bits:
		ld	d,b			; store b | 4 t-states
		ld	b,#BITS			; 8 bits to read
	
		;; waste t-states	
		inc	iy			; 10 t-states
		dec	iy			; 10 t-states
		inc	iy			; 10 t-states
		dec	iy			; 10 t-states
		inc	iy			; 10 t-states
		dec	iy			; 10 t-states
		nop				; 4 t-states
		nop				; 4 t-states

read_bit:
		;; start reading data bits 
		in  	a,(RS232_DTA)  		; bit 0  | 11 t-states 
		rla                     	; lsb to carry | 7 t-states 
		rr 	e               	; and to msb (e) |8 t-states

		;; waste 20 t-states
		inc	iy
		dec	iy

		djnz	read_bit		; 13/8 t-states           	

		ld	b,d			; restore b | 4 t-states

		;; t-states of 2 stop bits ... to prepare for next start bit 
		ld	a,e			; 4 t-states 
		cpl				; 4 t-states 
		ld	(hl),a			; write to buffer | 7 t-states 
		inc	hl			; increase buff. counter | 6 t-states 
	
		;; tell sender to stop sending (every time you read a byte...)
		ld	a,#CTS_OFF		; xxx1xxxx (cts) | 7 t-states 
		out	(RS232_CTL),a		; CTS off | 11 t-states

		djnz	jp_sbit			; 13/8 t-states
		
		ld 	sp,(#_rs232_sp)		; restore stack

		pop	de			; original buffer to de
		or	a			; clear carry
		sbc	hl,de			; count of bytes to hl

		ei
		ret

jp_sbit:	jp	start_bit
retm_table:	.word data_bits

		;; srecv115k.s
		;; rs232 receive @ 115.200-8-N-2 baud
		;;
		;; notes: works, but unreliable
		;;
		;; tomaz stih, thu aug 2 2012

		.module srecv115k
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
		call	_di

		;; buffer to hl
		ld	iy,#0x0000
		add	iy,sp
		ld	l,2(iy)
		ld	h,3(iy)
		push	hl			; store original buffer

		;; initial values
		ld	a,#CTS_ON		; xxx1xxxx - CTS
		ld	b,#RS232_IBUFF_SIZE	; b=buffer size
		ld	c,#RS232_DTA		; c=data port
		ld	de,#0x8000		; masks
		
		;; intialize SP
		ld	(#_rs232_sp),sp		; store SP
		ld	sp,#retm_table		; 20 x same return address 

		;; announce clear to send (CTS)
		out	(RS232_CTL),a		; 11 t-states

start_bit:
		;; get start bit, try 10 times before giving up 
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
		
		;; no start bit, assume no more data 
		ld	a,#CTS_OFF		; 11101111 (cts) | 7 t-states 
		out	(RS232_CTL),a		; deactivate CTS | 11 t-states
		ld 	sp,(#_rs232_sp)		; restore stack

		pop	de			; original buffer to de
		or	a			; clear carry flag
		sbc	hl,de			; count of bytes to hl
		call	_ei			; enable interrupts
		ret

data_bits:
		;; add 21 t-states
		cp	#0			; 7 t-states
		dec	a			; 4 t-states
		nop				; 4 t-states
		nop				; 4 t-states

		;; start reading data bits 
		in  	a,(#0xf7)   	; bit 0  | 11 t-states 
		rla                     	; lsb to carry | 7 t-states 
		rr 	e               	; and to msb (e) |8 t-states 
		nop				; 4 t-states 

		in  	a,(#0xf7) 
		rla
		rr 	e
		nop

		in  	a,(#0xf7)
		rla  
		rr 	e
		nop

		in  	a,(#0xf7)
		rla
		rr 	e 
		cp	#0			; waste extra cycles from now on

		in  	a,(#0xf7)
		rla
		rr 	e 
		cp	#0

	
		in  	a,(#0xf7)
		rla 
		rr 	e	
		cp	#0
	
		in  	a,(#0xf7)
		rla
		rr 	e
		cp	#0
	
		in  	a,(#0xf7)
		rla  
		rr 	e 

		;; t-states of 2 stop bits ... to prepare for next start bit 
		ld	a,e			; 4 t-states 
		cpl				; 4 t-states 
		ld	(hl),a			; write to buffer | 7 t-states 
		inc	hl			; increase buff. counter | 6 t-states 
	
		;; tell sender to stop sending (every time you read a byte...)
		ld	a,#CTS_OFF		; xxx0xxxx (set cts) | 7 t-states 
		out	(RS232_CTL),a		; raise CTS | 11 t-states

		djnz	jp_start_bit		; 13/8 t-states
		
		ld 	sp,(#_rs232_sp)		; restore stack
		
		pop	de			; original buffer to de
		or	a			; clear carry flag
		sbc	hl,de			; count of bytes to hl

		call	_ei
		ret

jp_start_bit:	jp	start_bit

retm_table:	
		.word data_bits, data_bits, data_bits, data_bits
		.word data_bits, data_bits, data_bits, data_bits
		.word data_bits, data_bits, data_bits, data_bits
		.word data_bits, data_bits, data_bits, data_bits
		.word data_bits, data_bits, data_bits, data_bits
		.word data_bits, data_bits, data_bits, data_bits
		.word data_bits, data_bits, data_bits, data_bits
		.word data_bits, data_bits, data_bits, data_bits
		.word data_bits, data_bits, data_bits, data_bits
		

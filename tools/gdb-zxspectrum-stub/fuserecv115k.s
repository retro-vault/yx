		;; fuserecv115k.s
		;; rs232 receive @ 115.200-8-N-2 baud
		;;
		;; notes: for FUSE only, exploits FUSE bugs!
		;;
		;; tomaz stih, sat jul 12 2014
		.module fuserecv115k
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

		;; buffer to hl
		pop	af
		pop	hl
		push	hl
		push	af

		;; optimization for later ... hl to top of stack
		push	hl

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
		;; get start bit, try 3 times before giving up 
		in	a,(c)			; read rs232 bit
		ret	m			; if start bit
		in	a,(c)			
		ret	m			
		in	a,(c)			
		ret	m			
		
		;; no start bit, assume no more data 
		ld	a,#CTS_OFF		; xxx0xxxx (cts off) 
		out	(RS232_CTL),a		; raise CTS

		ld 	sp,(#_rs232_sp)		; restore stack

		pop	de			; original buffer to de
		or	a			; clear carry flag
		sbc	hl,de			; count of bytes to hl
		ei				; enable interrupts
		ret

data_bits:
		;; fuse hack - 4 start bits, dont even ask.
		in	a,(c)
		in	a,(c)
		in	a,(c)

		;; start reading data bits, nevermind the timing
		in  	a,(#0xf7)   		; bit 0   
		rla                     	; lsb to carry 
		rr 	e               	; and to msb (e)  

		in  	a,(#0xf7) 
		rla
		rr 	e

		in  	a,(#0xf7)
		rla  
		rr 	e

		in  	a,(#0xf7)
		rla
		rr 	e 

		in  	a,(#0xf7)
		rla
		rr 	e

	
		in  	a,(#0xf7)
		rla 
		rr 	e	
	
		in  	a,(#0xf7)
		rla
		rr 	e
	
		in  	a,(#0xf7)
		rla  
		rr 	e 

		;; 2 stop bits ... to prepare for next start bit 
		ld	a,e			 
		cpl				; prepare result in a 
		ld	(hl),a			; write to buffer 
		inc	hl			; increase buff. counter 
	
		;; tell sender to stop sending (every time you read a byte...)
		ld	a,#CTS_OFF		; xxx0xxxx (cts) 
		out	(RS232_CTL),a		

		djnz	start_bit
		
		ld 	sp,(#_rs232_sp)		; restore stack
		
		pop	de			; original buffer to de
		or	a			; clear carry flag
		sbc	hl,de			; count of bytes to hl

		ei
		ret

retm_table:	;; max 20 bytes -> max 20 returns
		.word data_bits, data_bits, data_bits, data_bits
		.word data_bits, data_bits, data_bits, data_bits
		.word data_bits, data_bits, data_bits, data_bits
		.word data_bits, data_bits, data_bits, data_bits
		.word data_bits, data_bits, data_bits, data_bits

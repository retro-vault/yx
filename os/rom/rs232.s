		;; rs232.s
		;; rs232 send and receive, FUSE version
		;;
		;; notes: works with FUSE only, exploits FUSE bugs!
		;;
		;; tomaz stih, sun sep 6 2015
		.module rs232

		.globl	_rs232_buffered_input
		.globl	_rs232_putb

		;; consts
		RS232_IBUFF_SIZE 	= 0x14
		RS232_CTL		= 0xef
		RS232_DTA		= 0xf7
		CTS_ON			= 0xff
		CTS_OFF			= 0xef
		BITS			= 0x08
		RESULT_SUCCESS		= 0x00

		.area	_CODE
	
		;; extern word rs232_buffered_input(void *buffer);
_rs232_buffered_input::
		di
		;; buffer to hl
		pop	de
		pop	hl
		push	hl
		push	de
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


		;; extern result rs232_putb(byte b);
_rs232_putb:: 
		di				; no interrupts for precise timing 
		;; get byte ptr from stack
		ld	hl,#0x0000
		add	hl,sp
		inc	hl
		inc	hl			; hl points to byte to send
		;; fuse hack, fuse waiting for down signal
		ld	a,#0xfe			; signal tx to low 
		out	(RS232_DTA),a
		;; send the start bit 
		ld	bc,#0x01ff		; b=0x01, c=0xff  
		ld	a,c
		ld	d,(hl)			; byte to transfer to d 
		out	(RS232_DTA),a		; start bit
		;; start sending out bits... 
		srl	d			; LSB to carry... 
		rla				; ...and to LSB of a 
		xor	b			; negate bit 0 
		out	(RS232_DTA),a		; out bit
		srl	d			
		rla				
		xor	b						
		out	(RS232_DTA),a
		srl	d
		rla
		xor	b
		out	(RS232_DTA),a
		srl	d
		rla
		xor	b
		out	(RS232_DTA),a
		srl	d
		rla
		xor	b
		out	(RS232_DTA),a
		srl	d
		rla
		xor	b
		out	(RS232_DTA),a
		srl	d
		rla
		xor	b
		out	(RS232_DTA),a
		srl	d
		rla
		xor	b
		out	(RS232_DTA),a
		;; emit stop bit 
		ld	a,#0xfe			; load a with stop bit 
		inc	hl			
		out	(RS232_DTA),a		; emit stop bit
		out	(RS232_DTA),a		; second stop bit
		;; fuse hack, bit 12 must be 1
		ld	a,#0xff
		out	(RS232_DTA),a		; retransmit stop bit 3 times for FUSE
		ld	l,#RESULT_SUCCESS	; report success
		ei
		ret


		.area	_BSS
_rs232_sp::
		.ds	2
_rs232_ibuff::
		.ds	RS232_IBUFF_SIZE

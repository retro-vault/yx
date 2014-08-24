		;; fusesend115k.s
		;; rs232 send @ 115.200-8-N-2 baud
		;;
		;; notes: for FUSE only, exploits FUSE bugs!
		;;
		;; tomaz stih, sat jul 12 2014

		.module fusesend115k
		.globl	_rs232_putb

		;; consts
		RS232_CTL		= 0xef
		RS232_DTA		= 0xf7
		CTS_ON			= 0xff
		CTS_OFF			= 0xef
		RESULT_SUCCESS		= 0x00

		.area	_CODE
	
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


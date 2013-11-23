		;; ssend115k.s
		;; rs232 send @ 115.200-8-N-2 baud
		;;
		;; tomaz stih, thu aug 2 2012

		.module ssend115k
		.globl	_rs232_putb

		;; consts
		RS232_CTL		= 0xef
		RS232_DTA		= 0xf7
		CTS_ON			= 0xff
		CTS_OFF			= 0xef
		RESULT_SUCCESS		= 0x00

		.area	_CODE
	
_rs232_putb::
		;; delay between bits must be
		;; 30.3819 t-states (= 3.500.000 / 115.200) 
		call	_di			; no interrupts for precise timing 

		;; get byte ptr from stack
		ld	hl,#0x0000
		add	hl,sp
		inc	hl
		inc	hl			; hl points to byte to send

		;; make sure CTS is off (just to make sure)
		ld	a,#CTS_OFF
		out	(RS232_CTL),a	

		;; 1. Send the start bit 
		ld	bc,#0x01ff		; b=0x01, c=0xff | 10 t-states 
		ld	a,c			; 4 t-states 
		ld	d,(hl)			; byte to transfer to d | 7 t-states 
		out	(RS232_DTA),a		; start bit | 11 t-states 

		;; 2. start sending out bits... 
		srl	d			; LSB to carry... | 8 t-states 
		rla				; ...and to LSB of a | 4 t-states 
		xor	b			; negate bit 0 | 4 t-states 
		nop				; 4 t-states 
		out	(RS232_DTA),a		; out bit | 11 t-states
		;; 31 t-states...should do */

		srl	d			
		rla				
		xor	b			
		nop				
		out	(RS232_DTA),a

		srl	d
		rla
		xor	b
		nop
		out	(RS232_DTA),a

		srl	d
		rla
		xor	b
		nop
		out	(RS232_DTA),a

		srl	d
		rla
		xor	b
		nop
		out	(RS232_DTA),a

		srl	d
		rla
		xor	b
		nop
		out	(#0xf7),a

		srl	d
		rla
		xor	b
		nop
		out	(RS232_DTA),a

		srl	d
		rla
		xor	b
		nop
		out	(RS232_DTA),a
				
		;; 3. emit stop bit 
		ld	a,#0xfe			; load a with stop bit | 7 t-states 
		inc	hl			; 6 t-states
		nop				; 4 t-states 
		out	(RS232_DTA),a		; emit stop bit || 11 t-states 
	
		;; what about stop bit duration?
		;; sending start bit takes 31 t-states so even if
		;; one _rs232_write is called after another there is still enough mark time... */

		ld	l,#RESULT_SUCCESS	; report success

		call	_ei
		ret


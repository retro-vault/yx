/*
 *	keyboard.c
 *	keyboard device driver 
 *
 *	tomaz stih wed may 30 2012
 */
#include "yeah.h"

kbd_handle_t *kbd_exclusive_handle=NULL;
byte kbd_buffer[KBD_BUFF_SIZE];
byte kbd_buff_head=0;
byte kbd_buff_tail=0;
byte kbd_lastkey=0;

/*
 * keyboard maps
 */
byte kbd_map[]={
	CAPS,	'z',	'x',	'c',	'v',
	'a',	's',	'd',	'f',	'g',
	'q',	'w',	'e',	'r',	't',
	'1',	'2',	'3',	'4',	'5',
	'0',	'9',	'8',	'7',	'6',
	'p',	'o',	'i',	'u',	'y',
	ENTER,	'l',	'k',	'j',	'h',
	SPACE,	SYM,	'm',	'n',	'b'
	};

byte caps_kbd_map[]= {
	NOMAP,	'Z',	'X',	'C',	'V',
	'A',	'S',	'D',	'F',	'G',
	'Q',	'W',	'E',	'R',	'T',
	'1',	'2',	'3',	'4',	LEFT,
	DELETE,	'9',	RIGHT,	UP,	DOWN,
	'P',	'O',	'I',	'U',	'Y',
	ENTER,	'L',	'K',	'J',	'H',
	CAPSBRK,CAPSSYM,'M',	'N',	'B'
	};

byte sym_kbd_map[]={
	CAPSSYM,':' ,	0x60,	'?' ,	'/',
	0x7e,	0x7c,	0x5c,	'{' ,	'}',
	NOMAP,	NOMAP,	NOMAP,	'<' ,	'>',
	'!',	'@',	'#',	'$',	'%',
	'_',	')',	'(',	0x27,	'&',
	0x22,	';',	0x7f,	']',	'[',
	ENTER,	'=',	'+',	'-',	0x5e,
	SYMBRK,	NOMAP,	'.',	',',	'*'
	};

/*
 * driver functions
 */
word kbd_open(struct driver_s *drv, uint8_t *hint, uint16_t attr) {
	if (kbd_exclusive_handle!=NULL) {
		last_error=RESULT_CANT_LOCK;
		return NULL;
	} else {
		kbd_exclusive_handle=mem_allocate(sizeof(kbd_handle_t), (word)tsk_current);
		kbd_exclusive_handle->driver=drv;
		kbd_exclusive_handle->owner=tsk_current;
		kbd_exclusive_handle->read_done=NULL;
		kbd_exclusive_handle->ret_char=NULL;
		last_error=RESULT_SUCCESS;
	}
	return (word)kbd_exclusive_handle;
}

void kbd_close(word handle) {
	if (handle!=(word)kbd_exclusive_handle)
		last_error=RESULT_DONT_OWN;
	else {
		mem_free(kbd_exclusive_handle);
		kbd_exclusive_handle=NULL;
		last_error=RESULT_SUCCESS;
	}
}

result kbd_read_async(word handle, uint8_t *buffer, uint16_t count, event_t *done) {
	if (handle!=(word)kbd_exclusive_handle)
		return last_error=RESULT_DONT_OWN;
	else {
		if (kbd_exclusive_handle->read_done!=NULL)
			return last_error=RESULT_CANT_LOCK;
		else if (count!=1) /* can only read single byte from driver */
			return last_error=RESULT_INVALID_PARAMETER;
		else {
			kbd_exclusive_handle->read_done=done;
			kbd_exclusive_handle->ret_char=buffer;
			return last_error=RESULT_SUCCESS;
		}
	}
}

void kbd_timer_hook() {

	word the_key;

	/* scan the keyboard */
	kbd_scan();

	/* check if subscription to key */
	if (kbd_exclusive_handle!=NULL &&
		kbd_exclusive_handle->read_done!=NULL && 
		kbd_exclusive_handle->ret_char!=NULL) {
			/* if byte in buffer then read it and pulse an event */
			the_key=kbd_get_key();
			if (the_key) {
				*(kbd_exclusive_handle->ret_char)=the_key;
				evt_set(kbd_exclusive_handle->read_done,signaled);
			}
		}
}

word kbd_get_key() __naked {
	__asm
		ld	hl,#_kbd_buff_tail	; end of kbd buffer
		ld	b,(hl)			; to b
		ld	hl,#_kbd_buff_head	; start of kbd buffer
		ld	a,(hl)			; to a
		cp	b			; kbd buffer empty?
		jr	nz,key_avail
		ld	hl,#0			; return 0 in hl
		ret	
key_avail:	
		ld	d,#0
		ld	e,a
		inc	a			; next position in buffer
		cp	#KBD_BUFF_SIZE		; end of buffer?
		jr	z,resetbstart
		jr	updatebstart
resetbstart:	ld	a,#0			; buffer overflow
updatebstart:	ld	(hl),a			; write to tail
		ld	hl,#_kbd_buffer
		add	hl,de			; hl points to next key
		ld	a,(hl)			; get the key
		ld	h,#0
		ld	l,a			; and store to hl
endread:	ret	
	__endasm;
}

word kbd_scan() {

	__asm
		ld	l,#1
		ld	bc,#0xfefe		; first line to scan
		ld	de,#0x0000		; de holds "downed" keys
scanline:	in	a,(c)			; read kbd
		or	#0xe0			; set bits 5-7 of a
		cp	#0xff			; all bits set?
		jr	nz,testbits		; no key down
		inc	l
		inc	l
		inc	l
		inc	l
		inc	l
		jr	nextscan

		; manualy test bits 0-4	
testbits:	bit	0,a			
		call	z,keydown
		inc	l
		bit	1,a
		call	z,keydown
		inc	l
		bit	2,a
		call	z,keydown
		inc	l
		bit	3,a
		call	z,keydown
		inc	l
		bit	4,a
		call	z,keydown
		inc	l
		jr	nextscan
			
		; store keys to d and e
keydown:	ex	af,af'			; alternate accu.
		ld	a,d			; d already contains key?			
		cp	#0		
		jr	nz,keytoe	
		ld	d,l
		jr	endofscan
keytoe:		ld	a,e
		cp	#0
		jr	nz,ghosting
		ld	e,l
		jr	endofscan
ghosting:	ld	de,#0x0000		; reset de
endofscan:	ex	af,af'			; restore a to in a,(c) result
		ret

		; cont with scan
nextscan:	ld	a,b
		scf				; carry flag on
		rla				; next line
		ld	b,a
		cp	#0xff			; the end?
		jr	nz, scanline

kbd_process:	ld	a,d
		cp	e			
		jr	z,nokeys		; no keys to process, de=0
	
		ld	a,d			; get first key
		dec	a			; minus 1 to get offset
	
		cp	#CAPSOFFS		; caps shift?	
		jr	z,caps			
		cp	#SYMOFFS		; symbol shift?
		jr	z,sym_
		
		ld	a,e			; check symbol again
		dec	a
		cp	#SYMOFFS		; second key could be symbol?
		jr	z,symbole

		ld	a,d

		ld	hl,#_kbd_map
		jr	prockey

caps:		ld	a,e
		cp	#0			; is there another key?
		jr	z,keyprocend
		ld	hl,#_caps_kbd_map
		jr	prockey

sym_:		ld	a,e
		cp	#0
		jr	z,keyprocend
		jr	gosymbol

symbole:	ld	a,d			; d is key and we know it is not 0
gosymbol:	ld	hl,#_sym_kbd_map
		jr	prockey

prockey:	dec	a
		ld	d,#0			; get to key code
		ld	e,a
		add	hl,de
		ld	a,(hl)			; a now has key code

		ld	iy,#_kbd_lastkey
		ld	d,a
		ld	a,(iy)
		cp	d
		jr	z,keyprocend		; key is the same as previous...
		
		ld	a,d
		ld	(iy),a			; store new key code to previous
		
		ld	b,a			; store key code
		ld	iy,#_kbd_buff_tail
		ld	a,(iy)			; get end buffer
		ld	d,#0

		ld	e,a
		ld	hl,#_kbd_buffer
		add	hl,de			; hl points to kbd buffer
		inc	a			; increase end of buffer		
		cp	#KBD_BUFF_SIZE		; end of buffer?
		jr	z,resetbend
		jr	updatebend
resetbend:	ld	a,#0			; buffer overflow
updatebend:	ld	(iy),a			; write to _kbdbend
		ld	a,b			; restore key code and...
		ld	(hl),a			; ...insert to kbd buffer
		jr	keyprocend

nokeys:		ld	iy,#_kbd_lastkey
		ld	(iy),#0x00		; clear previous key

keyprocend:	ex	de,hl			; result from de to hl

		ret
	__endasm;

}

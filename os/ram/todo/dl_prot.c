/*
 *	dl_prot.c
 *	data link protocol implementation 
 *	
 *	tomaz stih thu jul 26 2012
 */
#include "dl_prot.h"

/* current sequence numbers starting with 1 (0...no sequence received yet) */
byte zx_sequence=0;
byte pc_sequence=0;

void communicate() {
	

		
}

word crc16(byte *buffer, word length) __naked {

	__asm
	
		/*
		 * from - http://wikiti.brandonw.net/index.php?title=Z80_Routines:Security:CRC16
		 */
		ld	iy,#0x0000
		add	iy,sp			/* iy = sp */
		
		ld	e,2(iy)			/* de = buffer address */
		ld	d,3(iy)
		
		ld	c,4(iy)			/* bc = byte count */
		ld	b,5(iy)
		
crc16_raw::     
		ld	hl,#0xFFFF
		push	bc
		
crc16_read:
		ld	a,(de)
		inc	de
		xor	h
		ld	h,a
		ld	b,#8
crc16_crcbyte:
		add	hl,hl
		jr	nc,crc16_next
		ld	a,h
		xor	#0x10
		ld	h,a
		ld	a,l
		xor	#0x21
		ld	l,a
crc16_next:
		djnz crc16_crcbyte
		
		pop bc
		dec bc
		push bc
		ld a,b
		or c
		jr nz,crc16_read
		   
		pop bc
		ret				/* hl holds calculated crc16 */
	
	__endasm;

}

#endif
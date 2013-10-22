# tools
CC			=	sdcc
AS			=	sdasz80
LD			=	sdcc
MAKEBIN		=	makezxbin
CFLAGS		=	--no-std-crt0 -mz80
ASFLAGS		=	-xlos -g
LDFLAGS		=	-mz80 --no-std-crt0 --nostdlib --code-loc 0x8100 --data-loc 0x8200 -Wl -b_HEADER=0x8000

.PHONY:		all clean

# dependencies
all:		app.bin
app.bin:	crt0.rel app.rel

# rules
%.bin:		%.rel
			$(LD) $(LDFLAGS) $^
			$(MAKEBIN) <app.ihx >app.bin

%.rel: 		%.s
			$(AS) $(ASFLAGS) -o $@ $<

%.rel: 		%.c
			$(CC) $(CFLAGS) -c -o $@ $<

			
clean:
			del *.rel 2>NUL
			del *.sym 2>NUL
			del *.lst 2>NUL
			del *.bin 2>NUL
			del *.lk 2>NUL
			del *.noi 2>NUL
			del *.map 2>NUL
			del *.ihx 2>NUL
			del *.asm 2>NUL
OBJS		=	crt0.rel c60s.rel c64.rel cour-new.rel envy.rel \
			ocr-a.rel sin-serif.rel chicago.rel liquid.rel \
			test.rel font.rel rect.rel
CC		=	sdcc
AS		=	sdasz80
LD		=	sdcc
LIB		=	ar
LIBFLAGS	=	-Sq
CFLAGS		=	-mz80 --no-std-crt0 -D DEBUG \
			--disable-warning 59 \
			--disable-warning 60 \
			--disable-warning 85 \
			--disable-warning 84 \
			--disable-warning 112 \
			--disable-warning 154
ASFLAGS		=	-xlos -g
LDFLAGS		=	-mz80 --no-std-crt0 --code-loc 0x0100 --data-loc 0x5b00 

.PHONY:		all clean

all:		48.rom

48.rom:		$(OBJS)
		$(LD) $(LDFLAGS) $^
		makebin -s 16384 <crt0.ihx >48.rom

%.rel: 		%.s
		$(AS) $(ASFLAGS) $(basename $*).rel $*.s

%.rel: 		%.c
		$(CC) $(CFLAGS) -c $<

clean:		
		rm -f core *~ \#* *.cdb *.rel *.hex *.ihx *.lst *.asm *.map *.o \
			*.rst *.sym *.lib *.bin *.mem *.lib kernel.s *.rom *.lnk

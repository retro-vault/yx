OBJS		=	crt0.rel z80-stub.rel fusesend115k.rel fuserecv115k.rel serial.rel 

CC		=	sdcc 
LD		=	sdcc
AS		=	sdasz80

CFLAGS		=	--no-std-crt0 -mz80 --no-peep --stack-auto \
			--disable-warning 85 \
			--disable-warning 154 \
			--disable-warning 196
LDFLAGS		=	-mz80 --no-peep --no-std-crt0 --code-loc 0x007a --data-loc 0x5b00 --stack-auto
ASFLAGS		=	-gols

.PHONY:		all clean

all:		sdbg

sdbg:		${OBJS}
		sdcc ${LDFLAGS} ${OBJS}
		makebin <crt0.ihx >48.rom
		truncate --size 16384 48.rom
		

%.rel: 		%.s
		$(AS) $(ASFLAGS) $(basename $*).rel $*.s

%.rel: 		%.c
		$(CC) $(CFLAGS) -c $<

clean:
		rm -f core *~ \#* *.cdb *.rel *.hex *.ihx *.lst *.asm *.map *.o \
			*.rst *.sym *.lib *.bin *.mem *.lib kernel.s *.rom *.lnk \
			*.lk *.noi



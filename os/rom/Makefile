# Tools.
GNUC		=	gcc
GNUCFLAGS	=	-I.
CC		=	sdcc
CFLAGS		=	-mz80 --no-std-crt0 -D DEBUG
AS		=	as-z80
ASFLAGS		=	-xlos -g
LD		=	sdcc
LDFLAGS		=	-mz80 --no-std-crt0 --code-loc 0x0092 --data-loc 0x5b00

# Deps.
CSRCS		=	$(wildcard *.c)
SSRCS		=	$(wildcard *.s)
OBJS		=	$(patsubst %.c,%.o,$(CSRCS)) $(patsubst %.s,%.o,$(SSRCS))

# Rules.
.PHONY:		all clean

all:		depend 48.rom

depend:		$(CSRCS)
		rm --force .depend
		$(GNUC) $(GNUCFLAGS) $(CSRCS) -MM >> .depend

-include 	.depend

48.rom:		crt0.o $(OBJS)
		$(LD) $(LDFLAGS) $^
		makebin -s 16384 <crt0.ihx >48.rom
		fuse-gtk --rom48 48.rom \
			--interface1 --interface2 \
			--kempston --kempston-mouse \
			--machine 48 --graphics-filter hq2x \
			--debugger-command "br 0x0000"

%.o:		%.s
		$(AS) $(ASFLAGS) $(basename $*).o $*.s

%.o: 		%.c
		$(CC) -c -o $@ $< $(CFLAGS)

clean:		
		rm 	-f core *~ \#* *.cdb *.rel *.hex *.ihx *.lst *.asm *.map *.o \
			*.rst *.sym *.lib *.bin *.mem *.lib kernel.s *.rom *.lnk \
			*.noi *.lk


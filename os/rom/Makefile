# Tools.
DIR		=	$(shell pwd)
GNUC		=	gcc
GNUCFLAGS	=	-I$(DIR)/include/
CC		=	sdcc
CFLAGS		=	-mz80 --no-std-crt0 -D DEBUG -I$(DIR)/include/ --reserve-regs-iy
AS		=	sdasz80
ASFLAGS		=	-xlos -g
LD		=	sdcc
LDFLAGS		=	-mz80 --no-std-crt0 \
			--code-loc 0x0092 \
			--data-loc 0x5b00
# Deps.
CSRCS		=	$(wildcard *.c)
SSRCS		=	$(wildcard *.s)
OBJS		=	$(patsubst %.c,%.rel,$(CSRCS)) $(patsubst %.s,%.rel,$(SSRCS))

# Rules.
.PHONY:		all clean

all:		depend 48.rom

depend:		$(CSRCS)
		rm --force .depend
		$(GNUC) $(GNUCFLAGS) $(CSRCS) -MM >> .depend
		sed -i 's/\.o/\.rel/g' .depend

-include 	.depend

48.rom:		crt0.rel $(OBJS)
		$(LD) $(LDFLAGS) $^
		makebin <crt0.ihx >48.rom
		truncate --size=16384 48.rom
		fuse-gtk --rom-48 48.rom \
			--interface1 \
			--machine 48 \
			--graphics-filter 2x \
			--no-sound \
			--debugger-command "br 0xffff"

%.rel:		%.s
		$(AS) $(ASFLAGS) $(basename $*).rel $*.s

%.rel: 		%.c
		$(CC) -c -o $@ $< $(CFLAGS)

clean:		
		rm -f core *~ \#* *.cdb *.rel *.hex *.ihx *.lst *.asm *.map *.rel \
			*.rst *.sym *.lib *.bin *.mem *.lib kernel.s *.rom *.lnk \
			*.noi *.lk *.tap a.out
		rm -f .depend

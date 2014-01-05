# Tools.
GNUC		=	gcc
GNUCFLAGS	=	-I.
CC		=	sdcc
CFLAGS		=	-mz80 --no-std-crt0 -D DEBUG
AS		=	sdasz80
ASFLAGS		=	-xlos -g
LD		=	sdcc
LDFLAGS		=	-mz80 --no-std-crt0 \
			--nostdlib --code-loc 0x8032 \
			--data-loc 0xF000 -Wl -b_HEADER=0x8000
# Deps.
CSRCS		=	$(wildcard *.c)
SSRCS		=	$(wildcard *.s)
OBJS		=	$(patsubst %.s,%.rel,$(SSRCS))
OBJS		+=	$(patsubst %.c,%.rel,$(CSRCS)) 

# Rules.
.PHONY:		all clean

all:		depend buddy.bin

depend:		$(CSRCS)
		rm --force .depend
		$(GNUC) $(GNUCFLAGS) $(CSRCS) -MM >> .depend

-include 	.depend

buddy.bin:	crt0.rel $(OBJS)
		$(LD) $(LDFLAGS) $^
		makezxbin <crt0.ihx >buddy.bin
		appmake +zx --binfile ./buddy.bin --org 32768
		fuse-gtk --tape ./buddy.tap \
			--interface1 --interface2 \
			--kempston --kempston-mouse \
			--machine 48 \
			--graphics-filter 2x
			# --graphics-filter hq2x \
			# --debugger-command "br 0x8000"

%.rel:		%.s
		$(AS) $(ASFLAGS) $(basename $*).rel $*.s

%.rel: 		%.c
		$(CC) -c -o $@ $< $(CFLAGS)

clean:		
		rm -f core *~ \#* *.cdb *.rel *.hex *.ihx *.lst *.asm *.map *.rel \
			*.rst *.sym *.lib *.bin *.mem *.lib kernel.s *.rom *.lnk \
			*.noi *.lk *.tap a.out

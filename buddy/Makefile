# Tools.
DIR		=	$(shell pwd)
GNUC		=	gcc
GNUCFLAGS	=	-I$(DIR)/include/
CC		=	sdcc
CFLAGS		=	-mz80 --no-std-crt0 -D DEBUG -I$(DIR)/include/
AS		=	sdasz80
ASFLAGS		=	-xlos -g
LD		=	sdcc
LDFLAGS		=	-mz80 --no-std-crt0 \
			--nostdlib --code-loc 0x8032 \
			--data-loc 0xc000 -Wl -b_HEADER=0x8000
# Deps.
CSRCS		=	$(wildcard *.c)
SSRCS		=	$(wildcard *.s)
OBJS		=	$(patsubst %.c,%.rel,$(CSRCS)) $(patsubst %.s,%.rel,$(SSRCS))

# Rules.
.PHONY:		all clean

all:		libs graphics depend app.bin

depend:		$(CSRCS)
		rm --force .depend
		$(GNUC) $(GNUCFLAGS) $(CSRCS) -MM >> .depend
		sed -i 's/\.o/\.rel/g' .depend

-include 	.depend

libs:	
		cd os && $(MAKE) INCLUDE=$(DIR)/include/ OUTDIR=$(DIR)/lib/
		cd graphics && $(MAKE) INCLUDE=$(DIR)/include/ OUTDIR=$(DIR)/lib/

app.bin:	crt0.rel $(OBJS)
		$(LD) $(LDFLAGS) $^ -los -lgraphics -Llib
		makezxbin <crt0.ihx >app.bin
		appmake +zx --binfile ./app.bin --org 32768
		fuse-gtk --tape ./app.tap \
			--interface1 \
			--kempston-mouse \
			--machine 48 --graphics-filter 2x \
			--no-sound \
			--debugger-command "br 0xffff"

%.rel:		%.s
		$(AS) $(ASFLAGS) $(basename $*).rel $*.s

%.rel: 		%.c
		$(CC) -c -o $@ $< $(CFLAGS)

clean:		
		cd os && $(MAKE) INCLUDE=$(DIR)/include/ OUTDIR=$(DIR)/lib/ clean
		cd graphics && $(MAKE) INCLUDE=$(DIR)/include/ OUTDIR=$(DIR)/lib/ clean
		rm -f core *~ \#* *.cdb *.rel *.hex *.ihx *.lst *.asm *.map *.rel \
			*.rst *.sym *.lib *.bin *.mem *.lib kernel.s *.rom *.lnk \
			*.noi *.lk *.tap a.out
		rm -f .depend

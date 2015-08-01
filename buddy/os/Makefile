# Tools.
GNUC		=	gcc
GNUCFLAGS	=	-I$(INCLUDE)
CC		=	sdcc
CFLAGS		=	-mz80 -I$(INCLUDE)
AS		=	sdasz80
AR		=	sdcclib
ARFLAGS		=	
ASFLAGS		=	-xlos -g
LD		=	sdcc
LDFLAGS		=	-mz80

# Deps.
CSRCS		=	$(wildcard *.c)
SSRCS		=	$(wildcard *.s)
OBJS		=	$(patsubst %.c,%.rel,$(CSRCS)) $(patsubst %.s,%.rel,$(SSRCS))

# Rules.
.PHONY:		all clean

all:		depend os.lib

depend:		$(CSRCS)
		rm --force .depend
		$(GNUC) $(GNUCFLAGS) $(CSRCS) -MM >> .depend
		sed -i 's/\.o/\.rel/g' .depend

-include 	.depend

os.lib:		$(OBJS)
		$(AR) $(ARFLAGS) $(OUTDIR)$@ $^

%.rel:		%.s
		$(AS) $(ASFLAGS) $(basename $*).rel $*.s

%.rel: 		%.c
		$(CC) -c -o $@ $< $(CFLAGS)

clean:		
		rm -f core *~ \#* *.cdb *.rel *.hex *.ihx *.lst *.asm *.map *.rel \
			*.rst *.sym *.lib *.bin *.mem *.lib kernel.s *.rom *.lnk \
			*.noi *.lk *.tap a.out
		rm -f $(OUTDIR)os.lib
		rm -f .depend

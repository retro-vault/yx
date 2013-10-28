GCC	=	gcc
CC	=	sdcc
LD	=	sdcc
AS	=	as-z80
MAKEBIN	=	makezxbin
CFLAGS	=	--no-std-crt0 -mz80
ASFLAGS	=	-xlos -g
GCFLAGS	=	-std=c99 -I.
LDFLAGS	=	-mz80 --no-std-crt0 --nostdlib --code-loc 0x8100 --data-loc 0x8200 -Wl -b_HEADER=0x8000

SRCS	=	$(wildcard *.c)
OBJS	=	$(patsubst %.c,%.o,$(SRCS))

.PHONY: all clean 

all:	depend buddy.bin

depend:	$(SRCS)
	rm -f .depend
	$(GCC) $(GCFLAGS) $(SRCS) -MM >> .depend

-include .depend

buddy.bin: crt0.o $(OBJS)
	$(LD) $(LDFLAGS) $^
	$(MAKEBIN) <crt0.ihx >buddy.bin

%.o:	%.s
	$(AS) $(ASFLAGS) -o $@ $<

%.o:	%.c
	$(CC) $(CFLAGS) -c -o $@ $<
	
clean:
	rm -f *.o 
	rm -f *.sym
	rm -f .depend
	rm -f *.lst
	rm -f *.bin
	rm -f *.lnk 
	rm -f *.noi	
	rm -f *.map
	rm -f *.ihx
	rm -f *.asm

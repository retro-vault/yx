OBJS		=	crt0.rel string.rel errors.rel interrupt.rel system.rel \
			list.rel name.rel handle.rel queue.rel \
			sysfont.rel hires.rel lores.rel \
			srecv115k.rel ssend115k.rel serial.rel \
			memory.rel event.rel timer.rel driver.rel task.rel \
			debug.rel ball.rel ukernel.rel 
			
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
LDFLAGS		=	-mz80 --no-std-crt0 --code-loc 0xc01f --data-loc 0x5b00 -Wl -b_HEADER=0xbfff -Wl -b_IM2=0xfff0

.PHONY:		all clean

all:		yx.bin

yx.bin:		$(OBJS)
		$(LD) $(LDFLAGS) $^
		makezxbin <crt0.ihx >yx.bin
		appmake +zx --binfile ./yx.bin --org 49151
		fuse-gtk --tape ./yx.tap \
			--interface1 --interface2 \
			--kempston --kempston-mouse \
			--machine 48 --graphics-filter hq2x \
			#--debugger-command "br 0xD25B"

%.rel:		%.s
		$(AS) $(ASFLAGS) $(basename $*).rel $*.s

%.rel: 		%.c
		$(CC) $(CFLAGS) -c $<

clean:		
		rm -f core *~ \#* *.cdb *.rel *.hex *.ihx *.lst *.asm *.map *.o \
			*.rst *.sym *.lib *.bin *.mem *.lib kernel.s *.rom *.lnk \
			*.noi *.lk *.tap

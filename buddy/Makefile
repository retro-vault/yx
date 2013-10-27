CC	=	gcc
CFLAGS	=	-DSDL -std=c99 -I. `pkg-config --cflags sdl`
LDFLAGS	=	`pkg-config --libs sdl`
SRCS	=	$(wildcard *.c)
OBJS	=	$(patsubst %.c,%.o,$(SRCS))

.PHONY: all clean 

all:	depend buddy

depend:	$(SRCS)
	rm -f .depend
	$(CC) $(CFLAGS) $(SRCS) -MM >> .depend

-include .depend

%.o:	%.c
	$(CC) -c -o $@ $< $(CFLAGS)
	
buddy:	$(OBJS)
	$(CC) -o $@ $^ $(LDFLAGS)
	
clean:
	rm -f *.o 
	rm -f *.exe
	rm -f .depend

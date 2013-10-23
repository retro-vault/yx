CC		=	gcc
CFLAGS	=	-I.
LDFLAGS	=	
SRCS	=	$(wildcard *.c)
OBJS	=	$(patsubst %.c,%.o,$(SRCS))

.PHONY: all clean 

all:	depend buddy.exe

depend:	$(SRCS)
		del .depend 2>NUL
		$(CC) $(CFLAGS) $(SRCS) -MM >> .depend

-include .depend

%.o:	%.c
	$(CC) -c -o $@ $< $(CFLAGS)
	
buddy.exe:	$(OBJS)
	$(CC) -o $@ $^ $(LDFLAGS)
	
clean:
		del *.o 2>NUL
		del *.exe 2>NUL
		del .depend 2>NUL
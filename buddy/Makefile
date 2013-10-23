CC		=	gcc
CFLAGS	=	-I. -I..\lib\SDL2-2.0.0\x86_64-w64-mingw32\include\SDL2
LDFLAGS	=	-L..\lib\SDL2-2.0.0\x86_64-w64-mingw32\lib -Dmain=SDL_main -lmingw32 -lsdl2main -lsdl2 -mwindows
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
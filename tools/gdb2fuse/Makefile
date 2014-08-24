# Tools.
CC		=	g++
CFLAGS		=	-std=c++0x

# Deps.
CSRCS		=	$(wildcard *.cpp)
OBJS		=	$(patsubst %.cpp,%.o,$(CSRCS))

# Rules.
.PHONY:		all clean

all:		depend gdb2fuse

depend:		$(CSRCS)
		rm --force .depend
		$(CC) -I. $(CSRCS) -MM >> .depend

-include 	.depend

gdb2fuse:	$(OBJS)
		$(CC) -o gdb2fuse $(OBJS)

%.o: 		%.cpp
		$(CC) -c -o $@ $< $(CFLAGS)

clean:		
		rm -f *.o *~ .depend gdb2fuse

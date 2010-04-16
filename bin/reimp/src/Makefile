CC = gcc -o $@
#CC = cl -nologo

#CFLAGS = -g -I.
CFLAGS = -O2 -I.

# .exe suffix
X = .exe
#X =

# object suffix
O = .o
#O = .obj

.SUFFIXES:
.SUFFIXES: .c $(O)

OBJS = reimp$(O) ar$(O) util$(O)

reimp$(X): $(OBJS)
	$(CC) $(OBJS)

reimp$(O): reimp.c reimp.h
ar$(O): ar.c reimp.h
util$(O): util.c reimp.h

.c$(O):
	$(CC) $(CFLAGS) -c $<

clean:
	rm -f *$(O) reimp$(X)

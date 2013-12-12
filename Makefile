CC	= gcc
AR      = ar
RANLIB  = ranlib
SIZE    = size

CFLAGS	= -O3 -Wall

ALL     = libpigpio.a checklib demolib pig2vcd pigpiod pigs

all:	$(ALL)

checklib:	checklib.o libpigpio.a
	$(CC) -o checklib checklib.c -L. -lpigpio -lpthread -lrt

demolib:	demolib.o libpigpio.a
	$(CC) -o demolib demolib.c -L. -lpigpio -lpthread -lrt

pig2vcd:	pig2vcd.o
	$(CC) -o pig2vcd pig2vcd.c

pigpiod:	pigpiod.o libpigpio.a
	$(CC) -o pigpiod pigpiod.c -L. -lpigpio -lpthread -lrt

pigs:		command.o
	$(CC) -o pigs pigs.c command.c

clean:
	rm -f *.o *.i *.s *~ $(ALL)

install:	$(LIB) 
	sudo install -m 0755 -d          /usr/local/include
	sudo install -m 0644 pigpio.h    /usr/local/include
	sudo install -m 0755 -d          /usr/local/lib
	sudo install -m 0644 libpigpio.a /usr/local/lib
	sudo install -m 0755 -d          /usr/local/bin
	sudo install -m 0755 pig2vcd     /usr/local/bin
	sudo install -m 0755 pigpiod     /usr/local/bin
	sudo install -m 0755 pigs        /usr/local/bin
	sudo python setup.py install

uninstall:
	sudo rm -f /usr/local/include/pigpio.h
	sudo rm -f /usr/local/lib/libpigpio.a
	sudo rm -f /usr/local/bin/pig2vcd
	sudo rm -f /usr/local/bin/pigpiod
	sudo rm -f /usr/local/bin/pigs

LIB     = libpigpio.a
OBJ     = pigpio.o command.o

$(LIB):	$(OBJ)
	$(AR) rcs $(LIB) $(OBJ)
	$(RANLIB) $(LIB)
	$(SIZE)   $(LIB)

# generated using gcc -M *.c

checklib.o: checklib.c pigpio.h
command.o: command.c pigpio.h command.h
demolib.o: demolib.c pigpio.h
pig2vcd.o: pig2vcd.c pigpio.h
pigpio.o: pigpio.c pigpio.h command.h
pigpiod.o: pigpiod.c pigpio.h command.h
pigs.o: pigs.c pigpio.h command.h


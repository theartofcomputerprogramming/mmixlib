LIBSIM=	libboot.c     libfinal.c     libload.c     libprint.c       libstats.c \
	libcommand.c  libinit.c      libmem.c      libprofile.c     libtrace.c \
	libdtrap.c    libinteract.c  libmmget.c    libshowbreaks.c  libglobals.c \
	libdump.c     liblibfinal.c  libmmput.c    libshowline.c    libstdin.c \
	libfetch.c    liblibinit.c   libperform.c  libsoption.c    

LIBAL=  libmmixal.c libalerror.c

LIBH=	libarith.h libtype.h mmix-io.h

LIBSRC= libname.c libbase.c

LIBOBJ= $(LIBSIM:.c=.o) $(LIBAL:.c=.o) $(LIBSRC:.c=.o) mmix-arith.o mmix-io.o


CC= gcc
CFLAGS= -Wall -ggdb -O0
AR = ar
ARFLAGS = cru
RANLIB = ranlib

all: libmmix.a mmix-sim.c mmixal.c

libbase.o: libbase.c libbase.h libconfig.h

%.o : %.c abstime.h mmixlib.h  $(LIBH)

boilerplate.w: mmix/boilerplate.w
	cp $< $@

abstime.h: mmix/abstime.h
	cp $< $@

mmix/abstime.h: mmix/abstime
	$(MAKE) -C mmix abstime
	mmix/abstime > mmix/abstime.h

mmix-arith.c: boilerplate.w mmix/mmix-arith.w
	ctangle mmix/mmix-arith.w

mmix-io.c: boilerplate.w mmix/mmix-io.w
	ctangle mmix/mmix-io.w

$(LIBAL):  boilerplate.w mmix/mmixal.w mmixallib.ch
	ctangle mmix/mmixal.w mmixallib.ch


$(LIBSIM) $(LIBH) mmix-sim.c: boilerplate.w mmix/mmix-sim.w mmixlib.ch libconfig.h
	ctangle mmix/mmix-sim.w mmixlib.ch 


libmmix.a: $(LIBOBJ)
	rm -f $@
	$(AR) $(ARFLAGS) $@ $(LIBOBJ)
	$(RANLIB) $@

mmix-sim: libmmix.a mmix-sim.c
	$(CC) $(CFLAGS) mmix-sim.c -L. -lmmix -o mmix-sim

mmixal: libmmix.a mmixal.c
	$(CC) $(CFLAGS) mmixal.c -L. -lmmix -o mmixal

.PHONY: TAGS
TAGS:
	etags *.c *.h *.ch

clean:
	rm -f *.o
	rm -f $(LIBSIM) $(LIBH) $(LIBAL) mmix-arith.c mmix-io.c
	rm -f *~ *.tmp
	rm -f libmmix.a mmix-sim
	rm -f mmix-sim.c mmixal.c

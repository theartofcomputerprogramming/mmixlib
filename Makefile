LIBSIM=	libboot.c     libfinal.c     libload.c     libprint.c       libstats.c \
	libcommand.c  libinit.c      libmem.c      libprofile.c     libtrace.c \
	libdtrap.c    libinteract.c  libmmget.c    libshowbreaks.c \
	libdump.c     liblibfinal.c  libmmput.c    libshowline.c \
	libfetch.c    liblibinit.c   libperform.c  libsoption.c \
	libarith.h  libtype.h


LIBOBJ= $(LIBSIM:.c=.o) mmix-arith.o libmmixal.o


CC= gcc
CFLAGS= -Wall
AR = ar
ARFLAGS = cru
RANLIB = ranlib

all: libmmix.a mmix-sim.c


%.o : %.c abstime.h mmixlib.h

boilerplate.w: mmix/boilerplate.w
	cp $< $@

abstime.h: mmix/abstime.h
	cp $< $@

mmix/abstime.h: mmix/abstime
	$(MAKE) -C mmix abstime
	mmix/abstime > mmix/abstime.h

mmix-arith.c: boilerplate.w mmix/mmix-arith.w
	ctangle mmix/mmix-arith.w

libmmixal.c: 
	ctangle mmix/mmixal.w libmixal.ch libmmixal.c


$(LIBSIM) mmix-sim.c: boilerplate.w mmix/mmix-sim.w mmixlib.ch libconfig.h
	ctangle mmix/mmix-sim.w mmixlib.ch 


libmmix.a: $(LIBSIM) $(LIBOBJ)
	rm -f $@
	$(AR) $(ARFLAGS) $@ $(LIBOBJ)
	$(RANLIB) $@


clean:
	rm -f *.o
	rm -f $(LIBSIM) mmix-arith.c libmmixal.c
	rm -f *~
	rm -f libmmix.a
	rm -f mmix-sim.c

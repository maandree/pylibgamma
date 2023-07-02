.POSIX:

CONFIGFILE = config.mk
include $(CONFIGFILE)

OS = linux
include mk/$(OS).mk


OBJ =\
	libgamma_native_error.o\
	libgamma_native_facade.o\
	libgamma_native_method.o

PYSRC =\
	libgamma.py\
	libgamma_error.py\
	libgamma_facade.py\
	libgamma_method.py

LIBFILES = $(OBJ:.o=.$(LIBEXT))
FILES = $(PYSRC) $(LIBFILES)


all: $(LIBFILES)

libgamma_native_error.pyx: libgamma_native_error.$(PLATFORM).pyx
	cp -- $< $@

.o.$(LIBEXT):
	$(CC) -o $@ $< -shared $(LDFLAGS)

.c.o:
	$(CC) -fPIC -c -o $@ $< $$(pkg-config --cflags $(PYTHON)) $(CFLAGS) $(CPPFLAGS)

.pyx.c:
	if ! $(CYTHON) -$(PYTHON_MAJOR) -v $< -o $@ ; then rm $@; false; fi

install: $(LIBFILES)
	mkdir -p -- "$(DESTDIR)$(PYTHON_DIR)"
	cp -- $(FILES) "$(DESTDIR)$(PYTHON_DIR)/"

uninstall:
	-cd -- "$(DESTDIR)$(PYTHON_DIR)" && rm -f -- $(FILES)

run-test: $(LIBFILES)
	./test.py

clean:
	-rm -rf -- *.$(LIBEXT) *.o *_native_*.c *.pyc *.pyo __pycache__ libgamma_native_error.pyx

.SUFFIXES:
.SUFFIXES: .$(LIBEXT) .o .c .pyx

.PHONY: all install uninstall check run-test clean

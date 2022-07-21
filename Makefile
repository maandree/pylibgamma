.POSIX:

CONFIGFILE = config.mk
include $(CONFIGFILE)

OS = linux
include mk/$(OS).mk


python         = python$(PYTHON_MAJOR)
python_version = $(PYTHON_MAJOR).$(PYTHON_MINOR)
python_ver     = $(PYTHON_MAJOR)$(PYTHON_MINOR)
python_dir     = $(PREFIX)/lib/python$(python_version)/site-packages
python_cache   = $(python_dir)/__pycache__


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
	$(CC) -fPIC -c -o $@ $< $$(pkg-config --cflags $(python)) $(CFLAGS) $(CPPFLAGS)

.pyx.c:
	if ! cython -$(PYTHON_MAJOR) -v $< -o $@ ; then rm $@; false; fi

install: $(LIBFILES)
	mkdir -p -- "$(DESTDIR)$(python_dir)"
	cp -- $(FILES) "$(DESTDIR)$(python_dir)/"

uninstall:
	-cd -- "$(DESTDIR)$(python_dir)" && rm -f -- $(FILES)

run-test: $(LIBFILES)
	./test.py

clean:
	-rm -rf -- *.$(LIBEXT) *.o *_native_*.c *.pyc *.pyo __pycache__ libgamma_native_error.pyx

.SUFFIXES:
.SUFFIXES: .$(LIBEXT) .o .c .pyx

.PHONY: all install uninstall check run-test clean

# Copying and distribution of this file, with or without modification,
# are permitted in any medium without royalty provided the copyright
# notice and this notice are preserved.  This file is offered as-is,
# without any warranty.


# The package path prefix, if you want to install to another root, set DESTDIR to that root
PREFIX ?= /usr
# The command path excluding prefix
BIN ?= /bin
# The resource path excluding prefix
DATA ?= /share
# The command path including prefix
BINDIR ?= $(PREFIX)$(BIN)
# The resource path including prefix
DATADIR ?= $(PREFIX)$(DATA)
# The generic documentation path including prefix
DOCDIR ?= $(DATADIR)/doc
# The info manual documentation path including prefix
INFODIR ?= $(DATADIR)/info
# The license base path including prefix
LICENSEDIR ?= $(DATADIR)/licenses

# The target and host platform
PLATFORM = posix

# The major version number of the current Python installation
PY_MAJOR = 3
# The minor version number of the current Python installation
PY_MINOR = 4
# The version number of the current Python installation without a dot
PY_VER = $(PY_MAJOR)$(PY_MINOR)
# The version number of the current Python installation with a dot
PY_VERSION = $(PY_MAJOR).$(PY_MINOR)

# The name of the package as it should be installed
PKGNAME = pylibgamma


# The installed pkg-config command
PKGCONFIG ?= pkg-config
# The installed cython command
CYTHON ?= cython


# Libraries to link with using pkg-config
LIBS = python3

# The C standard for C code compilation
STD = c99
# Optimisation settings for C code compilation
OPTIMISE ?= -Og -g



# Flags to use when compiling
CC_FLAGS = $$($(PKGCONFIG) --cflags $(LIBS)) -std=$(STD) \
           $(OPTIMISE) -fPIC $(CFLAGS) $(CPPFLAGS)

# Flags to use when linking
LD_FLAGS = $$($(PKGCONFIG) --libs $(LIBS)) -lgamma -std=$(STD) \
           $(OPTIMISE) -shared $(LDFLAGS)


# The suffixless basename of the .py-files
PYTHON_SRC = libgamma_error libgamma_facade libgamma_method libgamma

# The suffixless basename of the .py-files
CYTHON_SRC = libgamma_native_error libgamma_native_facade libgamma_native_method


.PHONY: all pyx-files py-files
all: pyc-files pyo-files so-files
pyc-files: $(foreach M,$(PYTHON_SRC),src/__pycache__/$(M).cpython-$(PY_VER).pyc)
pyo-files: $(foreach M,$(PYTHON_SRC),src/__pycache__/$(M).cpython-$(PY_VER).pyo)
so-files: $(foreach M,$(CYTHON_SRC),bin/$(M).so)

bin/%.so: obj/%.o
	@mkdir -p bin
	$(CC) $(LD_FLAGS) -o $@ $^

obj/%.o: obj/%.c src/*.h
	$(CC) $(CC_FLAGS) -iquote"src" -c -o $@ $<

obj/%.c: obj/%.pyx
	if ! $(CYTHON) -3 -v $< ; then rm $@ ; false ; fi

obj/libgamma_native_facade.pyx: src/libgamma_native_facade.pyx
	@mkdir -p obj
	cp $< $@

obj/libgamma_native_method.pyx: src/libgamma_native_method.pyx
	@mkdir -p obj
	cp $< $@

ifeq ($(PLATFORM),windows)
obj/libgamma_native_error.pyx: src/libgamma_native_error.w32.pyx
	@mkdir -p obj
	cp $< $@
else
obj/libgamma_native_error.pyx: src/libgamma_native_error.pyx
	@mkdir -p obj
	cp $< $@
endif

src/__pycache__/%.cpython-$(PY_VER).pyc: src/%.py
	python -m compileall $<

src/__pycache__/%.cpython-$(PY_VER).pyo: src/%.py
	python -OO -m compileall $<


.PHONY: clean
clean:
	-rm -r obj bin src/__pycache__


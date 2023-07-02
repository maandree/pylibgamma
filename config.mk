PREFIX = /usr

PYTHON_MAJOR = $$(python --version 2>&1 | cut -d ' ' -f 2 | cut -d . -f 1)
PYTHON_MINOR = $$(python$(PYTHON_MAJOR) --version 2>&1 | cut -d . -f 2)

PYTHON_VERSION = $(PYTHON_MAJOR).$(PYTHON_MINOR)
PYTHON_VER     = $(PYTHON_MAJOR)$(PYTHON_MINOR)
PYTHON_DIR     = $(PREFIX)/lib/python$(python_version)/site-packages
PYTHON_CACHE   = $(python_dir)/__pycache__

CC     = c99
CYTHON = cython$(PYTHON_MAJOR)
PYTHON = python$(PYTHON_MAJOR)

CPPFLAGS =
CFLAGS   =
LDFLAGS  = -lgamma

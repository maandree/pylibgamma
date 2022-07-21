PREFIX = /usr

PYTHON_MAJOR = $$(python --version 2>&1 | cut -d . -f 1 | cut -d ' ' -f 2)
PYTHON_MINOR = $$(python$(PYTHON_MAJOR) --version 2>&1 | cut -d . -f 2)

CC = c99

CPPFLAGS =
CFLAGS =
LDFLAGS = -lgamma

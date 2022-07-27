all: init

C_COMPILER ?= x86_64-ninex-gcc
STRIP ?= x86_64-ninex-strip
CFLAGS ?= -O2 -g

init: init.c
	$(C_COMPILER) $(CFLAGS) -o init init.c

.PHONY: install install-strip init
install: init
	install -d "$(DESTDIR)$(PREFIX)/bin"
	install init "$(DESTDIR)$(PREFIX)/bin/"

install-strip: init
	install -d "$(DESTDIR)$(PREFIX)/bin"
	install -s --strip-program=$(STRIP) init "$(DESTDIR)$(PREFIX)/bin/"

clean:
	rm init

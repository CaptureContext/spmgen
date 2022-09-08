PREFIX?=/usr/local
INSTALL_NAME = spmgen

install: build install_bin

install_clean: build_clean install_bin

build:
	swift package update
	swift build -c release --disable-sandbox --build-path '.build'

build_clean:
	swift package clean
	swift package update
	swift build -c release --disable-sandbox --build-path '.build'

install_bin:
	mkdir -p $(PREFIX)/bin
	install .build/release/$(INSTALL_NAME) $(PREFIX)/bin

uninstall:
	rm -f $(PREFIX)/bin/$(INSTALL_NAME)

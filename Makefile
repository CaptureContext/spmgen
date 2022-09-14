install_name = spmgen

ifndef destination
	install_path = /usr/local/bin
else
	install_path = $(destination)
endif

# –––––––––––––––––––––––––––––– Install ––––––––––––––––––––––––––––––

# usage `reinstall destination="./Scripts/.bin"`
# default value for the destination is "/usr/local/bin"
reinstall: uninstall install

# usage `reinstall_bin destination="./Scripts/.bin"`
# default value for the destination is "/usr/local/bin"
reinstall_bin: uninstall install_bin

# usage `reinstall_clean destination="./Scripts/.bin"`
# default value for the destination is "/usr/local/bin"
reinstall_clean: uninstall install_clean

# usage `install destination="./Scripts/.bin"`
# default value for the destination is "/usr/local/bin"
install: build install_bin

# usage `install_clean destination="./Scripts/.bin"`
# default value for the destination is "/usr/local/bin"
install_clean: build_clean install_bin

# usage `install_bin destination="./Scripts/.bin"`
# default value for the destination is "/usr/local/bin"
install_bin:
	mkdir -p $(install_path)
	install .build/release/$(install_name) $(install_path)/$(install_name)

# usage `uninstall destination="./Scripts/.bin"`
# default value for the destination is "/usr/local/bin"
uninstall:
	rm -f $(install_path)/$(install_name)

# –––––––––––––––––––––––––––––– Build ––––––––––––––––––––––––––––––

build:
	swift package update
	swift build -c release --disable-sandbox --build-path '.build'

build_clean:
	swift package clean
	swift package update
	swift build -c release --disable-sandbox --build-path '.build'

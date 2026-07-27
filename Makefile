.PHONY: build clean install-deb

PACKAGE := bm

build:
	dpkg-buildpackage -us -uc

clean:
	dpkg-buildpackage -Tclean

install-deb:
	sudo apt install ./../$(PACKAGE)_*.deb

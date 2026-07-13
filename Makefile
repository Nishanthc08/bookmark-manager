.PHONY: build clean install

PACKAGE := bm

build:
	dpkg-buildpackage -us -uc

clean:
	dpkg-buildpackage -Tclean

install:
	sudo apt install ./../$(PACKAGE)_*.deb

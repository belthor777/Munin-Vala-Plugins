#!/usr/bin/make -f
# -* makefile -*-

BUILD_TYPE = 'Release'
BUILD_DIR = 'build'

DEB_SRCDIR = $(CURDIR)/src			# where sources are
DEB_BUILDDIR = $(DEB_SRCDIR)/$(BUILD_DIR)	# # in which directory to build
DEB_DESTDIR = $(CURDIR)/debian/tmp		# in which directory to install the sofware

%:
	dh $@

# shared library versions, option 1
version=0.1.0
major=0

# Config for launchpad
# Add here commands to compile the package.
DEB_CMAKE_NORMAL_ARGS = \
	-DCMAKE_BUILD_TYPE:STRING=$(BUILD_TYPE) \
	-DCMAKE_VERBOSE_MAKEFILE=ON \
	-DCMAKE_INSTALL_PREFIX:PATH='debian/tmp' \
	-DBUILD_DOCUMENTATION=OFF \
	-DBUILD_INSTALLER=OFF

# 2
build: build-stamp
	echo "STEP: build"
	ls -l

build-stamp:
	echo "STEP: build-stamp"
	ls -l
	mkdir -p $(BUILD_DIR)
	cd build
	cmake $(DEB_CMAKE_NORMAL_ARGS) ..

	#touch $@

# 1
clean:
	echo "STEP: clean"
	dh_testdir
	dh_testroot
	dh_prep

# 3
install: build
	cd $(BUILD_DIR)
	echo "STEP: install"
	ls -l
	dh_testdir
	dh_testroot
	dh_prep -k 

	# Add here commands to install the package into build dir
	$(MAKE) install DESTDIR=$(DEB_DESTDIR)

# Build architecture-dependent files here.
binary-arch: build install
	echo "STEP: binary-arch"
	ls -l
	dh_testdir -a
	dh_testroot -a
	dh_installdocs
	dh_installchangelogs
	dh_installdirs -a
	dh_install -a --sourcedir=$(DEB_DESTDIR) --autodest
	dh_strip -a
	dh_compress -a
	dh_fixperms -a
	dh_installdeb -a
	dh_gencontrol -a
	dh_md5sums -a
	dh_builddeb -a

binary: binary-arch
	echo "STEP: binary"
	ls -l

.PHONY: build clean binary-arch binary install

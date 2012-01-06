#!/bin/sh

./make_clean.sh
mkdir build

cd build; cmake -DCMAKE_BUILD_TYPE:STRING="Release" -DCMAKE_VERBOSE_MAKEFILE=OFF -DCMAKE_INSTALL_PREFIX:PATH="/usr" -DBUILD_DOCUMENTATION=OFF -DCONFIG_CPACK="DEB" -DBUILD_INSTALLER=ON -DHOST_GNU_TYPE="x86_64-linux-gnu" -DBUILD_GNU_TYPE="x86_64-linux-gnu" -DBUILD_ARCH="amd64" -DHOST_ARCH="amd64" ..; make && ( cd .. )

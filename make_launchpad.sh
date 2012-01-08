#!/bin/sh

./make_clean.sh
mkdir build
cd build; cmake -DCMAKE_BUILD_TYPE:STRING="Release" -DCMAKE_VERBOSE_MAKEFILE=OFF -DCMAKE_INSTALL_PREFIX:PATH="/usr" -DBUILD_DOCUMENTATION=OFF -DCONFIG_CPACK="DEB" -DBUILD_INSTALLER=ON ..; make && ( cd .. )
rm -R ../build
cd ..
git add . -A
git commit -m "latest version"
git push

./make.sh
rm -rf build/
dpkg-buildpackage -us -uc -S -rfakeroot
sudo pbuilder build ../*.dsc

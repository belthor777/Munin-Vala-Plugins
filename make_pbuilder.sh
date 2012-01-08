./make_launchpad.sh
dpkg-buildpackage -us -uc -S -rfakeroot
sudo pbuilder build ../*.dsc

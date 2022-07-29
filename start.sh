#!/usr/bin/env bash

basepath=$(cd `dirname $0`; pwd)

if [ -z $@ ]; then
    version='3.8.13'
else
    version="$@"
fi

APPDIR="python-$version"
PKGNAME="Python-$version"
MAKE_OPT="./configure --prefix=$basepath/${APPDIR} \
--enable-optimizations"

_python_make_install(){
    wget -c https://www.python.org/ftp/python/$version/$PKGNAME.tar.xz
    tar xf $PKGNAME.tar.xz
    ls -l
    cd $PKGNAME && $MAKE_OPT && make -j $(nproc) && make install 
    cd ..
    tar zcf $APPDIR.tar.xz $PKGNAME
}

_python_make_install "$@"

gh release delete ${APPDIR} -y

# gh release create ${PKGNAME} ./*.tar.xz --title "${PKGNAME} (beta)" --notes "this is a nginx beta release" --prerelease
gh release create ${APPDIR} $APPDIR.tar.xz --title "${APPDIR}" --notes "this is a python release" --prerelease

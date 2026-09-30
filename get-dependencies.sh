#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
    faac \
    faad2 \
    fribidi \
    hicolor-icon-theme \
    libcdio-paranoia \
    libcpuid \
    libgudev \
    libiconv \
    libjpeg-turbo \
    libmp4v2 \
    libwebp \
    speex \
    uriparser

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano opus-mini

# Comment this out if you need an AUR package
#make-aur-package smooth
#make-aur-package boca
#make-aur-package freac

# If the application needs to be manually built that has to be done down here
echo "Building smooth..."
echo "---------------------------------------------------------------"
REPO="https://github.com/enzo1982/smooth"
git clone --depth 1 "$REPO" ./smooth

cd ./smooth
make -j$(nproc) config="systemlibbz2,\
    systemlibcpuid,\
    systemlibcurl,\
    systemlibfribidi,\
    systemlibiconv,\
    systemlibjpeg,\
    systemlibpng,\
    systemlibwebp,\
    systemlibxml2,\
    systemzlib" \
install
cd ../

echo "Building BoCA..."
echo "---------------------------------------------------------------"
REPO="https://github.com/enzo1982/BoCA"
git clone --depth 1 "$REPO" ./BoCA

cd ./BoCA
make -j$(nproc) all
make install
cd ../

echo "Building freac..."
echo "---------------------------------------------------------------"
REPO="https://github.com/enzo1982/freac"
VERSION="$(git ls-remote "$REPO" HEAD | cut -c 1-9 | head -1)"
git clone --depth 1 "$REPO" ./freac
echo "$VERSION" > ~/version

cd ./freac
make -j$(nproc) install

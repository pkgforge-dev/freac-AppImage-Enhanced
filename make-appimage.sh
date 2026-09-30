#!/bin/sh

set -eu

ARCH=$(uname -m)
export ARCH
export OUTPATH=./dist
export ADD_HOOKS="self-updater.hook:wayland-is-broken.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON=/usr/local/share/icons/hicolor/128x128/apps/org.freac.freac.png
export DESKTOP=/usr/local/share/applications/org.freac.freac.desktop
export STARTUPWMCLASS="fre:ac"
export USE_HOST_DRIVERS_EXPERIMENTAL=1

# Deploy dependencies
quick-sharun /usr/local/bin/freac /usr/local/lib/libsmooth-0.9.so /usr/local/lib/libboca-1.0.so /usr/local/lib/libfreac-1.1.so

# Turn AppDir into AppImage
quick-sharun --make-appimage

# Test the app for 12 seconds, if the test fails due to the app
# having issues running in the CI use --simple-test instead
quick-sharun --simple-test ./dist/*.AppImage

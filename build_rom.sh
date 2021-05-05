#!/bin/bash

set -e
set -x

# sync rom
repo init -u git://github.com/DerpFest-11/manifest.git -b 11 --depth=1
git clone https://github.com/pocox3pro/Local-Manifests --depth=1 -b master .repo/local_manifests
repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync -j$(nproc --all)

#Setup
rm -rf device/generic/opengl-transport

# build rom
source build/envsetup.sh
lunch derp_vayu-userdebug
mka derp

# upload rom
up(){
	curl --upload-file $1 https://transfer.sh/$(basename $1); echo
	# 14 days, 10 GB limit
}

up out/target/product/vayu/*.zip

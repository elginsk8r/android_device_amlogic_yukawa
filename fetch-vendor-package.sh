#!/bin/bash
# fetch, check & extract the current vendor package
set -e

EXPECTED_YUKAWA_VENDOR_VERSION=20251218
EXPECTED_YUKAWA_VENDOR_SHA=dfced6cb1c79d28fdafc19d3457dede8fec95c2023e06fba70b52276822d8075b7c308c6be2abb33d2100850eee73839b8e766b7a369198e7669b51585b655e4

DIR_PARENT=$(cd $(dirname $0); pwd)
if [ -z "${ANDROID_BUILD_TOP}" ]; then
    ANDROID_BUILD_TOP=$(cd ${DIR_PARENT}/../../../; pwd)
fi

VND_PKG_URL=https://public.amlogic.binaries.baylibre.com/ci/vendor_packages/${EXPECTED_YUKAWA_VENDOR_VERSION}/extract-yukawa_devices-${EXPECTED_YUKAWA_VENDOR_VERSION}.tgz
PKG_FILE=extract-yukawa_devices-${EXPECTED_YUKAWA_VENDOR_VERSION}

pushd ${ANDROID_BUILD_TOP}

# remove the older vendor-package, if any
rm -rf ${ANDROID_BUILD_TOP}/vendor/amlogic/yukawa

if [ ! -e "${PKG_FILE}.tgz"  ]; then
    echo "Vendor package not present: fetching it"
    curl -L ${VND_PKG_URL} -o  ${PKG_FILE}.tgz
fi

# verify checksum
echo "${EXPECTED_YUKAWA_VENDOR_SHA} ${PKG_FILE}.tgz" | sha512sum -c
if [ $? -ne 0 ]; then
    echo "Vendor package checksum mismatch: abort"
    exit 1
fi

tar -xf ${PKG_FILE}.tgz
./${PKG_FILE}.sh

sed -i "s|vendor/amlogic/yukawa/gpu/[0-9]*/mesa/a55|vendor/amlogic/yukawa/gpu/${EXPECTED_YUKAWA_VENDOR_VERSION}/mesa/a55|" external/minigbm/gbm_mesa_driver/Android.bp
sed -i "s|vendor/amlogic/yukawa/gpu/[0-9]*/mesa/a73|vendor/amlogic/yukawa/gpu/${EXPECTED_YUKAWA_VENDOR_VERSION}/mesa/a73|" external/minigbm/gbm_mesa_driver/a73/Android.bp

popd

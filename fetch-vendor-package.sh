#!/bin/bash
# fetch, check & extract the current vendor package
set -e

EXPECTED_YUKAWA_VENDOR_VERSION=20251114
EXPECTED_YUKAWA_VENDOR_SHA=0a96d860e411e1cd4305fcf78f4e868a190378b0788c29290dc4f777feb37ba807f3f88dcf0a59f63c23575a2adfbaacda80232f991a538a6da7e2918ac42597

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
popd

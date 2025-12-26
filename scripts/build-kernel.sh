#!/bin/bash

clone_linux() {
    if [ ! -d "linux-stm32mp" ]; then
        git clone git@github.com:OneKiwiEmbedded/linux-stm32mp.git -b onekiwi-v6.1-stm32mp-r1.1
    fi
}

build_linux() {
    source ${ENV_SETUP}
    cd linux-stm32mp
    make distclean
    export KBUILD_OUTPUT=./build
    unset -v CFLAGS LDFLAGS
    make multi_v7_defconfig
    if [[ "$DEVICE_NAME" == *"stm32mp13"* ]]; then
        echo "stm32mp13"
        make ${DEVICE_NAME}.dtb -j8
        make ${DEVICE_NAME}-a7-examples.dtb -j8
    fi
    if [[ "$DEVICE_NAME" == *"stm32mp15"* ]]; then
        echo "stm32mp15"
        make ${DEVICE_NAME}.dtb -j8
        make ${DEVICE_NAME}-a7-examples.dtb -j8
        make ${DEVICE_NAME}-m4-examples.dtb -j8
    fi
}

source ./scripts/build-sdk.sh

clone_linux
build_linux
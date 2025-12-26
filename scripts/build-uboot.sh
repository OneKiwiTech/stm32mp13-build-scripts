#!/bin/bash

clone_uboot() {
    if [ ! -d "uboot-stm32mp" ]; then
        git clone git@github.com:OneKiwiEmbedded/uboot-stm32mp.git -b onekiwi-v2022.10-stm32mp-r1.1
    fi
}

build_uboot_debug() {
    source ${ENV_SETUP}
    cd uboot-stm32mp
    export KBUILD_OUTPUT=./build
    make distclean
    unset -v CFLAGS LDFLAGS
    
    if [[ "$DEVICE_NAME" == *"stm32mp13"* ]]; then
        echo "stm32mp13_defconfig"
        make stm32mp13_defconfig
    fi
    if [[ "$DEVICE_NAME" == *"stm32mp15"* ]]; then
        echo "stm32mp15_defconfig"
        make stm32mp15_defconfig
    fi
    #make menuconfig
    #make DEVICE_TREE=$DEVICE_NAME DDR_INTERACTIVE=1 all -j8
    make DEVICE_TREE=$DEVICE_NAME all -j8
    cp -v build/u-boot-nodtb.bin ../output
    cp -v build/u-boot.dtb ../output
    cd ${ROOTDIR}
}

build_uboot_trusted() {
    source ${ENV_SETUP}
    cd uboot-stm32mp
    export KBUILD_OUTPUT=./build
    make distclean
    unset -v CFLAGS LDFLAGS
    make stm32mp15_trusted_defconfig
    make DEVICE_TREE=$DEVICE_NAME all -j8
    cp build/u-boot-nodtb.bin ../output
    cp build/u-boot.dtb ../output
    cd ${ROOTDIR}
}

source ./scripts/build-sdk.sh
clone_uboot
build_uboot_debug
#build_uboot_trusted
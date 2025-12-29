#!/bin/bash

clone_atf() {
    if [ ! -d "atf-stm32mp" ]; then
        git clone https://github.com/OneKiwiTech/stm32mp13-tfa.git -b v2.8-stm32mp-r1.1
    fi
}

build_atf_mp13() {
    #build_atf_release_mp13
    build_atf_debug_mp13
}

build_atf_release_mp13() {
    #source ${ENV_SETUP}
    cd stm32mp13-tfa
    #TFA_BL32=build/stm32mp1/release/bl2.bin
    ARG="PLAT=stm32mp1 ARCH=aarch32 AARCH32_SP=optee ARM_ARCH_MAJOR=7 STM32MP13=1 STM32MP_SDMMC=1 STM32MP_EMMC=1 STM32MP_USB_PROGRAMMER=1"
    PATH_BL33=${ROOTDIR}/output/u-boot-nodtb.bin
    PATH_BL33_CFG=${ROOTDIR}/output/u-boot.dtb
    PATH_BL32=${ROOTDIR}/output/tee-header_v2.bin
    PATH_BL32_EXTRA1=${ROOTDIR}/output/tee-pager_v2.bin
    PATH_BL32_EXTRA2=${ROOTDIR}/output/tee-pageable_v2.bin
    make distclean
    unset -v CFLAGS LDFLAGS

    make ${ARG} DTB_FILE_NAME=${DEVICE_NAME}.dtb
    cp -v build/stm32mp1/release/tf-a-${DEVICE_NAME}.stm32 ../output/tfa-usb.stm32

    # build FW_CONFIG
    make ${ARG} DTB_FILE_NAME=${DEVICE_NAME}.dtb bl32 dtbs
    
    
    #make PLAT=stm32mp1 ARCH=aarch32 ARM_ARCH_MAJOR=7 STM32MP13=1 STM32MP_SDMMC=1 STM32MP_EMMC=1 DTB_FILE_NAME=${DEVICE_NAME}.dtb BL33=${ROOTDIR}/output/u-boot-nodtb.bin BL33_CFG=${ROOTDIR}/output/u-boot.dtb BL32=${TFA_BL32} fip
    make ${ARG} DTB_FILE_NAME=${DEVICE_NAME}.dtb BL33=${PATH_BL33} BL33_CFG=${PATH_BL33_CFG} BL32=${PATH_BL32} BL32_EXTRA1=${PATH_BL32_EXTRA1} BL32_EXTRA2=${PATH_BL32_EXTRA2} fip
    cp -v build/stm32mp1/release/fip.bin ../output
}

build_atf_debug_mp13() {
    #source ${ENV_SETUP}
    cd stm32mp13-tfa
    ARG="PLAT=stm32mp1 ARCH=aarch32 AARCH32_SP=optee LOG_LEVEL=40 DEBUG=1 ARM_ARCH_MAJOR=7 STM32MP13=1 STM32MP_SDMMC=1 STM32MP_EMMC=1 STM32MP_USB_PROGRAMMER=1"
    PATH_BL33=${ROOTDIR}/output/u-boot-nodtb.bin
    PATH_BL33_CFG=${ROOTDIR}/output/u-boot.dtb
    PATH_BL32=${ROOTDIR}/output/tee-header_v2.bin
    PATH_BL32_EXTRA1=${ROOTDIR}/output/tee-pager_v2.bin
    PATH_BL32_EXTRA2=${ROOTDIR}/output/tee-pageable_v2.bin
    make distclean
    unset -v CFLAGS LDFLAGS

    make ${ARG} DTB_FILE_NAME=${DEVICE_NAME}.dtb
    cp -v build/stm32mp1/debug/tf-a-${DEVICE_NAME}.stm32 ../output/tfa-usb.stm32

    # build FW_CONFIG
    make ${ARG} DTB_FILE_NAME=${DEVICE_NAME}.dtb bl32 dtbs

    make ${ARG} DTB_FILE_NAME=${DEVICE_NAME}.dtb BL33=${PATH_BL33} BL33_CFG=${PATH_BL33_CFG} BL32=${PATH_BL32} BL32_EXTRA1=${PATH_BL32_EXTRA1} BL32_EXTRA2=${PATH_BL32_EXTRA2} fip
    cp -v build/stm32mp1/debug/fip.bin ../output
}

build_atf_mp15() {
    source ${ENV_SETUP}
    cd atf-stm32mp
    make distclean
    unset -v CFLAGS LDFLAGS
    make PLAT=stm32mp1 ARCH=aarch32 ARM_ARCH_MAJOR=7 AARCH32_SP=sp_min STM32MP15=1 DTB_FILE_NAME=${DEVICE_NAME}.dtb STM32MP_SDMMC=1 STM32MP_EMMC=1 STM32MP_USB_PROGRAMMER=1
    cp build/stm32mp1/release/tf-a-${DEVICE_NAME}.stm32 ../output/tfa-usb.stm32

    make PLAT=stm32mp1 ARCH=aarch32 ARM_ARCH_MAJOR=7 AARCH32_SP=sp_min STM32MP_SDMMC=1 STM32MP_EMMC=1 STM32MP_USB_PROGRAMMER=1 DTB_FILE_NAME=${DEVICE_NAME}.dtb BL33=${ROOTDIR}/output/u-boot-nodtb.bin BL33_CFG=${ROOTDIR}/output/u-boot.dtb fip
    cp -v build/stm32mp1/release/fip.bin ../output
}
build_atf() {
    
    if [[ "$DEVICE_NAME" == *"stm32mp13"* ]]; then
        echo "stm32mp13"
        build_atf_mp13
    fi
    if [[ "$DEVICE_NAME" == *"stm32mp15"* ]]; then
        echo "stm32mp15"
        build_atf_mp15
    fi
}

source ./scripts/build-sdk.sh

export PATH=$ROOTDIR/$sdkdir/sysroots/x86_64-ostl_sdk-linux/usr/bin/arm-ostl-linux-gnueabi:$PATH
export CROSS_COMPILE=arm-ostl-linux-gnueabi-
export ARCH=arm

clone_atf
build_atf
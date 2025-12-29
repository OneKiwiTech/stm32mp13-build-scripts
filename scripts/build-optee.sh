#!/bin/bash

clone_optee() {
    if [ ! -d "optee_os-stm32mp" ]; then
        git clone https://github.com/OneKiwiTech/stm32mp13-optee_os.git -b 3.19.0-stm32mp-r1.1
    fi
}

build_optee() {
    source ${ENV_SETUP}
    cd stm32mp13-optee_os
    make distclean
    unset -v CFLAGS LDFLAGS
    make PLATFORM=stm32mp1 CFG_EMBED_DTB_SOURCE_FILE=${DEVICE_NAME}.dts CFG_TEE_CORE_LOG_LEVEL=2 CFLAGS32=--sysroot=${SDKTARGETSYSROOT} O=build all

    cp -v build/core/tee-pager_v2.bin ../output
    cp -v build/core/tee-pageable_v2.bin ../output
    cp -v build/core/tee-header_v2.bin ../output
}

source ./scripts/build-sdk.sh

clone_optee
build_optee
#!/bin/bash

ROOTDIR=`pwd`
PARALLEL=$(getconf _NPROCESSORS_ONLN) # Amount of parallel jobs for the builds

#DEVICE_NAME=stm32mp151aaa-thatico-r2x512v12
#DEVICE_NAME=stm32mp15xxab-som-v11
#DEVICE_NAME=stm32mp157aaa-thatico-r2x512v12
#DEVICE_NAME=stm32mp15xxab-som-v11
#DEVICE_NAME=stm32mp135f-dk
DEVICE_NAME=stm32mp131dae-som
#DEVICE_NAME=stm32mp157c-dk2

sdkname=en.SDK-x86_64-stm32mp1-openstlinux-6.1-yocto-mickledore-mp1-v23.06.21.tar.gz
sdkdir=sdk-6.1-mickledore
sdkdirtemp=stm32mp1-openstlinux-6.1-yocto-mickledore-mp1-v23.06.21
openstlinux=st-image-weston-openstlinux-weston-stm32mp1-x86_64-toolchain-4.2.1-openstlinux-6.1-yocto-mickledore-mp1-v23.06.21.sh
ENV_SETUP=${ROOTDIR}/${sdkdir}/environment-setup-cortexa7t2hf-neon-vfpv4-ostl-linux-gnueabi

merge_sdk() {
    if [ ! -d "${sdkdir}" ]; then
        if [ ! -f "sdk/${sdkname}" ]; then
            cd sdk
            echo "merge file: ${sdkname}"
            cat ${sdkname}.* > ${sdkname}
            cd ${ROOTDIR}
        fi
    fi
}

extract_sdk() {
    if [ ! -d "${sdkdir}" ]; then
        if [ ! -d "sdk/${sdkdirtemp}" ]; then
            if [ -f "sdk/${sdkname}" ]; then
                cd sdk
                echo "extract: ${sdkname}"
                tar -xvf ${sdkname}
            else 
                echo "${sdkname} does not exist."
            fi
        fi
    fi
}

setup_sdk() {
    if [ ! -d "${sdkdir}" ]; then
        if [ -d "sdk/${sdkdirtemp}" ]; then
            cd sdk/${sdkdirtemp}/sdk
            ./${openstlinux} -d ${ROOTDIR}/${sdkdir}

            cd ${ROOTDIR}/sdk
            rm -rf ${sdkdirtemp}
            rm -rf ${sdkname}
        fi
    fi
    cd ${ROOTDIR}
}

merge_sdk
extract_sdk
setup_sdk
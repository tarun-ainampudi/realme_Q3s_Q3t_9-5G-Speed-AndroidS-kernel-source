#!/bin/bash

SOURCE_DIR=$HOME/Desktop/RMX3461_Kernel/
export CLANG_DIR=$SOURCE_DIR/android_prebuilts_clang_host_linux-x86_clang-6573524
export PATH=$CLANG_DIR/bin:$PATH
export CROSS_COMPILE=$SOURCE_DIR/aarch64-linux-android-4.9/bin/aarch64-linux-android-

if [ ! -d "$CLANG_DIR" ]; then
    echo "Clang directory not found. Cloning the repository..."
    git clone https://github.com/crdroidandroid/android_prebuilts_clang_host_linux-x86_clang-6573524.git "$CLANG_DIR"
fi
if [ ! -d "$SOURCE_DIR/aarch64-linux-android-4.9" ]; then
    echo "aarch64-linux-android-4.9 directory not found. Cloning the repository..."
    git clone https://github.com/KudProject/aarch64-linux-android-4.9.git "$SOURCE_DIR/aarch64-linux-android-4.9"
fi

DEFCONFIG="vendor/lahaina-qgki_defconfig"
CONFIG_ADDON="CONFIG_SECTION_MISMATCH_WARN_ONLY=y LD=ld.lld LLVM=1 LLVM_IAS=1"
UAPI_CFLAGS="-std=c90 -Wall -Werror=implicit-function-declaration -D_GNU_SOURCE -D_POSIX_C_SOURCE=199309L"
make V=1 O=out ARCH=arm64 CC=clang HOSTCC=clang CLANG_TRIPLE=aarch64-linux-gnu- CROSS_COMPILE=${CROSS_COMPILE} ${DEFCONFIG} ${CONFIG_ADDON}
make V=1 ARCH=arm64 CROSS_COMPILE=${CROSS_COMPILE} UAPI_CFLAGS="${UAPI_CFLAGS}" O=out CC=clang HOSTCC=clang CLANG_TRIPLE=aarch64-linux-gnu- ${CONFIG_ADDON} -j$(nproc)

#!/bin/bash

SOURCE_DIR=$HOME/Desktop/RMX3461_Kernel/
export CLANG_DIR=$SOURCE_DIR/clang-r383902b1
export PATH=$CLANG_DIR/bin:$PATH
export CROSS_COMPILE=$SOURCE_DIR/llvm-r383902b/bin/aarch64-linux-android-

if [ ! -d "$CLANG_DIR" ]; then
    echo "Clang directory not found. Cloning the repository..."
    wget wget https://android.googlesource.com/platform/prebuilts/clang/host/linux-x86/+archive/refs/heads/android11-qpr2-release/clang-r383902b1.tar.gz
    mkdir -p "$CLANG_DIR"
    tar -zxvf clang-r383902b1.tar.gz -C "$CLANG_DIR"
fi
if [ ! -d "$SOURCE_DIR/llvm-r383902b" ]; then
    echo "aarch64-linux-android-4.9 directory not found. Cloning the repository..."
    wget wget https://android.googlesource.com/platform/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/+archive/refs/heads/llvm-r383902b.tar.gz
    mkdir -p "$SOURCE_DIR/llvm-r383902b"
    tar -zxvf llvm-r383902b.tar.gz -C "$SOURCE_DIR/llvm-r383902b"
fi

DEFCONFIG="vendor/lahaina-qgki_defconfig"
CONFIG_ADDON="CONFIG_SECTION_MISMATCH_WARN_ONLY=y LD=ld.lld LLVM=1 LLVM_IAS=1"
UAPI_CFLAGS="-std=c90 -Wall -Werror=implicit-function-declaration -D_GNU_SOURCE -D_POSIX_C_SOURCE=199309L"
make V=1 O=out ARCH=arm64 CC="clang" CLANG_TRIPLE=aarch64-linux-gnu- CROSS_COMPILE=${CROSS_COMPILE} ${DEFCONFIG} ${CONFIG_ADDON}
make V=1 ARCH=arm64 CROSS_COMPILE=${CROSS_COMPILE} UAPI_CFLAGS="${UAPI_CFLAGS}" O=out CC="clang" CLANG_TRIPLE=aarch64-linux-gnu- ${CONFIG_ADDON} -j$(nproc)

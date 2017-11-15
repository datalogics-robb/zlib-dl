#!/bin/bash
if test -d zlib; then
    :
else
    echo "Cloning Git repo for zlib"
    git clone git@github.com:madler/zlib.git
    ( cd zlib && git checkout v1.2.11 )
fi
UNAME=`uname`
    
PREFIXDIR=${PREFIXDIR-"$(dirname ${0})/./"}
if test -d ${PREFIXDIR}; then
    :
else
    mkdir -p $PREFIXDIR
fi
# bourne shell's version of abspath
PREFIXDIR=`cd $PREFIXDIR && pwd`

if test "X$UNAME" == "XDarwin"; then
    # Set up the environment for NDK use
    NDK_ROOT=/Users/robb/android-ndk-r15
    export NDK_ROOT
    STARTING_PATH=${PATH}
    BUILDMACH=x86_64-apple-darwin15.6.0
    export BUILDMACH
    ## Loop over all the Android architectures
    for SPEC in "arch-arm arm-linux-androideabi" \
                    "arch-arm64 aarch64-linux-android" \
                    "arch-mips mipsel-linux-android" \
                    "arch-mips64 mips64el-linux-android"
                do
                    CROSS=`echo $SPEC | sed 's/[^ ]*[ ]//'`
                    ARCH=`echo $SPEC | sed 's/[ ][^ ]*//'`
                    echo "Building for $CROSS and $ARCH on Mac OS X"
                    OS=${CROSS}
                    PATH=${NDK_ROOT}/toolchains/${CROSS}-4.9/prebuilt/darwin-x86_64/bin:$STARTING_PATH
                    for STAGE in 'Debug' 'Release'
                    do
                        mkdir -p ./$STAGE/$OS
                        PREFIXDIR=$(cd ./$STAGE/$OS && pwd)
                        BUILDDIR="build/${STAGE}/$OS"
                        mkdir -p $BUILDDIR
                        if test $STAGE == 'Debug'; then
                            OPTFLAG="-g"
                        else
                            OPTFLAG="-O3"
                        fi
                        #  --build=BUILD     configure for building on BUILD [guessed]
                        #  --host=HOST       cross-compile to build programs to run on HOST [BUILD]
                        #  --target=TARGET   configure for building compilers for TARGET [HOST]
                        ( cd ${BUILDDIR} && \
                                CHOST=${CROSS} \
                                     CC=${CROSS}-gcc \
                                     LD=${CROSS}-ld \
                                     AS=${CROSS}-as \
                                     AR=${CROSS}-ar \
                                     TARGETARCH=${CROSS} \
                                     CFLAGS="$OPTFLAG --sysroot ${NDK_ROOT}/platforms/android-24/${ARCH}" \
                                     ../../../zlib/configure --prefix="${PREFIXDIR}/../.." --eprefix=$PREFIXDIR --static && \
                                gnumake && gnumake install )
                    done
    done
fi

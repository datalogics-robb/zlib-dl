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

if test "X$UNAME" == "XMSYS_NT-10.0"; then
    # under windows, use pdfl15_all\build-zilb\zlib\contrib\vstudio\vc12\zlibvc.sln
    # build project zlibstat with configuraitons "Debug|x64" "ReleaseWithoutAsm|x64"
    #   "Debug|Win32" "ReleaseWithoutAsm|Win32"
    ./build.bat
    exit 0
elif test "X$UNAME" == "XDarwin"; then
    for STAGE in 'Debug' 'Release'
    do
        mkdir -p "Mac${STAGE}"
        if test $STAGE == 'Debug'; then
            OPTFLAG="-gdwarf-2"
        else
            OPTFLAG="-O3"
        fi
        ( cd "Mac${STAGE}" && \
            CC=clang \
            CFLAGS="-fpascal-strings -fvisibility=hidden -fexceptions $OPTFLAG -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/MACOSX.platform/Developer/SDKs/MacOSX10.9.sdk -mmacosx-version-min=10.7 -fPIC" \
          ../zlib/configure --prefix=$PREFIXDIR/$STAGE/Mac --static --archs="-arch i386 -arch x86_64" && gnumake  && gnumake install && gnumake distclean )

    done
    exit 0
fi
# UNIX stuff
MAKE="gmake"
OS="$(echo $OS | tr A-Z a-z)"

case $OS in
    itanium2hpux)
        PATH=/opt/aCC.6.28/bin:$PATH
        ita2_sys_flags="+DD64 +DSitanium2 -fPIC"
        ita2_sys_flags="+DD32 +DSitanium2 -fPIC"

        ;;
    rs6000aix)
        ##############################################################
        # Note: zlib does something strainge with out-of-tree builds
        #  that breaks with IBM's xlc, so we'll build in-tree on AIX.
        ##############################################################
	BUILD_IN_TREE=true
        PATH=/opt/IBM/xlC/13.1.3/bin:$PATH
	COMP=/opt/IBM/xlC/13.1.3/bin/xlc_r
        DEBFLAGS="-g -qfullpath"
        RELFLAGS="-O3 -qstrict=all"
        CFLAGS64="-q64"
        CFLAGS32="-q32"
        CFLAGSALL="-qpic=small -qthreaded"
	OS="rs6000aix"
	OS64="${OS}_64"
	AR32="ar -X 32"
	AR64="ar -X 64"
    ;;
    i80386linux)
        # configuration for rhel5
        PATH=/opt/gcc-4.1.2/bin:$PATH
	COMP=/opt/gcc-4.1.2/bin/gcc
        DEBFLAGS="-g"
        RELFLAGS="-O3 -fstack-protector-all -Wstack-protector -D_FORTIFY_SOURCE=2"
        CFLAGS64="-m64"
        CFLAGS32="-m32 -mtune=i686 -march=pentium4"
        CFLAGSALL="-fPIC"
	OS="i80386linux"
	OS64="${OS}_64"
    ;;
    sparcsolaris)
        # configuration for sol - solaris10
        PATH=/opt/developerstudio12.5/bin:$PATH
	COMP=/opt/developerstudio12.5/bin/cc
        DEBFLAGS="-g"
        RELFLAGS="-fast"
        CFLAGS64="-m64"
        CFLAGS32="-m32"
        CFLAGSALL="-xcode=pic32 -std=c99 -xarch=sparcvis"
	OS="sparcsolaris"
	OS64="${OS}_64"
    ;;
    intelsolaris)
        # configuration for sol - solaris10
	MAKE=make
	COMP=/usr/bin/cc
        DEBFLAGS="-g"
        RELFLAGS="-fast"
        CFLAGS64="-m64"
        CFLAGS32="-m32"
        CFLAGSALL="-KPIC -xc99=all -xpentium"
	OS="intelsolaris"
	OS64="${OS}_64"
    ;;
esac

for STAGE in Debug Release
do
    if test $STAGE == 'Debug'; then
        OPTFLAG="$DEBFLAGS"
    else
        OPTFLAG="$RELFLAGS"
    fi
    mkdir -p ../zlib-bin/$STAGE/$OS
    PREFIXDIR=$(cd ../zlib-bin/$STAGE/$OS && pwd)
    mkdir -p ${STAGE}/$OS
    if test "X$BUILD_IN_TREE" == "Xtrue"; then
        ( cd ./zlib/ && \
             AR=${AR32} CC=$COMP CFLAGS="$CFLAGS32 $OPTFLAG $CFLAGSALL" ./configure --prefix=${PREFIXDIR} --static &&  $MAKE && $MAKE install && $MAKE distclean)
    else
        ( cd ${STAGE}/$OS && \
            CC=$COMP CFLAGS="$CFLAGS32 $OPTFLAG $CFLAGSALL" ../../zlib/configure --prefix=${PREFIXDIR} --static &&  $MAKE &&  $MAKE install )
# && $MAKE distclean )
    fi
    mkdir -p ../zlib-bin/$STAGE/$OS64
    PREFIXDIR=$(cd ../zlib-bin/$STAGE/$OS64 && pwd)
    mkdir -p ${STAGE}/$OS64
    if test "X$BUILD_IN_TREE" == "Xtrue"; then
        ( cd ./zlib/ && \
            AR=${AR64} CC=$COMP CFLAGS="$CFLAGS64 $OPTFLAG $CFLAGSALL" ./configure --prefix=${PREFIXDIR} --64 --static &&  $MAKE && $MAKE install && $MAKE distclean)
    else
       ( cd ${STAGE}/$OS64 && \
            CC=$COMP CFLAGS="$CFLAGS64 $OPTFLAG $CFLAGSALL" ../../zlib/configure --prefix=${PREFIXDIR} --64 --static && $MAKE && $MAKE install )
 # && $MAKE distclean )
   fi
done

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
    # under windows, use zilb-dl\zlib\contrib\vstudio\vc12\zlibvc.sln
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
    hppahpux)
	COMP=/opt/ansic/bin/cc
        PATH=/opt/ansic/bin:$PATH
        DEBFLAGS="-g"
        RELFLAGS="-fast"
        CFLAGS64="+DD64 +DA2.0W"
        CFLAGS32="+DD32"
        CFLAGSALL="+Z -AC99"
	OS="hppahpux"
	OS64="${OS}_64"
        ;;
    itanium2hpux)
        PATH=/opt/aCC.6.28/bin:$PATH
	COMP=/opt/aCC.6.28/bin/aCC
        DEBFLAGS="-g"
        RELFLAGS="-fast"
        CFLAGS64="+DD64"
        CFLAGS32="+DD32"
        CFLAGSALL="+std=c99 +Z +DSitanium2"
	OS="itanium2hpux"
	OS64="${OS}_64"
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
        # configuration for 64-bit tibet - solaris10 -- for 32-bit, solaris9
        PATH=/opt/gcc-4.1.2/bin:/opt/developerstudio12.5/bin:$PATH
        COMP64=/opt/developerstudio12.5/bin/cc
        CFLAGS64="-m64 -xcode=pic32 -std=c99 -xarch=sparcvis"
	COMP32=/opt/gcc-4.1.2/bin/gcc
        CFLAGS32="-m32 -fPIC -fexceptions"
        DEBFLAGS="-g"
        RELFLAGS32="-O3"
        RELFLAGS64="-fast"
        CFLAGSALL=""
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
    if test "X$STAGE" == "XDebug"; then
        OPTFLAG="$DEBFLAGS"
    else
        OPTFLAG="$RELFLAGS"
    fi
    mkdir -p ./$STAGE/$OS
    PREFIXDIR=$(cd ./$STAGE/$OS && pwd)
    if test "X$BUILD_IN_TREE" == "Xtrue"; then
        ( cd ./zlib/ && \
            AR=${AR32} CC=${COMP-${COMP32}} CFLAGS="$CFLAGS32 $OPTFLAG $CFLAGSALL" ./configure --prefix=${PREFIXDIR} --static && \
            $MAKE && $MAKE install && $MAKE distclean)
    else
        BUILDDIR="build/${STAGE}/$OS"
        mkdir -p $BUILDDIR
        ( cd ${BUILDDIR} && \
            CC=${COMP-${COMP32}} CFLAGS="$CFLAGS32 $OPTFLAG $CFLAGSALL" ../../../zlib/configure --prefix=${PREFIXDIR} --static && \
            $MAKE && $MAKE install && $MAKE distclean )
    fi
    mkdir -p ./$STAGE/$OS64
    PREFIXDIR=$(cd ./$STAGE/$OS64 && pwd)
    if test "X$BUILD_IN_TREE" == "Xtrue"; then
        ( cd ./zlib/ && \
            AR=${AR64} CC=${COMP-${COMP64}} CFLAGS="$CFLAGS64 $OPTFLAG $CFLAGSALL" ./configure --prefix=${PREFIXDIR} --64 --static && \
	    $MAKE && $MAKE install && $MAKE distclean)
    else
        BUILDDIR="build/${STAGE}/$OS64"
        mkdir -p $BUILDDIR
        ( cd ${BUILDDIR} && 
            CC=${COMP-${COMP64}} CFLAGS="$CFLAGS64 $OPTFLAG $CFLAGSALL" ../../../zlib/configure --prefix=${PREFIXDIR} --64 --static && \
	    $MAKE && $MAKE install && $MAKE distclean )
   fi
done

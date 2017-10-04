@REM under windows, use pdfl15_all\build-zilb\zlib\contrib\vstudio\vc12\zlibvc.sln
@REM build project zlibstat with configuraitons "Debug|x64" "ReleaseWithoutAsm|x64"
@REM   "Debug|Win32" "ReleaseWithoutAsm|Win32"

@echo "Cloning Git repo for zlib"
@REM TODO - test for the existence of the zlib directory and skip all this if present
git clone git@github.com:madler/zlib.git

cd zlib

git checkout v1.2.11

cd ..

CALL "%VS120COMNTOOLS%\..\..\VC\vcvarsall.bat" amd64

devenv zlib\contrib\vstudio\vc12\zlibvc.sln /rebuild "Debug|x64" /project zlibstat

copy zlib\contrib\vstudio\vc12\x64\ZlibStatDebug\zlibstat.lib  .\Debug\x64\

devenv zlib\contrib\vstudio\vc12\zlibvc.sln /rebuild "ReleaseWithoutAsm|x64" /project zlibstat

copy zlib\contrib\vstudio\vc12\x64\ZlibStatReleaseWithoutAsm\zlibstat.lib .\Release\x64\

CALL "%VS120COMNTOOLS%\..\..\VC\vcvarsall.bat" x86

devenv zlib\contrib\vstudio\vc12\zlibvc.sln /rebuild "Debug|Win32" /project zlibstat

copy zlib\contrib\vstudio\vc12\x86\ZlibStatDebug\zlibstat.lib  .\Debug\Win32\

devenv zlib\contrib\vstudio\vc12\zlibvc.sln /rebuild "ReleaseWithoutAsm|Win32" /project zlibstat

copy zlib\contrib\vstudio\vc12\x86\ZlibStatReleaseWithoutAsm\zlibstat.lib  .\Release\Win32\

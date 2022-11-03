@REM under windows, use pdfl15_all\build-zilb\zlib\contrib\vstudio\vc12\zlibvc.sln
@REM build project zlibstat with configuraitons "Debug|x64" "ReleaseWithoutAsm|x64"
@REM   "Debug|Win32" "ReleaseWithoutAsm|Win32"

IF EXIST zlib GOTO CONT1
	@echo "Cloning Git repo for zlib"
	git clone git@github.com:madler/zlib.git zlib
:CONT1

cd zlib

git checkout v1.2.13
REM ===========================================================================
REM           Update zlibstat.vxproj project file for DL needs
REM ===========================================================================
REM apply a patch that will correct build settings in the windows VS project
git apply --verbose ../modify-zlib-build.patch

cd ..

REM ===========================================================================
REM Build 64 bit version of the library
REM ===========================================================================
CALL "%VS120COMNTOOLS%\..\..\VC\vcvarsall.bat" amd64

MSBuild zlib\contrib\vstudio\vc12\zlibstat.vcxproj /t:Rebuild /p:Configuration=Debug;Platform=x64  
xcopy zlib\contrib\vstudio\vc12\x64\ZlibStatDebug\zlibstat.lib  .\Debug\x64\lib\ /Y

MSBuild zlib\contrib\vstudio\vc12\zlibstat.vcxproj /t:Rebuild /p:Configuration=ReleaseWithoutAsm;Platform=x64 
xcopy zlib\contrib\vstudio\vc12\x64\ZlibStatReleaseWithoutAsm\zlibstat.lib .\Release\x64\lib\ /Y

REM ===========================================================================
REM Build 32 bit version of the library
REM ===========================================================================
CALL "%VS120COMNTOOLS%\..\..\VC\vcvarsall.bat" x86

MSBuild zlib\contrib\vstudio\vc12\zlibstat.vcxproj /t:Rebuild /p:Configuration=Debug;Platform=Win32  
xcopy zlib\contrib\vstudio\vc12\x86\ZlibStatDebug\zlibstat.lib  .\Debug\Win32\lib\ /Y

MSBuild zlib\contrib\vstudio\vc12\zlibstat.vcxproj /t:Rebuild /p:Configuration=ReleaseWithoutAsm;Platform=Win32 
xcopy zlib\contrib\vstudio\vc12\x86\ZlibStatReleaseWithoutAsm\zlibstat.lib  .\Release\Win32\lib\ /Y


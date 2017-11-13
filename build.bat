@REM under windows, use pdfl15_all\build-zilb\zlib\contrib\vstudio\vc12\zlibvc.sln
@REM build project zlibstat with configuraitons "Debug|x64" "ReleaseWithoutAsm|x64"
@REM   "Debug|Win32" "ReleaseWithoutAsm|Win32"

IF EXIST zlib GOTO CONT1
	@echo "Cloning Git repo for zlib"
	git clone git@github.com:madler/zlib.git
:CONT1

cd zlib

git checkout v1.2.11

cd ..

REM ===========================================================================
REM Remove ZIP_WINAPU preprocessor definition from zlibstat.vxproj project file
REM ===========================================================================
REM Save original zlibstat.vcxproj to a temporary folder
xcopy zlib\contrib\vstudio\vc12\zlibstat.vcxproj zlib\contrib\vstudio\vc12\_data_logics_\ /Y

REM Run Python script, which replaces ZLIB_WINAPI with nothing
python replace_def.py zlib\contrib\vstudio\vc12\zlibstat.vcxproj ZLIB_WINAPI; ""

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
xcopy zlib\contrib\vstudio\vc12\x86\ZlibStatReleaseWithoutAsm\zlibstat.lib  .\Release\Win32\lib /Y

REM Restore the original content of zlibstat.vcxproj and remove the temporary folder
xcopy zlib\contrib\vstudio\vc12\_data_logics_\zlibstat.vcxproj zlib\contrib\vstudio\vc12\ /Y
rd /S /Q zlib\contrib\vstudio\vc12\_data_logics_

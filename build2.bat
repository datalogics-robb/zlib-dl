@REM under windows, use this secondary script to build via CMake
@REM with the newer windows compilers

IF EXIST zlib GOTO CONT1
	@echo "Cloning Git repo for zlib"
	git clone git@github.com:madler/zlib.git zlib
	cd zlib
	git checkout v1.2.11
	cd ..
:CONT1

@REM  zlib-dl directory.
@REM I could probably figure out how to do this with more loops given the time
@REM but no.

for %%S in (Release,Debug) DO (
mkdir %%S_vs14_64
cd %%S_vs14_64
 cmake -G "Visual Studio 14 2015 Win64" -DCMAKE_C_FLAGS_RELEASE="/MT /Zi /O2" -DCMAKE_C_FLAGS_DEBUG="/MTd /Zi /Ob0 /Od /RTC1" -DCMAKE_C_FLAGS="/Zi" -DCMAKE_INSTALL_PREFIX="c:\Users\robb\Development\apdfl-18box\zlib-dl\%%S\x64_v140" ../zlib
 cmake --build . --config %%S --target install

cd ..

mkdir %%S_vs14_32
cd %%S_vs14_32
 cmake -G "Visual Studio 14 2015" -DCMAKE_C_FLAGS_RELEASE="/MT /Zi /O2" -DCMAKE_C_FLAGS_DEBUG="/MTd /Zi /Ob0 /Od /RTC1" -DCMAKE_C_FLAGS="/Zi" -DCMAKE_INSTALL_PREFIX="c:\Users\robb\Development\apdfl-18box\zlib-dl\%%S\Win32_v140" ../zlib
 cmake --build . --config %%S --target install

cd ..

mkdir %%S_vs14_64
cd %%S_vs14_64
 cmake -G "Visual Studio 14 2015 Win64" -DCMAKE_C_FLAGS_RELEASE="/MT /Zi /O2" -DCMAKE_C_FLAGS_DEBUG="/MTd /Zi /Ob0 /Od /RTC1" -DCMAKE_C_FLAGS="/Zi" -DCMAKE_INSTALL_PREFIX="c:\Users\robb\Development\apdfl-18box\zlib-dl\%%S\x64_v140" ../zlib
 cmake --build . --config %%S --target install

cd ..

mkdir %%S_vs14_32
cd %%S_vs14_32
 cmake -G "Visual Studio 14 2015" -DCMAKE_C_FLAGS_RELEASE="/MT /Zi /O2" -DCMAKE_C_FLAGS_DEBUG="/MTd /Zi /Ob0 /Od /RTC1" -DCMAKE_C_FLAGS="/Zi" -DCMAKE_INSTALL_PREFIX="c:\Users\robb\Development\apdfl-18box\zlib-dl\%%S\Win32_v140" ../zlib
 cmake --build . --config %%S --target install

cd ..
)


for %%S in (Release,Debug) DO (
mkdir %%S_vs15_64
cd %%S_vs15_64
 cmake -G "Visual Studio 15 2017 Win64" -DCMAKE_C_FLAGS_RELEASE="/MT /Zi /O2" -DCMAKE_C_FLAGS_DEBUG="/MTd /Zi /Ob0 /Od /RTC1" -DCMAKE_C_FLAGS="/Zi" -DCMAKE_INSTALL_PREFIX="c:\Users\robb\Development\apdfl-18box\zlib-dl\%%S\x64_v141" ../zlib
 cmake --build . --config %%S --target install

cd ..

mkdir %%S_vs15_32
cd %%S_vs15_32
 cmake -G "Visual Studio 15 2017" -DCMAKE_C_FLAGS_RELEASE="/MT /Zi /O2" -DCMAKE_C_FLAGS_DEBUG="/MTd /Zi /Ob0 /Od /RTC1" -DCMAKE_C_FLAGS="/Zi" -DCMAKE_INSTALL_PREFIX="c:\Users\robb\Development\apdfl-18box\zlib-dl\%%S\Win32_v141" ../zlib
 cmake --build . --config %%S --target install

cd ..

mkdir %%S_vs15_64
cd %%S_vs15_64
 cmake -G "Visual Studio 15 2017 Win64" -DCMAKE_C_FLAGS_RELEASE="/MT /Zi /O2" -DCMAKE_C_FLAGS_DEBUG="/MTd /Zi /Ob0 /Od /RTC1" -DCMAKE_C_FLAGS="/Zi" -DCMAKE_INSTALL_PREFIX="c:\Users\robb\Development\apdfl-18box\zlib-dl\%%S\x64_v141" ../zlib
 cmake --build . --config %%S --target install

cd ..

mkdir %%S_vs15_32
cd %%S_vs15_32
 cmake -G "Visual Studio 15 2017" -DCMAKE_C_FLAGS_RELEASE="/MT /Zi /O2" -DCMAKE_C_FLAGS_DEBUG="/MTd /Zi /Ob0 /Od /RTC1" -DCMAKE_C_FLAGS="/Zi" -DCMAKE_INSTALL_PREFIX="c:\Users\robb\Development\apdfl-18box\zlib-dl\%%S\Win32_v141" ../zlib
 cmake --build . --config %%S --target install

cd ..
)


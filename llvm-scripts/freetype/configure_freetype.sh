#!/usr/bin/env bash
set -eo pipefail
cd freetype
BUILD="build_$TARGET_TRIPLE"

if [ "$(dpkg --print-architecture)" != "$DPKG_ARCH" ]; then
  CROSS_COMPILING='1'
else
  CROSS_COMPILING=''
fi

if [ "$CROSS_COMPILING" == '1' ]; then
  CMAKE_TRY_COMPILE_TARGET_TYPE_OPTION='-DCMAKE_TRY_COMPILE_TARGET_TYPE=STATIC_LIBRARY'
else
  CMAKE_TRY_COMPILE_TARGET_TYPE_OPTION=''
fi
CMAKE_C_FLAGS=(-fPIC)
echo "CMAKE_C_FLAGS: ${CMAKE_C_FLAGS[*]}"

# let's disable every codec and see whether it works anyway
cmake -B"$BUILD" \
"$CMAKE_TRY_COMPILE_TARGET_TYPE_OPTION" \
-DBUILD_SHARED_LIBS=off \
-DFT_DISABLE_PNG=on \
-DFT_DISABLE_ZLIB=on \
-DFT_DISABLE_BZIP2=on \
-DFT_DISABLE_BROTLI=on \
-DCMAKE_C_FLAGS="${CMAKE_C_FLAGS[*]}" \
-DCMAKE_TOOLCHAIN_FILE="$TOOLCHAIN_FILE"
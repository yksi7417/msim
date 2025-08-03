$ErrorActionPreference = "Stop"

# Set VCPKG path and triplet
$VCPKG_ROOT = "$env:VCPKG_ROOT"
$VCPKG_TRIPLET = "x64-windows"

# Install dependencies (assumes vcpkg already installed)
& $VCPKG_ROOT\vcpkg install boost openssl

# Configure and build
mkdir -Force build
cd build
cmake .. -DCMAKE_TOOLCHAIN_FILE="$VCPKG_ROOT\scripts\buildsystems\vcpkg.cmake" `
         -DCMAKE_BUILD_TYPE=Release `
         -A x64
cmake --build . --config Release

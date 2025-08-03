$ErrorActionPreference = "Stop"

# Set VCPKG path and triplet
$VCPKG_ROOT = "$env:VCPKG_ROOT"
$VCPKG_TRIPLET = "x64-windows"

# Install dependencies for Fix8 and project (assumes vcpkg already installed)
# Fix8 requires POCO C++ Libraries and additional Windows-specific dependencies
& $VCPKG_ROOT\vcpkg install poco[complete] boost openssl zlib libxml2

# Clone and build Fix8 from source
Write-Host "Building Fix8 from source..."
if (Test-Path "fix8") {
    Remove-Item -Recurse -Force "fix8"
}
git clone https://github.com/fix8/fix8.git
cd fix8

# Fix8 on Windows typically uses Visual Studio/MSBuild
# Check if we have the msvc directory with project files
if (Test-Path "msvc") {
    Write-Host "Using Visual Studio project files..."
    # Build using MSBuild if available
    if (Get-Command "msbuild" -ErrorAction SilentlyContinue) {
        msbuild msvc\fix8.sln /p:Configuration=Release /p:Platform=x64
    } else {
        Write-Host "MSBuild not found. Please build Fix8 manually using Visual Studio."
    }
} else {
    Write-Host "MSVC project files not found. Fix8 may need manual configuration for Windows."
}

cd ..

# Configure and build
mkdir -Force build
cd build
cmake .. -DCMAKE_TOOLCHAIN_FILE="$VCPKG_ROOT\scripts\buildsystems\vcpkg.cmake" `
         -DCMAKE_BUILD_TYPE=Release `
         -A x64
cmake --build . --config Release

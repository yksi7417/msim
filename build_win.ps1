$ErrorActionPreference = "Stop"

Write-Host "Building msim project with Fix8 dependency..." -ForegroundColor Green

# Set VCPKG path and triplet
$VCPKG_ROOT = "$env:VCPKG_ROOT"
$VCPKG_TRIPLET = "x64-windows"

if (-not $VCPKG_ROOT) {
    Write-Error "VCPKG_ROOT environment variable not set. Please install vcpkg and set VCPKG_ROOT."
    exit 1
}

# Install dependencies for Fix8 and project (assumes vcpkg already installed)
# Fix8 requires POCO C++ Libraries and additional Windows-specific dependencies
Write-Host "Installing dependencies via vcpkg..." -ForegroundColor Yellow
& $VCPKG_ROOT\vcpkg install poco[complete] boost openssl zlib libxml2

# Clone and build Fix8 from source
Write-Host "Building Fix8 from source..." -ForegroundColor Yellow
if (Test-Path "fix8") {
    Remove-Item -Recurse -Force "fix8"
}
git clone https://github.com/fix8/fix8.git
Set-Location fix8

# Fix8 on Windows typically uses Visual Studio/MSBuild
# Check if we have the msvc directory with project files
if (Test-Path "msvc") {
    Write-Host "Using Visual Studio project files..." -ForegroundColor Green
    # Build using MSBuild if available with warning suppressions
    if (Get-Command "msbuild" -ErrorAction SilentlyContinue) {
        msbuild msvc\fix8.sln /p:Configuration=Release /p:Platform=x64 /p:WarningLevel=1
        if ($LASTEXITCODE -eq 0) {
            Write-Host "Fix8 built successfully!" -ForegroundColor Green
        } else {
            Write-Error "Fix8 build failed"
            exit 1
        }
    } else {
        Write-Warning "MSBuild not found. Please build Fix8 manually using Visual Studio."
        Write-Host "Open msvc\fix8.sln in Visual Studio and build the Release|x64 configuration."
        exit 1
    }
} else {
    Write-Warning "MSVC project files not found. Fix8 may need manual configuration for Windows."
    Write-Host "Please refer to Fix8 Windows build documentation."
    exit 1
}

Set-Location ..

# Configure and build our project
Write-Host "Building msim project..." -ForegroundColor Yellow
if (Test-Path "build") {
    Remove-Item -Recurse -Force "build"
}
New-Item -ItemType Directory -Name "build" | Out-Null
Set-Location build

cmake .. -DCMAKE_TOOLCHAIN_FILE="$VCPKG_ROOT\scripts\buildsystems\vcpkg.cmake" `
         -DCMAKE_BUILD_TYPE=Release `
         -A x64

cmake --build . --config Release

if ($LASTEXITCODE -eq 0) {
    Write-Host "Build completed successfully!" -ForegroundColor Green
} else {
    Write-Error "Build failed"
    exit 1
}

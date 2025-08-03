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
& $VCPKG_ROOT\vcpkg install poco boost openssl zlib libxml2 --triplet=$VCPKG_TRIPLET

# Clone and build Fix8 from source
Write-Host "Building Fix8 from source..." -ForegroundColor Yellow
if (Test-Path "fix8") {
    Remove-Item -Recurse -Force "fix8"
}
git clone https://github.com/fix8/fix8.git
Set-Location fix8

# Check if Fix8 has CMake support
if (Test-Path "CMakeLists.txt") {
    Write-Host "Using CMake to build Fix8..." -ForegroundColor Green
    New-Item -ItemType Directory -Force -Name "build" | Out-Null
    Set-Location build
    
    cmake .. -DCMAKE_TOOLCHAIN_FILE="$VCPKG_ROOT\scripts\buildsystems\vcpkg.cmake" `
             -DCMAKE_BUILD_TYPE=Release `
             -A x64 `
             -DCMAKE_CXX_FLAGS="/W1"  # Suppress warnings
    
    cmake --build . --config Release
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Fix8 built successfully with CMake!" -ForegroundColor Green
        Set-Location ..
    } else {
        Write-Error "Fix8 CMake build failed"
        Set-Location ..
        Set-Location ..
        exit 1
    }
} elseif (Test-Path "msvc") {
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
} elseif (Test-Path "configure.ac" -or Test-Path "configure") {
    Write-Host "Fix8 appears to be autotools-based, which is not directly supported on Windows." -ForegroundColor Red
    Write-Host "Attempting to use MSYS2/MinGW approach..." -ForegroundColor Yellow
    
    # Check if we're in a Unix-like environment (MSYS2, Git Bash, etc.)
    if (Get-Command "bash" -ErrorAction SilentlyContinue) {
        Write-Host "Found bash, attempting Unix-style build..." -ForegroundColor Yellow
        bash -c "./bootstrap && ./configure && make"
        if ($LASTEXITCODE -eq 0) {
            Write-Host "Fix8 built successfully with autotools!" -ForegroundColor Green
        } else {
            Write-Warning "Autotools build failed. Fix8 may need manual Windows configuration."
            Write-Host "Consider using WSL or a pre-built Fix8 binary for Windows." -ForegroundColor Yellow
            Set-Location ..
            # Don't exit here, let's try to build our project anyway
        }
    } else {
        Write-Warning "Fix8 requires autotools which is not available in PowerShell."
        Write-Host "Please use one of these alternatives:" -ForegroundColor Yellow
        Write-Host "1. Install MSYS2 and build Fix8 there"
        Write-Host "2. Use WSL (Windows Subsystem for Linux)"
        Write-Host "3. Find a pre-built Fix8 binary for Windows"
        Write-Host "4. Use Visual Studio with a custom Fix8 project"
        Set-Location ..
        # Don't exit, continue with the build attempt
    }
} else {
    Write-Warning "Fix8 build system not recognized. Manual configuration may be required."
    Write-Host "Fix8 directory contents:" -ForegroundColor Yellow
    Get-ChildItem | Format-Table Name
}

Set-Location ..

# Verify Fix8 installation
Write-Host "Verifying Fix8 installation..." -ForegroundColor Yellow
& .\verify_fix8.ps1

# Configure and build our project
Write-Host "Building msim project..." -ForegroundColor Yellow
if (Test-Path "build") {
    Remove-Item -Recurse -Force "build"
}
New-Item -ItemType Directory -Name "build" | Out-Null
Set-Location build

# Try to build with Fix8 first, fall back to stub if needed
Write-Host "Configuring project with CMake..." -ForegroundColor Yellow
cmake .. -DCMAKE_TOOLCHAIN_FILE="$VCPKG_ROOT\scripts\buildsystems\vcpkg.cmake" `
         -DCMAKE_BUILD_TYPE=Release `
         -A x64

if ($LASTEXITCODE -eq 0) {
    Write-Host "CMake configuration successful" -ForegroundColor Green
    cmake --build . --config Release
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Build completed successfully!" -ForegroundColor Green
        Write-Host "Executables built:" -ForegroundColor Yellow
        if (Test-Path "Release\fill_sim.exe") {
            Write-Host "  - Release\fill_sim.exe" -ForegroundColor Green
        }
        if (Test-Path "Release\test_smoke.exe") {
            Write-Host "  - Release\test_smoke.exe" -ForegroundColor Green
        }
    } else {
        Write-Error "Build failed"
        exit 1
    }
} else {
    Write-Error "CMake configuration failed"
    exit 1
}

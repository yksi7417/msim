# Windows Build Instructions

This document provides instructions for building the msim project on Windows.

## Prerequisites

1. **Visual Studio 2019 or later** with C++ development tools
2. **vcpkg** package manager
3. **Git** for cloning repositories
4. **CMake** (usually included with Visual Studio)

## vcpkg Setup

1. Install vcpkg if you haven't already:
   ```powershell
   git clone https://github.com/Microsoft/vcpkg.git
   cd vcpkg
   .\bootstrap-vcpkg.bat
   ```

2. Set the VCPKG_ROOT environment variable:
   ```powershell
   $env:VCPKG_ROOT = "C:\path\to\your\vcpkg"
   ```

## Building

### Option 1: Automated Build (Recommended)

Run the PowerShell build script:
```powershell
.\build_win.ps1
```

### Option 2: Manual Build

1. Install dependencies:
   ```powershell
   vcpkg install poco boost openssl zlib libxml2 --triplet=x64-windows
   ```

2. Build Fix8 (if needed):
   ```powershell
   git clone https://github.com/fix8/fix8.git
   # Follow Fix8 Windows build instructions
   ```

3. Build the project:
   ```powershell
   mkdir build
   cd build
   cmake .. -DCMAKE_TOOLCHAIN_FILE="$env:VCPKG_ROOT\scripts\buildsystems\vcpkg.cmake" -A x64
   cmake --build . --config Release
   ```

## Troubleshooting

### Fix8 Build Issues

Fix8 may not have full Windows support. If Fix8 fails to build:

1. The project includes a stub implementation that allows basic compilation
2. You can develop and test the project structure without full Fix8 functionality
3. For production use, consider using WSL or a Linux environment

### Common Issues

- **vcpkg errors**: Update vcpkg with `git pull` and re-run `.\bootstrap-vcpkg.bat`
- **MSBuild not found**: Ensure Visual Studio is properly installed with C++ tools
- **Fix8 compilation errors**: Use the stub implementation or consider WSL

## Alternative: Windows Subsystem for Linux (WSL)

For the most straightforward experience, consider using WSL:

1. Install WSL2 with Ubuntu
2. Use the Linux build script: `./build_linux.sh`
3. This provides full Fix8 compatibility

## Output

Successful builds will create:
- `build\Release\fill_sim.exe`
- `build\Release\test_smoke.exe`

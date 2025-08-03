# Build Scripts

This directory contains helper scripts and documentation for building the msim project.

## Main Build Scripts (in project root)

The primary build scripts are located in the project root directory:

### `build_linux.sh`
Complete Linux/Unix build script that:
- Installs system dependencies 
- Builds Fix8 from source with warning suppressions
- Builds the msim project

**Usage:**
```bash
./build_linux.sh
```

### `build_win.ps1`
Complete Windows build script that:
- Installs dependencies via vcpkg
- Builds Fix8 using Visual Studio/MSBuild
- Builds the msim project with CMake

**Usage:**
```powershell
.\build_win.ps1
```

## Requirements

### Linux/Unix
- git
- autotools (autoconf, automake, libtool)
- POCO C++ Libraries development packages
- Standard build tools (gcc, make, cmake)

### Windows
- Visual Studio with C++ support
- Git
- vcpkg (with VCPKG_ROOT environment variable set)

## Warning Suppressions

Both build scripts apply compiler flags to reduce noise in build output from the Fix8 dependency:
- `-Wno-class-memaccess`: Safe memcpy usage on POD structures
- `-Wno-unused-result`: Ignored return values in utility functions  
- `-Wno-overloaded-virtual`: Intentional virtual function hiding
- `-Wno-deprecated-declarations`: Legacy pthread functions still in use

See `doc/ignored_warnings.md` for detailed explanations of each suppression.

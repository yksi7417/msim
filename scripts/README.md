# Build Scripts

This directory contains helper scripts for building Fix8 with suppressed warnings.

## Linux/Unix Scripts

### `build_fix8_quiet.sh`
Builds Fix8 from source with compiler warnings suppressed for cleaner output.

**Usage:**
```bash
./scripts/build_fix8_quiet.sh
```

**Requirements:**
- git
- autotools (autoconf, automake, libtool)
- POCO C++ Libraries development packages
- Standard build tools (gcc, make)

## Windows Scripts

### `build_fix8_quiet.ps1`
PowerShell script for building Fix8 on Windows with Visual Studio.

**Usage:**
```powershell
.\scripts\build_fix8_quiet.ps1
```

**Requirements:**
- Visual Studio with C++ support
- Git
- vcpkg (recommended for dependencies)

**Note:** Windows builds may require additional manual configuration. Refer to the 
[Fix8 Windows build documentation](https://fix8engine.atlassian.net/wiki/x/EICW) for detailed instructions.

## Warning Suppressions

Both scripts apply the following compiler flags to reduce noise in build output:
- `-Wno-class-memaccess`: Safe memcpy usage on POD structures
- `-Wno-unused-result`: Ignored return values in utility functions  
- `-Wno-overloaded-virtual`: Intentional virtual function hiding
- `-Wno-deprecated-declarations`: Legacy pthread functions still in use

See `doc/ignored_warnings.md` for detailed explanations of each suppression.

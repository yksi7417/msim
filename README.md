# msim
Million Fill Simulator

A FIX protocol market simulator built on the Fix8 engine.

## Building

### Linux/Unix
Run the complete build script:
```bash
./build_linux.sh
```

This will:
- Install system dependencies (cmake, boost, POCO, etc.)
- Build Fix8 from source with warning suppressions
- Build the msim project

### Windows
Run the PowerShell build script:
```powershell
.\build_win.ps1
```

**Prerequisites:**
- Visual Studio with C++ support
- vcpkg package manager with `VCPKG_ROOT` environment variable set

This will:
- Install dependencies via vcpkg (POCO, boost, OpenSSL, etc.)
- Build Fix8 using Visual Studio project files
- Build the msim project with CMake

## Manual Build

If you prefer to build manually or need to customize the process:

1. **Install Fix8 dependency** (see Fix8 documentation)
2. **Configure project:**
   ```bash
   mkdir build && cd build
   cmake .. -DCMAKE_BUILD_TYPE=Release
   ```
3. **Build:**
   ```bash
   make -j$(nproc)  # Linux
   cmake --build . --config Release  # Windows
   ```

## Components

- `fill_sim` - Main fill simulator executable
- `test_smoke` - Smoke test executable

## Documentation

- `doc/ignored_warnings.md` - Information about suppressed compiler warnings
- `scripts/README.md` - Build script documentation

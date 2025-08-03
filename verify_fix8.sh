#!/bin/bash

echo "Verifying Fix8 installation..."

# Check if Fix8 headers exist in multiple locations
echo "Searching for Fix8 headers..."

HEADER_FOUND=false
HEADER_LOCATIONS=(
    "fix8/include/fix8/f8config.h"
    "fix8/include/fix8/f8config.hpp"
    "fix8/src/fix8/f8config.h" 
    "fix8/src/fix8/f8config.hpp"
    "fix8/f8config.h"
    "fix8/f8config.hpp"
    "/usr/local/include/fix8/f8config.h"
    "/usr/local/include/fix8/f8config.hpp"
    "/usr/include/fix8/f8config.h"
    "/usr/include/fix8/f8config.hpp"
    "/opt/fix8/include/fix8/f8config.h"
    "/opt/fix8/include/fix8/f8config.hpp"
)

for location in "${HEADER_LOCATIONS[@]}"; do
    if [ -f "$location" ]; then
        echo "✓ Fix8 headers found at: $location"
        HEADER_FOUND=true
        break
    else
        echo "  Checked: $location (not found)"
    fi
done

if [ "$HEADER_FOUND" = false ]; then
    echo "✗ Fix8 headers not found in any standard location"
    
    # Check if fix8 directory exists
    if [ -d "fix8" ]; then
        echo "Fix8 directory exists. Checking its contents:"
        ls -la fix8/ | head -10
        
        echo "Searching for any header files in fix8/:"
        find fix8 -name "*.hpp" -o -name "*.h" | head -10 || echo "No header files found"
        
        echo "Searching specifically for f8config files:"
        find fix8 -name "*f8config*" | head -5 || echo "No f8config files found"
    else
        echo "Fix8 directory does not exist. The build process may have failed."
    fi
    
    # Try to find Fix8 files anywhere
    echo "Searching for any Fix8 files..."
    find / -name "*fix8*" -type f 2>/dev/null | head -10 || true
    find . -name "*f8config*" -type f 2>/dev/null | head -5 || true
    
    echo "Fix8 installation may have failed. Check the build logs above."
    exit 1
fi

# Check if Fix8 library exists
echo "Searching for Fix8 libraries..."

LIBRARY_FOUND=false
LIBRARY_LOCATIONS=(
    "fix8/.libs/libfix8.so"
    "fix8/.libs/libfix8.a"
    "fix8/lib/libfix8.so"
    "fix8/lib/libfix8.a"
    "fix8/libfix8.so"
    "fix8/libfix8.a"
    "/usr/local/lib/libfix8.so"
    "/usr/local/lib/libfix8.a"
    "/usr/lib/libfix8.so"
    "/usr/lib/libfix8.a"
    "/usr/lib/x86_64-linux-gnu/libfix8.so"
    "/usr/lib/x86_64-linux-gnu/libfix8.a"
)

for location in "${LIBRARY_LOCATIONS[@]}"; do
    if [ -f "$location" ]; then
        echo "✓ Fix8 library found at: $location"
        LIBRARY_FOUND=true
        break
    else
        echo "  Checked: $location (not found)"
    fi
done

if [ "$LIBRARY_FOUND" = false ]; then
    echo "✗ Fix8 library not found in any standard location"
    
    # Try to find Fix8 libraries anywhere
    echo "Searching for any Fix8 libraries..."
    find / -name "*libfix8*" -type f 2>/dev/null | head -5 || true
    find . -name "*libfix8*" -type f 2>/dev/null | head -5 || true
    
    echo "Fix8 library installation may have failed."
    exit 1
fi

echo "Fix8 installation verification completed successfully."

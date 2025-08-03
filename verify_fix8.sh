#!/bin/bash

echo "Verifying Fix8 installation..."

# Check if Fix8 headers exist
if [ -f "/usr/local/include/fix8/f8config.hpp" ]; then
    echo "✓ Fix8 headers found in /usr/local/include"
elif [ -f "/usr/include/fix8/f8config.hpp" ]; then
    echo "✓ Fix8 headers found in /usr/include"
else
    echo "✗ Fix8 headers not found"
    exit 1
fi

# Check if Fix8 library exists
if [ -f "/usr/local/lib/libfix8.so" ] || [ -f "/usr/local/lib/libfix8.a" ]; then
    echo "✓ Fix8 library found in /usr/local/lib"
elif [ -f "/usr/lib/libfix8.so" ] || [ -f "/usr/lib/libfix8.a" ] || [ -f "/usr/lib/x86_64-linux-gnu/libfix8.so" ]; then
    echo "✓ Fix8 library found in system lib directory"
else
    echo "✗ Fix8 library not found"
    exit 1
fi

echo "Fix8 installation verification completed successfully."

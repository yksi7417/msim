#!/bin/bash

echo "Checking Fix8 local build status..."

if [ ! -d "fix8" ]; then
    echo "✗ Fix8 directory not found. Run the build script first."
    exit 1
fi

cd fix8

echo "Fix8 directory contents:"
ls -la

echo "Searching for Fix8 configuration files:"
find . -name "configure" -o -name "CMakeLists.txt" -o -name "Makefile*" | head -5

echo "Searching for Fix8 headers:"
find . -name "*.hpp" -path "*/fix8/*" | head -5
find . -name "f8config.hpp" | head -5

echo "Searching for Fix8 libraries:"
find . -name "*.so" -o -name "*.a" | head -5

echo "Checking build artifacts:"
if [ -d ".libs" ]; then
    echo "Found .libs directory:"
    ls -la .libs/
fi

if [ -d "include" ]; then
    echo "Found include directory:"
    ls -la include/
fi

if [ -d "src" ]; then
    echo "Found src directory:"
    ls -la src/ | head -10
fi

echo "Fix8 local build check completed."

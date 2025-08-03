#!/bin/bash
# Script to build Fix8 with suppressed warnings for cleaner output
# This modifies the Fix8 build process to add warning suppressions

set -e

echo "Building Fix8 with suppressed warnings..."

# Clone Fix8 if not present
if [ ! -d "fix8" ]; then
    git clone https://github.com/fix8/fix8.git
fi

cd fix8

# Run bootstrap
./bootstrap

# Configure with additional CXXFLAGS to suppress warnings
CXXFLAGS="-Wno-class-memaccess -Wno-unused-result -Wno-overloaded-virtual -Wno-deprecated-declarations" \
    ./configure

# Build
make -j$(nproc)

# Install
sudo make install

echo "Fix8 installed successfully with suppressed warnings."

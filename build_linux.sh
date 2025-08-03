#!/bin/bash
set -e

echo "Building msim project with Fix8 dependency..."

# Install dependencies
sudo apt update
sudo apt install -y cmake libboost-all-dev libssl-dev libxml2-dev git build-essential
sudo apt install -y libpoco-dev libtool autoconf automake

# Build Fix8 with suppressed warnings for cleaner output
echo "Building Fix8 from source..."
if [ ! -d "fix8" ]; then
    git clone https://github.com/fix8/fix8.git
fi

cd fix8
./bootstrap

# Configure with suppressed warnings
echo "Configuring Fix8 with warning suppressions..."
CXXFLAGS="-Wno-class-memaccess -Wno-unused-result -Wno-overloaded-virtual -Wno-deprecated-declarations" \
    ./configure

# Build and install Fix8
make -j$(nproc)
sudo make install
sudo ldconfig

cd ..

# Configure and build our project
echo "Building msim project..."
mkdir -p build
cd build
cmake .. -DCMAKE_BUILD_TYPE=Release
make -j$(nproc)

echo "Build completed successfully!"

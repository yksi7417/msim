#!/bin/bash
set -e

# Install dependencies
sudo apt update
sudo apt install -y cmake libboost-all-dev libssl-dev libxml2-dev git build-essential
sudo apt install -y libpoco-dev

# Configure and build
mkdir -p build
cd build
cmake .. -DCMAKE_BUILD_TYPE=Release
make -j$(nproc)

#!/bin/bash

echo "Running all tests..."

cd build || { echo "Build directory not found. Run build script first."; exit 1; }

echo "=== Running Smoke Test ==="
./test_smoke || { echo "Smoke test failed"; exit 1; }

echo ""
echo "=== Running Fill Simulator ==="
./fill_sim || { echo "Fill simulator failed"; exit 1; }

echo ""
echo "=== Running Integration Test ==="
./test_integration || { echo "Integration test failed"; exit 1; }

echo ""
echo "✓ All tests passed successfully!"

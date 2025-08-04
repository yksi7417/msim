Write-Host "Running all tests..." -ForegroundColor Green

if (-not (Test-Path "build")) {
    Write-Error "Build directory not found. Run build script first."
    exit 1
}

Set-Location build\Release

Write-Host "=== Running Smoke Test ===" -ForegroundColor Yellow
if (-not (Test-Path "test_smoke.exe")) {
    Write-Error "test_smoke.exe not found. Build may have failed."
    exit 1
}
try {
    & .\test_smoke.exe
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Smoke test failed with exit code $LASTEXITCODE"
        exit 1
    }
} catch {
    Write-Error "Smoke test execution failed: $_"
    exit 1
}

Write-Host ""
Write-Host "=== Running Fill Simulator ===" -ForegroundColor Yellow
if (-not (Test-Path "fill_sim.exe")) {
    Write-Error "fill_sim.exe not found. Build may have failed."
    exit 1
}
try {
    & .\fill_sim.exe
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Fill simulator failed with exit code $LASTEXITCODE"
        exit 1
    }
} catch {
    Write-Error "Fill simulator execution failed: $_"
    exit 1
}

Write-Host ""
Write-Host "=== Running Integration Test ===" -ForegroundColor Yellow
if (-not (Test-Path "test_integration.exe")) {
    Write-Error "test_integration.exe not found. Build may have failed."
    exit 1
}
try {
    & .\test_integration.exe
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Integration test failed with exit code $LASTEXITCODE"
        exit 1
    }
} catch {
    Write-Error "Integration test execution failed: $_"
    exit 1
}

Write-Host ""
Write-Host "[SUCCESS] All tests passed successfully!" -ForegroundColor Green

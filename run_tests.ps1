Write-Host "Running all tests..." -ForegroundColor Green

if (-not (Test-Path "build")) {
    Write-Error "Build directory not found. Run build script first."
    exit 1
}

Set-Location build\Release

Write-Host "=== Running Smoke Test ===" -ForegroundColor Yellow
& .\test_smoke.exe
if ($LASTEXITCODE -ne 0) {
    Write-Error "Smoke test failed"
    exit 1
}

Write-Host ""
Write-Host "=== Running Fill Simulator ===" -ForegroundColor Yellow
& .\fill_sim.exe
if ($LASTEXITCODE -ne 0) {
    Write-Error "Fill simulator failed"
    exit 1
}

Write-Host ""
Write-Host "=== Running Integration Test ===" -ForegroundColor Yellow
& .\test_integration.exe
if ($LASTEXITCODE -ne 0) {
    Write-Error "Integration test failed"
    exit 1
}

Write-Host ""
Write-Host "✓ All tests passed successfully!" -ForegroundColor Green

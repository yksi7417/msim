$ErrorActionPreference = "Stop"

Write-Host "Verifying Fix8 installation on Windows..." -ForegroundColor Green

$Fix8Found = $false
$Fix8HeaderPath = ""
$Fix8LibraryPath = ""

# Check common locations for Fix8 headers
$HeaderPaths = @(
    "fix8\include\fix8\f8config.h",
    "fix8\include\fix8\f8config.hpp",
    "fix8\include\fix8\session.h",
    "fix8\include\fix8\session.hpp", 
    "fix8\include\fix8\message.h",
    "fix8\include\fix8\message.hpp",
    "fix8\src\fix8\f8config.h",
    "fix8\src\fix8\f8config.hpp",
    "fix8\build\include\fix8\f8config.h",
    "C:\fix8\include\fix8\f8config.h"
)

foreach ($path in $HeaderPaths) {
    if (Test-Path $path) {
        Write-Host "✓ Fix8 headers found at: $path" -ForegroundColor Green
        $Fix8HeaderPath = $path
        $Fix8Found = $true
        break
    }
}

if (-not $Fix8Found) {
    Write-Host "⚠ Fix8 headers not found in standard locations" -ForegroundColor Yellow
    Write-Host "  Checked paths:" -ForegroundColor Gray
    foreach ($path in $HeaderPaths) {
        Write-Host "    $path" -ForegroundColor Gray
    }
}

# Check for Fix8 libraries
$LibraryPaths = @(
    "fix8\build\Release\fix8.lib",
    "fix8\build\Debug\fix8.lib", 
    "fix8\.libs\libfix8.a",
    "fix8\lib\fix8.lib",
    "fix8\lib\libfix8.lib",
    "fix8\Release\fix8.lib",
    "fix8\x64\Release\fix8.lib",
    "C:\fix8\lib\fix8.lib",
    "C:\fix8\lib\libfix8.lib"
)

$LibraryFound = $false
foreach ($path in $LibraryPaths) {
    if (Test-Path $path) {
        Write-Host "✓ Fix8 library found at: $path" -ForegroundColor Green
        $Fix8LibraryPath = $path
        $LibraryFound = $true
        break
    }
}

if (-not $LibraryFound) {
    Write-Host "⚠ Fix8 library not found in standard locations" -ForegroundColor Yellow
    Write-Host "  Checked paths:" -ForegroundColor Gray
    foreach ($path in $LibraryPaths) {
        Write-Host "    $path" -ForegroundColor Gray
    }
}

# Summary
if ($Fix8Found -and $LibraryFound) {
    Write-Host "✓ Fix8 installation verification completed successfully!" -ForegroundColor Green
    Write-Host "  Headers: $Fix8HeaderPath" -ForegroundColor Green
    Write-Host "  Library: $Fix8LibraryPath" -ForegroundColor Green
} elseif ($Fix8Found -or $LibraryFound) {
    Write-Host "⚠ Partial Fix8 installation detected" -ForegroundColor Yellow
    Write-Host "  The project will attempt to build with stub implementation" -ForegroundColor Yellow
} else {
    Write-Host "⚠ Fix8 not found - using stub implementation for development" -ForegroundColor Yellow
    Write-Host "  This allows basic compilation but full Fix8 features won't be available" -ForegroundColor Yellow
}

Write-Host "Fix8 verification completed." -ForegroundColor Cyan

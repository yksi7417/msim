# PowerShell script to build Fix8 with suppressed warnings for cleaner output
# This would need to be adapted for Windows - included for completeness

param(
    [string]$InstallPath = "C:\fix8"
)

Write-Host "Building Fix8 for Windows..." -ForegroundColor Green
Write-Host "Note: This script assumes you have Visual Studio and vcpkg installed." -ForegroundColor Yellow

# Check if Fix8 directory exists
if (-not (Test-Path "fix8")) {
    Write-Host "Cloning Fix8 repository..."
    git clone https://github.com/fix8/fix8.git
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Failed to clone Fix8 repository"
        exit 1
    }
}

Set-Location fix8

# Check for MSVC project files
if (Test-Path "msvc") {
    Write-Host "Found Visual Studio project files. Building with MSBuild..." -ForegroundColor Green
    
    # Build using MSBuild with warning suppressions
    if (Get-Command "msbuild" -ErrorAction SilentlyContinue) {
        # Add warning suppressions via MSBuild properties
        msbuild msvc\fix8.sln /p:Configuration=Release /p:Platform=x64 /p:WarningLevel=1
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "Fix8 built successfully!" -ForegroundColor Green
        } else {
            Write-Error "Fix8 build failed"
            exit 1
        }
    } else {
        Write-Warning "MSBuild not found. Please build Fix8 manually using Visual Studio."
        Write-Host "Open msvc\fix8.sln in Visual Studio and build the Release|x64 configuration."
    }
} else {
    Write-Warning "MSVC project files not found. Fix8 may need manual configuration for Windows."
    Write-Host "Please refer to Fix8 Windows build documentation at:"
    Write-Host "https://fix8engine.atlassian.net/wiki/x/EICW"
}

Set-Location ..
Write-Host "Fix8 Windows build process completed." -ForegroundColor Green

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "   RBRDUCK Environment Setup Script" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

# Check for Python
if (-not (Get-Command "python" -ErrorAction SilentlyContinue)) {
    Write-Warning "Python is not installed or not in your PATH. Please install Python 3 before running this script."
    Pause
    exit
}

# Ensure pip is up to date
Write-Host "Updating pip..." -ForegroundColor Yellow
python -m pip install --upgrade pip --quiet

$packages = @(
    "setuptools",
    "wheel",
    "numpy",
    "openpyxl",
    "pandas",
    "scipy",
    "sounddevice",
    "soundfile"
)

Write-Host "`nInstalling required Python packages..." -ForegroundColor Yellow
foreach ($pkg in $packages) {
    Write-Host " -> Installing $pkg..."
    python -m pip install $pkg --quiet
}

Write-Host "`n==========================================" -ForegroundColor Green
Write-Host "   All requirements successfully installed!" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Green
Write-Host ""
Pause

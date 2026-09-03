$rootDir = (Get-Item $PSScriptRoot).Parent.FullName
$jsonPath = Join-Path $rootDir "resources\stencil_matrix.json"
$sourceNormalized = Join-Path $rootDir "audio_normalized"
$buildPath = Join-Path $rootDir "build"

if (-not (Test-Path $jsonPath)) {
    Write-Warning "Cannot find stencil_matrix.json in resources folder."
    Pause
    exit
}

$matrix = Get-Content $jsonPath -Raw | ConvertFrom-Json

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "   RBRCDCK - Interactive Stencil Wizard" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Select a scale category:"
Write-Host "  [1] Descriptive & Hybrid"
Write-Host "  [2] Numeric"
Write-Host ""
$catChoice = Read-Host "Enter 1 or 2"

$options = @()
if ($catChoice -eq "1") {
    $options = $matrix.Descriptive
} elseif ($catChoice -eq "2") {
    $options = $matrix.Numeric
} else {
    Write-Warning "Invalid choice."
    Pause
    exit
}

Write-Host ""
Write-Host "Available Scales:" -ForegroundColor Yellow
$letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789" # Extended just in case

for ($i = 0; $i -lt $options.Count; $i++) {
    Write-Host "  [$($letters[$i])] $($options[$i].ScaleName)"
}
Write-Host ""
$scaleChoice = (Read-Host "Select scale").ToUpper()

$choiceIndex = $letters.IndexOf($scaleChoice)
if ($choiceIndex -lt 0 -or $choiceIndex -ge $options.Count) {
    Write-Warning "Invalid selection."
    Pause
    exit
}

$selectedEntry = $options[$choiceIndex]
$targetFolder = $selectedEntry.TargetFolder
$requiredFiles = $selectedEntry.Files

$destSoundDir = Join-Path $buildPath "Plugins\Pacenote\sounds\$targetFolder"
if (-not (Test-Path $destSoundDir)) {
    New-Item -ItemType Directory -Path $destSoundDir -Force | Out-Null
}

Write-Host ""
Write-Host "Building $($selectedEntry.ScaleName) into $targetFolder..." -ForegroundColor Cyan

$injectedCount = 0
$missingCount = 0

foreach ($reqFile in $requiredFiles) {
    $baseName = [System.IO.Path]::GetFileNameWithoutExtension($reqFile)
    $baseNameStripped = $baseName -replace '[1-9]$', ''
    
    $sourceFile = Join-Path $sourceNormalized "$baseNameStripped.ogg"
    
    if (Test-Path $sourceFile) {
        $destFile = Join-Path $destSoundDir $reqFile
        Copy-Item -Path $sourceFile -Destination $destFile -Force
        $injectedCount++
    } else {
        $missingCount++
    }
}

Write-Host "Build Complete!" -ForegroundColor Green
Write-Host "  -> Successfully injected: $injectedCount files."
Write-Host "  -> Missing/Unrecorded: $missingCount files."
Write-Host "Your package is ready in the 'build' folder."
Write-Host "==========================================" -ForegroundColor Green
Pause

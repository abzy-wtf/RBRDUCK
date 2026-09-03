$rootDir = (Get-Item $PSScriptRoot).Parent.FullName
$jsonPath = Join-Path $rootDir "resources\stencil_matrix.json"
$sourceNormalized = Join-Path $rootDir "audio_normalized"
$buildPath = Join-Path $rootDir "build"
$templatePath = Join-Path $rootDir "template"

if (-not (Test-Path $jsonPath)) {
    Write-Warning "Cannot find stencil_matrix.json in resources folder."
    Pause
    exit
}

$matrix = Get-Content $jsonPath -Raw | ConvertFrom-Json

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "   RBRDUCK - Interactive Stencil Wizard" -ForegroundColor Cyan
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

if (Test-Path $templatePath) {
    Copy-Item -Path "$templatePath\*" -Destination $buildPath -Recurse -Force
}

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
    $ext = [System.IO.Path]::GetExtension($reqFile)
    $baseNameStripped = $baseName -replace '[1-9]$', ''
    
    $sourceFile = Join-Path $sourceNormalized "$baseNameStripped$ext"
    
    if (Test-Path $sourceFile) {
        $destFile = Join-Path $destSoundDir $reqFile
        Copy-Item -Path $sourceFile -Destination $destFile -Force
        $injectedCount++
    } else {
        $missingCount++
    }
}

Write-Host ""
Write-Host "Copying auxiliary audio files (Speech\Broken, Speech\Number, Audio\Game)..." -ForegroundColor Cyan

$extraMappings = @{
    "batterys_flat.ogg" = "Audio\Speech\Broken\eng\batterys_flat.ogg"
    "problem_engine.ogg" = "Audio\Speech\Broken\eng\problem_engine.ogg"
    "steering_broke.ogg" = "Audio\Speech\Broken\eng\steering_broke.ogg"
    "sus_broke.ogg" = "Audio\Speech\Broken\eng\sus_broke.ogg"
    "water_temp.ogg" = "Audio\Speech\Broken\eng\water_temp.ogg"
    "weve_got_fire.ogg" = "Audio\Speech\Broken\eng\weve_got_fire.ogg"
    "wv_lost_brakes.ogg" = "Audio\Speech\Broken\eng\wv_lost_brakes.ogg"
    "start1.ogg" = "Audio\Speech\Number\start1.ogg"
    "start2.ogg" = "Audio\Speech\Number\start2.ogg"
    "start3.ogg" = "Audio\Speech\Number\start3.ogg"
    "Go.wav" = "Audio\Game\Go.wav"
}

foreach ($key in $extraMappings.Keys) {
    $base = [System.IO.Path]::GetFileNameWithoutExtension($key)
    $srcWav = Join-Path $sourceNormalized "$base.wav"
    $srcOgg = Join-Path $sourceNormalized "$base.ogg"
    
    $srcToUse = $null
    $destExt = ".ogg"
    if (Test-Path $srcWav) { $srcToUse = $srcWav; $destExt = ".wav" }
    elseif (Test-Path $srcOgg) { $srcToUse = $srcOgg; $destExt = ".ogg" }

    if ($srcToUse) {
        $destPath = Join-Path $buildPath ($extraMappings[$key] -replace '\.ogg$', $destExt)
        $destDir = Split-Path $destPath -Parent
        if (-not (Test-Path $destDir)) { New-Item -ItemType Directory -Path $destDir -Force | Out-Null }
        Copy-Item -Path $srcToUse -Destination $destPath -Force
        $injectedCount++
    } else {
        $missingCount++
    }
}

Write-Host ""
Write-Host "Build Complete!" -ForegroundColor Green
Write-Host "  -> Successfully injected: $injectedCount files."
Write-Host "  -> Missing/Unrecorded: $missingCount files."
Write-Host "Your package is ready in the 'build' folder."
Write-Host "==========================================" -ForegroundColor Green
Pause
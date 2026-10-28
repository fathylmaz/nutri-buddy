$ErrorActionPreference = 'Stop'
$root = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$project = Join-Path $root 'design\rive\nutri_buddy'
if (-not (Get-Command rive -ErrorAction SilentlyContinue)) {
  throw 'Rive CLI is not installed. See docs\ADIM8_RIVE_KURULUM.md'
}
Write-Host '1/2 Verifying Rive source...' -ForegroundColor Cyan
& rive $project --verify
if ($LASTEXITCODE -ne 0) { throw "Rive verify failed ($LASTEXITCODE)." }
Write-Host '2/2 Building Rive file...' -ForegroundColor Cyan
& rive $project --once
if ($LASTEXITCODE -ne 0) { throw "Rive build failed ($LASTEXITCODE)." }
$out = Join-Path $project 'build\nutri_buddy.riv'
if (-not (Test-Path $out)) {
  throw "Build succeeded but output was not found: $out. Inspect actual build output path."
}
Write-Host "Build complete: $out" -ForegroundColor Green
Write-Host 'Before publishing, finish and validate Happy/Energetic/Celebrate transitions in Rive Editor.'

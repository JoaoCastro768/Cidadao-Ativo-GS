$ErrorActionPreference = 'Stop'
Set-Location (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
flutter create --project-name cidadao_ativo --platforms android,web .
if ($LASTEXITCODE -ne 0) { exit 1 }
flutter pub get
if ($LASTEXITCODE -ne 0) { exit 1 }
flutter analyze
if ($LASTEXITCODE -ne 0) { exit 1 }
flutter test
if ($LASTEXITCODE -ne 0) { exit 1 }
Write-Host 'Validacao concluida com sucesso.' -ForegroundColor Green

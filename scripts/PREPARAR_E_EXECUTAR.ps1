$ErrorActionPreference = 'Stop'
Set-Location (Resolve-Path (Join-Path $PSScriptRoot '..')).Path

if (-not (Get-Command flutter -ErrorAction SilentlyContinue)) {
    $localFlutterBin = Join-Path $env:USERPROFILE 'develop\flutter\bin'
    if (Test-Path (Join-Path $localFlutterBin 'flutter.bat')) {
        $env:PATH = "$localFlutterBin;$env:PATH"
    }
}

if (-not (Get-Command flutter -ErrorAction SilentlyContinue)) {
    Write-Host 'Flutter nao encontrado no PATH. Instale o Flutter SDK e rode flutter doctor.' -ForegroundColor Red
    exit 1
}

Write-Host '1/5 - Verificando Flutter...' -ForegroundColor Cyan
flutter --version
if ($LASTEXITCODE -ne 0) { exit 1 }

Write-Host '2/5 - Completando arquivos de plataforma gerados pelo Flutter...' -ForegroundColor Cyan
flutter create --project-name cidadao_ativo --platforms android,web .
if ($LASTEXITCODE -ne 0) { exit 1 }

Write-Host '3/5 - Instalando dependencias...' -ForegroundColor Cyan
flutter pub get
if ($LASTEXITCODE -ne 0) { exit 1 }

Write-Host '4/5 - Analise estatica e testes...' -ForegroundColor Cyan
flutter analyze
if ($LASTEXITCODE -ne 0) { exit 1 }
flutter test
if ($LASTEXITCODE -ne 0) { exit 1 }

Write-Host '5/5 - Abrindo aplicativo no Google Chrome...' -ForegroundColor Green
flutter run -d chrome
if ($LASTEXITCODE -ne 0) { exit 1 }

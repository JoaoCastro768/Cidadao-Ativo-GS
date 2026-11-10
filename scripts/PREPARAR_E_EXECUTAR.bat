@echo off
cd /d "%~dp0.."
powershell -NoProfile -ExecutionPolicy Bypass -File "scripts\PREPARAR_E_EXECUTAR.ps1"

@echo off
:: LRN Man - Defender of the Network
:: Portable launcher - run directly from the zip/folder without installing

set "HERE=%~dp0"
set "INDEX=%HERE%..\issues\index.html"

if not exist "%INDEX%" (
    echo Cannot find comic files. Please keep all files together.
    pause
    exit /b 1
)

start "" "%INDEX%"

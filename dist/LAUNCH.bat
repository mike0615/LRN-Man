@echo off
:: LRN Man - Defender of the Network
:: DVD Auto-Launcher for Windows
:: Opens the comic series in your default browser from disc

setlocal

set "DISC=%~dp0"
set "INDEX=%DISC%issues\index.html"

:: Try to open in default browser
start "" "%INDEX%"

:: If start failed, try common browsers
if errorlevel 1 (
    for %%B in (
        "C:\Program Files\Google\Chrome\Application\chrome.exe"
        "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe"
        "C:\Program Files\Mozilla Firefox\firefox.exe"
        "C:\Program Files (x86)\Mozilla Firefox\firefox.exe"
        "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
    ) do (
        if exist %%B (
            start "" %%B "%INDEX%"
            goto :done
        )
    )
)

:done
endlocal

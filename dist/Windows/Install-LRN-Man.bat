@echo off
:: ============================================================
:: LRN Man: Defender of the Network
:: Windows Installer
:: Created by Mike Anderson
:: ============================================================

setlocal enabledelayedexpansion
title LRN Man Installer

echo.
echo  =====================================================
echo   LRN MAN: DEFENDER OF THE NETWORK
echo   Windows Installer
echo   Created by Mike Anderson
echo  =====================================================
echo.
echo  This will install LRN Man Comic Series on your computer.
echo.

:: Default install location
set "INSTALL_DIR=%USERPROFILE%\LRN Man - Defender of the Network"

echo  Install location:
echo  %INSTALL_DIR%
echo.
set /p CONFIRM="  Press ENTER to install, or type a custom path: "

if not "!CONFIRM!"=="" set "INSTALL_DIR=!CONFIRM!"

echo.
echo  Installing to: %INSTALL_DIR%
echo.

:: Create install directory
if not exist "%INSTALL_DIR%" mkdir "%INSTALL_DIR%"
if not exist "%INSTALL_DIR%\issues" mkdir "%INSTALL_DIR%\issues"
if not exist "%INSTALL_DIR%\art" mkdir "%INSTALL_DIR%\art"

:: Copy files (source is relative to THIS installer's location)
set "SRC=%~dp0.."

echo  Copying comic files...
xcopy /E /Y /Q "%SRC%\issues\*" "%INSTALL_DIR%\issues\" >nul 2>&1
echo  Copying artwork...
xcopy /E /Y /Q "%SRC%\art\*" "%INSTALL_DIR%\art\" >nul 2>&1

:: Create launcher in install dir
echo @echo off > "%INSTALL_DIR%\LRN Man.bat"
echo start "" "%INSTALL_DIR%\issues\index.html" >> "%INSTALL_DIR%\LRN Man.bat"

:: Create VBScript launcher (no terminal window)
(
echo Set WshShell = CreateObject("WScript.Shell"^)
echo WshShell.Run """" ^& WScript.Arguments(0^) ^& """"
echo Set WshShell = Nothing
) > "%INSTALL_DIR%\launch-silent.vbs"

:: Create Desktop shortcut via PowerShell
echo  Creating Desktop shortcut...
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "$ws = New-Object -ComObject WScript.Shell; ^
     $s = $ws.CreateShortcut('%USERPROFILE%\Desktop\LRN Man - Defender of the Network.lnk'); ^
     $s.TargetPath = '%INSTALL_DIR%\issues\index.html'; ^
     $s.IconLocation = '%INSTALL_DIR%\art\lrn-man.ico'; ^
     $s.Description = 'LRN Man: Defender of the Network - Comic Series by Mike Anderson'; ^
     $s.WorkingDirectory = '%INSTALL_DIR%\issues'; ^
     $s.Save()" >nul 2>&1

:: Create Start Menu shortcut
set "STARTMENU=%APPDATA%\Microsoft\Windows\Start Menu\Programs"
if not exist "%STARTMENU%\LRN Man" mkdir "%STARTMENU%\LRN Man"

powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "$ws = New-Object -ComObject WScript.Shell; ^
     $s = $ws.CreateShortcut('%STARTMENU%\LRN Man\LRN Man - Defender of the Network.lnk'); ^
     $s.TargetPath = '%INSTALL_DIR%\issues\index.html'; ^
     $s.IconLocation = '%INSTALL_DIR%\art\lrn-man.ico'; ^
     $s.Description = 'LRN Man: Defender of the Network'; ^
     $s.WorkingDirectory = '%INSTALL_DIR%\issues'; ^
     $s.Save()" >nul 2>&1

powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "$ws = New-Object -ComObject WScript.Shell; ^
     $s = $ws.CreateShortcut('%STARTMENU%\LRN Man\Uninstall LRN Man.lnk'); ^
     $s.TargetPath = '%INSTALL_DIR%\Windows\Uninstall-LRN-Man.bat'; ^
     $s.Description = 'Uninstall LRN Man'; ^
     $s.Save()" >nul 2>&1

:: Create uninstaller
(
echo @echo off
echo title LRN Man Uninstaller
echo echo.
echo echo  Uninstalling LRN Man: Defender of the Network...
echo echo.
echo set /p CONFIRM="  Are you sure? This will delete all files. [Y/N]: "
echo if /i "%%CONFIRM%%"=="Y" (
echo     del "%USERPROFILE%\Desktop\LRN Man - Defender of the Network.lnk" 2^>nul
echo     rmdir /S /Q "%STARTMENU%\LRN Man" 2^>nul
echo     rmdir /S /Q "%INSTALL_DIR%" 2^>nul
echo     echo   Uninstall complete.
echo ^) else (
echo     echo   Uninstall cancelled.
echo ^)
echo pause
) > "%INSTALL_DIR%\Windows\Uninstall-LRN-Man.bat"

echo.
echo  =====================================================
echo   Installation Complete!
echo  =====================================================
echo.
echo   Location : %INSTALL_DIR%
echo   Desktop  : LRN Man - Defender of the Network
echo   Start    : Start Menu ^> LRN Man
echo.
echo  Opening LRN Man now...
echo.

start "" "%INSTALL_DIR%\issues\index.html"

echo  Press any key to close this window.
pause >nul
endlocal

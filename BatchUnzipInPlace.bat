@echo off
setlocal enabledelayedexpansion

REM Check if a directory argument is provided
if "%~1"=="" (
    set "targetdir=%cd%"
) else (
    set "targetdir=%~1"
)

REM Loop through all zip files in the specified directory and its subdirectories
for /r "%targetdir%" %%f in (*.zip) do (
    REM Get the full path of the zip file
    set "zipfile=%%f"

    REM Get the directory of the zip file
    set "zipdir=%%~dpf"

    REM Get the name of the zip file without the extension
    set "zipname=%%~nf"

    REM Create a directory with the same name as the zip file
    mkdir "!zipdir!!zipname!" 2>nul
    if !errorlevel! neq 0 (
        echo Failed to create directory for !zipname!.zip
        continue
    )

    REM Unzip the file into the new directory using PowerShell
    powershell -Command "Expand-Archive -Path '!zipfile!' -DestinationPath '!zipdir!!zipname!' -Force"
    if !errorlevel! neq 0 (
        echo Failed to unzip !zipname!.zip
        continue
    )

    REM Delete the zip file
    del "!zipfile!"
    if !errorlevel! neq 0 (
        echo Failed to delete !zipname!.zip
        continue
    )

    echo Successfully processed !zipname!.zip
)

echo All zip files have been processed.
pause
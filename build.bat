@echo off
REM Build script for TicketCore on Windows

setlocal enabledelayedexpansion

echo === TicketCore Build Script (Windows) ===
echo.

REM Check if cmake is installed
where cmake >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: CMake is not installed.
    echo Download from: https://cmake.org/download/
    exit /b 1
)

REM Check if a C++ compiler is available
where cl.exe >nul 2>nul
set hasVS=!ERRORLEVEL!

where g++.exe >nul 2>nul
set hasGCC=!ERRORLEVEL!

if !hasVS! NEQ 0 if !hasGCC! NEQ 0 (
    echo ERROR: No C++ compiler found.
    echo Install Visual Studio 2019+ or MinGW-w64
    exit /b 1
)

echo Creating build directory...
if exist build rmdir /s /q build
mkdir build
cd build

echo Running CMake...
cmake ..

echo Building project...
cmake --build . --config Release

echo.
echo === Build Complete ===
echo To run the application, execute:
echo   Release\ticketcore.exe
echo.

cd ..

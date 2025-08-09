@echo off
:: Check if Java is installed
java -version >nul 2>&1
IF %ERRORLEVEL% EQU 0 (
    echo Java is already installed on this system.
    java -version
    goto END
)

:: Ask user which Java version to install
set /p JAVAVER=Which Java version do you want to install? (e.g. 8, 11, 17):

:: Set download link based on user input (OpenJDK from Adoptium)
IF "%JAVAVER%"=="8" (
    set JAVADL=https://github.com/adoptium/temurin8-binaries/releases/download/jdk8u432-b06/OpenJDK8U-jdk_x64_windows_hotspot_8u432b06.msi
) ELSE IF "%JAVAVER%"=="11" (
    set JAVADL=https://github.com/adoptium/temurin11-binaries/releases/download/jdk-11.0.28%2B6/OpenJDK11U-jre_x64_windows_hotspot_11.0.28_6.msi
) ELSE IF "%JAVAVER%"=="17" (
    set JAVADL=https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.13%2B11/OpenJDK17U-jdk_x64_windows_hotspot_17.0.13_11.msi
) ELSE (
    echo Unsupported version, aborting.
    goto END
)

:: Download installer using PowerShell
echo Downloading OpenJDK %JAVAVER% installer...
powershell -Command "Invoke-WebRequest '%JAVADL%' -OutFile 'java-installer.msi'"

:: Install Java silently
echo Installing OpenJDK %JAVAVER%...
msiexec /i "java-installer.msi" /qn

:: Cleanup installer file
del "java-installer.msi"

:: Confirm installation
echo Checking Java installation...
java -version

:END
pause

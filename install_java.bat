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

:: Set download link based on user input
IF "%JAVAVER%"=="8" (
    set JAVADL=https://github.com/adoptium/temurin8-binaries/releases/latest/download/OpenJDK8U-jre_x64_windows_hotspot_latest.msi
) ELSE IF "%JAVAVER%"=="11" (
    set JAVADL=https://github.com/adoptium/temurin11-binaries/releases/latest/download/OpenJDK11U-jre_x64_windows_hotspot_latest.msi
) ELSE IF "%JAVAVER%"=="17" (
    set JAVADL=https://github.com/adoptium/temurin17-binaries/releases/latest/download/OpenJDK17U-jre_x64_windows_hotspot_latest.msi
) ELSE (
    echo Unsupported version, aborting.
    goto END
)

:: Download installer (using bitsadmin, available on most Windows)
echo Downloading Java %JAVAVER% installer...
bitsadmin /transfer "JAVAINSTALL" %JAVADL% "%cd%\java-installer.msi"

:: Install Java
echo Installing Java...
msiexec /i "%cd%\java-installer.msi" /qn

:: Cleanup
del "%cd%\java-installer.msi"

:: Confirm Installation
echo Checking Java installation...
java -version

:END
pause

@ echo off


REM Script: RestoreUserProfile.bat


echo off setlocal

set "source=\ networkshare\%USERNAME%\Capture.txt"
set "destination=C:\Users\%USERNAME%\Capture.txt"

if exist "%source%" (
    echo Copying %source% to %destination%...
    copy "%source%" "%destination%"
    if %errorlevel% neq 0 (
        echo Failed to copy %source% to %destination%.

    ) else (
        echo File copied successfully.
    )
) else (
    echo %source% does not exist.
    exit /b
)


set "userProfile=%USERPROFILE%"

if exist "%userProfile%\Restored.txt" (
    echo Restored.txt already exists in %userProfile%.
    exit /b
)





rem Define an array of process names
set processesToStop=OUTLOOK Teams msedge Chrome OneDrive

rem Loop through each process and stop it
for %%p in (%processesToStop%) do (
    taskkill /f /im %%p.exe >nul 2>&1
)

echo Processes stopped.


Set the backup location (change this to your actual backup
folder)
set "backupLocation=Netwrok\share"

:: Get the currently logged-in user’s profile path 
set "username=%username%"
set "userProfilePath=C:\Users\%username%"
Set "logfile=%userProfilePath%\RoboCopyLog.txt"

:: Check if the backup directory exists
if exist "%backupLocation%\%username%" (
         echo Restoring user profile from %backupLocation%\%username% to %userProfilePath%... 
         robocopy "%backupLocation%\%username%" "%userProfilePath%" /E /COPY:DAT /R:0 /W:0 /MT:8 /log:"%logfile%"  /NC /BYTES /tee
         echo Restore completed successfully.
) else (
    echo Backup directory not found: %backupLocation%\%username%
)


rem Restore mapped network drives using the configuration from Net folders file 
set configFilePath="Networkshare\%username%"

if exist %configFilePath% (
    for /f "tokens=*" %%i in (%configFilePath%) do (
        net use %%i
    )
    echo Mapped drives restored successfully.
) else (
    echo Configuration file not found: %configFilePath%
)

echo off
set "userProfile=%USERPROFILE%"

echo This is a file for restoration. > "%userProfile%\Restored.txt"
echo Restored.txt has been created in %userProfile%.

endlocal


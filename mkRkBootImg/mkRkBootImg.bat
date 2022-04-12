@ECHO OFF

:: Get Label
SET ramdiskPath="%1"
SET imageSize=%2

IF NOT EXIST %ramdiskPath% (
	ECHO. && ECHO Please enter the directory of the RAMDISK
	GOTO :EOF
)

IF %imageSize%=="" (
	ECHO. && ECHO Please enter the size of the IMAGE in bytes
	GOTO :EOF
)

:: Start Repack

ECHO.

ECHO Compressing RAMDISK...
mkbootfs.exe %ramdiskPath% | minigzip.exe > .\ramdisk.gz 1>nul 2>nul
ECHO Resizeing RAMDISK...
truncate.exe -s %imageSize% .\ramdisk.gz 1>nul 2>nul
ECHO Making KERNEL...
mkkrnlimg.exe .\ramdisk.gz .\repack_new.img 1>nul 2>nul

:: Clean Up

ECHO Cleaning Up...
DEL .\ramdisk.gz 1>nul 2>nul
ECHO. && ECHO The output file is at %CD%\repack_new.img

@ECHO ON
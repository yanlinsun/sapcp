@ECHO OFF
SET /A TEST=0
IF "%OS%"=="Windows_NT" SETLOCAL
SET /A ERR=0
SET SCP_KEY=~\.ssh\id_rsa
SET SCP_HOST=%SAPCP_HOST%
SET SCP_DESTINATION=/root/sap_download
SET SCP_USER=root
SET SOURCE=
SET /A SCP_DL=0

IF NOT "%SAPCP_DESTINATION%"=="" SET SCP_DESTINATION=%SAPCP_DESTINATION%
IF NOT "%SAPCP_USER%"=="" SET SCP_USER=%SAPCP_USER%

IF "%1"=="" GOTO VALIDATE ELSE GOTO PARAMETER

:PARAMETER
SET CUR=%~1
IF "%CUR%"=="" GOTO VALIDATE
ECHO.%CUR% | FINDSTR /R /C:"^-" >NUL
IF NOT ERRORLEVEL 1 (
    SET PARAM=%CUR%
    IF %TEST% EQU 1 ECHO FOUND OPTION [%CUR%]
) ELSE (
    SET VALID_PARAM=0
    IF /I "%PARAM%"=="" (
        IF "%SOURCE%"=="" (
            SET SOURCE="%CUR%"
        ) ELSE (
            SET SOURCE=%SOURCE% "%CUR%"
        )
        SET VALID_PARAM=1
        IF %TEST% EQU 1 ECHO SET SOURCE=%CUR%
    )
    IF /I "%PARAM%"=="-H" (
        SET SCP_HOST=%CUR%
        SET VALID_PARAM=1
        IF %TEST% EQU 1 ECHO SET SCP_HOST=%CUR%
    )
    IF /I "%PARAM%"=="-D" (
        SET SCP_DESTINATION=%CUR%
        SET VALID_PARAM=1
        IF %TEST% EQU 1 ECHO SET SCP_DESTINATION=%CUR%
    )
    IF /I "%PARAM%"=="-K" (
        SET SCP_KEY=%CUR%
        SET VALID_PARAM=1
        IF %TEST% EQU 1 ECHO SET SCP_KEY=%CUR%
    )
    IF /I "%PARAM%"=="-U" (
        SET SCP_USER=%CUR%
        SET VALID_PARAM=1
        IF %TEST% EQU 1 ECHO SET SCP_USER=%CUR%
    )
    IF /I "%PARAM%"=="-DL" (
        SET /A SCP_DL=1
        SET SOURCE=%CUR%
        SET VALID_PARAM=1
        IF %TEST% EQU 1 ECHO SET SCP_DL=1
        IF %TEST% EQU 1 ECHO SET SCP_USER=%CUR%
    )
    IF "%VALID_PARAM%"=="0" (
        ECHO ERROR: Invalid option %PARAM% %CUR%
        SET /A ERR+=1
    ) ELSE (
        SET PARAM=
    )
)
SHIFT
GOTO PARAMETER

:VALIDATE
SET SCP_PARAM=
IF NOT "%SCP_KEY%"=="" SET SCP_PARAM=-i %SCP_KEY%
IF "%SCP_HOST%"=="" (
        ECHO ERROR: Neither -h ^<host^> nor environment variable SAPCP_HOST defined
        SET /A ERR+=1
)
IF "%SCP_DESTINATION%"=="" (
        ECHO ERROR: No destination specified. Please use -d option or set environment variable SAPCP_DESTINATION.
        SET /A ERR+=1
)
IF "%SCP_USER%"=="" (
        ECHO ERROR: No user specified. Please use -u option or set environment variable SAPCP_USER.
        SET /A ERR+=1
)
IF "%SOURCE%"=="" (
        ECHO No file specified. Nothing to do.
        SET /A ERR+=1
)
IF %TEST% EQU 1 (
        ECHO.
        ECHO === Execute using following parameters ===
        ECHO SCP_HOST=%SCP_HOST%
        ECHO SCP_USER=%SCP_USER%
        ECHO SCP_DESTINATION=%SCP_DESTINATION%
        ECHO SCP_KEY=%SCP_KEY%
        ECHO FILES=%SOURCE%
        ECHO ERR=%ERR%
        ECHO SCP_DL=%SCP_DL%
        IF %SCP_DL% EQU 1 (
        ECHO SCP -r %SCP_USER%@%SCP_HOST%:%SCP_DESTINATION%/%SOURCE% .
        ) ELSE (
        ECHO SCP -r %SCP_PARAM% %SOURCE% %SCP_USER%@%SCP_HOST%:%SCP_DESTINATION%
        )
        GOTO END
)

IF %ERR% GTR 0 (
        ECHO.
        GOTO USAGE
) ELSE (
        GOTO EXEC
)

:EXEC
IF %SCP_DL% EQU 1 (
SCP -r %SCP_USER%@%SCP_HOST%:%SCP_DESTINATION%/%SOURCE% .
) ELSE (
SCP -r %SCP_PARAM% %SOURCE% %SCP_USER%@%SCP_HOST%:%SCP_DESTINATION%
)
GOTO END

:USAGE
@ECHO Examples:
@ECHO     To upload one file from current directory:
@ECHO         sapcp file_to_be_upload.zip
@ECHO     To upload all files from a directory:
@ECHO         sapcp C:\download\*
@ECHO     To download a file from remote server to current directory:
@ECHO         sapcp -dl file_to_be_download.zip
@ECHO. 
@ECHO Usage: sapcp [-h ^<host^>] [-u ^<user^>] [-d ^<destination^>] [-k ^<ssh_key_file^>] [-dl] ^<files...^> 
@ECHO     -h Destination host name or ip address. 
@ECHO.
@ECHO     -u Logon user to host. Default value: root
@ECHO. 
@ECHO     -d Destination directory. Default value: /root/sap_download
@ECHO. 
@ECHO     -k Key file for scp connection. Default location is '~\.ssh\id_rsa'.
@ECHO.
@ECHO     -dl Download file from remote server.
@ECHO.
@ECHO     ^<file^> Filename to be uploaded or downloaded. You can use wild char to match multiple files. e.g. *.zip, k*.sar
@ECHO.
@ECHO     Use of environment variables:
@ECHO     You can specify several environment variables to ignore some of the options.
@ECHO         SAPCP_HOST =^> ^<host^>
@ECHO         SAPCP_USER =^> ^<user^>
@ECHO         SAPCP_DESTINATION =^> ^<destination^>
@ECHO     You can always override the environment variable value by specifying the related options. e.g. if SAPCP_DESTINATION exists, but you use 
@ECHO         sapcp -d /some_other_dir
@ECHO     The file will be upload to 'some_other_dir' instead of the directory defined in SAPCP_DESTINATION.
@ECHO.
GOTO END

:END
IF "%OS%"=="Windows_NT" ENDLOCAL

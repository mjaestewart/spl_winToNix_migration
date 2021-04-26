@echo off

REM This script copies Splunk Buckets from Windows to Linux
 
REM ==== Vars ==========
SET /A MaxVal=999
SET /A MinVal=600
SET /A Count=0
SET SplunkPath=C:\Program Files\splunk\var\lib\splunk
SET nixServer=splunk@adv-rhel-spl-idx1.advanced.lab:/tmp/
SET splunkData="/cygdrive/c/Program Files/splunk/var/lib/splunk"


REM Set the subroutine below for :Copy OR :CopyRandom
GOTO :SET_SUBROUTINE_HERE

:Copy

REM ====================
REM This subroutine uses an rsync copy only
REM ==================== 

.\rsync.exe -avzh -P -e "./ssh.exe" --stats --timeout=8400 %splunkData% %nixServer%

Goto :END

:CopyRandom

REM ====================
REM This subroutine uses logic to randomize bucket ID's between two Global variables
REM that are set in MaxVal and MinVal. 
REM ==================== 

FOR /F "tokens=*" %%a IN ('dir /A:D /B /S "%SplunkPath%" ^| find "b_" ^| find /v "rawdata"') Do SET pathName=%%a&CALL :ParseDir 2>NUL
.\rsync.exe -avzh -P -e "./ssh.exe" --stats --timeout=8400 %splunkData% %nixServer%

Echo Done!
Echo proccessed %Count% Dirs.
Goto :END
 
REM PARSER FUNCTION
:ParseDir
SET /A Count+=1
Echo ***debug Count=[%Count%] DirName=[%pathName%]
FOR /F "tokens=7-9 delims=\" %%a IN ("%pathName%") Do SET SF1=%%a&SET SF2=%%b&SET dirName=%%c
FOR /F "tokens=1-4* delims=_" %%a IN ("%dirName%") Do SET D1=%%a&SET D2=%%b&SET D3=%%c&SET D4=%%d&SET D5=%%e
Echo ***debug DirName Tokens=[%D1%]_[%D2%]_[%D3%]_[%D4%]_[%D5%]
 
REM ----- Check ID -----
SET /A ID=%D4%
IF %ID% GTR 80 (ECHO ***debug ID=[%ID%] which is GTR 80, skipping&GOTO :END)
 
SET /A RN=%RANDOM% * (%MaxVal% - %MinVal% + 1) / 32768 + %MinVal%
Echo ***debug RN=[%RN%]
SET NewDir=%D1%_%D2%_%D3%_%RN%_%D5%
Echo ***debug NewDir=[%NewDir%]
 
REM --- Rename command---
ECHO ***debug REN "%SplunkPath%\%SF1%\%SF2%\%dirName%" "%NewDir%"
ECHO ***debug .\scp.exe "%SplunkPath%\%SF1%" splunk@adv-rhel-spl-idx1.advanced.lab:/tmp/
REN "%SplunkPath%\%SF1%\%SF2%\%dirName%" "%NewDir%"

:END
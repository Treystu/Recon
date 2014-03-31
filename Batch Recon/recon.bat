@ECHO OFF
cls
SETLOCAL
:BEGINNING
ECHO *****************
ECHO ***** Recon *****
ECHO *****************
::Below, skips Address input, if an address was imported from Arcsight. 
IF [%1]==[$SelectedCell] goto ADDRESSCHOICE
IF not [%1]==[] set ADDRESS=%1
IF not [%1]==[] goto MENU
:ADDRESSCHOICE
ECHO.
ECHO For Hostnames, please ensure that they are fully qualified 
ECHO (i.e. wsoca01.homeoffice)
ECHO.
IF [%1]==[$SelectedCell] goto SKIPIMPORT
IF not [%1]==[] ECHO To use the address from ArcSight (%1) please type 'import'
:SKIPIMPORT
ECHO.
set /p ADDRESS=Please type the address that you would like to use:
IF '%ADDRESS%'=='import' set ADDRESS=%1
::Above, if user selects 'import' then it sets the variable "ADDRESS" to the imported address.
:MENU
set CHOICE=[]
echo _______________________________________________ 
echo 1.  Ping
echo 2.  Name Server Lookup
echo 3.  Traceroute
echo 4.  Pingpath
echo 5.  *Systeminfo*
echo 6.  *Tasklist*
echo 7.  *PsLoggedon*
echo 8.  *Psexec*
echo 9.  *1,2,3,5,6,7 and 8 exported to Text File*
echo 10. Change Address
echo 11. Elevate to Admin
echo 12. Exit
echo     * denotes the need for Admin escalation.
Echo _______________________________________________ 
set /p CHOICE=Please select the command that you would like to perform:
if '%CHOICE%'=='1' goto PING
if '%CHOICE%'=='2' goto NSLOOKUP
if '%CHOICE%'=='3' goto TRACERT
if '%CHOICE%'=='4' goto PINGPATH
if '%CHOICE%'=='5' goto SYSTEMINFO
if '%CHOICE%'=='6' goto TASKLIST
if '%CHOICE%'=='7' goto PSLOGGEDON
if '%CHOICE%'=='8' goto PSEXEC
if '%CHOICE%'=='9' goto TOTAL
if '%CHOICE%'=='10' goto ADDRESSCHOICE
if '%CHOICE%'=='11' goto ELEVATE
if '%CHOICE%'=='12' goto EXIT
if [%CHOICE%]==[] goto MENU
::Below, all commands are listed with a pause, then a loop back to the menu.
ECHO.
goto MENU
:PING
echo.
set /p COUNT=Enter the number of packets to be sent:
ping -a -n %COUNT% %ADDRESS%
echo Press any key to return to the Main Menu.
pause >nul
goto MENU
:NSLOOKUP
echo.
nslookup %ADDRESS%
echo Press any key to return to the main menu.
pause >nul
goto MENU
:TRACERT
echo.
tracert %ADDRESS%
echo Press any key to return to the main menu.
pause >nul
goto MENU
:PINGPATH
echo.
pathping -p 1 %ADDRESS%
echo Press any key to return to the main menu.
pause >nul
goto MENU
:SYSTEMINFO
echo.
set /p USERNAME= Please enter your username (i.e. jsmith):
systeminfo /S %ADDRESS% /U ad-%USERNAME%
echo Press any key to return to the main menu.
pause >nul
goto MENU
:TASKLIST
echo.
tasklist /S %ADDRESS%
echo Press any key to return to the main menu.
pause  >nul
goto MENU
:PSLOGGEDON
echo.
psloggedon \\%ADDRESS%
echo Press any key to return to the main menu.
pause  >nul
goto MENU
:PSEXEC
set PSARG=NULL
Echo.
Echo If you need more information, please type "more"
set /P PSARG=Please enter the command that you wish to execute:
IF "%PSARG%"=="more" goto MORE
IF "%PSARG%"=="NULL" goto PSEXEC
goto EXE
:MORE
psexec /?
goto PSEXEC
:EXE
psexec \\%ADDRESS% %PSARG% 2>NUL
echo Press any key to return to the main menu.
pause >nul
goto MENU
:TOTAL
set PSARG=NULL
set /p USERNAME= Please enter your username (i.e. jsmith):
set /P PSARG=Please enter the command that you wish to execute with PsExec. (if none, leave blank):
ECHO This should take a short while.
ECHO. > results.txt
ECHO This is the results page for the analysis performed on %ADDRESS%. >> results.txt
ECHO. >>results.txt
ECHO PING: >>results.txt
ping -a -n 4 %ADDRESS% >>results.txt 
ECHO. >>results.txt
ECHO NSLookup: >>results.txt
ECHO. >>results.txt
nslookup %ADDRESS% 2>NUL >>results.txt 
ECHO. >>results.txt
ECHO Trace Route: >>results.txt
tracert %ADDRESS% 2>NUL >>results.txt 
ECHO. >>results.txt
ECHO. SystemInfo: >>results.txt
systeminfo /S %ADDRESS% /U ad-%USERNAME% 2>NUL >>results.txt 
ECHO. >>results.txt
ECHO. TaskList: >>results.txt
tasklist /S %ADDRESS% 2>NUL >>results.txt 
ECHO. >>results.txt
ECHO. PsLoggedon: >>results.txt
psloggedon \\%ADDRESS% 2>NUL >>results.txt 
if "%PSARG%"=="NULL" goto SKIP
ECHO. >>results.txt
ECHO. PsExec %PSARG%: >>results.txt
psexec \\%ADDRESS% %PSARG% 2>NUL >>results.txt
goto PASTSKIP
:SKIP
Echo PsExec has been skipped, as no command was entered. >>results.txt
:PASTSKIP
ECHO Press any key to open the results.
pause >nul
start results.txt
goto MENU
:ELEVATE
echo.
echo Please insert your smart card now, then press any key to continue.
pause >nul
runas /smartcard "C:\arcsight\scripts\recon.bat %1=$SelectedCell"
:exit
exit
@ECHO off
setlocal
runas /smartcard "powershell C:\arcsight\scripts\Recon\Recontesting.ps1 "%1""
exit
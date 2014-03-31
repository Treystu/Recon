@ECHO off
setlocal
runas /smartcard "powershell C:\arcsight\scripts\Recon\Recon.ps1 "%1""
exit
@ECHO off
setlocal
runas /smartcard "powershell C:\arcsight\scripts\Recon\Smartcon.ps1 "%1""
exit
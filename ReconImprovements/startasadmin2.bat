@ECHO off
setlocal
runas /smartcard "powershell C:\arcsight\scripts\Recon\ReconImprovements\Recon.ps1 "%1""
exit
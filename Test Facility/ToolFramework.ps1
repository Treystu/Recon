<#
Variables:
$Compname - Computer's address


#>

##############Call Scripts Here#############
. C:\arcsight\scripts\Recon\Test-PortWin.ps1

############################################

#Pause Function, for ease of use.
function Pause ($Message="Press any key to continue..."){ 
    "" 
    Write-Host $Message 
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") 
} 
 
#If $compname is null, send it here! 
function GetCompName{ 
    $compname = Read-Host "Please enter a computer name or IP" 
    CheckHost 
} 

#Checking that host is online
function CheckHost{ 
    $ping = gwmi Win32_PingStatus -filter "Address='$compname'" 
    if($ping.StatusCode -eq 0){$pcip=$ping.ProtocolAddress; NullCheck} 
    else{Pause "Host $compname down...Press any key to continue"; GetCompName} 
} 








#---------Start Main-------------- 
$compname = $args[0] 
if($compname){CheckHost} 
else{GetCompName}
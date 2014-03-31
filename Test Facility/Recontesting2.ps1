# Clearing/Setting Variables #
$Computer = $pcip
$Port = "135"
##############################

function Porttest {
param ( [string]$Computer, [int]$Port )   
#  Initialize object 
$Test = new-object Net.Sockets.TcpClient   
#  Attempt connection, 500 millisecond timeout, returns boolean 
$result = ( $Test.BeginConnect( $Computer, $Port, $Null, $Null ) ).AsyncWaitHandle.WaitOne( 500 )  
#return $result 
Portresult
}

function Portresult {
If ($result -eq "True"){
#Echo "Port $Port open on $Compname ($Computer)"
GetMenu
}
Else {
Echo "Port $Port closed on $compname ($Computer)"
GetBadMenu
}
}

# Create Pause Function
function Pause ($Message="Press any key to continue..."){ 
    "" 
    Write-Host $Message 
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") 
} 

# Get Computername
function GetCompName{ 
    $compname = Read-Host "Please enter a computer name or IP" 
    CheckHost 
} 
# Ensure computer is online
function CheckHost{
    $ping = gwmi Win32_PingStatus -filter "Address='$compname'" 
    if($ping.StatusCode -eq 0){$pcip=$ping.ProtocolAddress; Porttest "$pcip" 135} 
    else{Pause "Host $compname down...Press any key to continue"; GetCompName} 
} 



function GetBadMenu {
	Clear-Host
	"  /----------------------\" 
    " |         Recon          |" 
    "  \----------------------/" 
    "  $compname ($pcip) "
	""
    "	!! This Host does not appear to be a Windows device !!"
    "	Proceed at your own risk..."
	""
	"1)Exit"
	"2)Live Dangerously, and continue..."
	"3)Enter a new address "
    ""
	$MenuSelection = Read-Host "Enter Selection"
    GetInfoBad
	}
	
function GetInfoBad{ 
    Clear-Host 
    switch ($MenuSelection){ 
           
        1 {Exit
          }
        2 {GetMenu
          }
		3 {GetCompName
		  }
        default{CheckHost} 
    }
}

function GetMenu {
write-host " This has been a success. "
}






#---------Start Main-------------- 
$compname = $args[0] 
if($compname){CheckHost} 
else{GetCompName}


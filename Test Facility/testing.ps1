function Test-PortWin{   
param ( [string]$Computer, [int]$Port )   
#  Initialize object 
$Test = new-object Net.Sockets.TcpClient   
#  Attempt connection, 200 millisecond timeout, returns boolean 
( $Test.BeginConnect( $Computer, $Port, $Null, $Null ) ).AsyncWaitHandle.WaitOne( 200 )   
# Cleanup 
$Test.Close()
echo $Test
}
<#If ($true){
GetMenu
}
} 
#Specify Windows Port Here
$Port = 135
$compname = "127.0.0.1"
#########################

Test-PortWin

function GetMenu {
write-host "success!"
}#>

Test-PortWin "127.0.0.1 135"

function Test-PortWin{   
param ( [string]$Computer, [int]$Port )   
#  Initialize object 
$Test = new-object Net.Sockets.TcpClient
pause   
#  Attempt connection, 300 millisecond timeout, returns boolean 
( $Test.BeginConnect( $Computer, $Port, $Null, $Null ) ).AsyncWaitHandle.WaitOne( 99 )
pause   
# Cleanup 
$Test.Close()
pause
#If ($true){
#numeral
#}
} 

$Port = 135,445,3389
$Computer = "hostname"

$i = 1

function numeral{
do {Write-Host $i; $i++}
until ($iz -gt 5)
}


Test-PortWin





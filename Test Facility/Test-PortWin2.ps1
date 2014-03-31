function Test-PortWin{   
param ( [string]$Computer, [int]$Port )   
#  Initialize object 
$Test = new-object Net.Sockets.TcpClient   
#  Attempt connection, 500 millisecond timeout, returns boolean 
$result = ( $Test.BeginConnect( $Computer, $Port, $Null, $Null ) ).AsyncWaitHandle.WaitOne( 500 )   
# Cleanup 
$Test.Close()

return $result
}

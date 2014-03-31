
param ( [string]$Computer, [int]$Port )   

#Error-Checking for Null $Computer


#  Initialize object 
$Test = new-object Net.Sockets.TcpClient   

#  Attempt connection, 500 millisecond timeout, returns boolean 
$result = ( $Test.BeginConnect( $Computer, $Port, $Null, $Null ) ).AsyncWaitHandle.WaitOne( 500 )   

#------------------------



#------------------------
# Cleanup 
$Test.Close()


#Pass Variable
return $result



#ForTesting#
#Test-PortWin "" 135
#write-host "$result"
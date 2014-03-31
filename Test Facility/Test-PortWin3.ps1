


$t = New-Object Net.Sockets.TcpClient "172.29.104.14", 135 | out-null

function test {
if($t.Connected | out-null)
{
    "Port 443 is operational"
}
else
{

    "Closed..."
}
}

test | out-null


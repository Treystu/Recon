function pscan{
nmap.exe "-p $port $flags $addr"
}

$port="1-5000"
$addr="WGCDC01"
$flags="-Pn"

pscan
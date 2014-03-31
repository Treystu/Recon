#
. C:\arcsight\scripts\Recon\Test-PortWin.ps1
#
function Testing {
$tryit = ( Test-PortWin $Computer 135 )
write-host "$tryit"
}

Testing

$Computer="172.29.204.16"
#Changelog:
#1/12/2014 - Changed "Press any key to continue" to "Press Enter to continue"
#
#

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
function Pause ($Message="Press Enter to continue..."){ 
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
    else{Pause "Host $compname down...Press Enter to continue"; GetCompName} 
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

#End Error-Checking Logic#
##########################


function GetMenu {
	Clear-Host
	"  /----------------------\" 
    " |         Recon          |" 
    "  \----------------------/" 
    "  $compname ($pcip)" 
	"1)Software Recon"
	"2)Hardware Recon"
    "3)Experimental"
	$MenuSelection = Read-Host "Enter Selection"
    GetInfo
	}
	
function GetInfo{ 
    Clear-Host 
    switch ($MenuSelection){ 
           
        1 {GetMenusoftware
          }
        2 {GetMenuhardware
          }
        3 {Experimental
          }
        default{CheckHost} 
    }
}
#Start Software Menu	
function GetMenusoftware {
	Clear-Host
	"  /----------------------\" 
    " |         Recon          |" 
    "  \----------------------/" 
    "  $compname ($pcip)" 
	"Software Menu"
	""
	"1) Current User" 
	"2) OS Info"
	"3) System Info" 
    "4) Currently Unused"
    "5) Process List" 
    "6) Service List" 
	"" 
    "C) Change Computer Name" 
    "X) Exit The program"
    "M) Main Menu"
    "" 
	$MenuSelectionsoftware = Read-Host "Enter Selection"
	GetInfosoftware
	}
	
function GetInfosoftware{ 
    Clear-Host 
    switch ($MenuSelectionsoftware){ 
           
        1 { #Current User 
            gwmi -computer $compname Win32_ComputerSystem | Format-Table @{Expression={$_.Username};Label="Current User"} 
            Pause 
            GetMenusoftware           
          } 
           
        2 { #OS Info 
            gwmi -computer $compname Win32_OperatingSystem | Format-List @{Expression={$_.Caption};Label="OS Name"},SerialNumber,OSArchitecture 
            Pause 
            GetMenusoftware        
          } 
           
        3 { #System Info 
            gwmi -computer $compname Win32_ComputerSystem | Format-List Name,Domain,Manufacturer,Model,SystemType 
            Pause 
            GetMenusoftware          
          }         
           
        4 { #OPEN
			write-host "Have an idea for a command? Open the code, and add it to the Experimental Section"
			Pause 
            GetMenusoftware 
          } 
           
        5 { #Process Listx 
         
            gwmi -computer $compname Win32_Process | Select-Object Caption,Handle | Sort-Object Caption | Format-Table 
            Pause 
            GetMenusoftware          
          } 
           
        6 { #Service List 
            gwmi -computer $compname Win32_Service | Select-Object Name,State,Status,StartMode,ProcessID, ExitCode | Sort-Object Name | Format-Table 
            Pause 
            GetMenusoftware         
          } 
         
        c {Clear-Host;$compname="";GetCompName} 
        x {Clear-Host; exit}
        m {CheckHost} 
        default{GetMenusoftware} 
      } 
} 
 #Start Hardware Meun
function GetMenuhardware { 
    Clear-Host 
    "  /----------------------\" 
    " |         Recon          |" 
    "  \----------------------/" 
    "  $compname ($pcip)" 
    "Hardware Menu" 
    "" 
    "1) PC Serial Number" 
    "2) PC Printer Info" 
    "3) USB Devices" 
    "4) Uptime" 
    "5) Disk Space" 
    "6) Memory Info" 
    "7) Processor Info" 
    "8) Monitor Serial Numbers" 
    "" 
    "C) Change Computer Name" 
    "X) Exit The program"
    "M) Main Menu" 
    "" 
    $MenuSelectionhardware = Read-Host "Enter Selection" 
    GetInfohardware 
} 
 
 
function GetInfohardware{ 
    Clear-Host 
    switch ($MenuSelectionhardware){ 
        1 { #PC Serial Number 
            gwmi -computer $compname Win32_BIOS | Select-Object SerialNumber | Format-List 
            Pause 
            GetMenuhardware 
          } 
           
        2 { #PC Printer Information 
            gwmi -computer $compname Win32_Printer | Select-Object DeviceID,DriverName, PortName | Format-List 
            Pause 
            GetMenuhardware           
          }  
         
        3 { #USB Devices 
            gwmi -computer $compname Win32_USBControllerDevice | %{[wmi]($_.Dependent)} | Select-Object Caption, Manufacturer, DeviceID | Format-List 
            Pause 
            GetMenuhardware           
          } 
           
        4 { #Uptime 
            $wmi = gwmi -computer $compname Win32_OperatingSystem 
            $localdatetime = $wmi.ConvertToDateTime($wmi.LocalDateTime) 
            $lastbootuptime = $wmi.ConvertToDateTime($wmi.LastBootUpTime) 
             
            "Current Time:      $localdatetime" 
            "Last Boot Up Time: $lastbootuptime" 
             
            $uptime = $localdatetime - $lastbootuptime 
            "" 
            "Uptime: $uptime" 
            Pause 
            GetMenuhardware 
          } 
        5 { #Disk Info 
            $wmi = gwmi -computer $compname Win32_logicaldisk 
            foreach($device in $wmi){ 
                    Write-Host "Drive: " $device.name    
                    Write-Host -NoNewLine "Size: "; "{0:N2}" -f ($device.Size/1Gb) + " Gb" 
                    Write-Host -NoNewLine "FreeSpace: "; "{0:N2}" -f ($device.FreeSpace/1Gb) + " Gb" 
                    "" 
             } 
            Pause 
            GetMenuhardware 
          } 
        6 { #Memory Info 
            $wmi = gwmi -computer $compname Win32_PhysicalMemory 
            foreach($device in $wmi){ 
                Write-Host "Bank Label:     " $device.BankLabel 
                Write-Host "Capacity:       " ($device.Capacity/1MB) "Mb" 
                Write-Host "Data Width:     " $device.DataWidth 
                Write-Host "Device Locator: " $device.DeviceLocator     
                ""         
            } 
            Pause 
            GetMenuhardware 
          } 
        7 { #Processor Info 
            gwmi -computer $compname Win32_Processor | Format-List Caption,Name,Manufacturer,ProcessorId,NumberOfCores,AddressWidth   
            Pause 
            GetMenuhardware 
          } 
        8 { #Monitor Info 
             
            #Turn off Error Messages 
            $ErrorActionPreference_Backup = $ErrorActionPreference 
            $ErrorActionPreference = "SilentlyContinue" 
 
 
            $keytype=[Microsoft.Win32.RegistryHive]::LocalMachine 
            if($reg=[Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey($keytype,$compname)){ 
                #Create Table To Hold Info 
                $montable = New-Object system.Data.DataTable "Monitor Info" 
                #Create Columns for Table 
                $moncol1 = New-Object system.Data.DataColumn Name,([string]) 
                $moncol2 = New-Object system.Data.DataColumn Serial,([string]) 
                $moncol3 = New-Object system.Data.DataColumn Ascii,([string]) 
                #Add Columns to Table 
                $montable.columns.add($moncol1) 
                $montable.columns.add($moncol2) 
                $montable.columns.add($moncol3) 
 
 
 
                $regKey= $reg.OpenSubKey("SYSTEM\\CurrentControlSet\\Enum\DISPLAY" ) 
                $HID = $regkey.GetSubKeyNames() 
                foreach($HID_KEY_NAME in $HID){ 
                    $regKey= $reg.OpenSubKey("SYSTEM\\CurrentControlSet\\Enum\\DISPLAY\\$HID_KEY_NAME" ) 
                    $DID = $regkey.GetSubKeyNames() 
                    foreach($DID_KEY_NAME in $DID){ 
                        $regKey= $reg.OpenSubKey("SYSTEM\\CurrentControlSet\\Enum\\DISPLAY\\$HID_KEY_NAME\\$DID_KEY_NAME\\Device Parameters" ) 
                        $EDID = $regKey.GetValue("EDID") 
                        foreach($int in $EDID){ 
                            $EDID_String = $EDID_String+([char]$int) 
                        } 
                        #Create new row in table 
                        $monrow=$montable.NewRow() 
                         
                        #MonitorName 
                        $checkstring = [char]0x00 + [char]0x00 + [char]0x00 + [char]0xFC + [char]0x00            
                        $matchfound = $EDID_String -match "$checkstring([\w ]+)" 
                        if($matchfound){$monrow.Name = [string]$matches[1]} else {$monrow.Name = '-'} 
 
                         
                        #Serial Number 
                        $checkstring = [char]0x00 + [char]0x00 + [char]0x00 + [char]0xFF + [char]0x00            
                        $matchfound =  $EDID_String -match "$checkstring(\S+)" 
                        if($matchfound){$monrow.Serial = [string]$matches[1]} else {$monrow.Serial = '-'} 
                                                 
                        #AsciiString 
                        $checkstring = [char]0x00 + [char]0x00 + [char]0x00 + [char]0xFE + [char]0x00            
                        $matchfound = $EDID_String -match "$checkstring([\w ]+)" 
                        if($matchfound){$monrow.Ascii = [string]$matches[1]} else {$monrow.Ascii = '-'}          
 
                                 
                        $EDID_String = '' 
                         
                        $montable.Rows.Add($monrow) 
                    } 
                } 
                $montable | select-object  -unique Serial,Name,Ascii | Where-Object {$_.Serial -ne "-"} | Format-Table  
            } else {  
                Write-Host "Access Denied - Check Permissions" 
            } 
            $ErrorActionPreference = $ErrorActionPreference_Backup #Reset Error Messages 
            Pause 
            GetMenuhardware 
          } 
        c {Clear-Host;$compname="";GetCompName} 
        x {Clear-Host; exit}
        m {CheckHost} 
        default{GetMenuhardware} 
      } 
} 
 
########################################################################
# This area is for testing new commands to execute within this script. #
#  Please Utilize a "Reserved" slot, and remember to change both the   #
#       "Menu" and the "Command" sections to reflect your script.      #
#                            Variables:                                #
#                     $compname Ex: hostname                           #
#                      $pcip Ex: 127.0.0.1                             #
#           Please leave the "pause" and "Experimental"                #
#                   lines following your command                       #
########################################################################


#Start Experimental Menu
function Experimental { 
    Clear-Host 
    "  /----------------------\" 
    " |         Recon          |" 
    "  \----------------------/" 
    "  $compname ($pcip)" 
    "Experimental Menu" 
    "" 
    "1) Total Recon" 
    "2) Reserved" 
    "3) Reserved" 
    "4) Reserved" 
    "5) Reserved" 
    "6) Reserved" 
    "7) Reserved" 
    "8) Reserved" 
    "" 
    "C) Change Computer Name" 
    "X) Exit The program"
    "M) Main Menu" 
    "" 
    $MenuSelectionexperimental = Read-Host "Enter Selection" 
    Experimentalinfo
} 



function Experimentalinfo{ 
    Clear-Host 
    switch ($MenuSelectionexperimental){ 
         1 { #Total Recon 
         Echo "Reconnaisance performed on $compname" > C:\Temp\TotalRecon.txt
         Echo "" | Out-File C:\Temp\TotalRecon.txt -append
         Echo "***************Software Information***************" | Out-File C:\Temp\TotalRecon.txt -append
         Echo "Current User" | Out-File C:\Temp\TotalRecon.txt -append
         gwmi -computer $compname Win32_ComputerSystem | Format-Table @{Expression={$_.Username};Label="Current User"} | Out-File C:\Temp\TotalRecon.txt -append
		 Echo "=====================================================================" | Out-File C:\Temp\TotalRecon.txt -append
         Echo "OS Info " | Out-File C:\Temp\TotalRecon.txt -append
         gwmi -computer $compname Win32_OperatingSystem | Format-List @{Expression={$_.Caption};Label="OS Name"},SerialNumber,OSArchitecture | Out-File C:\Temp\TotalRecon.txt -append
		 Echo "=====================================================================" | Out-File C:\Temp\TotalRecon.txt -append
         Echo "System Info" | Out-File C:\Temp\TotalRecon.txt -append
         gwmi -computer $compname Win32_ComputerSystem | Format-List Name,Domain,Manufacturer,Model,SystemType | Out-File C:\Temp\TotalRecon.txt -append
		 Echo "=====================================================================" | Out-File C:\Temp\TotalRecon.txt -append
         Echo "Process List" | Out-File C:\Temp\TotalRecon.txt -append
         gwmi -computer $compname Win32_Process | Select-Object Caption,Handle | Sort-Object Caption | Format-Table | Out-File C:\Temp\TotalRecon.txt -append
		 Echo "=====================================================================" | Out-File C:\Temp\TotalRecon.txt -append
         Echo "Service List" | Out-File C:\Temp\TotalRecon.txt -append
         gwmi -computer $compname Win32_Service | Select-Object Name,State,Status,StartMode,ProcessID, ExitCode | Sort-Object Name | Format-Table | Out-File C:\Temp\TotalRecon.txt -append
		 Echo "=====================================================================" | Out-File C:\Temp\TotalRecon.txt -append
		 Echo "***************Hardware Information***************" | Out-File C:\Temp\TotalRecon.txt -append
         Echo "PC Serial Number" | Out-File C:\Temp\TotalRecon.txt -append
         gwmi -computer $compname Win32_BIOS | Select-Object SerialNumber | Format-List | Out-File C:\Temp\TotalRecon.txt -append
		 Echo "=====================================================================" | Out-File C:\Temp\TotalRecon.txt -append
         Echo "USB Devices" | Out-File C:\Temp\TotalRecon.txt -append
         gwmi -computer $compname Win32_USBControllerDevice | %{[wmi]($_.Dependent)} | Select-Object Caption, Manufacturer, DeviceID | Format-List | Out-File C:\Temp\TotalRecon.txt -append
		 Echo "=====================================================================" | Out-File C:\Temp\TotalRecon.txt -append
         Echo "Uptime" | Out-File C:\Temp\TotalRecon.txt -append
         $wmi = gwmi -computer $compname Win32_OperatingSystem 
            $localdatetime = $wmi.ConvertToDateTime($wmi.LocalDateTime) 
            $lastbootuptime = $wmi.ConvertToDateTime($wmi.LastBootUpTime) 
             
            "Current Time:      $localdatetime"  | Out-File C:\Temp\TotalRecon.txt -append
            "Last Boot Up Time: $lastbootuptime"  | Out-File C:\Temp\TotalRecon.txt -append
             
            $uptime = $localdatetime - $lastbootuptime 
            ""  | Out-File C:\Temp\TotalRecon.txt -append
            Echo "Uptime: $uptime"  | Out-File C:\Temp\TotalRecon.txt -append
		 Echo "=====================================================================" | Out-File C:\Temp\TotalRecon.txt -append	
         Echo "Disk Info" | Out-File C:\Temp\TotalRecon.txt -append
		 gwmi -computer $compname Win32_logicaldisk | Out-File C:\Temp\TotalRecon.txt -append
		 Echo "=====================================================================" | Out-File C:\Temp\TotalRecon.txt -append
         Echo "Memory Info"  | Out-File C:\Temp\TotalRecon.txt -append
         gwmi -computer $compname Win32_PhysicalMemory | Out-File C:\Temp\TotalRecon.txt -append
		 Echo "=====================================================================" | Out-File C:\Temp\TotalRecon.txt -append
         Echo "Processor Info" | Out-File C:\Temp\TotalRecon.txt -append
         gwmi -computer $compname Win32_Processor | Format-List Caption,Name,Manufacturer,ProcessorId,NumberOfCores,AddressWidth | Out-File C:\Temp\TotalRecon.txt -append
		 
        Read-Host "Press Enter to open the results"

		 C:\Temp\TotalRecon.txt
         Experimental 
		 }

         2 { #Command Name
			Insert Command Here
            Pause 
            Experimental
          }

         3 { #Command Name 
            Insert Command here 
            Pause 
            Experimental 
          }
          
         4 { #Command Name 
            Insert Command here 
            Pause 
            Experimental 
          }
          
         5 { #Command Name 
            Insert Command here 
            Pause 
            Experimental 
          }
          
         6 { #Command Name 
            Insert Command here 
            Pause 
            Experimental 
          }
          
         7 { #Command Name 
            Insert Command here 
            Pause 
            Experimental 
          }
          
         8 { #Command Name 
            Insert Command here 
            Pause 
            Experimental 
          }
        c {Clear-Host;$compname="";GetCompName} 
        x {Clear-Host; exit}
        m {CheckHost} 
        default{Experimental} 
    }
}





#---------Start Main-------------- 
$compname = $args[0] 
if($compname){CheckHost} 
else{GetCompName}
#Porttest "$iptocheck" 135



#$Servers = ((get-vmhost ((Get-VM -Name smallvm).vmhost)).Parent.name)
#$Servers = get-vmhost -Location ((get-vmhost ((Get-VM -Name smallvm).vmhost)).Parent.name) | Where-Object Connectionstate -eq "connected"
#$dstore = get-datastore -id ((get-vmhost -Location ((get-vmhost ((Get-VM -Name smallvm).vmhost)).Parent.name) | Where-Object Connectionstate -eq "connected").datastoreidlist)

########for my lab



$MyCollection2 = @()
$Servers = get-vmhost -Location ((get-vmhost ((Get-VM -Name photon10nic).vmhost)).Parent.name) | Where-Object Connectionstate -eq "connected"
ForEach ($server in $servers) {
  $VMOBJECT = New-Object PSobject 
  $VMOBJECT | Add-Member -Name server -Value $server.name -Membertype NoteProperty
  $VMOBJECT | Add-Member -Name Datastore -Value ((get-vmhost $server.name | get-datastore)).name -Membertype NoteProperty
 # $VMOBJECT | Add-Member -Name Portgroup -Value (Get-NetworkAdapter -VM $vm.name | get-vdportgroup) -Membertype NoteProperty
  $MyCollection2 += $VMOBJECT
  }


 foreach ($server in $MyCollection2) 
	{
        $prompt = Read-Host -Prompt $("VMOTION TO ($server).server [Y] Yes [N] No  ")                  
        if ($prompt -ne "Y") 
        {   
        Write-Host -ForegroundColor GREEN "----------------------------------------------------------------------------------------------------------------------------------------------------------------"
        Write-Host -ForegroundColor GREEN "                  NOT VMOTIONING TO ($SERVER).server, MOVING ON....                                                        "
        Write-Host -ForegroundColor GREEN "----------------------------------------------------------------------------------------------------------------------------------------------------------------"
        continue
        }

 	$vMotion = Move-VM -VM photon10nic -Destination $server.server -Datastore $server.datastore 
   	$vMotionTimestamp = Get-Date
    If($vMotion -eq $Null) 
			{
      		write-output "vMotion Error moving to $Server.server - $vMotionTimestamp" 
      		continue
    		}
    #$script ="ping -c 5 -W 1 -I eth0 192.168.1.1"
    $script ="ping -c 5 -W 1  192.168.1.1"
    Invoke-VMScript -VM photon10nic -ScriptText $script -ScriptType BASH -GuestUser root -GuestPassword V0daf0ne1!
     Read-Host -Prompt "COMMIT?"
   }


remove-variable  -Name mycollection2
remove-variable  -Name server
remove-variable  -Name script

###PREP FOR REAL LAB

(Get-VM -Name PHOTON10NIC).ExtensionData.GUEST.TOOLSSTATUS

(Get-NetworkAdapter -VM PHOTON10NIC)[0]

$script ="ping -c 5 -W 1 -I " + $Interface + " " + $ToPing 
Invoke-VMScript -VM $VM -ScriptText $script -ScriptType BASH -GuestUser $guestUser -GuestPassword $guestPassword


$script ="ping -c 5 -W 1 -I eth0 192.168.1.1"
Invoke-VMScript -VM photon10nic -ScriptText $script -ScriptType BASH -GuestUser root -GuestPassword V0daf0ne1!


###---for real lab
$DEST1= Read-Host "PLEASE TYPE IN PING DESTINATION 1 (X.X.X.X):"
$script1 ="ping -c 5 -W 1  $DEST1"
$DEST2= Read-Host "PLEASE TYPE IN PING DESTINATION 2 (X.X.X.X):"
$script2 ="ping -c 5 -W 1  $DEST2"
$DEST3= Read-Host "PLEASE TYPE IN PING DESTINATION 3 (X.X.X.X):"
$script3 ="ping -c 5 -W 1  $DEST3"

 #If($DEST3 -notlike "*.*") 
	#		{
     # 		write-output "No Test to Run' VMOTIONING TO NEXT BLADE" 
      #		continue
    	#	}


$Servers = get-vmhost -Location ((get-vmhost ((Get-VM -Name photon10nic).vmhost)).Parent.name) | Where-Object Connectionstate -eq "connected"

foreach ($server in $servers) 
	{
     $prompt = Read-Host -Prompt $("VMOTION TO ($server)[Y] Yes [N] No  ")                  
        if ($prompt -ne "Y") 
        {   
        Write-Host -ForegroundColor RED "----------------------------------------------------------------------------------------------------------------------------------------------------------------"
        Write-Host -ForegroundColor RED "                  NOT VMOTIONING TO BLADE <$SERVER>, MOVING ON....                                                        "
        Write-Host -ForegroundColor RED "----------------------------------------------------------------------------------------------------------------------------------------------------------------"
        continue
        }	

    $vMotion = Move-VM -VM photon10nic -Destination $server.name 
   	$vMotionTimestamp = Get-Date
    If($vMotion -eq $Null) 
			{
      		write-output "vMotion Error moving to $Server - $vMotionTimestamp" 
      		continue
    		}
    If($DEST1 -notlike "*.*") 
			{
      		Write-Host -ForegroundColor GREEN ""
            Write-Host -ForegroundColor GREEN "----------------------------------------------------------------------------------------------------------------------------------------------------------------"
            Write-Host -ForegroundColor GREEN "                 PING TEST COMPLETED FOR THIS BLADE <$SERVER> - VMOTIONING VM TO NEXT BLADE                                                      "
            Write-Host -ForegroundColor GREEN "----------------------------------------------------------------------------------------------------------------------------------------------------------------"
            Write-Host -ForegroundColor GREEN "" 
      		continue
    		}
    Write-Host -ForegroundColor ORANGE "----------------------------------------------------------------------------------------------------------------------------------------------------------------"
    Write-Host -ForegroundColor ORANGE "                  VM ACTIVE ON BLADE <$SERVER>, RUNNING PING TEST 1 - DESTINATION $DEST1 ....                                                        "
    Write-Host -ForegroundColor ORANGE "----------------------------------------------------------------------------------------------------------------------------------------------------------------"
    Write-Host -ForegroundColor ORANGE ""

    #$script ="ping -c 5 -W 1 -I eth0 192.168.1.1"
    #$script ="ping -c 5 -W 1  192.168.1.1"
    $P1 = Invoke-VMScript -VM photon10nic -ScriptText $script1 -ScriptType BASH -GuestUser root -GuestPassword V0daf0ne1!
    write-host Output: $P1.ScriptOutput
    #if ($P1.ScriptOutput -match '5 packets transmitted, \d received, (?<packetLost>\d*)% packet loss')
	#				{
	#				Write-Host -BackgroundColor "Yellow" -ForegroundColor "Black" Packet Lost% for $Portgroup  = $Matches.packetLost; 
    #                Read-Host -Prompt "CONTINUE? (ENTER CTRL ^C IF NOT)"
    #                }
    remove-variable  -Name P1
   If($DEST2 -notlike "*.*") 
			{
      		Write-Host -ForegroundColor GREEN ""
            Write-Host -ForegroundColor GREEN "----------------------------------------------------------------------------------------------------------------------------------------------------------------"
            Write-Host -ForegroundColor GREEN "                 PING TEST COMPLETED FOR THIS BLADE <$SERVER> - VMOTIONING VM TO NEXT BLADE                                                      "
            Write-Host -ForegroundColor GREEN "----------------------------------------------------------------------------------------------------------------------------------------------------------------"
            Write-Host -ForegroundColor GREEN "" 
      		continue
    		}
    Write-Host -ForegroundColor ORANGE "----------------------------------------------------------------------------------------------------------------------------------------------------------------"
    Write-Host -ForegroundColor ORANGE "                  VM ACTIVE ON BLADE <$SERVER>, RUNNING PING TEST 2 - DESTINATION $DEST2 ....                                                        "
    Write-Host -ForegroundColor ORANGE "----------------------------------------------------------------------------------------------------------------------------------------------------------------"
    Write-Host -ForegroundColor ORANGE ""

    #$script ="ping -c 5 -W 1 -I eth0 192.168.1.1"
    #$script ="ping -c 5 -W 1  192.168.1.1"
    $P2 = Invoke-VMScript -VM photon10nic -ScriptText $script2 -ScriptType BASH -GuestUser root -GuestPassword V0daf0ne1!
    write-host Output: $P2.ScriptOutput
    #if ($P1.ScriptOutput -match '5 packets transmitted, \d received, (?<packetLost>\d*)% packet loss')
	#				{
	#				Write-Host -BackgroundColor "Yellow" -ForegroundColor "Black" Packet Lost% for $Portgroup  = $Matches.packetLost; 
    #                Read-Host -Prompt "CONTINUE? (ENTER CTRL ^C IF NOT)"
    remove-variable  -Name P2

    If($DEST3 -notlike "*.*") 
			{
      		Write-Host -ForegroundColor GREEN ""
            Write-Host -ForegroundColor GREEN "----------------------------------------------------------------------------------------------------------------------------------------------------------------"
            Write-Host -ForegroundColor GREEN "                 PING TEST COMPLETED FOR THIS BLADE <$SERVER> - VMOTIONING VM TO NEXT BLADE                                                      "
            Write-Host -ForegroundColor GREEN "----------------------------------------------------------------------------------------------------------------------------------------------------------------"
            Write-Host -ForegroundColor GREEN "" 
      		continue
    		}
    Write-Host -ForegroundColor ORANGE "----------------------------------------------------------------------------------------------------------------------------------------------------------------"
    Write-Host -ForegroundColor ORANGE "                  VM ACTIVE ON BLADE <$SERVER>, RUNNING PING TEST 3 - DESTINATION $DEST3 ....                                                        "
    Write-Host -ForegroundColor ORANGE "----------------------------------------------------------------------------------------------------------------------------------------------------------------"
    Write-Host -ForegroundColor ORANGE ""

    #$script ="ping -c 5 -W 1 -I eth0 192.168.1.1"
    #$script ="ping -c 5 -W 1  192.168.1.1"
    $P3 = Invoke-VMScript -VM photon10nic -ScriptText $script2 -ScriptType BASH -GuestUser root -GuestPassword V0daf0ne1!
    write-host Output: $P3.ScriptOutput
    #if ($P1.ScriptOutput -match '5 packets transmitted, \d received, (?<packetLost>\d*)% packet loss')
	#				{
	#				Write-Host -BackgroundColor "Yellow" -ForegroundColor "Black" Packet Lost% for $Portgroup  = $Matches.packetLost; 
    #                Read-Host -Prompt "CONTINUE? (ENTER CTRL ^C IF NOT)"
    
    
    remove-variable  -Name P3
   
   #If($DEST4 -notlike "*.*") 
	#		{
      		Write-Host -ForegroundColor GREEN ""
            Write-Host -ForegroundColor GREEN "----------------------------------------------------------------------------------------------------------------------------------------------------------------"
            Write-Host -ForegroundColor GREEN "                 PING TEST COMPLETED FOR THIS BLADE <$SERVER> - VMOTIONING VM TO NEXT BLADE                                                      "
            Write-Host -ForegroundColor GREEN "----------------------------------------------------------------------------------------------------------------------------------------------------------------"
            Write-Host -ForegroundColor GREEN "" 
    #  		continue
    		} 
    ###TO ENTER IN MORE NWK HERE.
   }
    
    Write-Host -ForegroundColor GREEN ""
    Write-Host -ForegroundColor ORANGE "----------------------------------------------------------------------------------------------------------------------------------------------------------------"
    Write-Host -ForegroundColor ORANGE "                  NO MORE HOST LEFT IN CLUSTER - TEST COMPLETED                                                      "
    Write-Host -ForegroundColor ORANGE "----------------------------------------------------------------------------------------------------------------------------------------------------------------"
    Write-Host -ForegroundColor GREEN ""
  

   #########ensure server.name when copy down from above

remove-variable  -Name servers
remove-variable  -Name server
remove-variable  -Name script1
remove-variable  -Name script2
remove-variable  -Name script3
remove-variable  -Name DEST1
remove-variable  -Name DEST2
remove-variable  -Name DEST3




#######


    	write-output "####################################################################" >> $fileLogPath\$SITE-$VNF-$Cluster.testlog.$timestamp.txt
    	write-output " " >> $fileLogPath\$SITE-$VNF-$Cluster.testlog.$timestamp.txt
    	If($vMotion -eq $Null) 
			{
      		write-output "vMotion Error from $PrevServer.Name to $Server.Name - $vMotionTimestamp" >> $fileLogPath\$SITE-$VNF-$Cluster.testlog.$timestamp.txt
      		write-output " " >> $fileLogPath\$SITE-$VNF-$Cluster.testlog.$timestamp.txt
     		write-output "####################################################################" >> $fileLogPath\$SITE-$VNF-$Cluster.testlog.$timestamp.txt
      		continue
    		}
    	write-output "Test for host $Server.Name - $vMotionTimestamp" >> $fileLogPath\$SITE-$VNF-$Cluster.testlog.$timestamp.txt
    	write-output " " >> $fileLogPath\$SITE-$VNF-$Cluster.testlog.$timestamp.txt
    	write-host "Test for host $Server.Nam

 




$MyCollection2 = @()
$AllVMs = Get-View -ViewType VirtualMachine | Where {-not $_.Config.Template}
ForEach ($VM in $allvms) {
  $VMOBJECT = New-Object PSobject 
  $VMOBJECT | Add-Member -Name VM -Value $VM.name -Membertype NoteProperty
  $VMOBJECT | Add-Member -Name Datastore -Value (get-vm $VM.name | get-datastore) -Membertype NoteProperty
  $VMOBJECT | Add-Member -Name Portgroup -Value (Get-NetworkAdapter -VM $vm.name | get-vdportgroup) -Membertype NoteProperty
  $MyCollection2 += $VMOBJECT
  }
$MyCollection2 | Out-GridView
  
  | Add-Member -Name Name -Value (get-vm ac1vm | get-datastore) -Membertype NoteProperty
 
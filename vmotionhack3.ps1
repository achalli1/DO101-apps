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
        $prompt = Read-Host -Prompt $("VMOTION TO $server.server [Y] Yes [N] No  ")                  
        if ($prompt -ne "Y") 
        {   
        Write-Host -ForegroundColor GREEN "----------------------------------------------------------------------------------------------------------------------------------------------------------------"
        Write-Host -ForegroundColor GREEN "                  NOT VMOTIONING TO $SERVER.SERVER, MOVING ON....                                                        "
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

$Servers = get-vmhost -Location ((get-vmhost ((Get-VM -Name photon10nic).vmhost)).Parent.name) | Where-Object Connectionstate -eq "connected"

foreach ($server in $servers) 
	{
 	$vMotion = Move-VM -VM photon10nic -Destination $server.name 
   	$vMotionTimestamp = Get-Date
    #$script ="ping -c 5 -W 1 -I eth0 192.168.1.1"
    $script ="ping -c 5 -W 1  192.168.1.1"
    Invoke-VMScript -VM photon10nic -ScriptText $script -ScriptType BASH -GuestUser root -GuestPassword V0daf0ne1!
     Read-Host -Prompt "COMMIT?"

   }


   #########ensure server.name when copy down from above

remove-variable  -Name servers
remove-variable  -Name server
remove-variable  -Name script

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
 
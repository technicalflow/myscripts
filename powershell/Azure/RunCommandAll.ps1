#Azure Subscription I want to use
$subscriptionId = "XXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"
#Resource Group my VMs are in
$resourceGroup = "test-azurevms-rg"

#Select the right Azure subscription
Set-AzContext -Subscription $subscriptionId

#Get all Azure VMs which are in running state and are running Windows
$myAzureVMs = Get-AzVM -ResourceGroupName $resourceGroup -status | Where-Object {$_.PowerState -eq "VM running" -and $_.StorageProfile.OSDisk.OSType -eq "Windows"}

#Run the scirpt again all VMs in parallel
$myAzureVMs | ForEach-Object -Parallel {
    $out = Invoke-AzVMRunCommand `
        -ResourceGroupName $_.ResourceGroupName `
        -Name $_.Name  `
        -CommandId 'RunPowerShellScript' `
        -ScriptPath .\script.ps1 
    #Formating the Output with the VM name
    $output = $_.Name + " " + $out.Value[0].Message
    $output   
}
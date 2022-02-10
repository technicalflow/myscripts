$RG=rgname
do {
    foreach ($a in $(Get-AzResource -ResourceGroupName $RG).Id) 
    {Remove-AzResource -ResourceId $a -Force}
    } 
Until ((Get-AzResource -ResourceGroupName $RG).Id -eq $null)

# Set the variables:
$gMSA_AccountName = 'mdiSvc01'
$gMSA_HostsGroupName = 'mdiSvc01Group'
$gMSA_HostNames = 'DC01', 'DC02', 'ADCS', 'ADFS'

# Import the required PowerShell module:
Import-Module ActiveDirectory

# Create the group and add the members
$gMSA_HostsGroup = New-ADGroup -Name $gMSA_HostsGroupName -GroupScope Global -PassThru
$gMSA_HostNames | ForEach-Object { Get-ADComputer -Identity $_ } |
    ForEach-Object { Add-ADGroupMember -Identity $gMSA_HostsGroupName -Members $_ }
# Or, use the built-in 'Domain Controllers' group if the environment is a single forest, and will contain only domain controller sensors
# $gMSA_HostsGroup = Get-ADGroup -Identity 'Domain Controllers'

#Add ad keyroot before creating account. Only nessesary first time
Add-KdsRootKey –EffectiveTime ((get-date).addhours(-10))
  
# Create the gMSA:
New-ADServiceAccount -Name $gMSA_AccountName -DNSHostName "$gMSA_AccountName.$env:USERDNSDOMAIN" `
-PrincipalsAllowedToRetrieveManagedPassword $gMSA_HostsGroupName

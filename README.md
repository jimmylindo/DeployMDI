This is used to deploy MDI



Start-BitsTransfer -Source https://github.com/jimmylindo/DeployMDI/raw/main/MDI-GPOs.zip -Destination C:\Temp
Expand-Archive -Path C:\Temp\MDI-GPOs.zip -DestinationPath C:\Temp\mdigpo\

#Create Policies for domain controllers. These policies should be linked to domain controllers after verified

$GPO = New-GPO -Name "MDI-DC-AdvancedAuditLogs"
$localdomain = Get-ADDomain
Import-GPO -Path C:\Temp\mdigpo -BackupId 9A8A0A9F-E336-4910-89DA-2102347E3599 -TargetGuid $GPO.Id -Domain $localdomain.Forest
#To automatically link GPO you can un-comment row below:
#New-GPLink -Name $GPO.DisplayName -Target "OU=Domain Controllers,DC=CORP,DC=acme,DC=com"

$GPO2 = New-GPO -Name "MDI-DC-NTLMAudit"
Import-GPO -Path C:\Temp\mdigpo -BackupId EC000D70-3BA4-430B-943D-15682D495F09 -TargetGuid $GPO2.Id -Domain $localdomain.Forest
#To automatically link GPO you can un-comment row below:
#New-GPLink -Name $GPO.DisplayName -Target "OU=Domain Controllers,DC=CORP,DC=acme,DC=com"

#Create policy for Active Directory Certificate services

$GPO3 = New-GPO -Name "MDI-ADDC-Audit"
Import-GPO -Path C:\Temp\mdigpo -BackupId F7D2DE3D-C7CB-49FF-B6C0-4317C15FEFA4 -TargetGuid $GPO3.Id -Domain $localdomain.Forest

#Create a policy for SAMR to get lateral movement. This should be attached to all computers except domain controllers. This policy needs to be updated with DSA account. It should also be runned in audit mode when first deployed.

$GPO4 = New-GPO -Name "MDI-Windows-SAMR"
Import-GPO -Path C:\Temp\mdigpo -BackupId F7D2DE3D-C7CB-49FF-B6C0-4317C15FEFA4 -TargetGuid $GPO4.Id -Domain $localdomain.Forest

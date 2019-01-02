﻿#region remoting on CL1
Enable-PSRemoting
Enable-PSRemoting -verbose
winrm qc
disable-psremoting
winrm qc

get-aduser -identity otto

$cred =Get-Credential it\administrator

Enter-PSSession `

$dc = New-PSSession -ComputerName dc1 -Credential (Get-Credential it\administrator)

invoke-command `
Get-NetIPAddress} 

invoke-command `

invoke-command `

$cred =Get-Credential it\administrator

Enter-PSSession `

$dc = New-PSSession -ComputerName dc1 -Credential (Get-Credential it\administrator)

invoke-command `
Get-NetIPAddress} 

invoke-command `

invoke-command `

#endregion

#region domainjoin
$localpw = Get-Credential local\administrator

Set-DnsClientServerAddress `

Add-Computer `

Restart-Computer

#endregion

#region DomainInstall

Get-WindowsFeature *ad*
Install-WindowsFeature -Name Ad-Domain-Services -IncludeManagementTools

#
# Windows PowerShell script for AD DS Deployment
#

Import-Module ADDSDeployment

$pass = ConvertTo-SecureString -String 'Pa$$w0rd' -AsPlainText -force

Install-ADDSForest `
-CreateDnsDelegation:$false `
-DatabasePath "C:\Windows\NTDS" `
-DomainMode "Win2012R2" `
-DomainName "it.fisi" `
-DomainNetbiosName "IT" `
-ForestMode "Win2012R2" `
-InstallDns:$true `
-LogPath "C:\Windows\NTDS" `
-NoRebootOnCompletion:$false `
-SysvolPath "C:\Windows\SYSVOL" `
-Force:$true `


#endregion

#region NewUser
New-ADUser `


#endregion

#region LabInstall

Install-Module -Name AutomatedLab -AllowClobber -force
Import-Module -Name AutomatedLab 
Get-LabAvailableOperatingSystem -Path C:\LabSources |Format-Table imageindex,OperatingSystemImageName

New-LabDefinition -Name Powershell -DefaultVirtualizationEngine HyperV

Add-LabMachineDefinition -Name DC1 -OperatingSystem 'Windows Server 2016 Datacenter (Desktop Experience)'
Add-LabMachineDefinition -Name CL1 -OperatingSystem 'Windows 10 Enterprise'
Add-LabMachineDefinition -Name SVR1 -OperatingSystem 'Windows Server 2016 Datacenter (Desktop Experience)'

Install-Lab

Show-LabDeploymentSummary 

#endregion
#region remoting on CL1
Enable-PSRemoting
Enable-PSRemoting -verbose
winrm qc
disable-psremoting
winrm qc

get-aduser -identity otto

$cred =Get-Credential it\administrator

Enter-PSSession `-ComputerName dc1 `-Credential $cred

$dc = New-PSSession -ComputerName dc1 -Credential (Get-Credential it\administrator)

invoke-command `-Session $dc `-ScriptBlock {get-aduser -identity otto;ipconfig
Get-NetIPAddress} 

invoke-command `-Session $dc `-ScriptBlock {get-aduser -identity tim} 

invoke-command `-Session $dc `-ScriptBlock {import-module activedirectory} Import-PSSession -Session $dcget-aduser -identity otto

$cred =Get-Credential it\administrator

Enter-PSSession `-ComputerName dc1 `-Credential $cred

$dc = New-PSSession -ComputerName dc1 -Credential (Get-Credential it\administrator)

invoke-command `-Session $dc `-ScriptBlock {get-aduser -identity otto;ipconfig
Get-NetIPAddress} 

invoke-command `-Session $dc `-ScriptBlock {get-aduser -identity tim} 

invoke-command `-Session $dc `-ScriptBlock {import-module activedirectory} Import-PSSession -Session $dc

#endregion

#region domainjoin
$localpw = Get-Credential local\administrator

Set-DnsClientServerAddress `-InterfaceIndex 3 `-ServerAddresses 192.168.11.3

Add-Computer `-ComputerName SVR1 `-LocalCredential $localpw `-DomainName it.fisi `-Credential (Get-Credential it\administrator)

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
-Force:$true `-SafeModeAdministratorPassword $pass


#endregion

#region NewUser
New-ADUser `-DisplayName:"Otto Krabumm" `-GivenName:"Otto" `-Name:"Otto Krabumm" `-Path:"CN=Users,DC=it,DC=fisi" `-SamAccountName:"otto" `-Server:"DC1.it.fisi" `-Surname:"Krabumm" `-Type:"user" `-UserPrincipalName:"otto@it.fisi"Set-ADAccountPassword `-Identity "CN=Otto Krabumm,CN=Users,DC=it,DC=fisi" `-NewPassword (ConvertTo-SecureString -String 'Pa$$w0rd' -AsPlainText -Force) `-Reset:$true `-Server "DC1.it.fisi"


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
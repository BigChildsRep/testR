###################################################################
# PS50-PowerShell Grundlagen
# PowerShell Remoting

Get-Service -Name WinRM
Get-NetConnectionProfile
Get-NetConnectionProfile | Set-NetConnectionProfile -NetworkCategory Private

#cmd.exe
winrm qc

#Powershell
Enable-PSRemoting 

#Using Remoting: One-to-One
#Port: 5985 WinRM (http) | 5986 (https)
Enter-PSSession -ComputerName LON-DC1 
$env:COMPUTERNAME
Exit-PSSession

#Using Remoting: One-to-Many
#Port: 5985 WinRM (http) | 5986 (https)
Invoke-Command -ComputerName LON-DC1 -ScriptBlock { $env:COMPUTERNAME ; Get-Service }
Invoke-Command -ComputerName LON-DC1,localhost -ScriptBlock { $env:COMPUTERNAME ; Get-Service }

#Port 135 RPC
Get-Service -ComputerName LON-DC1
Get-Service -ComputerName LON-DC1, localhost

#Lokale Variablen, remote nutzen
$Bits="Bits"
Invoke-Command -ComputerName LON-DC1 -ScriptBlock { Get-Service -Name $Bits } #Error

$Bits="Bits"
Invoke-Command -ComputerName LON-DC1 -ScriptBlock { Param($ServiceName) Get-Service -Name $ServiceName } -ArgumentList $Bits

$Bits="Bits"
Invoke-Command -ComputerName LON-DC1 -ScriptBlock { Param($ServiceName,$date) Get-Service -Name $ServiceName ; Write-Output -InputObject "Today is $date"} -ArgumentList $Bits,(Get-Date)

$Bits="Bits"
Invoke-Command -ComputerName LON-DC1 -ScriptBlock { Get-Service -Name $using:Bits }

#Neue PowerShell Session
$dc=New-PSSession -ComputerName LON-DC1

#PowerShell Session nutzen
Get-Module -PSSession $dc -ListAvailable
Import-Module -PSSession $dc -Name ActiveDirectory -Prefix DC1REM
Get-Help Get-DC1REMADUser
Get-DC1REMADUser -Filter *

#PowerShell Session trennen
$dc | Remove-PSSession

$sessionArgs2= @{
    ConfigurationName = "Microsoft.exchange";
    ConnectionUri = "https://server.fqdn.com/powershell";
    Credential = (Get-Credential adatum\Administrator)
}
$session = New-PSSession @sessionArgs2
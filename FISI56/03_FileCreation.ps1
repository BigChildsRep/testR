#########################################################
# This is a JEA configuration script to create and register an Operator user, 
# allowed to restart services and read user attributes from AD
#
# Used in the Session 'Securing your infrastructure with JEA'
#
# Author: Miriam Wiesner
# Creation date: 13.04.2018
# Version: 1.0.0

####################### VARIABLES #######################

# Environment
$path = "$env:ProgramFiles\WindowsPowerShell\Modules\Operator"
$rolePath = "$path\RoleCapabilities"

# Domain
$DomainName = (Get-WmiObject -Class Win32_ComputerSystem).Domain
$DomainNetbiosName = (Get-WmiObject -Class Win32_NTDomain -Filter "DnsForestName = '$DomainName'").DomainName

# AccountNames
$Operator = "$DomainNetbiosName\Operator"

#########################################################

# Create Paths if needed
if(!(Test-Path -Path $path )){
    New-Item -Path $path -ItemType Directory
}

if(!(Test-Path -Path $rolePath )){
    New-Item -Path $rolePath -ItemType Directory
}


#########################################################

# Module Manifest
New-ModuleManifest -Path "$path\Operator.psd1"

#########################################################

# Create the Role Capability File
$RoleCapParams = @{
    Path = "$rolePath\Operator-RoleCapability.psrc"
    Author = 'Miriam Wiesner'
    CompanyName = 'Microsoft'
    VisibleCmdlets = 'Test-NetConnection', @{ Name = 'Restart-Service'; Parameters = @{ Name = 'Name'; ValidateSet = 'Bits', 'Rpcss' } }
    }
New-PSRoleCapabilityFile @RoleCapParams

powershell_ise.exe $rolePath\Operator-RoleCapability.psrc


#########################################################

# Create the Session Configuration
$SessionConfigParams = @{
    SessionType = 'RestrictedRemoteServer'
    RunAsVirtualAccount = $true
    RoleDefinitions = @{$Operator = @{ RoleCapabilities = 'Operator-RoleCapability' }}
}

New-PSSessionConfigurationFile -Path "$path\Operator-SessionConfigurationFile.pssc" @SessionConfigParams
powershell_ise.exe "$path\Operator-SessionConfigurationFile.pssc"

#########################################################

# Register the session configuration
Register-PSSessionConfiguration -Name Operator -Path "$path\Operator-SessionConfigurationFile.pssc"
Restart-Service -name Winrm

#########################################################

# Unregister the Session Configuration
Unregister-PSSessionConfiguration -Name Operator
Restart-Service -name Winrm
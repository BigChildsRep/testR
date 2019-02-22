$path = "c:\FISIJEA\ModulesJEA"
$rolePath = "$path\RoleCapabilities"

# Domain
$DomainName = (Get-WmiObject -Class Win32_ComputerSystem).Domain
$DomainNetbiosName = (Get-WmiObject -Class Win32_NTDomain -Filter "DnsForestName = '$DomainName'").DomainName

# AccountNames
$FISIAdmin = "$DomainNetbiosName\FISIAdmin"

New-ADGroup -name $FISIAdmin -groupCategory Security -groupScope Universal

# Create Paths if needed
if(!(Test-Path -Path $path )){
    New-Item -Path $path -ItemType Directory
}

if(!(Test-Path -Path $rolePath )){
    New-Item -Path $rolePath -ItemType Directory
}

#########################################################

# Module Manifest
New-ModuleManifest -Path "$path\moduleJEA.psd1"

#########################################################


# Create the Role Capability File
$RoleCapParams = @{
    Path = "$rolePath\FiSiJEARole.psrc"
    Author = 'Administrator'
    Copyright = '(c) 2017 GFN-Training. All rights reserved.'
    CompanyName = 'gfn-training'
    VisibleExternalCommands = 'C:\Windows\System32\netstat.exe'
    VisibleProviders = 'Variable'
    VisibleCmdlets = 'get-service','restart-service'
    }
New-PSRoleCapabilityFile @RoleCapParams


# Create the Session Configuration
$SessionConfigParams = @{
    SessionType = 'RestrictedRemoteServer'
    CompanyName = 'Unknown'
    LanguageMode = 'NoLanguage'
    ExecutionPolicy = 'Restricted'
    TranscriptDirectory = 'C:\Transcripts'
    RunAsVirtualAccount = $true
    RoleDefinitions = @{$FISIAdmin = @{ RoleCapabilities = 'FISIJEARole' }}
}

New-PSSessionConfigurationFile -Path "$path\FISIJEASession.pssc" @SessionConfigParams


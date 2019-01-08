$antwort = read-host "Wirklich alles ausführen? J/N"
if ($antwort -eq "j")
{
    Set-PSBreakpoint -Mode Read -Action 
}

#region dism Demo
dism /online /get-features
dism /online /enable-feature /featurename:TelnetClient
#endregion 
#region VMLABPrep
mkdir c:\TMP
new-item -Path c:\ -Name TMP -ItemType Directory
New-VHD -Path C:\TMP\BaseCL.vhd -SizeBytes 40GB -Dynamic
New-VHD -Path C:\TMP\trans.vhd -SizeBytes 40GB -Dynamic
Mount-VHD -Path C:\TMP\trans.vhd
#endregion
#region wichtige Snap-Ins
diskmgmt.msc
gpedit.msc
ncpa.cpl
#endregion
#region verwalten  von lokalem Speicher
get-disk | Where-Object partitionstyle -eq RAW
clear-disk -Number 5
Initialize-Disk -Number 5 -PartitionStyle MBR|New-Volume -FileSystem NTFS -FriendlyName System
Get-Disk | 
Where-Object {$_.PartitionStyle -eq "raw"} | 
Initialize-Disk -PartitionStyle MBR -PassThru | 
New-Partition -UseMaximumSize -DriveLetter V| 
Format-Volume -FileSystem NTFS
#endregion
#eine Kommentar Zeile
<#
ein Kommentar Block mehere Zeilen
#>
#region Anwenden eines WIM Image
get-disk | Where-Object partitionstyle -eq RAW
clear-disk -Number 5
Initialize-Disk -Number 5 -PartitionStyle MBR|New-Volume -FileSystem NTFS -FriendlyName System
Get-Disk | Where-Object {$_.PartitionStyle -eq "raw"} | Initialize-Disk -PartitionStyle MBR -PassThru | New-Partition -UseMaximumSize -DriveLetter V| Format-Volume -FileSystem NTFS
clear-host

Get-WindowsImage -ImagePath C:\tmp\install.wim
Expand-WindowsImage -ImagePath C:\tmp\install.wim -Index 1 -ApplyPath i:\
Mount-VHD -Path D:\vm\base\BaseCL1.vhd
#endregion
#region VHD vorbbereiten
Mount-VHD -Path D:\vm\base\BaseCL.vhd
Dismount-VHD -Path D:\vm\base\BaseCL.vhd
new-item -Path D:\ -Name VM -ItemType Directory
new-item -Path D:\VM -Name Base -ItemType Directory
New-VHD -Path D:\VM\vhd\cl001.vhd -Differencing -ParentPath D:\vm\base\BaseCL.vhd
New-VM `
    -Name CL001 `
    -MemoryStartupBytes 2GB `
    -VHDPath D:\vm\vhd\cl001.vhd `
    -Path D:\vm\ -Generation 1

for ($i = 2; $i -lt 8; $i++)
{ 
 New-VHD `
    -Path "D:\VM\vhd\cl00$i.vhd" `
    -Differencing `
    -ParentPath D:\vm\base\BaseCL.vhd
 Start-Sleep 500
 New-VM `
    -Name CL00$i `
    -MemoryStartupBytes 2GB `
    -VHDPath "D:\vm\vhd\cl00$i.vhd" `
    -Path D:\vm\ -Generation 1
   
}

for ($i = 2; $i -lt 8; $i++)
{ 
 New-VHD `
    -Path "D:\VM\vhd\cl00$i.vhd" `
    -Differencing `
    -ParentPath D:\vm\base\BaseCL1.vhd   
}

get-disk | where-object  {$psitem.Size -eq 40GB} |get-partition | Set-Partition -IsActive $true
get-disk | where-object  {$psitem.Size -eq 40GB} |get-partition|format-list
#endregion
#region Deploy Windows10 for native Boot
 New-VHD -Path C:\win10\win10.vhd -Dynamic -SizeBytes 60GB | Mount-VHD

Get-Disk | 
    Where-Object {$_.PartitionStyle -eq "raw"} | 
    Initialize-Disk -PartitionStyle MBR -PassThru | 
    New-Partition -UseMaximumSize -DriveLetter V | 
    Format-Volume -FileSystem NTFS

& "C:\Program Files\Internet Explorer\iexplore.exe" "http://windows.microsoft.com/en-us/windows/preview-iso-update?os=win10epi%281974598307276002304%29&abc"

Get-FileHash -Algorithm SHA1 -Path C:\win10\win10.iso 

Mount-DiskImage -ImagePath "c:\win10\win10.iso" -PassThru | Get-Volume

Get-WindowsImage -ImagePath D:\sources\install.wim

Expand-WindowsImage -ImagePath D:\sources\install.wim -Index 1 -ApplyPath v:\

bcdboot v:\Windows

Dismount-VHD -Path C:\win10\win10.vhd

Dismount-DiskImage -ImagePath C:\win10\win10.iso

Restart-Computer
#endregion 
#region Windows Server2012 deploy 
dism /get-wiminfo /wimfile:D:\Temp\2012R2\sources\install.wim


cd D:\VM
.\Convert-WindowsImage.ps1 `
    -SourcePath "D:\Temp\2012R2\sources\install.wim" `
    -Edition ServerStandard `
    -SizeBytes 50gb `
    -VHDType fixed `
    -VHDFormat VHDX `
    -VHDPath "D:\VM\VHD\SR011_2012R2_c.vhdx" `
    -RemoteDesktopEnable



dism /get-wiminfo /wimfile:D:\Temp\VISTASP2\sources\install.wim
#endregion
#region und dann
BCDedit

New-VM `
    -Name Help `
    -MemoryStartupBytes 2GB `
    -VHDPath D:\vm\base\BaseCL.vhd `
    -Path D:\vm\ -Generation 1
#endregion
    #region Create and edit PowerShell profiles

$profile|Get-Member
Test-Path $profile.AllUsersAllHosts
Test-Path $profile.AllUsersCurrentHost
Test-Path $profile.CurrentUserAllHosts
Test-Path $profile.CurrentUserCurrentHost
if (!(test-path $profile)) {new-item -type file -path $profile -force}
Set-Location "C:\Users\$env:USERNAME\Documents\WindowsPowerShell"
psedit -filenames $profile.CurrentUserCurrentHost

New-Item -ItemType File -Path $profile.CurrentUserAllHosts -Force

Write-Output '[string]$global:Lab          = "TP5"'                                                             > $profile.CurrentUserAllHosts
Write-Output '[string]$global:LabRoot      = "D:\Labs"'                                                        >> $profile.CurrentUserAllHosts
Write-Output '[string]$global:LabSwitch    = "TP5"'                                                            >> $profile.CurrentUserAllHosts
Write-Output '[long]  $global:LabMem       = 4GB'                                                              >> $profile.CurrentUserAllHosts
Write-Output '[long]  $global:LabProcessorCount = 4'                                                           >> $profile.CurrentUserAllHosts
Write-Output '[string]$global:BaseVhd4Gen1 = "D:\Base\Base-WS2016_TP4_withDesktopExperience_en_MBR_v1.1.vhd"'  >> $profile.CurrentUserAllHosts
Write-Output '[string]$global:BaseVhd4Gen2 = "D:\Base\Base-WS2016_TP5_withDesktopExperience_en_GPT_v0.2.vhdx"' >> $profile.CurrentUserAllHosts
Write-Output '$LabDir = Join-Path $LabRoot $Lab'                                                               >> $profile.CurrentUserAllHosts
Write-Output '#------------------------------------------'                                                     >> $profile.CurrentUserAllHosts
Write-Output 'Get-Date -Format D'                                                                              >> $profile.CurrentUserAllHosts
Write-Output '(Get-Culture).DisplayName'                                                                       >> $profile.CurrentUserAllHosts
Write-Output ''                                                                                                >> $profile.CurrentUserAllHosts
Write-Output 'Import-Module -Name tjLabs'                                                                      >> $profile.CurrentUserAllHosts
Write-Output 'Get-Module -Name tjLabs | ft Name,Version'                                                       >> $profile.CurrentUserAllHosts
Write-Output ''                                                                                                >> $profile.CurrentUserAllHosts
Write-Output 'cd $LabDir'                                                                                      >> $profile.CurrentUserAllHosts
Write-Output 'Get-Variable Lab*'                                                                               >> $profile.CurrentUserAllHosts
Write-Output 'Get-Lab'                                                                                         >> $profile.CurrentUserAllHosts

get-vm CL00?

# Current Host is ISE
New-Item -ItemType File -Path $profile.CurrentUserCurrentHost -Force
Write-Output '$psISE.Options.Zoom = 240' >> $profile.CurrentUserCurrentHost

#endregion
#region Transport laufwerk
New-VHD -Path C:\TMP\trans.vhd -SizeBytes 40GB -Dynamic #|mount-vhd
Mount-VHD -Path C:\TMP\trans.vhd
Get-Disk | 
 Where-Object {$_.PartitionStyle -eq "raw"} | 
 Initialize-Disk -PartitionStyle MBR -PassThru | 
 New-Partition -UseMaximumSize -DriveLetter V| 
 Format-Volume -FileSystem NTFS
#endregion

#region DemoLAB
    #region Install Hyper-V

    Install-WindowsFeature -Name Hyper-V -IncludeAllSubFeature -IncludeManagementTools -Restart

    #endregion 
    #region Switch erstellen un IP vergeben

    $VmSwitchName = "Internes Netzwerk"
    New-VMSwitch -Name $VmSwitchName -SwitchType Internal
    start-sleep -Milliseconds 100
    $idx = Get-NetIPAddress -AddressFamily IPv4  | 
     where InterfaceAlias -Like *$VmSwitchName* | 
     % InterfaceIndex

    New-NetIPAddress -InterfaceIndex $idx -IPAddress 172.16.0.200 -PrefixLength 16


    #endregion
    #region create VM's
    new-vhd `
        -Path "D:\VM\VHD\SR001_C.vhd" `
        -ParentPath "D:\VM\Base\Base14A-WS12R2.vhd"
    New-VM `
        -Name SR001 `
        -Generation 1 `
        -MemoryStartupBytes 2GB `
        -SwitchName $VmSwitchName `
        -Path "D:\VM\" `
        -VHDPath "D:\VM\VHD\SR001_C.vhd"

    new-vhd `
        -Path "c:\DemoLAB\VMGuest2.vhd" `
        -ParentPath "c:\DemoLAB\Base\Win81EE.vhd"
    New-VM `
        -Name VMGuest2 `
        -Generation 1 `
        -MemoryStartupBytes 2GB `
        -SwitchName $VmSwitchName `
        -Path c:\DemoLAB\VM `
        -VHDPath "c:\DemoLAB\VMGuest2.vhd"

    for ($i = 3; $i -lt 5; $i++)
    { 
     new-vhd `
        -Path "c:\DemoLAB\VMGuest$i.vhd" `
        -ParentPath "c:\DemoLAB\Base\WS2012R2.vhd"
     New-VM `
        -Name VMGuest$i `
        -Generation 1 `
        -MemoryStartupBytes 2GB `
        -SwitchName $VmSwitchName `
        -Path c:\DemoLAB\VM `
        -VHDPath "c:\DemoLAB\VMGuest$i.vhd"
     }
     Get-VM|Set-VM -ProcessorCount 8
     Get-VM|Start-VM
    #endregion
    #region Edit TrustedHosts

    Set-Item  'WSMan:\localhost\Client\TrustedHosts' -Value '*' -Force

    #endregion
    #region IP Adresse vergeben und Umbenennen
    New-NetIPAddress -InterfaceAlias Ethernet -IPAddress 172.16.0.10 -PrefixLength 16 -DefaultGateway 172.16.0.1
    Rename-Computer -NewName DC1 -Restart
    #endregion
    #region Add a new forest on DC1

        $SecureModePW=ConvertTo-SecureString -String 'Pa$$w0rd' -AsPlainText -Force

        Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools

        Import-Module ADDSDeployment

        Install-ADDSForest `
            -DomainName "Adatum.com" `
            -DomainNetbiosName "ADATUM" `
            -DomainMode "Win2012R2" `
            -ForestMode "Win2012R2" `
            -InstallDns:$true `
            -CreateDnsDelegation:$false `
            -SafeModeAdministratorPassword $SecureModePW `
            -DatabasePath "C:\Windows\NTDS" `
            -SysvolPath "C:\Windows\SYSVOL" `
            -LogPath "C:\Windows\NTDS" `
            -NoRebootOnCompletion:$false `
            -Force:$true
        Start-Sleep -Seconds 360

    #endregion
    #region Configure DNS
    Add-DnsServerPrimaryZone -NetworkId '172.16.0.0/16' -ReplicationScope Domain -DynamicUpdate Secure
    Add-DnsServerResourceRecordPtr -ZoneName "16.172.in-addr.arpa" -Name "10.0" -PtrDomainName "DC1.Adatum.com." 
    #endregion
    #region Install and configure DHCP
    Install-WindowsFeature -Name DHCP -IncludeManagementTools
    Add-DhcpServerSecurityGroup
    Restart-Service -Name DHCPServer
    Start-Sleep 60
    Add-DhcpServerInDC
    # tell server manager post-install completed
    Set-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\ServerManager\Roles\12 -Name ConfigurationState -Value 2
    # server options
    Set-DhcpServerv4OptionValue -DnsDomain "Adatum.com"
    # new scope with scope options
    Add-DhcpServerv4Scope -Name "Deployment" `
                      -StartRange 172.16.99.1 `
                      -EndRange   172.16.99.199 `
                      -SubnetMask 255.255.0.0 -PassThru |
        Set-DhcpServerv4OptionValue -DnsServer 172.16.0.10 `
                                    -Router 172.16.0.1
    #endregion
#endregion

Connect-VMNetworkAdapter -SwitchName $VmSwitchName -VMName CL00? -Confirm $true
get-vm cl00?
Connect-VMNetworkAdapter -VMName cl00? -SwitchName $VmSwitchName
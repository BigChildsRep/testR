
function get-drive 
{
<#
.Synopsis
   Gibt Tabelle mit Information zu den Volumen eines Computers wieder.
.DESCRIPTION
   Gibt Tabelle mit Information zu den Volumen eines Computers wieder. Nee
.EXAMPLE
   get-drive -cn Lon-SVR1.adatum.com
.EXAMPLE
   get-drive
#>

param(
[string]
$className = 'win32_logicaldisk',
$cn= $env:COMPUTERNAME
)
Get-CimInstance -ClassName $classname -Filter "drivetype=3" -computername $cn |
select-object   PsComputername,
                DeviceID,
                @{Name="SizeGB";e={($_.size / 1GB -as [int]).ToString() + " GB"}},
                @{Name="FreeSpaceGB";e={($_.freeSpace / 1GB -as [int]).ToString() + " GB"}}    |
format-table
}

function get-DeviceInformation
{
<#
.Synopsis
   Diese Funktion gibt ausgewählte Infomation zu eienm Computersysetm wieder.
.DESCRIPTION
   Diese Funktion gibt ausgewählte Infomation zu eienm Computersysetm wieder.
.EXAMPLE
   get-deviceInformation -computername LON-SVR2,Localhost
#>

    [CmdletBinding()]
    [Alias()]
    [OutputType([int])]
    Param
    (
        # ComputerName help description
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        [Alias('cn')]
        #[ValidatePattern('LON-\w{2,3}\d{1,2}')]
        [string[]]$ComputerName
    )

     PROCESS {
              foreach ($machine in $ComputerName) {
              Write-Verbose "Now connecting to $machine"
                    
              $os = Get-CimInstance -ComputerName $machine -ClassName Win32_OperatingSystem
              $compsys = Get-CimInstance -ComputerName $machine -ClassName Win32_ComputerSystem
              $bios = Get-CimInstance -ComputerName $machine -ClassName Win32_BIOS

              $properties= @{'ComputerName'= $machine;
                             'OSVersion' = $os.Caption;
                             'Architektur' = $os.OSArchitecture;
                             'Manufacturer'= $bios.Manufacturer;
                             'BiosVersion' = $bios.SMBIOSBIOSVersion
                            }

              $output= New-Object -TypeName psobject -Property $properties

              return $output

              } #foreach
             } #process
} #function

function get-spevent
{
<#
.Synopsis
   Diese Funktion gibt ausgewählte Infomation zu eienm Computersysetm wieder.
.DESCRIPTION
   Diese Funktion gibt ausgewählte Infomation zu eienm Computersysetm wieder.
.EXAMPLE
   get-deviceInformation -computername LON-SVR2,Localhost
#>
Param
    (
        # ComputerName help description
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        [Alias('cn')]
        #[ValidatePattern('LON-\w{2,3}\d{1,2}')]
        [string[]]$ComputerName,
        
        [ValidateSet("4624", "4634", "4648", "4672")]
        $eventID = 4624
    )
    Process{
           foreach ($machine in $ComputerName) {
                        try
                        {
                        Get-EventLog -LogName Security `                                 -InstanceId $eventID `                                 -Newest 10 `                                 -ComputerName $machine
                        #Get-CimInstance -ClassName Win32_BIOS -ComputerName $machine -ErrorAction Stop
                        } #try
                        catch {
                        Write-Warning "The command on this line runs, but neither of the available computers are queried because the overall command terminates after receiving and error against NOTONLINE"
                        if (!(Test-Path -Path C:\test\logFile)) {New-Item C:\test\logFile}
                        Add-Content -Path C:\test\logFile ((get-date).ToString()+ ' ' + $machine)
                        } #catch
                   } #foreach
           } #process
} #function



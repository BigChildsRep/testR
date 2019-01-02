#region module

($env:PSModulePath).split(';')

Set-Location (($env:PSModulePath).split(';'))[0]
test-path (($env:PSModulePath).split(';'))[0]
#mkdir besser nicht
New-Item -ItemType Directory -path (($env:PSModulePath).split(';'))[0]
if (test-path (($env:PSModulePath).split(';'))[0])
{
    
}
else
{
 New-Item -ItemType Directory -path (($env:PSModulePath).split(';'))[0]   
}

if (!(test-path (($env:PSModulePath).split(';'))[0]))
{
 New-Item -ItemType Directory -path (($env:PSModulePath).split(';'))[0]   
}

New-ModuleManifest -Path "C:\Users\administrator.IT\Documents\WindowsPowerShell\Modules\fisi\fisi.psd1"
  
#endregion  

$test=$Env:USERPROFILE
$test|Get-Member
set-location "$test"
set-location '$test'

Write-Output "der user x hat das passwort 'Pa`$`$w0rd' "
Write-Output "der user x hat das passwort 'Pa$$w0rd' "
Write-Output "der user x hat das passwort "'Pa$$w0rd'


#region Reload FISI-Module
    if(get-module "FISI" ) {
    remove-module fisi}
    import-module fisi
    #endregion Reload FISI-Module

get-help about_operators -ShowWindow
    
New-ModuleManifest `
    -RootModule "fisi.psm1" `
    -ModuleVersion 0.8 -Author "memyself" `
    -path C:\Users\Administrator.it\WindowsPowerShell\Modules\FISI\fisi.psd1
#region Strukturen

#region do until
$x=-1

do
{
 write-host "nochmal" 
}
until ($x -gt 0)
#endregion
#region do while
$x=-1

do
{
    write-host "nochmal"  
}
while ($x -gt 0)
#endregion
#region switch/swtich -wildcard
switch ($x)
{
    'value1' {}
    {$_ -in 'A','B','C'} {}
    'value3' {}
    Default {}
}


$computer = "LON-CL1"

$role = "unknown role"
$location = "unknown location"

Switch -wildcard ($computer) {
    "*-CL*" {$role = "client"}
    "*-SRV*" {$role = "server"}
    "*-DC*" {$role = "domain controller"}
    "LON-*" {$location = "London"}
    "VAN-*" {$location = "Vancouver"}
    Default {"$computer is not a valid name"}
}

Write-Host "$computer is a $role in $location"
#endregion
#region while
while ($x -gt 0)
{
    
}
#endregion
#region for
$i=0

for ($i = 1; $i -lt 29; $i++)
{ 
    write-output $i
    $i=$i+2
}
#endregion

#region Foreach
$serviceCollection =(get-service)[0..12]

foreach ($einzelservice in $serviceCollection)
{
    write-output "Der Service $($einzelservice.name) `hat den Status: $($einzelservice.status) und den Starttype: $($einzelservice.starttype)"
}
#endregion

#endregion


# Anwenden der LCMConfig für den Computer Localhost
Set-DscLocalConfigurationManager -Path .\LCMConfig -ComputerName localhost
Get-DscLocalConfigurationManager

# Starten der Configuration FileandPrint 
Start-DscConfiguration -Path C:\FileAndPrint -Wait -Verbose -Force

#Überberprüfen der Configuration FileandPrint für Computer LON-SVR2
Invoke-Command -ScriptBlock {
    Get-WindowsFeature -Name print-server,fs-data-deduplication,bits
} -ComputerName LON-SVR2


###################################################################
# PS51-PowerShell - Mein erstes Skript
# Mein erstes Modul
 
#region Wo liegen meine Module
$env:PSModulePath
$env:PSModulePath.Split(";")
$env:PSModulePath.Split(";")[2]
 
$ModulePath = $PSHome + "\Modules\"
 
Set-Location -Path $ModulePath
Get-ChildItem
#endregion
 
#region "MyModule" Ordner erstellen und Funktion kopieren
New-Item -Path $ModulePath -Name MyModule -ItemType directory 
 
#Beim verschieben wird "GET-REMEvent.ps1" zu "MyModule.psm1"
Copy-Item -Path .\GET-REMEvent.ps1 `
          -Destination "$ModulePath\MyModule\MyModule.psm1"
 
Get-ChildItem -Path "$ModulePath\MyModule"
 
#Import "MyModule"
Import-Module -Name MyModule
 
#endregion
 
 

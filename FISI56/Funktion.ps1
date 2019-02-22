###################################################################
# PS51-PowerShell - Mein erstes Skript
# Funktion 
 
#region Ein einfacher Befehl
Get-EventLog -LogName Security -ComputerName SurfacePro3 |
    Where-Object -Property EventID -EQ -Value 4624 |
        Select-Object -First 10 
#endregion
 
#region Werte indentifizieren die sich aendern koennen
$ComputerName
$EventID
 
Get-EventLog -LogName Security -ComputerName $ComputerName |
    Where-Object -Property EventID -EQ -Value $EventID |
        Select-Object -First 10 
#endregion
 
#region Variablen deklarieren 
[String]$ComputerName
[int]$EventID = 4624
 
Get-EventLog -LogName Security -ComputerName $ComputerName |
    Where-Object -Property EventID -EQ -Value $EventID |
        Select-Object -First 10 
#endregion
 
#region Variable werden zu Parameter
Param (
    [String]$ComputerName,
    [int]$EventID = 4624
        )
 
Get-EventLog -LogName Security -ComputerName $ComputerName |
    Where-Object -Property EventID -EQ -Value $EventID |
        Select-Object -First 10 
#endregion
 
#region ComputerName wird "Mandatory"
Param (
    [Parameter(Mandatory=$true)]
    [String]$ComputerName,
 
    [int]$EventID = 4624
        )
 
Get-EventLog -LogName Security -ComputerName $ComputerName |
    Where-Object -Property EventID -EQ -Value $EventID |
        Select-Object -First 10 
#endregion
 
#region Hilfeinformationen fuer unser Skript
<#
 
.SYNOPSIS
Ruft Events mi einer bestimmten ID ab.
 
.DESCRIPTION
Sie koennen Events von einem Remote Computer abrufen. 
 
.PARAMETER ComputerName
The name of the computer to query.
 
.EXAMPLE
.\Event4624.ps1 -ComputerName LON-DC1 -EventID 4624
 
.LINK
www.Microsoft.com
 
.NOTES
Get-Help -Name about_Comment_Based_Help -ShowWindow
Zeigt den Aufbau einer solchen Hilfe.
 
#>
Param (
    [Parameter(Mandatory=$true)]
    [String]$ComputerName,
 
    [int]$EventID = 4624
        )
 
Get-EventLog -LogName Security -ComputerName $ComputerName |
    Where-Object -Property EventID -EQ -Value $EventID |
        Select-Object -First 10 
#endregion
 
#region "Verbose" und "Debugging" Meldungen hinzufuegen 
<#
 
.SYNOPSIS
Ruft Events mi einer bestimmten ID ab.
 
.DESCRIPTION
Sie koennen Events von einem Computer abrufen. 
 
.PARAMETER ComputerName
The name of the computer to query.
 
.EXAMPLE
.\Event4624.ps1 -ComputerName LON-DC1 -EventID 4624
 
.LINK
www.Microsoft.com
 
.NOTES
Get-Help -Name about_Comment_Based_Help -ShowWindow
Zeigt den Aufbau einer solchen Hilfe.
 
#>
 
Param (    
    [Parameter(Mandatory=$true)]
    [String]$ComputerName,
 
    [int]$EventID = 4624
        )
 
Write-Verbose -Message "Die Verbindung wird aufgebaut."
Write-Verbose -Message "Die Events werden abgerufen."
 
Write-Debug -Message "Die Verbindung wird aufgebaut."
Write-Debug -Message "Die Events werden abgerufen."
 
Get-EventLog -LogName Security -ComputerName $ComputerName |
    Where-Object -Property EventID -EQ -Value $EventID |
        Select-Object -First 10 
#endregion
 
#region Das Skript wird zur Funktion
<#
 
.SYNOPSIS
Ruft Events mit einer bestimmten ID ab.
 
.DESCRIPTION
Sie koennen Events von einem Computer abrufen. 
 
.PARAMETER ComputerName
The name of the computer to query.
 
.EXAMPLE
Get-REMEvent -ComputerName LON-DC1 -EventID 4624
 
.LINK
www.Microsoft.com
 
.NOTES
Get-Help -Name about_Comment_Based_Help -ShowWindow
Zeigt den Aufbau einer solchen Hilfe.
 
#>
 
function Get-REMEvent {
Param (    
    [Parameter(Mandatory=$true)]
    [String]$ComputerName,
 
    [int]$EventID = 4624
        )
 
Write-Verbose -Message "Die Verbindung wird aufgebaut."
Write-Verbose -Message "Die Events werden abgerufen."
 
Write-Debug -Message "Die Verbindung wird aufgebaut."
Write-Debug -Message "Die Events werden abgerufen."
 
Get-EventLog -LogName Security -ComputerName $ComputerName |
    Where-Object -Property EventID -EQ -Value $EventID |
        Select-Object -First 10 
}
#endregion
 
 

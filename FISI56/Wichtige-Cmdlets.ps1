










###################################################################
# PS50-PowerShell Grundlagen
# Wichtige Cmdlets

# 1.) Get-Command
Get-Command
Get-Command -Verb Get
Get-Command -Verb Get -Noun Services #Kein Ergebniss. Das Noun ist immer Singular
Get-Command -Verb Get -Noun Service

Get-Command
Get-Command -Module PackageManagement
Get-Command -Module PackageManagement -Verb Find
Get-Command -Module PackageManagement -Verb Find -Noun *Provider

Get-Command
Get-Command -Verb Get
Get-Command -Verb Get -Noun *Event*
Get-Command -Verb Get -Noun *Event*log* -Syntax

# 2.) Get-Help
man
help

Get-Command
Get-Command -Verb Get
Get-Command -Verb Get -Noun Help

#PowerShell Hilfe Updaten oder Speichern
Update-Help -Force

Save-Help -DestinationPath \\LON-DC1\Share\PSHelp -Credential Adatum\Administrator
Update-Help -SourcePath \\LON-DC1\Share\PSHelp -Credential Adatum\Administrator

#Mit der PowerShell Hilfe arbeiten.
Get-Help -Name Get-EventLog
Get-Help -Name Get-EventLog -ShowWindow
Get-Help -Name Get-EventLog -Examples
Get-Help -Name Get-EventLog -Online

###################################################################
#region Übung 1 - Hello World!                                    
# Suchen sie ein Cmdlet um den String "Hello World!" auszugeben!  

#Moeglichkeit 1
echo "Hello World!" 
echo "Hello World!" | Get-Member
Get-Alias -Name echo

#Moeglichkeit 2
Get-Command 
Get-Command -Verb Write
Get-Command -Verb Write -Noun Host

Get-Help -Name Write-Host -ShowWindow

Write-Host -Object "Hello World!"
Write-Host -Object "Hello World!" | Get-Member #Error - Write-Host gibt kein Objekt wieder.

#Möglichkeit 3
Get-Command 
Get-Command -Verb Write
Get-Command -Verb Write -Noun Output

Get-Help -Name Write-Output -ShowWindow
Write-Output -InputObject "Hello World!"
Write-Output -InputObject "Hello World!" | Get-Member

#endregion 

###################################################################
#region Übung 2 - Netzwerkkonfiguration!
# Lassen Sie sich die lokalen Netzwerkkonfigurationen anzeigen.

#Moeglichkeit 1
Get-Command 
Get-Command -Verb Get
Get-Command -Verb Get -Noun *ip*

Get-Help -Name Get-NetIPAddress -ShowWindow
Get-NetIPAddress

#Moeglichkeit 2
Get-Command 
Get-Command -Verb Get
Get-Command -Verb Get -Noun *ip*

Get-Help -Name Get-NetIPConfiguration -ShowWindow
Get-NetIPConfiguration

#endregion

#Hilfedateien richtig lesen
#
# Get-EventLog [-LogName] <String> [[-InstanceId] <Int64[]>] [-After <DateTime>] [-AsBaseObject] [-Before <DateTime>] [-ComputerName <String[]>] 
# [-EntryType {Error | Information | FailureAudit | SuccessAudit | Warning}] [-Index <Int32[]>] [-Message <String>] [-Newest <Int32>] 
# [-Source <String[]>] [-UserName <String[]>] [<CommonParameters>]
#
# Mandatory Parameters:      -LogName <String>
# Optional Parameters:       [-Newest <Int32>]
# Positional Parameters:     [-LogName] <String>
# Single Parameter Value:    <String>
# Multiple Parameter Values: <String[]>
# Switch:                    [-AsBaseObject]
# Stativ Values:             [-EntryType {Error | Information | FailureAudit | SuccessAudit | Warning}]
 
#Was sind "About" Files?
Get-Help -Name about*
Get-Help -Name about_Aliases
Get-Help -Name about_Aliases -ShowWindow

Get-Help -Name about*
Get-Help -Name about_Variables
Get-Help -Name about_Variables -ShowWindow

Get-Help -Name about*
Get-Help -Name about_Comment_Based_Help
Get-Help -Name about_Comment_Based_Help -ShowWindow

# 3.) Get-Member
Get-Command
Get-Command -Verb Get
Get-Command -Verb Get -Noun Member

Get-Help -Name Get-Member
Get-Help -Name Get-Member -ShowWindow

#Beispiel 1 aus der Hilfe
Get-Service | Get-Member
Get-Process | Get-Member

Write-Output -InputObject "Hello World!" | Get-Member #System.String
Write-Host -Object "Hello World!" | Get-Member #Error - Write-Host gibt kein Objekt wieder.

Get-VM -Name *Cl01
Get-VM -Name *Cl01 | Get-Member #Microsoft.HyperV.PowerShell.VirtualMachine
(Get-VM -Name *Cl01).NetworkAdapters
(Get-VM -Name *Cl01).NetworkAdapters | Get-Member #Microsoft.HyperV.PowerShell.VMNetworkAdapter
((Get-VM -Name *Cl01).NetworkAdapters).IPAddresses 
((Get-VM -Name *Cl01).NetworkAdapters).IPAddresses  | Get-Member #System.String

###################################################################
#region Übung 3 - Eigenschaften von einem Datum!                                    
# Welche Eigenschaften hat ein Objekt vom "TypeName: System.DateTime" ? 
Get-Command
Get-Command -Verb Get
Get-Command -Verb Get -Noun *Date*

Get-Help -Name Get-Date -ShowWindow 
Get-Date
Get-Date | Get-Member
<# 
DisplayHint          NoteProperty   DisplayHintType DisplayHint=DateTime                                                                         
Date                 Property       datetime Date {get;}                                                                                         
Day                  Property       int Day {get;}                                                                                               
DayOfWeek            Property       System.DayOfWeek DayOfWeek {get;}                                                                            
DayOfYear            Property       int DayOfYear {get;}                                                                                         
Hour                 Property       int Hour {get;}                                                                                              
Kind                 Property       System.DateTimeKind Kind {get;}                                                                              
Millisecond          Property       int Millisecond {get;}                                                                                       
Minute               Property       int Minute {get;}                                                                                            
Month                Property       int Month {get;}                                                                                             
Second               Property       int Second {get;}                                                                                            
Ticks                Property       long Ticks {get;}                                                                                            
TimeOfDay            Property       timespan TimeOfDay {get;}                                                                                    
Year                 Property       int Year {get;}                                                                                              
DateTime             ScriptProperty System.Object DateTime {get=if ((& { Set-StrictMode -Version 1; $this.DisplayHint }) -ieq  "Date")...        
#>
#endregion
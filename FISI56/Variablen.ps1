







###################################################################
# PS51-PowerShell - Mein erstes Skript
# Variablen
 
#Using Variables
Get-Command
Get-Command -Noun *Variab*
Get-Command -Noun *Variab* -Verb New
 
Get-Help -Name New-Variable -ShowWindow
 
#Variablen definieren
#Moeglichkeit 1
New-Variable -Name VorName -Value "Peter"
$VorName
$VorName | Get-Member
 
#Moeglichkeit 2
$NachName = "Lustig"
$NachName
$NachName  | Get-Member
 
#Moeglichkeit 3
[String]$IPv4 = "192.168.0.10"
$IPv4 
$IPv4 | Get-Member
 
[int32]$TelNummer = "7113333"
$TelNummer
 
#Moeglichkeit 4
Write-Output -InputObject "Managers" -OutVariable Abteilung
$Abteilung 
$Abteilung | Get-Member
 
 
#Variablen und Objekte
$Service = Get-Service
$Service 
$Service | Get-Member
 
Get-Service -Name BITS
Stop-Service -Name BITS
$BITS = Get-Service -Name BITS 
$BITS #Stopped
$BITS | Start-Service

###################################################################
#region Übung 1 - Hello $Name!                                    
# Lesen Sie einen Namen ein und geben Sie folgenden Satz aus! 
# Beispiel:
# Geben Sie Ihren Namen ein: Jochen 
# Hallo Jochen !

#Moeglichkeit 1
Get-Command 
Get-Command -Verb Read
Get-Command -Verb Read -Noun Host

Get-Help -Name Read-Host -ShowWindow

Get-Command 
Get-Command -Verb Write
Get-Command -Verb Write -Noun Output

Get-Help -Name Write-Output -ShowWindow

$Name = Read-Host -Prompt "Geben Sie Ihren Namen ein" 
Write-Output -InputObject "Hallo $Name !"

#endregion 
 
#Arrays
#Moeglichkeit 1
$service = Get-Service | Select-Object -First 5
$service
$service[0]
$service[1]
$service[2]
$service[3]
$service[4]
 
#New-Item -Path C:\TEMP -ItemType Directory
#$Namen = "Vorname","Hans","Thomas","Michael","Jochen" 
#$Namen | Out-File -FilePath C:\TEMP\Mitarbeiter.csv
$ImportNamen = Import-Csv -Path C:\TEMP\Mitarbeiter.csv
$ImportNamen
$ImportNamen[0]
$ImportNamen[1]
$ImportNamen[2]
 
#Moeglichkeit 2
[String[]]$StringArray = "Lisa","Peter"
$StringArray
 
[int32[]]$int32Array = "11","22","33"
$int32Array
 
[int32[]]$int32Array = "11","Peter","33" #Error - Ein int32 Array kann keine Buchstaben speichern
 
#Indexnummer anzeigen lassen
#$service = Get-Service
#$count   = $service.count
#for ($s = 0 ; $s -le $count ; $s++) 
#{ $service[$s] | Select-Object -Property Status,DisplayName,@{n="Index";e={$s}} }
 
#Arbeiten mit Variablen
Read-Host -Prompt "Wie lautet Ihr Name?"
$ReadName = Read-Host -Prompt "Wie lautet Ihr Name?"
$ReadName
Write-Output -InputObject "Hallo $ReadName!"
Write-Output -InputObject "In der Variable $ReadName steht der Wert: $ReadName"
Write-Output -InputObject ('In der Variable $ReadName steht der Wert: ' + "$ReadName")
Write-Output -InputObject ('In der Variable $ReadName steht der Wert: "' + "$ReadName" + '"!')
Write-Output -InputObject ('In der Variable $ReadName steht der Wert: ' + """$ReadName""")
 
###################################################################
#region Übung 2 - Mein lieblings Dienst
#Lassen Sie den Satz "Der Dienst [Dienst Nr. 5] ist toll" anzeigen
$ServiceArray = Get-Service
$ServiceArray
$ServiceArray[5]
Write-Output -InputObject "Der Dienst $ServiceArray ist toll"
Write-Output -InputObject "Der Dienst $ServiceArray[5].name ist toll" 
 
#Moeglichkeit 1
$ServiceArray = Get-Service
$ServiceArray
$ServiceArray5 = $ServiceArray[5].Name
Write-Output -InputObject "Der Dienst $ServiceArray5 ist toll" 
 
#Moeglichkeit 2
$ServiceArray = Get-Service
$ServiceArray
Write-Output -InputObject "Der Dienst $($ServiceArray[5].Name) ist toll!" 
 
#Moeglichkeit 3
$ServiceArray = Get-Service
$ServiceArray
Write-Output -InputObject ("Der dienst {0} ist toll" -f $service[5].Name)
Write-Output -InputObject ("Der dienst {5} ist toll" -f $service.Name)
#endregion
 
#Rechnen mit Variablen
$zehn = 10
$acht = 8
 
$zehn | Get-Member
 
$zehn + $acht
$zehn - $acht
$zehn * $acht
$zehn / $acht
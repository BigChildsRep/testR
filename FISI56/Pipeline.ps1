###################################################################
# PS50-PowerShell Grundlagen
# Pipeline

Get-Service
Get-Service -Name BITS
Get-Service -Name BITS | Stop-Service
Get-Service -Name BITS | Start-Service

#Format Cmdlets
Get-Command -Verb Format

Get-Service
Get-Service | Format-Wide
Get-Service | Format-Wide -AutoSize
Get-Service | Format-Wide -Column 5 

Get-Service
Get-Service | Format-List 
Get-Service | Format-List -Property DisplayName,Status

Get-Service
Get-Service | Format-Table -Property DisplayName,Status
Get-Service | Format-Table -Property DisplayName,Status -AutoSize
Get-Service | Format-Table -Property DisplayName,Status -AutoSize -Wrap

#Eigene Eigenschaften
Get-Service
Get-Service | Format-Table -Property Status,Name
Get-Service | Format-Table -Property Status,Name,@{L='Hello';E={"World"}}

###################################################################
#region Übung 1 - Tag des Jahres!                                    
# Lassen Sie das aktuelle Datum mit Uhrzeit und den Tag des Jahres in einer Tabelle ausgeben!  
Get-Command
Get-Command -Verb Get
Get-Command -Verb Get -Noun *Date*

Get-Help -Name Get-Date -ShowWindow 
Get-Date
Get-Date | Get-Member
Get-Date | Format-Table -Property DayOfYear,DateTime

#endregion 

#Ausgabe sortieren und gruppieren
Get-Service 
Get-Service | Format-Table -Property Status,Name
Get-Service | Format-Table -Property Status,Name -AutoSize 
Get-Service | Format-Table -Property Status,Name -AutoSize -Wrap
Get-Service | Format-Table -Property Status,Name -AutoSize -Wrap -GroupBy Status

Get-Service
Get-Service | Sort-Object -Property Status
Get-Service | Sort-Object -Property Status -Descending

Get-Service | Sort-Object -Property Status | Format-Table -Property Name,Status -AutoSize -Wrap -GroupBy Status
Get-Service | Sort-Object -Property Status | Format-Table -Property Name -AutoSize -Wrap -GroupBy Status
Get-Service | Sort-Object -Property Status | Format-Table -Property Name -AutoSize -Wrap -GroupBy Status | Get-Member
Get-Service | Sort-Object -Property Status | Format-Table -Property Name -AutoSize -Wrap -GroupBy Status | Out-File -FilePath C:\TEMP\Group-Service.txt

#Bestimmte Eigenschaften eines Objekts auswählen
Get-Service
Get-Service | Select-Object -Property Name,Status
Get-Service | Select-Object -Property Name,Status -First 5
Get-Service | Select-Object -Property Name,Status -Last 5
Get-Service | Select-Object -Property Name,Status -Skip 100

Get-VM -Name *CL1
Get-VM -Name *CL1 | Get-Member
Get-VM -Name *CL1 | Select-Object -Property *
Get-VM -Name *dc1 | Select-Object -ExpandProperty NetworkAdapters
(Get-VM -Name *DC1).select() 

#Select oder Format?
Get-Service
Get-Service | Select-Object -Property Name,Status 
Get-Service | Select-Object -Property Name,Status | Get-Member

Get-Service 
Get-Service | Format-Table -Property Name,Status
Get-Service | Format-Table -Property Name,Status | Get-Member

#Einfaches filtern
Get-Command -Verb Where
Get-Help -Name Where-Object -ShowWindow
get-help about_operators -ShowWindow

Get-Service | Where-Object -Property Status -EQ -Value "Running" 
gsv | where Status -EQ Running
gsv | ? Status -EQ Running

#Erweitertes filtern mit mehreren Bedingungen
Get-Service | Where-Object -FilterScript { $_.Status -eq "Running" }
Get-Service | Where-Object -FilterScript { $PSItem.Status -eq "Running" }

Get-Service | Where-Object -FilterScript { $PSItem.Status -eq "Running" -and $_.Name -like "*ss"}
Get-Service | Where-Object -FilterScript { $PSItem.Status -eq "Running" -and $_.Name -like "*ss"}

#Ausgabe formatieren und umleiten
Get-Process 
Get-Process | Format-Table -Property Name,Status | Out-File -FilePath C:\Process.txt
Get-Process | Format-Table -Property Name,Status | Out-Host

#Was ist Out-GridView
notepad
Get-Process
Get-Process | Out-GridView
Get-Process | Out-GridView -PassThru | Stop-Process
Get-Process | Select-Object -Property * | Out-GridView

# 10 mal CMD starten und dann alle CMD Processes 
# bis auf den letzten schließen
#
for ($i = 1; $i -lt 10; $i++) {
    Start-Process cmd
}

Get-Process -Name cmd | Sort-Object id |Select-Object -SkipLast 1 |Stop-Process
(Get-Process -Name cmd | Sort-Object id |Select-Object -SkipLast 1 ).kill()

Get-Process -Name cmd | Sort-Object id -Descending |Select-Object -skip 1

$all=(get-process -name cmd |Sort-Object id )
$all[0..($all.length-1)]| stop-process 

Get-Process | Get-Member | Out-GridView

notepad
Get-Process 
Get-Process | Out-GridView
Get-Process | Out-GridView -PassThru -OutVariable notepad 
$notepad
$notepad | Get-Member

#Was bedeutet "ByValue" und "ByPropertyName"
#Cmdlets akzeptieren nur Eingaben, wenn sie einem Parameter zugeordnet werden koennen.
#ByValue
Notepad
Get-Process -Name notepad
Get-Process -Name notepad | Stop-Process #Hidden Parameter "-InputObject <Process[]>"
Get-Help -Name Stop-Service -ShowWindow 

Notepad
Get-Process -Name notepad | Stop-Service #Error - Stop-Service erwartet bei seinem Parameter "-InputObject" ein Objekt vom Typ "<ServiceController[]>"
Get-Help -Name Stop-Process -ShowWindow

Get-Process -Name notepad | Get-Member

#Manuell einen Parameter ueberschreiben
Get-Help -Name Get-Service -ShowWindow #Der Parameter "-Name" erwartet ein Objekt vom Typ "<String[]>" (ByValue)
Get-Content -Path C:\TEMP\Service-BITS.txt 
Get-Content -Path C:\TEMP\Service-BITS.txt | Get-Member
Get-Content -Path C:\TEMP\Service-BITS.txt | Get-Service
Get-Content -Path C:\TEMP\Service-BITS.txt | Get-Service -Name *ss #Error

#Object und PSObject
Get-Command -ParameterName InputObject
Get-Help -Name Select-Object -ShowWindow


#ByPropertyName
#Besorgen sie von allen Servern im AD die Dienste
Get-Help -Name Get-Service -ShowWindow #Get-Service accept "-ComputerName <String[]>" Values (ByPropertyName)

Get-ADComputer -Filter *
Get-ADComputer -Filter * | Get-Member #Es gibt keine Eigenschaft mit dem Namen "ComputerName"

#Also muessen wir uns eine Custom Property bauen, in der "ComputerName = $_.Name"
Get-ADComputer -Filter * | 
    Select-Object -Property @{n="ComputerName" ; e={$_.Name}} | 
        Get-Service -Name *

Get-Content -Path C:\Users\administrator.ADATUM\Desktop\Name.txt | 
    Select-Object -Property @{n="ComputerName" ; e={$_}} | 
        Get-Service -Name *
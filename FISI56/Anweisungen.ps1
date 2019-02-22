###################################################################
# PS51-PowerShell - Mein erstes Skript
# Anweisungen
 
#STRG + J

#region Snippets
#Erzeugt wird "$Home\Documents\WindowsPowerShell\Snippets\Custom Property.snippets.ps1xml"

New-IseSnippet -Title "Custom Property" -Description "Eine eigne Eigenschaft"  -Text '

#Beispiel 1
Get-Service | 
    Select-Object -Property Status,Name,@{ Label="Hello" ; Expression={ "World 1" } }

#Beispiel 2
Get-Service | 
    Select-Object -Property Status,Name,@{ L="Hello" ; E={ "World 2" } }

#Beispiel 3
Get-Service | 
    Select-Object -Property Status,Name,@{ N="Hello" ; E={ "World 3" } }
'
#endregion
 
#region "If" Konstrukt
#Wenn die Bedingung erfuellt wird, wird der Scriptblock ausgefuehrt
#Erfuellt
$drei = 3
$zehn = 10
if ($zehn -gt $drei)
    { Write-Output -InputObject "Erfuellt" }
 
Write-Output -InputObject "Weiter gehts!"
 
#Nicht erfuellt
$drei = 3
$zehn = 10
if ($zehn -gt $drei)
    { Write-Output -InputObject "Erfuellt" }
 
Write-Output -InputObject "Weiter gehts!"
#endregion
 
#region "If-else" Konstrukt
$zehn = 10
$drei = 3
if ($zehn -gt $drei)
    { Write-Output -InputObject "Erfuellt" }
else
    { Write-Output -InputObject "Nicht erfuellt" }
 
Write-Output -InputObject "Weiter gehts!"
#endregion
 
#region "Switch" Konstrukt
$Eingabe = Read-Host -Prompt "Geben Sie eine Zahl zwischen 1 und 5 ein"
switch ($Eingabe)
    {
        '1' {Write-Output -InputObject "Fach 1"}
        '2' {Write-Output -InputObject "Fach 2"}
        '3' {Write-Output -InputObject "Fach 3"}
        '4' {Write-Output -InputObject "Fach 4"}
        '5' {Write-Output -InputObject "Fach 5"}
        Default  {Write-Output -InputObject "Eingabe ungueltig"}
    }   
 
#Beispiel
Clear-Host
Write-Output -InputObject '########### Dienste ############'
Write-Output -InputObject '# 1.) Alle laufenden Dienste   #'
Write-Output -InputObject '# 2.) Alle gestoppten Diensten #'
Write-Output -InputObject '# 3.) Alle Dienste             #'
Write-Output -InputObject '################################'
 
$Menue = Read-Host -Prompt "Geben Sie eine Zahl zwischen 1 und 3 ein"
switch ($Menue)
    {
        '1' { Get-Service | Where-Object -Property Status -eq "Running" }
        '2' { Get-Service | Where-Object -Property Status -eq "Stopped" }
        '3' { Get-Service }
        Default  {Write-Output -InputObject "Eingabe ungueltig"}
    }
#endregion
 
#region "ForEach" Schleife
$Namen = "Hans","Thomas","Michael","Jochen" 
$Namen | ForEach-Object -Process { Write-Output -InputObject "Hallo Welt $_!" }
 
#endregion
 
#region "For" Schleife
#for (Anfang ; Bedingung ; Schrittweite) { … }
for ($i = 0 ; $i -lt 10 ; $i++)
{ 
  Write-Output -InputObject "Hallo Welt $i!"  
}
#endregion
 
#region "do-while" Schleife
#Schreibe "Hello World", solange $whileZahl kleinergleich 5 ist
$whileZahl = 1
do
{
   Write-Output -InputObject "Hello World $whileZahl"
   $whileZahl++ 
}
while ($whileZahl -le 5) 
#endregion
 
#region "do-until" Schleife
#Schreibe "Hello World", bis $whileZahl -lt 5 ist
$untilZahl = 1
do
{
   Write-Output -InputObject "Hello World $untilZahl"
   $untilZahl++    
}
until ($untilZahl -eq 5)
#endregion
 
 

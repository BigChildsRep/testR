###################################################################
# PS15-PowerShell Bootcamp
# Syntax

#Alte Befehle und neue Aliase
cd
Get-Alias -Name cd    #Set-Location

dir
Get-Alias -Name dir   #Get-ChildItem

ls
Get-Alias -Name ls    #Get-ChildItem

cat
Get-Alias -Name cat   #Get-Content

type
Get-Alias -Name type  #Get-Content

#Was ist ein Cmdlet?
 Get-Service
#Verb-Noun

Get-Service -Name BITS
Get-Service -Name BITS,RpcSs
Get-Service -Name BITS,RpcSs -ComputerName LON-DC1

Get-Service      -Name           BITS             -ComputerName   LON-DC1
#CommandName    #ParameterName  #ParameterValue  #ParameterName  #ParameterValue 
#Cmdlet         #|---------Parameter 1---------| #|---------Parameter 2---------|
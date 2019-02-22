#########################################################
# This is a JEA configuration script to create and register a
# skeleton Role Capability File and a skeleton Session Configuration File
#
# Used in the Session 'Securing your infrastructure with JEA'
#
# Author: Miriam Wiesner
# Creation date: 13.04.2018
# Version: 1.0.0

#########################################################
New-Item -Path c:\JEA-Test -ItemType Directory

#Demonstration of skeleton config files
New-PSRoleCapabilityFile -Path c:\JEA-Test\PSRoleCapabilityFile.psrc 
powershell_ise.exe c:\JEA-Test\PSRoleCapabilityFile.psrc

New-PSSessionConfigurationFile -Path c:\JEA-Test\PSSessionConfigurationFile.pssc
powershell_ise.exe C:\JEA-Test\PSSessionConfigurationFile.pssc

Remove-Item C:\JEA-Test\* 
Remove-Item C:\JEA-Test\
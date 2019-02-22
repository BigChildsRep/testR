#########################################################
# This is a JEA preparation script
# Used in the Session 'Securing your infrastructure with JEA'
#
# Author: Miriam Wiesner
#
# Creation date: 13.04.2018
# Version: 1.0.0

#########################################################

#Import-Modules
import-module servermanager
Add-WindowsFeature -Name "RSAT-AD-PowerShell" -IncludeAllSubFeature
Import-Module ActiveDirectory
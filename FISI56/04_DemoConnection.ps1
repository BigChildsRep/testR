#########################################################
# This is a JEA configuration script demonstrate the session configuration
#
# Used in the Session 'Securing your infrastructure with JEA'
#
# Author: Miriam Wiesner
# Creation date: 13.04.2018
# Version: 1.0.0

####################### VARIABLES #######################
# Domain
$DomainName = (Get-WmiObject -Class Win32_ComputerSystem).Domain
$DomainNetbiosName = (Get-WmiObject -Class Win32_NTDomain -Filter "DnsForestName = '$DomainName'").DomainName

# AccountNames
$Operator = "$DomainNetbiosName\Operator"

###################TEST THE CONFIGURATION################

# Display the endpoint
Get-PSSessionConfiguration -Name Operator

# Connect to JEA Operator PS-Session
Enter-PSSession –ComputerName localhost –ConfigurationName Operator -Credential $Operator
Enter-PSSession –ComputerName dc01 –ConfigurationName Operator -Credential $Operator

# Test the session
get-aduser vicvega
get-adcomputer -Identity srv01
restart-service Dnscache
restart-service Dhcp
restart-service Dhcp -force
start-service dhcp
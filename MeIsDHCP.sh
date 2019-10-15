#!/bin/bash
#
###############################################################################################################################################
#
# ABOUT THIS PROGRAM
#
#   This Script is designed for use in JAMF
#
#   - This script will ...
#		Take The Supplied DHCP Client ID Suffix
#		Cycle through all Network adapters and set the DHCP Client ID of any Ethernet or WiFi Named Adapters
#		The the Mac Address of that Adapter followed by a Dash and then the supplied suffix eg. 1234567890-Suffix
#		This has to be done this way, as the Client ID presents itself as the Unique ID to a Windows DHCP Server
#		Using the suffix only would identify all machines doing this as the same and would produce clashes.
#
###############################################################################################################################################
#
# HISTORY
#
#	Version: 1.1 - 15/10/2019
#
#	- 25/09/2019 - V1.0 - Created by Headbolt
#
#   - 15/10/2019 - V1.1 - Updated by Headbolt
#							More comprehensive error checking and notation
#
###############################################################################################################################################
#
# DEFINE VARIABLES & READ IN PARAMETERS
#
###############################################################################################################################################
#
# Grab the DHCP Client ID suffix to add from JAMF Variable #4 eg. clientID
# Sets DHCP ID to Mac-Address followed by - and this variable eg. 1234567890-Suffix
IDtoAdd=$4
# Set the name of the script for later logging
ScriptName="append prefix here as needed - Set DHCP Client ID on Ethernet and WiFi Adapters"
#
# Read in List of Network Adapter Names
# This is done by listing all ports
# Selecting only the lines with names, eg Hardware Ports
# Then cutting off "Hardware Port: " from the beginning of the text 
PortList=$(networksetup -listallhardwareports | grep "Hardware Port:" | cut -c 16-)
#
###############################################################################################################################################
#
# SCRIPT CONTENTS - DO NOT MODIFY BELOW THIS LINE
#
###############################################################################################################################################
#
# Defining Functions
#
###############################################################################################################################################
#
# Section End Function
#
SectionEnd(){
#
# Outputting a Blank Line for Reporting Purposes
/bin/echo
#
# Outputting a Dotted Line for Reporting Purposes
/bin/echo  -----------------------------------------------
#
# Outputting a Blank Line for Reporting Purposes
/bin/echo
#
}
#
###############################################################################################################################################
#
# Script End Function
#
ScriptEnd(){
#
# Outputting a Blank Line for Reporting Purposes
#/bin/echo
#
/bin/echo Ending Script '"'$ScriptName'"'
#
# Outputting a Blank Line for Reporting Purposes
/bin/echo
#
# Outputting a Dotted Line for Reporting Purposes
/bin/echo  -----------------------------------------------
#
# Outputting a Blank Line for Reporting Purposes
/bin/echo
#
}
#
###############################################################################################################################################
#
# End Of Function Definition
#
###############################################################################################################################################
#
# Beginning Processing
#
###############################################################################################################################################
#
# Outputting a Blank Line for Reporting Purposes
/bin/echo
#
SectionEnd
#
/bin/echo Checking Adapters and adding DHCP Client ID to Ethernet and Wi-Fi Adapters
/bin/echo
/bin/echo ID Added will be Adapters Mac-Address plus $IDtoAdd
SectionEnd
#
while IFS= read -r Port
	do 
		# Cycle through any Adapaters with "Ethernet" in the name
		if [[ $Port == *"Ethernet"* ]]
			then
				# Look at the info for each port, grab the line wih the MAC Address (Ethernet Address)
				# and cut "Ethernet Address: " from the beginning
				EthernetAddress=$(networksetup -getinfo "${Port}" | grep "Ethernet Address" | cut -c 19-)
				# Now remove the : characters from the string.
				EthernetAddressFormatted=$(echo "${EthernetAddress//:}")
				# Set the DHCP ID to add to be the Mac Address with a dash and the supplied suffix
				DHCPID=$EthernetAddressFormatted-$IDtoAdd
				#
                /bin/echo Adapter '"'$Port'"' found
                /bin/echo Running Command '"'networksetup -setdhcp $Port $DHCPID'"'
                networksetup -setdhcp $Port $DHCPID
                #
                SectionEnd
		fi
        # Cycle through any Adapaters with "Wi-Fi" in the name
		if [[ $Port == *"Wi-Fi"* ]]
			then
				# Look at the info for each port, grab the line wih the MAC Address (Wi-Fi ID)
				# and cut "Wi-Fi ID: " from the beginning
				WiFiID=$(networksetup -getinfo "${Port}" | grep "Wi-Fi ID" | cut -c 14-)
				# Now remove the : characters from the string.
				WiFiIDFormatted=$(echo "${WiFiID//:}")
				# Set the DHCP ID to add to be the Mac Address with a dash and the supplied suffix
                DHCPID=$WiFiIDFormatted-$IDtoAdd
				#
                /bin/echo Adapter '"'$Port'"' found
                /bin/echo Running Command '"'networksetup -setdhcp $Port $DHCPID'"'
                networksetup -setdhcp $Port $DHCPID
                #
                SectionEnd
		fi
	done <<< "$PortList"
#
ScriptEnd
#
# Inserting a short pause as this process refreshes DHCP Leases,
# and network connections needs time to re-establish before the end of the script,
# otherwise subsequent policy actions will fail.
sleep 5
#
exit 0
#
# End Processing
#
###############################################################################################################################################

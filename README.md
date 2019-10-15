This Script is designed for use in JAMF

This script will ...

Take The Supplied DHCP Client ID Suffix
Cycle through all Network adapters and set the DHCP Client ID of any Ethernet or WiFi Named Adapters
The the Mac Address of that Adapter followed by a Dash and then the supplied suffix eg. 1234567890-Suffix
This has to be done this way, as the Client ID presents itself as the Unique ID to a Windows DHCP Server
Using the suffix only would identify all machines doing this as the same and would produce clashes.

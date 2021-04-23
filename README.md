# Create Zabbix hosts from a CSV file

This script reads the devices.csv and creates the Zabbix hosts.

Mandatory Fields:\
host - hostname\
host - hostgroup\
host - ip

Inventory fields may be added creating a field called "inv - ZABBIX_INVENTORY".\
Example:\
inv - macaddress_b\
inv - notes\
inv - os
  
  (inventory.csv may be consulted for avalaible inventory fields)

Tags may be added creating a field called "tag - TAG_NAME"
Example:
  *tag - TYPE
  *tag - ROOM
  *tag - RACK

Variables may be used using $_VARIABLE_NAME.
The variable has to be added on the variables.csv file.

On the DATA folder there is a devices.csv
Usage: 
Execute the run.ps1 file.

Enter the IP Address or domain of the Zabbix server;
TCP Port;
API admin User;
API admin password;
Protocol, HTTP or HTTPS;

Example

.\run.ps1
Please enter the Zabbix IP or Domain: 192.168.56.1
Please enter the Zabbix TCP Port: 8181
Please enter the Zabbix API username: Admin
Please enter the Zabbix API password: ******
Please enter the Protocol (http | https): https
Authentication successful
Importing Devices List
Importing Devices List
Creating Hosts
Host Created:  net-rtr01-br-core
Host Created:  net-rtr02-br-core
Host Created:  net-rtr03-br-core
Host Created:  switch01


Caveats
* SNMP v3 is currently not supported;





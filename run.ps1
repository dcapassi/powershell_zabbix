Import-Module .\Get-ParametersFromCSV.psm1
Import-Module .\SSLWorkAround.psm1
Import-Module .\Get-Token.psm1


#Get the Zabbix Parameters from the Console
$Token = $null
$Try = 0
$NumberOfRetries = 4
while ($Token -eq $null -and -not ($Try -eq $NumberOfRetries)){

$Ip = Read-Host "Please enter the Zabbix IP or Domain"
$Port = Read-Host "Please enter the Zabbix TCP Port"
$User = Read-Host "Please enter the Zabbix API username"
$Pass = Read-Host "Please enter the Zabbix API password" -AsSecureString
$Protocol =  Read-Host "Please enter the Protocol (http | https)"

$StringPassword = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($Pass))


#Temporary
<#  $Ip = "192.168.56.1"
 $Port = "8181"
 $User = ""
 $StringPassword = ""
 $Protocol = "https" #>

$Token = GetToken -IP $Ip -Port $Port -User $User -StringPassword $StringPassword -Protocol $Protocol
$Try = $Try + 1

}

#If the user did not receive a Token the script ends
if (-not $token){
    exit
}



$devices = Import-Csv -Path ./Data/devices.csv
$variableList = Import-Csv -Path ./Data/variables.csv
$parameters = Get-ParametersFromCSV -elemento $devices[0] -variableList $variableList
Write-Host $parameters | ConvertTo-Json -Depth 4















Import-Module .\GetParams.psm1

$devices = Import-Csv -Path ./Data/devices.csv
$variableList = Import-Csv -Path ./Data/variables.csv

getParameters -elemento $devices[0] -variableList $variableList
getParameters -elemento $devices[1] -variableList $variableList
getParameters -elemento $devices[2] -variableList $variableList
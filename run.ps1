Import-Module .\CsvToJson.psm1

$devices = Import-Csv -Path ./Data/devices.csv
$variableList = Import-Csv -Path ./Data/variables.csv

CsvToJson -elemento $devices[0] -variableList $variableList
CsvToJson -elemento $devices[1] -variableList $variableList
CsvToJson -elemento $devices[2] -variableList $variableList
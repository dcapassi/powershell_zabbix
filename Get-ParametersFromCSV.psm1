function Get-ParametersFromCSV {

    param ($elemento, $variableList)

    $tagsHashTable = @{}
    $inventoryHashTable = @{}
    $hostHashTable = @{}
    $snmpHashTable = @{}
    $includeHost = $true
    $includeSNMP = $true
    $includeInventory = $true
    $includeTags = $true
    $includeTemplate = $true

    function getVariable {

        param ($variableName, $variableList)
    
        $output = $variableName
        foreach ($variable in $variableList) {
            if ($variableName -eq $variable.Variable) {
                $output = $variable.Value
            }
        }
        Write-Output $output
    } 
    

    $hosts = $elemento | Get-Member -Name 'host *'
    foreach ($hostEntry in $hosts) {

        $hostName = $hostEntry.Name
        $hostNameZabbix = $hostName.Remove(0, 7)
        $hostValue = $elemento.$hostName
        $hostValue = getVariable -variableName $hostValue -variableList $variableList


        if (-not $hostValue -eq '') {
            $hostHashTable.add($hostNameZabbix, $hostValue)
        }

    }

    #Checking for Mandatory Fields
    #hostname
    #ip
    #groups

    if ($hostHashTable.'hostname' -eq $null -or 
        ($hostHashTable.'ip' -eq $null -and $hostHashTable.'dns' -eq $null) -or 
        $hostHashTable.'groups' -eq $null) {
        $includeHost = $false

    }
    
    if ($hostHashTable.'templates' -eq $null) {
        $includeTemplate = $false
    }

    $snmps = $elemento | Get-Member -Name 'snmp *'
    
    foreach ($snmp in $snmps) {
    

        $snmpName = $snmp.Name
        $snmpNameZabbix = $snmpName.Remove(0, 7)
        $snmpValue = $elemento.$snmpName
        $snmpValue = getVariable -variableName $snmpValue -variableList $variableList

        ##Check if there is an IP or DNS
        if (-not $snmpValue -eq '') {
            $snmpHashTable.add($snmpNameZabbix, $snmpValue)
        }

    }
    if ($snmpHashTable.'community' -eq $null -or 
        $snmpHashTable.'ip' -eq $null -and 
        $snmpHashTable.'dns' -eq $null) {
            
        $includeSNMP = $false
    }

    $inventories = $elemento | Get-Member -Name 'inv *'
    foreach ($inventory in $inventories) {

        $inventoryName = $inventory.Name
        $inventoryNameZabbix = $inventoryName.Remove(0, 6)
        $inventoryValue = $elemento.$inventoryName
        $inventoryValue = getVariable -variableName $inventoryValue -variableList $variableList


        if (-not $inventoryValue -eq '') {
            $inventoryHashTable.add($inventoryNameZabbix, $inventoryValue)
        }

    }

    if ($inventoryHashTable.count -eq '0') {
        $includeInventory = $false
    }


    $tags = $elemento | Get-Member -Name 'tag *'
    foreach ($tag in $tags) {
    
        $tagName = $tag.Name
        $tagNameZabbix = $tagName.Remove(0, 6)
        $tagValue = $elemento.$tagName
        $tagValue = getVariable -variableName $tagValue -variableList $variableList

        if (-not $tagValue -eq '') {
            $tagsHashTable.add($tagNameZabbix, $tagValue)
        }

    }
    if ($tagsHashTable.count -eq '0') {
        $includeTags = $false
    }
    

    if ($includeHost) {

        $params = @{} 
        $params.Add("hostname", $hostHashTable.hostname)

        if (-not ($hostHashTable.name -eq $null)) {
            $params.Add("host", $hostHashTable.name)
        }

        $interfaces = @()

        $groups = @()
        $templates = @()
        $tags = @()


        $int = @{
            "type"  = 1
            "main"  = 1
            "useip" = 1
            "ip"    = ""
            "dns"   = ""
            "port"  = "10050"
        }

        if ($hostHashTable.ip -eq $null) {
            $int.useip = 0
            $int.dns = $hostHashTable.dns
        }
        else {
            if ($hostHashTable.dns -eq $null) {
                $int.ip = $hostHashTable.ip
            }
            else {
                $int.dns = $hostHashTable.dns
                $int.ip = $hostHashTable.ip
            }
        }

        $interfaces = $interfaces + $int

        if ($includeSNMP) {

            $version = if ($snmpHashTable.version) { $snmpHashTable.version } Else { "2" }

            $snmpInt = @{
                "type"    = 2
                "main"    = 1
                "useip"   = 1
                "ip"      = ""
                "dns"     = ""
                "port"    = "161"
                "details" = @{
                    "version"   = $version
                    "community" = $snmpHashTable.community
                    "bulk"      = 1
                }
            }

            if ($snmpHashTable.ip -eq $null) {
                $snmpInt.useip = 0
                $snmpInt.dns = $snmpHashTable.dns
            }
            else {
                if ($snmpHashTable.dns -eq $null) {
                    $snmpInt.ip = $snmpHashTable.ip
                }
                else {
                    $snmpInt.dns = $snmpHashTable.dns
                    $snmpInt.ip = $snmpHashTable.ip
                }
            }
  
            $interfaces = $interfaces + $snmpInt
        }
        $groupObj = @{}
        $groupsList = $hostHashTable.groups.split(" ")

        foreach ($group in $groupsList) {
            if (-not $group -eq '') {
                $groupObj.Add("groupid", $group)
                $groups = $groups + $groupObj
                $groupObj = @{}
            }
        }

        $params.Add("groups", $groups)

        if ($includeTemplate) {
            $templateObj = @{}
            $templatesList = $hostHashTable.templates.split(" ")
    
            foreach ($template in $templatesList) {
                if (-not $template -eq '') {
                    $templateObj.Add("templateid", $template)
                    $templates = $templates + $templateObj
                    $templateObj = @{}
                }
            }
    
            $params.Add("templates", $templates)
        }
     
        
        $params.Add("interfaces", $interfaces)

        if ($includeTags) {
            $tagObj = @{}
            $keys = $tagsHashTable.keys

            foreach ($key in $keys) {
                $tagObj.Add("tag", $key)
                $tagObj.Add("value", $tagsHashTable.$key)
                $tags = $tags + $tagObj
                $tagObj = @{}
            }

            $params.Add("tags", $tags)
        }


        if ($includeInventory) {
            $params.Add("inventory", $inventoryHashTable)
        }
        Write-Output  $params

    }
}




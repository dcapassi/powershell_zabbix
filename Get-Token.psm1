function GetToken{

    param ($IP, $Port, $Protocol, $User,$StringPassword)

    $WindowSize = $Host.UI.RawUI.WindowSize.Width

    $headers = @{
        'Content-Type' = 'application/json'
    }
    
    $body = @{
        "jsonrpc" = "2.0"
        "method"  = "user.login"
        "params"  = @{
            "user"     = $User
            "password" = $StringPassword
        }
        "id"      = 1
        "auth"    = $null
    } | ConvertTo-Json
    
    $token = $null


    try{
    ## Get Token
    $token = (Invoke-RestMethod -Headers  $headers -Body $body -Method Post -Uri  "${Protocol}://${Ip}:${Port}/zabbix/api_jsonrpc.php").result
    }
    catch{
        Write-Host "Error: " $_.Exception.Message
        $line = "-" * $WindowSize
        Write-Host $line
        Write-Host ""
    }

    Write-Output $token
    
}
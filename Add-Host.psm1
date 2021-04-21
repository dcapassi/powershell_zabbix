function Add-Host{

    param ($IP, $Port, $Protocol, $Token, $Parameters)

    $WindowSize = $Host.UI.RawUI.WindowSize.Width

    $headers = @{
        'Content-Type' = 'application/json'
    } 
    $body = @{
        "jsonrpc" = "2.0"
        "method"  = "host.create"
        "params"  = $Parameters
        "auth"    = $Token
        "id"      = 1 
    } | ConvertTo-Json -Depth 5

    try{
    ## Create Host
    $data = (Invoke-RestMethod -Headers $headers -Body ([System.Text.Encoding]::UTF8.GetBytes($body)) -Method Post -Uri  "${Protocol}://${Ip}:${Port}/zabbix/api_jsonrpc.php") 
    }

    catch{
        Write-Host "Error: " $_.Exception.Message
        $line = "-" * $WindowSize
        Write-Host $line
        Write-Host ""
        exit
    }

    if ($data){
        Write-Host "Host Created: " $Parameters.hostname
    }

    Write-Output $data
    
}
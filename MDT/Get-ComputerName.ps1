# Demo $Mac =  "00:21:CC:67:F0:0C"
# tech-02 $MAC = "D4:3D:7E:90:E8:ED"
# Property ComputerName is depreciated. Use OSDComputerName

$URI = "http://tech-02:5984/macs/"
$MAC = $TSenv:MACADDRESS001.ToUpper()

[System.Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic') > $null
$message = @"
Hostname not found
Set a new name for this MAC address:
$MAC
"@

try {
    $doc = Invoke-WebRequest -Uri ($URI + $MAC) -Method Get -UseBasicParsing
} catch {
    # Close the TS UI temporarily
    $TSProgressUI = New-Object -COMObject Microsoft.SMS.TSProgressUI
    $TSProgressUI.CloseProgressDialog()

    $ComputerName = [Microsoft.VisualBasic.Interaction]::InputBox($message, "Set Computer Name", "Test-01")
    if($ComputerName -notmatch "test-*"){
        $doc = Invoke-WebRequest -UseBasicParsing -Uri ($URI) -Method Post -ContentType 'application/json' -Body (
            Convertto-json @{
                "_id" = $MAC
                "hostname" = $ComputerName
            }
        )
    }
}

if($doc.StatusCode -in 200, 304 ){
    Write-Output "Success: $($doc.StatusCode)"
    $ComputerName = (Convertfrom-json $doc.Content).hostname
} elseif($doc.StatusCode -eq 201){
    Write-Output "updated database"
} elseif($doc.StatusCode -eq 404){
    Write-Output "missing"
} else {
    Write-Output "Failure: $($doc.StatusCode)"
    Exit 1
}

if($ComputerName){
    Set-Item TSenv:OSDCOMPUTERNAME -Value $ComputerName
} else {
    Write-Output 'Hostname for MAC not present'
}

Write-Output "New name: $ComputerName"

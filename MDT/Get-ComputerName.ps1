# Demo $Mac =  "00:21:CC:67:F0:0C"
# Property ComputerName is depreciated. Use OSDComputerName

$URI = "http://tech-02:5984/macs/"

$MAC = $TSenv:MACADDRESS001
$MAC = $MAC.ToUpper()

$record = Invoke-WebRequest -Uri ($URI + $MAC) -Method Get -UseBasicParsing
if($record.StatusCode -in 200, 304 ){
    Write-Output "Success: $($record.StatusCode)"
    $record | Add-Member -Value (ConvertFrom-json $record.Content) -Name Body -MemberType NoteProperty
} else {
    Write-Output "Failure: $($record.StatusCode)"
    Exit 1
}

if($record.Body.Hostname){
    Set-Item TSenv:OSDCOMPUTERNAME -Value $record.Body.hostname
} else {
    Write-Output 'Hostname for MAC not present'
}

Write-Output "New Environment name: $TSenv:OSDCOMPUTERNAME"

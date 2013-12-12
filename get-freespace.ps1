$FreeSpace = @{
    name="FreeSpace (GB)"
    expression={
        [Math]::Round($_.freeSpace/1gb, 2)
    }
}

$Size = @{
    name="Size (GB)"
    expression={
        [Math]::Round($_.Size/1gb, 2)
    }
}
$computerName = @{
    name="Computer Name"
    expression={
        $_.__SERVER
    }
}

Get-WmiObject `
    -Class win32_logicaldisk `
    -ComputerName 26-19,25-16 `
    -ErrorAction SilentlyContinue `
    |
    select `
        $computerName,
        deviceid,
        $FreeSpace,
        $Size `
    |
    Write-Output
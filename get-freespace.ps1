$FreeSpace = @{
    name="FreeSpace/gb"
    expression={
        [Math]::Round($_.freeSpace/1gb, 2)
    }
}

$Size = @{
    name="Size/gb"
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
    -class win32_logicaldisk `
    -ComputerName 26-19,25-16 `
    |
    select `
        $computerName,
        deviceid,
        $FreeSpace,
        $Size
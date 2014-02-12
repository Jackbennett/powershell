function Remap-F
{
    Param(
        [string]
        $computerName = 'localhost'    
    )

    $drive = gwmi -Class "win32_volume" -Filter "DriveLetter = F:" -ComputerName $computerName
    $drive = "Z:"
    $drive.put()
}
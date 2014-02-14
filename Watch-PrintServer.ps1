function Watch-PrintServer
{
    $s = get-service spooler -computername vprint-01 | select MachineName,status

    write-host -Object "$($s.MachineName): " -NoNewline

    if($s.status -like 'Running'){
        Write-Host -BackgroundColor Green -Object $s.status -NoNewline 
    } else {
        Write-Host -BackgroundColor Red -Object $s.status -NoNewline
    }

    $s = get-service spooler -computername vprint-02 | select MachineName,status

    write-host -Object " - $($s.MachineName): " -NoNewline

    if($s.status -like 'Running'){
        Write-Host -BackgroundColor Green -Object $s.status -NoNewline 
    } else {
        Write-Host -BackgroundColor Red -Object $s.status -NoNewline
    }

    $s = get-service spooler -computername vprint-03 | select MachineName,status

    write-host -Object " - $($s.MachineName): " -NoNewline

    if($s.status -like 'Running'){
        Write-Host -BackgroundColor Green -Object $s.status 
    } else {
        Write-Host -BackgroundColor Red -Object $s.status
    }

    sleep -Seconds 5
    Watch-PrintServer
}
function Watch-PrintServer
{
    # Check vPrint-2
    $s = get-service spooler -computername vPrint-02 | select MachineName,status

    write-host -Object "$($s.MachineName): " -NoNewline

    if($s.status -like 'Running'){
        Write-Host -BackgroundColor DarkGreen -Object $s.status -NoNewline
    } else {
        Write-Host -BackgroundColor Red -Object $s.status -NoNewline
    }


    write-host -Object " - " -NoNewline

    # Chack vPrint-03
    $s = get-service spooler -computername vPrint-03 | select MachineName,status

    write-host -Object "$($s.MachineName): " -NoNewline

    if($s.status -like 'Running'){
        Write-Host -BackgroundColor DarkGreen -Object $s.status -NoNewline
    } else {
        Write-Host -BackgroundColor Red -Object $s.status -NoNewline
    }


    Write-Host

    sleep -Seconds 5
    Watch-PrintServer
}
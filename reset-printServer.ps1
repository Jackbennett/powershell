Param(
    $computerName = 'vrpint-03'
)

get-service pcprint*,spooler -ComputerName $computerName | Stop-Service

Remove-Item -Recurse -Force -Path "\\$computerName\c$\system32\spool\PRINTERS\*"

get-service pcprint*,spooler -ComputerName $computerName | Start-Service
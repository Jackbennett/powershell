# Never let this script run alone
exit 1

# .Remove all scripts for users logon on the domain.
get-aduser -Property ScriptPath -Filter {ScriptPath -notlike $false} | Set-ADUser -ScriptPath $null

# Disable offline files
& "sc config CscService start=disabled"
new-itemproperty -path "HKLM:\SYSTEM\CurrentControlSet\Services\Csc\Parameters" -name FormatDatabase -propertytype DWORD -value 1
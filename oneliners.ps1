<#
.README
    A collection of one-line commands or as near as to do simple jobs.
#>

# Never let this script run alone
exit 1

# .Remove all scripts for users logon on the domain.
get-aduser -Property ScriptPath -Filter {ScriptPath -notlike $false} | Set-ADUser -ScriptPath $null

# Disable offline files
& "sc config CscService start=disabled"
new-itemproperty -path "HKLM:\SYSTEM\CurrentControlSet\Services\Csc\Parameters" -name FormatDatabase -propertytype DWORD -value 1

# Get a batch of the status of ligcator for a whole bunch of rooms
Set-Location $HOME

$cred = Get-Credential 08105curric\j
$r40 = New-ComputerList -Room 40 -Computer (1..26) -FQDN | New-PSSession -Credential $cred -Authentication Credssp
$r38 = New-ComputerList -Room 38 -Computer (1..13) -FQDN | New-PSSession -Credential $cred -Authentication Credssp
$r37 = New-ComputerList -Room 37 -Computer (1..32) -FQDN | New-PSSession -Credential $cred -Authentication Credssp

$computers = $r40 + $r38 + $r37

invoke-command -Session $computers -ScriptBlock {
    Set-ExecutionPolicy allsigned
    Import-Module "\\uhserver1\HomeStaff\Home\j.bennett\ps\Application\Application.psm1"
    Get-Application -name Logicator
} | select computername,name,version | format-table -AutoSize | out-file Output -Append

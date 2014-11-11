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

# Replace all placeholder values with the actual username for H drives.
# Odd problem with year 7
Get-ADGroupMember -Identity "Intake 2014" | 
    Get-ADuser -Properties "HomeDirectory" |
    Where-Object HomeDirectory -Match "%username%" |
    ForEach-Object {
        Set-ADuser -Identity $_ -HomeDirectory ($_.homeDirectory -replace "%username%", $_.samAccountName)
   }

# Test if powershell remoting is enabled on a selection of computers
Import-module ActiveDirectory
$computer = get-ADComputer -Filter * -searchBase "OU=R50,OU=Computers,OU=Upholland,DC=upholland,DC=lancsngfl,DC=ac,DC=uk"

foreach($comp in $computer){
    invoke-command -ComputerName $comp.name -ScriptBlock {
        get-service Netlogon | select-object Displayname,status
    }
}

Remove-Variable computer

# wipe the local profiles of selected user groups on target machines
import-module util
$s = New-ComputerList -Room 37 -Computer (2..32) | New-PSSession

invoke-command -Session $s -ScriptBlock {
    get-childitem -Directory "C:/Users" -Include "14*" | Remove-Item -Force
}

# reset a whole year group password
Get-ADGroupMember -Identity "Intake 2014" |
    Set-ADAccountPassword -Reset -NewPassword (ConvertTo-SecureString -AsPlainText "password" -Force)

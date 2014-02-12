# Written by BigTeddy 10 September 2012
# Version 1.0
# Ammended by Jackbennett 13/01/14


<#
.Synopsis
This function will return the logged-on status of a local or remote computer
.EXAMPLE
GetRemoteLogonStatus test-computer
#>
function GetRemoteLogonStatus
{
    Params(
        [string[]]$computerName = 'localhost'
    )

    foreach( $c in $computerName)
    {
        if (Test-Connection $c -Count 2 -Quiet) {
            try {
                $user = $null
                $user = gwmi -Class win32_computersystem -ComputerName $c | select -ExpandProperty username -ErrorAction Stop
                }
            catch { "Not logged on"; return }
            try {
                if ((Get-Process logonui -ComputerName $c -ErrorAction Stop) -and ($user)) {
                    "Workstation locked by $user"
                    }
                }
            catch { if ($user) { "$user logged on" } }
            }
        else { "$c Offline" }
    }
}



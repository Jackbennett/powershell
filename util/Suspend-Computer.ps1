<#
.Synopsis
   Send the suspend message to a computer
.DESCRIPTION
   To accompany stop-computer, we need suspend-computer.

   Great for knocking laptops off to be returned to users walking from the IT office.

   See examples, Get-Help Suspend-Computer -examples
.EXAMPLE
    Suspend-Computer -ComputerName "test","test2"
    WARNING: Will send sleep command to: test test2
    WARNING: Use "-Force" to execute this command
.EXAMPLE
    Suspend-Computer -Verbose -force
    VERBOSE: Suspend command sent to: localhost
.EXAMPLE
    Suspend-Computer -Force -ComputerName user-laptop-346
#>
function Suspend-Computer
{
    [CmdletBinding(
        SupportsShouldProcess,
        ConfirmImpact="High"
    )]
    Param
    (
        # Target Computer Name
        [Parameter(
            ValueFromPipelineByPropertyName=$true,
            Position=0
        )]
        [string[]]
        $ComputerName = "localhost"
        
        ,
        [switch]
        $Force
    )

    Begin
    {
        Write-Debug "Confirm Preference: $ConfirmPreference"
        Write-Debug "Force Preference: $Force"
    }
    Process
    {
        if(-not $Force)
        {
            Write-Warning "Will send suspend command to: $ComputerName"
            Write-Warning "Use `"-Force`" to execute this command"
        }

        if($Force)
        {
            Write-Verbose "Suspend command sent to: $ComputerName"
            $ComputerName | Invoke-command -ScriptBlock {
                #& "$env:SystemRoot\System32\rundll32.exe" powrprof.dll,SetSuspendState Standby
            }
        }
    }
    End
    {
    }
}

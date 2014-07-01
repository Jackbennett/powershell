<#
.Synopsis
   Short description
.DESCRIPTION
   Long description
.EXAMPLE
   Example of how to use this cmdlet
.EXAMPLE
   Another example of how to use this cmdlet
#>
function Sleep-computer
{
    [CmdletBinding(
        SupportsShouldProcess=$true,
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
        $ComputerName
        
        ,
        [switch]
        $Force = $false
    )

    Begin
    {
    }
    Process
    {
        if($Force -or $pscmdlet.ShouldProcess("Send Sleep command to: $computername"))
        {
            $ConfirmPreference

            $ComputerName | Invoke-command -ScriptBlock {
                "Sleep"
                #& "$env:SystemRoot\System32\rundll32.exe" powrprof.dll,SetSuspendState Standby
            }
        }
    }
    End
    {
    }
}
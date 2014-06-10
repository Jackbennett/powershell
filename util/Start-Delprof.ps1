<#
.Synopsis
   Util wraps the Delprof2.exe utility to help remotely wipe computers.
.DESCRIPTION
   Long description
.EXAMPLE
   Start-Delprof

   Deletes all profiles on the local computer
.EXAMPLE
   New-ComputerList 15 (1..31) | Start-Delprof

   Deletes user profiles on the computers named in the list provided
#>
function Start-Delprof
{
    [CmdletBinding()]
    Param
    (
        # Compute name to remove the local profiles on
        [Parameter(ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        [string[]]
        $computerName = 'localhost'
    )

    Begin
    {
        if((get-command -Name Start-Delprof).ModuleName){
            $ModuleName = (get-command -Name Start-Delprof).ModuleName
        } else {
            $ModuleName = '.'
        }
        
        if( -not (test-path "PS:\$ModuleName\bin\DelProf2.exe") )
        {
            throw "Missing binary DelProf2.exe in PS:"
        }
    }
    Process
    {
        foreach ($name in $computerName)
        {
            start-job -Name $name -ArgumentList $name,$ModuleName -ScriptBlock {
               Invoke-Expression -Command "& 'PS:\$($args[1])\bin\DelProf2.exe /u /q /i /c:\\$($args[0])'"
            }
        }
    }
    End
    {
        Write-Output "Use 'Get-Job' to see the state of running jobs. Help *-Job"
    }
}
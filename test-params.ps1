<#
.Synopsis
   Test script
.DESCRIPTION
   Test script to try out how powershell process' pipeline commands

.EXAMPLE
   Example of how to use this cmdlet
#>
function test-params
{
    [CmdletBinding()]
    Param
    (
        # String list
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        [string[]]
        $Param1,

        # Param2 help description
        [int]
        $Param2
    )

    Begin
    {
        Write-Output "Begin: $param1"
    }
    Process
    {
        "Process: "
        $param1
    }
    End
    {
        Write-Output "End: $param1"
    }
}
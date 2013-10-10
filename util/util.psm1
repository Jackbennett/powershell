<#
.Synopsis
   Create a computer list given a room name and range value
.DESCRIPTION
   Will create a computer list given a room name and range value without verifying if these names exist in the network.

   Pipeline output is an object with properties computerName

.EXAMPLE
   new-computerList -roomName 50 -range 8..11

   Output: 50-08, 50-09, 50-10, 50-11

.EXAMPLE
    new-computerList 40 -range 2,3,4,10 | copy-mimics
#>
function new-computerList
{
    [CmdletBinding()]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        $Param1,

        # Param2 help description
        [int]
        $Param2
    )

    Begin
    {
    }
    Process
    {
    }
    End
    {
    }
}
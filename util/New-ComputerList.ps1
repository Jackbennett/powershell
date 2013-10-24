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
        # Room number
        [Parameter(Mandatory=$true,
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        [string[]]
        $Room

        , # Start PC number, default is 1. leading zero is unnecessary
        [Parameter(ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true)]
        [int[]]
        $Range = 1

    )

    Begin
    {
        # Create a list to add computer names to
        $computerName = New-Object Collections.Generic.List[string]
    }

    Process
    {
        # We need to build the string ROOM-COMPUTER
        
        #So for each room we've been given
        foreach($r in $room){

            #Make a computer for each of the ranges specified
            foreach($c in $range){

                #Add this string to our list of computernames with a fully qualified domain name
                $computerName.Add("$r-$($c.toString('00')).upholland.lancsngfl.ac.uk")
            }
        }
    }

    End
    {
        # Return the list of computer names to the pipeline
        Write-Verbose "Returning to the pipeline with: $computername"

        return $computerName
    }
}
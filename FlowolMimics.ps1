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

<#

do 1a,8,12b,15a,16a,21a
#>

function set-flowolMimics{
    [CmdletBinding()]
    [OutputType([int])]
    Param
    (
        # Room number
        [Parameter(Mandatory=$true,
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        [int[]]
        $room,

        # Start PC number, default is 1. leading zero is unnecessary
        [Parameter(ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true)]
        [int[]]
        $range = 1
    )

    begin{
        $jobs = @()
        #$cred = Get-Credential
    }

    process{
        Write-Verbose "Act on room(s): $room"

        foreach($r in $room){
            $i = 0;

            $computer = buildRoom($r)

            foreach($c in $computer){
                Write-Verbose "'Invoke-Command' on: $c"
            }

            $job += Invoke-Command $computer {
                Copy-Item "\\uhserver1\apps\ICT progs\flowol\mimics" -Destination "$Env:ProgramFiles\keep I.T. Easy\Flowol 3\" -Recurse -Force
            } -asjob 

            $i++
        }
    }

    end{
        return $job
    }
}

function buildRoom($room){
    $name = @()

    foreach($r in $range){
        $name+="$room-$($r.toString('00')).upholland.lancsngfl.ac.uk"
    }

    return $name
}
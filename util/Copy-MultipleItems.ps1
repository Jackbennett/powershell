<#
.Synopsis
   Copy item to multiple desitnations
.DESCRIPTION
   Wraps `copy-item` to provide multiple destinations. Great for putting one set of files on many users home drives.
#>
function Copy-MultipleItems
{
    [CmdletBinding()]
    Param
    (
        # What to copy from
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        [string[]]
        $Path,

        # Where to copy to
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=1)]
        [string[]]
        $Destination
    )

    Begin
    {
    }
    Process
    {
        foreach ($location in $Destination)
        {
            Copy-Item -Path $path -Destination $location
        }
    }
    End
    {
    }
}
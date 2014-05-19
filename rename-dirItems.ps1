<#
.Synopsis
   Easy rename all files in a folder
.DESCRIPTION
   Sorting all files be creation time in the folder, sequentially number them starting at 1.
   Prefixed by the given filename
   Keeping their existing extension
.EXAMPLE
   Rename-DirItems PartsOfThisMovie

   PartsOfThisMovie-1.m4v
   PartsOfThisMovie-2.m4v
   PartsOfThisMovie-3...
#>
function Rename-DirItems
{
    [CmdletBinding()]
    Param
    (
        # File Name before number to increment
        [Parameter(Mandatory=$true,
                   Position=0)]
        $prefix
    )

    Begin
    {
        $i = 1
    }
    Process
    {
     Get-ChildItem |
        Sort-Object -Property Creationtime |
        foreach{
            Rename-Item -path $_ -NewName "$prefix-$i.$($_.Extension)"
            $i++
        }
    }
    End
    {
    }
}
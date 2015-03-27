<#
.Synopsis
    Insert categories into the list given.
.EXAMPLE
    get-childitem -Directory | sort Name | Show-ChildItem | Format-wide -autosize

    .ssh      ~ A ~           apps         ~ B ~      benchmark                                  
    bin       bkup desktop    brackets     ~ C ~      cmder                       
#>
function Show-ChildItem
{
    [CmdletBinding()]
 
    Param(
        [Parameter(ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true)]
        $Name
    )
 
    Begin {
        $lastLetter = '.'
    }
 
    Process {
        if($lastLetter -ne $Name.Name[0]) {
            $LastLetter =  $Name.Name[0].toString().ToUpper()
            New-Object -TypeName psobject -Property @{ Name = "~ $lastLetter ~" }
        }
        $Name | Select-Object 'Name'
    }
}

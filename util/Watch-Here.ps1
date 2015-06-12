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
function Watch-Here
{
    [CmdletBinding()]
    [OutputType([int])]
    Param
    (
        # Param1 help description
        [Parameter(ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        $Path = ".",

        # Param2 help description
        [string]
        $Filter = "*"
    )

    Begin
    {
        Unregister-Event -SourceIdentifier FileCreated
    }
    Process
    {
        $Watch = New-Object IO.FileSystemWatcher $Path, $filter -Property @{
            IncludeSubdirectories = $true # <-- set this according to your requirements
            NotifyFilter = [IO.NotifyFilters]'FileName, LastWrite'
        }

        $onCreated = Register-ObjectEvent -InputObject $watch -EventName "Created" -SourceIdentifier FileCreated -Action {
            Write-Debug $event
            $path = $Event.SourceEventArgs.FullPath
            $name = $Event.SourceEventArgs.Name
            $changeType = $Event.SourceEventArgs.ChangeType
            $timeStamp = $Event.TimeGenerated
            Write-Host "The file '$name' was $changeType at $timeStamp"
        }

        Wait-Event -SourceIdentifier FileCreated
    }
    End
    {
        Unregister-Event -SourceIdentifier FileCreated
    }
}
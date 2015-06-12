<#
.Synopsis
   Watch for new files
.DESCRIPTION
   Watch a target path for new files and log to the console
.EXAMPLE
    Watch-Here
    The file 'test - Copy.txt' was Created at 06/12/2015 11:13:08
    The file 'New Text Document.txt' was Created at 06/12/2015 11:13:20
#>
function Watch-Here
{
    [CmdletBinding()]
    [OutputType([int])]
    Param
    (
        # Specifies the path to watch
        [Parameter(ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        $Path = ".",

        # Specify a filesystem filter script
        [string]
        $Filter = "*"
    )

    Begin
    {
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

        try     { Wait-Event       -SourceIdentifier FileCreated }
        finally { Unregister-Event -SourceIdentifier FileCreated }
    }
    End
    {
    }
}

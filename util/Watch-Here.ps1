<#
.Synopsis
   Watch for new files
.DESCRIPTION
   Watch a target path for new files and log to the console
.EXAMPLE
    Watch-Here -Wait
    The file 'test - Copy.txt' was Created at 06/12/2015 11:13:08
    The file 'New Text Document.txt' was Created at 06/12/2015 11:13:20
.EXAMPLE
    Watch-Here
    Id   Name       PSJobTypeName   State         HasMoreData   Location   Command
    --   ----       -------------   -----         -----------   --------   -------
    28   Created                    NotStarted    False                    ...
#>
function Watch-Here
{
    [CmdletBinding()]
    Param
    (
        # Specifies the path to watch
        [Parameter(ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        $Path = "."

        , # Specify a filesystem filter script
        [string]
        $Filter = "*"

        , # Event Type
        [ValidateSet("Created", "Changed", "Renamed", "Deleted")]
        [string]
        $EventName = "Created"

        , # Show events in the console
        [switch]
        $Wait
    )

    Begin
    {
        $event = Get-EventSubscriber -SourceIdentifier $EventName -ErrorAction SilentlyContinue
        if($event){
            Unregister-Event -SourceIdentifier $EventName -Confirm
        }
    }
    Process
    {
        $Watch = New-Object IO.FileSystemWatcher $Path, $Filter -Property @{
            IncludeSubdirectories = $true # <-- set this according to your requirements
            NotifyFilter = [IO.NotifyFilters]'FileName, LastWrite'
        }

        $handler = Register-ObjectEvent -InputObject $watch -EventName $EventName -SourceIdentifier $EventName -Action {
            $name = $Event.SourceEventArgs.Name
            $changeType = $Event.SourceEventArgs.ChangeType
            $timeStamp = $Event.TimeGenerated
            Write-Host "$timeStamp`: $changeType the file '$name'"
        }

        if($Wait)
        {
            try     { Wait-Event       $EventName }
            finally { Unregister-Event $EventName }
        }
    }
    End
    {
        Write-Output $handler
    }
}

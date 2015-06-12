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

        , # Include Subdirectories
        [switch]
        $Recurse
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
            IncludeSubdirectories = $Recurse
            NotifyFilter = [IO.NotifyFilters]'FileName, LastWrite'
        }

        $handler = Register-ObjectEvent -InputObject $watch -EventName $EventName -SourceIdentifier $EventName -Action {
            $Name = $Event.SourceEventArgs.Name
            $Type = $Event.SourceEventArgs.ChangeType
            $Time = $Event.TimeGenerated
            Write-Host "$Time`: $Type the file '$Name'"
        }

        if($Wait)
        {
            <#
            Use try/finally to catch the script being killed with "Ctrl-C" and unregister the event listener.
            End {} Will not be called when ended this way.
            #>
            try     { Wait-Event       $EventName }
            finally { Unregister-Event $EventName }
        }
    }
    End
    {
        Write-Output $handler
    }
}

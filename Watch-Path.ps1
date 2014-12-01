function Watch-Path{
    Param(
        [string]$Path
    )

    $watcher = New-Object System.IO.FileSystemWatcher
    $watcher.Path = $Path
    $watcher.IncludeSubdirectories = $true
    $watcher.EnableRaisingEvents = $true

    $changed = Register-ObjectEvent $watcher "Changed" -Action {
        write-host "Changed: $($eventArgs.FullPath)"
    }
    $created = Register-ObjectEvent $watcher "Created" -Action {
        write-host "Created: $($eventArgs.FullPath)"
    }
    $deleted = Register-ObjectEvent $watcher "Deleted" -Action {
        write-host "Deleted: $($eventArgs.FullPath)"
    }
    $renamed = Register-ObjectEvent $watcher "Renamed" -Action {
        write-host "Renamed: $($eventArgs.FullPath)"
        $eventArgs
        write-host "---"
        $eventArgs | fl *
    }
}

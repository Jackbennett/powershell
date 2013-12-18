[cmdletBinding()]
Param(
    # What name would you prefer the drive to be mapped under.
    [string]$Store = "ps"

    , # If you don't have an existing profile, Copy our template in that maps the drive as your profile.
    [switch]$copyProfile
)

$v = measure-command {
    try
    {
        Get-PSDrive $Store -ErrorAction stop
    }
    catch [System.Exception]
    {
        Write-verbose "adding the store: $Store"
        # Add the network path to the shared powershell scripts as a drive for the current user
        New-PSDrive -Name $Store `
            -PSProvider "FileSystem" `
            -Root "f:\src\ps" `
            -Description "Powershell script and module store"
    }
    catch
    {
        Write-warning 'No Fault'
    }
}

Write-verbose "$($v.TotalSeconds) seconds - Detecting store drive"

$v = measure-command {
    write-verbose "path Before:"
    $env:PSModulePath.split(';') | % {write-host $PSItem}
    # Check to see if the above added drive is in the module path. If not, add it.
    if($env:PSModulePath -notmatch "$Store`:")
    {
        Write-verbose "no store found"
        $env:PSModulePath = $env:PSModulePath.Insert(0, "$Store`:\;")
    }

    write-verbose "path after:"
    $env:PSModulePath.split(';') | % {write-host $PSItem}

}


Write-verbose "$($v.TotalSeconds) seconds - add store to path"

function add-modules{
    # Exclude utils it's really slow
    Get-ChildItem "$Store`:\" -Directory | ForEach {
        write-host $PSItem.name
        $v = measure-command {
            import-module $psItem.Name
        }

        Write-verbose "$($v.TotalSeconds) seconds - $($PSItem.Name)"
    }
}

add-modules
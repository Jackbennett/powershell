function Import-Store
{
    [cmdletBinding()]
    Param(
        # What name would you prefer the drive to be mapped under.
        [string]$Store = "ps"

        , # Store Root Path
        [string]$StoreRoot = (Join-Path $HOME 'ps')

        # Verbose output with ". $profile.currentUserAllHosts -Verbose" in a session to view extra information
    )

    $Verbose = $VerbosePreference

    Write-Verbose "Map folder: $StoreRoot"
    Write-Verbose "To drive  : $Store"

    # ---------- Create the store drive ----------
    $v = measure-command {
        try
        {
            Get-PSDrive $Store -ErrorAction stop -PSProvider FileSystem
        }
        catch [System.Exception]
        {
            Write-Verbose "Map the folder '$StoreRoot' as drive '$store'"

            $Drive = @{
                Root = $StoreRoot
                Description = "Powershell script and module store"
                Name = $Store
                PSProvider = "FileSystem"
                Scope = "Global"
            }
            
            New-PSDrive @Drive
        }
        catch
        {
            Write-Verbose 'No Fault'
        }
    }

    Write-Verbose "$('{0:N6}' -f $v.TotalSeconds) seconds - Ensured the store existed"

    # ---------- Add store to module path ----------
    $v = measure-command {
        Write-Verbose "Path before testing for the store:"
        $env:PSModulePath.split(';') | % {Write-Verbose "    $PSItem"}

        # Check to see if the above added drive is in the module path. If not, add it.
        if($env:PSModulePath.Contains("$Store`:"))
        {
            Write-Verbose "Store exists"
        } else {
            Write-Verbose "! Store not found"
            Write-Verbose "Add to PSModulePath the store: $Store"

            $env:PSModulePath = $env:PSModulePath.Insert(0, "$Store`:\;")

            Write-Verbose "Path after adding;"
            $env:PSModulePath.split(';') | % {Write-Verbose "    $PSItem"}
        }
    }

    Write-Verbose "$($v.TotalSeconds) seconds - add store to path"
}
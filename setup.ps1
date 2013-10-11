
Param(
    # What name would you prefer the drive to be mapped under.
    [string]$DriveName = "psStore"

    , # If you don't have an existing profile, Copy our template in that maps the drive as your profile.
    [switch]$copyProfile
)


# Add the network path to the shared powershell scripts as a drive for the current user
New-PSDrive -Name $DriveName -PSProvider FileSystem -Root \\uhserver1\psstore -Description "Powershell script and module store"


# Check to see if the above added drive is in the module path. If not, add it.
if($env:PSModulePath -notmatch "$DriveName`:")
{
    $env:PSModulePath += ";$DriveName`:\"
}

if ($copyProfile)
{
    if( (test-path $profile.CurrentUserAllHosts) )
    {
        Write-output ("Will not overwrite existing profile in: " + $profile.CurrentUserAllHosts)
    }
    else
    {
        new-item (split-path $profile.CurrentUserAllHosts) -ItemType Directory 
        Copy-Item "$DriveName1`:\profile.template" $profile.CurrentUserAllHosts
    }
}


<#
 # I don't think this is nescsary once you've added the psstore to the module path
#>
    <#
    function Import-All($alias){
        Get-ChildItem -Path psstore:\ -Directory | select name | Import-Module $_
    }
    #>
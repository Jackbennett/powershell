<#
.Synopsis
   Profile the execution speed of each module
.DESCRIPTION
   when importing a module, in can something take a lot longer than it has to.

   They should but sub 1 second. Idealy sub .1
#>
function Test-ModuleSpeed
{
    [CmdletBinding()]
    Param
    (
        # Default mapped drive for the module store
        [Parameter(ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        $Location = 'ps:'
    )

    Begin
    {
        Write-Warning "List the available modules"
        Get-ChildItem $Location -Filter '*.psm1' -Recurse -OutVariable module | select LastWriteTime,Name
    }
    Process
    {
        Write-Warning "Now import the modules"

        foreach($mod in $module)
        {
            # Importing these commands with verbose set increases their exectuion
            # time and doesn't reflect their true speed fairly. Spot slow ones and import them
            # specifically with import-module <name> -verbose
            $VerbosePreference = "SilentlyContinue"

            $t = measure-command {
                import-module $mod.name -Force
            }

            $VerbosePreference = $Verbose

            Write-Output "$('{0:N6}' -f $t.TotalSeconds) seconds - $($mod.Name)"
        }
    }
    End
    {
    }
}
<#
.Synopsis
   Shortcut a folder to the $PSModulePath preferences
.DESCRIPTION
   Create a shortcut to a folder containing powershell scripts

   Folders in this location can be discovered natively by powershell by adding this shortcut
   to $PSModulePath preferences

   Find the store by looking for the specifice store name in the output from Get-PSDrive
.EXAMPLE
   Install-PSStore
.EXAMPLE
   Install-PSStore powershell
.EXAMPLE
   Install-PSStore powershell c:\myscripts
#>
function Install-PSStore
{
    [CmdletBinding(SupportsShouldProcess=$true,
                  PositionalBinding=$false,
                  ConfirmImpact='Medium')]
    [OutputType([String])]
    Param
    (
        # Param1 help description
        [Parameter(ValueFromPipelineByPropertyName=$true,
                   ValueFromRemainingArguments=$false,
                   Position=0)]
        [string]
        $Store = "ps"

        , # Param2 help description
        [Parameter(Position=1)]
        [ValidateScript({Test-Path $psitem -PathType Container})]
        [string]
        $StoreRoot = (Join-Path $env:HOMEDRIVE 'ps')
    )

    Begin
    {
    }
    Process
    {
        if ($pscmdlet.ShouldProcess($StoreRoot, "Create a drive name: $Store"))
        {
            $found = $true
            $v = measure-command {
                try
                {
                    Get-PSDrive $Store -ErrorAction stop
                }
                catch [Exception]
                {
                    Write-Verbose "New Drive: $Store"
                    $found = $false

                    $Drive = @{
                        Root = $StoreRoot
                        Description = "Powershell script and module store"
                        Name = $Store
                        PSProvider = "FileSystem"
                        Scope = "Global"
                    }

                    New-PSDrive @Drive
                }
            }
            Write-Verbose "Drive name: `"$Store`" returned $found"
            Write-Verbose "$('{0:N6}' -f $v.TotalSeconds) seconds - Detecting store drive"
        }

        if ($pscmdlet.ShouldProcess($Store, "Add to PSModulePath"))
        {
            $Before = $env:PSModulePath.split(';')
            # Check to see if the above added drive is in the module path. If not, add it.
            $v = measure-command {
                if( (test-path $StoreRoot) -and -not ($env:PSModulePath.Contains("$Store`:")) )
                {
                    $env:PSModulePath = $env:PSModulePath.Insert(0, "$Store`:\;")
                }
            }

            if($VerbosePreference -eq 'Continue'){
                Write-Verbose "Compare PSModulePath before and after for $Store"
                Compare-Object $Before $env:PSModulePath.split(';') -IncludeEqual
            }
            Write-Verbose "$('{0:N6}' -f $v.TotalSeconds) seconds - Add store to module path"
        }
    }
    End
    {
    }
}

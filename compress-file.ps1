<#
.Synopsis
   Use 7-zip to compress a remote shared directory
.DESCRIPTION
   Use 7-zip to compress a remote shared directory
.EXAMPLE
   Example of how to use this cmdlet
.EXAMPLE
   Another example of how to use this cmdlet
.INPUTS
   Inputs to this cmdlet (if any)
.OUTPUTS
   Output from this cmdlet (if any)
.NOTES
   General notes
.COMPONENT
   The component this cmdlet belongs to
.ROLE
   The role this cmdlet belongs to
.FUNCTIONALITY
   The functionality that best describes this cmdlet
#>
function Compress-File
{
    [CmdletBinding(PositionalBinding=$true,
                   SupportsShouldProcess=$True)]
    [OutputType([String])]
    Param
    (
        # Param1 help description
        [Parameter(#Mandatory=$true, 
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [string]
        $server = 'uhserver1'.Replace('\\','')

        , # Param1 help description
        [Parameter(#Mandatory=$true, 
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [string]
        $share = 'globalshared'

        , # Param2 help description
        [Parameter(ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true, 
                   ValueFromRemainingArguments=$true)]
        [string]
        $destination = 'TS-XL19C\share\'.Replace('\\','')

        , # Param2 help description
        [Parameter(ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true, 
                   ValueFromRemainingArguments=$true)]
        [Alias('filename')]
        [string]
        $name = $share.Replace('\', '-')

        , # Param2 help description
        [Parameter(ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true, 
                   ValueFromRemainingArguments=$true)]
        [string]
        $filter = '*.*'
    )

    Begin
    {
        # Alias for 7-zip, use 7zG.exe for GUI progress
        if (-not (Test-Path "$env:ProgramFiles\7-Zip\7z.exe"))
        {
            throw "$env:ProgramFiles\7-Zip\7z.exe needed"
        }
        Set-Alias sz "$env:ProgramFiles\7-Zip\7z.exe"

        $source = Join-Path -Path $server `
                            -ChildPath $share | 
                  Join-Path -ChildPath $filter

        $destination = Join-Path -path $destination `
                                 -childPath ("$name-" + (Get-Date -Format dd-MM-yyy))

        # Error checking access to files
        if (-not (Test-Path (Split-Path "\\$source")) )
        {
            throw "$source not accecible"
        }

        if (-not (Test-Path (Split-Path "\\$destination")) )
        {
            throw "$destination not accecible"
        }
    }
    Process
    {
        Write-Verbose "Executing: sz a -t7z -r '\\$destination.7z' '\\$source'"
        Invoke-Expression        "sz a -t7z -r '\\$destination.7z' '\\$source'"
    }
    End
    {
        #cleanup files if needed
    }
}


compress-file -server "xps-laptop" -share "share\fog_0.32" -Verbose -WhatIf
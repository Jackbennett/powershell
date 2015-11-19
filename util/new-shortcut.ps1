<#
.Synopsis
   Create a new shortcut instance to edit
.DESCRIPTION
   Copy the source shortcut into a variable to edit with the WScript shell methods

.EXAMPLE
   new-shortcut '.\GIMP.lnk' -newname 'GIMP 2.8'


#>
function new-shortcut
{
    [CmdletBinding(SupportsShouldProcess=$true)]
    Param
    (
        # Use an existing shortcut to update the target.
        [Parameter(Mandatory=$true,
                   Position=0,
                   ValueFromPipelineByPropertyName=$true)]
        [string]
        $template

        , # If no path is set, use the same directory as the source
        [string]
        [Parameter(Mandatory=$true,
        ValueFromPipelineByPropertyName=$true)]
        $destination

        , #
        [string]
        [Parameter(ValueFromPipelineByPropertyName=$true)]
        $targetPath = "C:\Program Files\"

        , # This is the "Comment" field under "Properties"
        [string]
        [Parameter(ValueFromPipelineByPropertyName=$true)]
        $description = "New Shortcut Link"

    )

    Begin
    {
        $shell = New-Object -COM WScript.Shell
    }
    Process
    {
        Copy-Item $template $destination  ## Get the lnk we want to use as a template
        $shortcut = $shell.CreateShortcut($destination)  ## Open the lnk

        $shortcut.TargetPath = $targetPath
        $shortcut.Description = $description
        $shortcut.Save()
    }
    End
    {
    }
}
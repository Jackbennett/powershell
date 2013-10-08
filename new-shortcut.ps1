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
        # Param1 help description
        [Parameter(Mandatory=$true,
                   Position=0)]
        [string]
        $source

        , # If no value is set, append " - copy" to the source file
        [string]
        $newName =  (split-path -leaf (resolve-Path $source)).trimEnd(".lnk") + " - copy.lnk"

        , # If no path is set, use the same directory as the source
        [string]
        $destination = (split-path (resolve-Path $source)) + "\$newName.lnk"

        , #
        [string]
        $targetPath = "C:\Program Files\"

        , #
        [string]
        $description = "New Shortcut Link"

    )

    Begin
    {
        $shell = New-Object -COM WScript.Shell
    }
    Process
    {
        Copy-Item $source $destination  ## Get the lnk we want to use as a template
        $shortcut = $shell.CreateShortcut($destination)  ## Open the lnk

        $shortcut.TargetPath = $targetPath
        $shortcut.Description = $description  ## This is the "Comment" field under Right-click > Properties
        $shortcut.Save()
    }
    End
    {
    }
}
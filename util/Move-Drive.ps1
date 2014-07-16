<#
.Synopsis
   Change a drive letter.
.DESCRIPTION
   Change a drive letter for a device to another letter.

   To run this command locally it must run under elevated privileges. If a computername is specified 
   your credentials should have enaough permissions to perform the operation.
.EXAMPLE
    Move-Drive
    This command requires elevated privileges

    Run the command as an administrator
.EXAMPLE
    move-drive e f tech-01 -verbose
    VERBOSE: Moved drive name E to F
#>
function Move-Drive
{
    Param(
        # Target Computer name to remap the drive
        [Parameter(position=2)]
        [string]
        $computerName = 'localhost'

        , # Target drive letter
        [Parameter(position=0)]
        [ValidateLength(1,1)]
        [ValidateRange("A","Z")]
        [string]
        $target = 'F'

        , # Drive letter to set
        [Parameter(position=1)]
        [ValidateLength(1,1)]
        [string]
        $letter = 'Z'
    )

    $target = $target.ToUpper()
    $letter = $letter.ToUpper()

    $drive = Get-WmiObject `
                -Class "win32_volume" `
                -filter "DriveLetter='$target`:'" `
                -ComputerName $computerName `

    if ( $drive )
    {
        $drive.DriveLetter = "$letter`:"
    } else {
        write-warning "$target Drive not found."
        return
    }

    try
    {
        invoke-command `
            -ScriptBlock { $drive.put() > $null } `
            -ErrorVariable err
    }
    catch
    {
        Write-error "Cannot move drive $target`: to $letter`:"
        return
    }

    if( -not $err )
    {
        write-output "Moved drive $target`: to $letter`:"
    }
}
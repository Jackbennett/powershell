<#
.Synopsis
   Remap a driver letter that is in use
.DESCRIPTION
   Change a drive letter for a device to another letter.
.EXAMPLE
   Remap-Drive
.EXAMPLE
   Another example of how to use this cmdlet
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
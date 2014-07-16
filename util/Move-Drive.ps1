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
        # Target drive letter
        [Parameter(position=1)]
        [ValidateLength(1,1)]
        [ValidatePattern("[a-z]")]
        [string]
        $Target = 'F'

        , # Drive destination to set
        [Parameter(position=2)]
        [ValidateLength(1,1)]
        [ValidatePattern("[a-z]")]
        [ValidateScript({ $psItem -ne $Target })]
        [string]
        $Destination = 'Z'

        ,# Target Computer perform the remap
        [Parameter(position=3)]
        [string]
        $ComputerName = 'localhost'
    )
    Begin{
        if( $ComputerName -eq 'localhost' -and -not (
            [Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()
            ).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")
          )
        {
            throw "This command requires elevated privileges"
        }

        $Target = $Target.ToUpper()
        $Destination = $Destination.ToUpper()

        if($Target -eq $Destination)
        {
            throw "Target ($Target) matches destination ($Destination). Exiting."
        }

        $Query = @{
            Class        = "Win32_Volume"
            Filter       = "DriveLetter='$Target`:'"
            ComputerName = $ComputerName
        }
    }
    Process
    {
        $drive = Get-WmiObject @Query

        if ( $drive )
        {
            $drive.DriveLetter = "$Destination`:"
        } else {
            Write-Warning "$Target Drive not found."
            return
        }

        try
        {
            Write-Progress -Activity "Working..." -Status "Move drive name $Target to $Destination"
            $drive.put() > $null
        }
        catch
        {
            Write-Error "Cannot move drive $Target`: to $Destination`:"
            return
        }

        Write-Verbose "Moved drive name $Target to $Destination"
    }
}
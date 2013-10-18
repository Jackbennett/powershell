# sudo.ps1
#
# Authors: Brian Marsh, mrigns, This guy: http://tsukasa.jidder.de/blog/2008/03/15/scripting-sudo-with-powershell
#
# Sources:
#       http://tsukasa.jidder.de/blog/2008/03/15/scripting-sudo-with-powershell
#       http://www.ainotenshi.org/%E2%80%98sudo%E2%80%99-for-powershell-sorta
#
# Version:
#       1.0     Initial version
#       1.1     added -ps flag, cleaned up passed $file/$script full path
#       1.2     Comments
#       1.3     Fixed passing working directory to powershell/auto closing

function sudo(){
    param(
            [switch]$ps,               # Switch for running args as powershell script
            [string]$file,             # Script/Program to run
            [string]$arguments = $args # Arguments to program/script
         )
 
    # Find our powershell full path
    $powershell = (get-command powershell).definition
 
    # Get current directory
    $dir = get-location
 
    #If we're running this as a elevated powershell script
    if ($ps){
 
            # Script verification
            if([System.IO.File]::Exists("$(get-location)\$file")) {
 
                    # Set the $script to full path of the ps script
                    $script = (get-childitem $file).fullname
            }
 
            # Create a powershell process
            $psi = new-object System.Diagnostics.ProcessStartInfo $powershell
 
            $psi.WorkingDirectory = Get-Location
 
            # Combine the script and its arguments
            $sArgs = $script + " " + $arguments
 
            # Set the arguments to be the ps script and it's arguments
            $psi.Arguments = "-noexit -command set-location $dir; $sArgs"
 
            # Magic to run as elevated
            $psi.Verb = "runas";
    }
 
    # We're running something other than a powershells script
    else {
 
            # File verification
            if([System.IO.File]::Exists("$(get-location)\$file")) {
 
                    # Get full path
                    $file = (get-childitem $file).fullname
            }
 
            # Same as above, create proccess/working directory/arguments/runas
            $psi = new-object System.Diagnostics.ProcessStartInfo $file
            $psi.Arguments = $arguments
            $psi.Verb = "runas"
    }
 
    # Start the process
    [System.Diagnostics.Process]::Start($psi)
}
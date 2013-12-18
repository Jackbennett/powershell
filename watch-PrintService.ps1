<#
.Synopsis
   Register a task to restart a failed print spooler
.DESCRIPTION
   Watch that the print spooler has stopped
   1. Define a scheduled task 
   2. Schedule the task on event Print Spooler Stopped
#>
function watch-PrintService
{
    [CmdletBinding()]
    [OutputType([int])]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        $Param1,

        # Param2 help description
        [int]
        $Param2
    )

    Begin
    {
        $Task = New-ScheduledTask 
    }
    Process
    {
    }
    End
    {
        Register-ScheduledTask -InputObject $Task
    }
}

<#
.Synopsis
   Restart a failed print spooler
.DESCRIPTION
   1. Insude the spooler has stopped
   2. clear the spoller directory
   3. restart the spooler
   4. Find print event that stopped the server ID #??????
   5. Log message of printer that crashed the spooler
#>

function restart-PrintService
{
    [CmdletBinding()]
    [OutputType([int])]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        $Param1,

        # Param2 help description
        [int]
        $Param2
    )

    Begin
    {
        Write-Verbose "If the print server (spoolsv) is running exit now."
        if( -not (Get-Process "spoolsv" -ErrorAction SilentlyContinue) )
        {
            Write-Verbose "Yes it's running; EXIT"
            return
        }
    }
    Process
    {
        return #debug / dont run
        # Clear the contents for the spooler directory to stop lockign the service
        Get-ChildItem -Recurse ` #spoolerDirectory 
        |
        Remove-item

        Start-Service -Name "spoolsv"
    }
    End
    {
        Get-WinEvent -FilterHashtable @{LogName="Microsoft-Windows-PrintService/Admin";ID=808} `
        |
        Where id -eq 808 `
        |
        Out-File -FilePath "\\uhhs\psStore\logs\$($env:Computername) PrintService $(Get-Date -Format u).log" -Force
    }
}
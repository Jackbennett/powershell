<#
.Synopsis
   Logon History
.DESCRIPTION
   Show interactive user logon history of the users on a target computer from the Security log.

   CREDIT
    Origonally from freenode#powershell IRC User ..?..
.EXAMPLE
   Get-LogonHistory 15-31
   Returns the User Name, Firstname, Surename, Logon time, logoff time
.INPUTS
   Inputs to this cmdlet (if any)
.OUTPUTS
   Output from this cmdlet (if any)
.NOTES
   LOGON event Log Name: Security, Source: Microsoft-Windows-Security-Auditing, ID: 4624
   LOGOFF event Log Name: Security, Source: Microsoft-Windows-Security-Auditing, ID: 4634
   WORKSTATION_LOCKED event Log Name: Security, Source: Microsoft-Windows-Security-Auditing, ID: 4800
   WORKSTATION_UNLOCKED event Log Name: Security, Source: Microsoft-Windows-Security-Auditing, ID: 4801
   Logon Types: Interactive = 2; Network = 3; Batch = 4; Service = 5; Unlock = 7;
      NetworkCleartext = 8; NewCredentials = 9; RemoteInteractive = 10; CachedInteractive = 11 
      [ref]http://www.windowsecurity.com/articles-tutorials/misc_network_security/Logon-Types.html
CREDIT
    Origonally from freenode#powershell IRC User ..?..
#>
function Get-LogonHistory
{
    [CmdletBinding()]
    Param
    (
        # Target computer name
        [Parameter(Position=0,
                   ValueFromPipelineByPropertyName=$true,
                   ParameterSetName='Default')]
        [string]
        $ComputerName = 'localhost'

        , # How many days before today should I search. By default get yesterdays records
        [Parameter(ParameterSetName='Default')]
        [int]
        $PastDays = 1

        , # How many days logons would you like to See
        [Parameter(ParameterSetName='Default')]
        [int]
        $Days = 1

        , # Just get todays records
        [Parameter(ParameterSetName='Today')]
        [switch]
        $Today
    )

    Begin
    {
        if($Today)
        {
            $PastDays = 0
        }

        # Use the .Date property to reset the time to 00:00:00
        [datetime]$StartDay = (Get-Date).AddDays( - $PastDays).Date
        [datetime]$StopDay = $StartDay.AddDays($Days).Date

        Write-Verbose "From $ComputerName get Logon events between $StartDay and $StopDay"
    }
    Process
    {
        if ($pscmdlet.ShouldProcess("Target", "Operation"))
        {
            # Grab the events from a remote computer
            $EventLog = Get-WinEvent -ComputerName $ComputerName -FilterHashtable @{
                            Logname='Security';
                            Id=4624;
                            StartTime=$StartDay;
                            EndTime=$StopDay
                        }

                if($EventLog.count -gt 0)
                {
                    Write-Verbose "Got $($EventLog.count) event(s)"
                }

            # Parse out the event message data
            ForEach ($Event in $EventLog) {

                $xml = [xml]$Event.ToXml()

                For ($i=0; $i -lt $xml.Event.EventData.Data.Count; $i++)
                {
                    $Event |
                        Add-Member -Force -NotePropertyName $xml.Event.EventData.Data[$i].name -NotePropertyValue $xml.Event.EventData.Data[$i].'#text'
                }
            }

            $EventLog |
                Where-Object { $_.logonType -eq 2 } |
                Select-Object @{n='User Name';e={$_.TargetUserName}},@{n='Logon Time';e={$_.TimeCreated}},@{n='Computer';e={$_.SubjectUserName}}
        }
    }
    End
    {
    }
}
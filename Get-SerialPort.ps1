<#
.Synopsis
   Print a line of whatever data comes in the Serial Port. Read Only.
.DESCRIPTION
   Echo all incoming data on the serial port.
   
   I want to wrap this with node and use this as a dev module instead of 
   installing VS 2013 to just compile nodeserialport
#>
function Get-SerialPort
{
    [CmdletBinding()]
    [OutputType([String])]
    Param
    (
        # Event Identifier
        [Parameter(ParameterSetName='Event Identifier')]
        [ValidatePattern("[a-z]*")]
        [String]
        $identifier = "Serial"
    )

    Begin
    {
        $port = New-Object system.io.ports.serialport COM3,9600,none,8,one
        $port.ReadTimeout = 4000 # 4 seconds
        $port.open()
    }
    Process
    {
        # Print data only when recieved, No polling the port that's crazy talk.
        $job = Register-ObjectEvent `
                -InputObject $port `
                -EventName "DataReceived" `
                -SourceIdentifier $identifier `
                -MessageData 5 `
                -Action {
                    $Script:counter += 1

                    Write-Host "Event count: $counter"
                    # Dump the entire buffer
                    write-host $sender.ReadExisting()

                    # Debug counter to stop spewing 400+ events while I close the hung process and burn my lap.
                    if($counter -ge $event.messageData)
                    {
                        Write-Host "Remove Event:" $event.SourceIdentifier
                        Unregister-Event $event.SourceIdentifier
                    }
                }

        try
        {
            Wait-Event $identifier
            # At this point I think we wait forever as we've unbound the event after 5 mesages.
            # I cannot cancel the process with ctrl-c. - Not desired
        } finally {
            # Stop Listening to data
            $port.Close()
            # Free the resources just to be sure it's safely unbound for sucessive runs of the script
            $port.Dispose()
            # Dispose of the event handler to make sure we're all clean
            Unregister-Event $identifier
        }
    }
    End
    {
    }
}
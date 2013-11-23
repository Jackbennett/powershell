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
        $port.ReadTimeout = 1000 # milliseconds
        $port.open()

        # Print data only when recieved, No polling the port that's crazy talk.
        Register-ObjectEvent `
                -InputObject $port `
                -EventName "DataReceived" `
                -SourceIdentifier $identifier
    }
    Process
    {
        try
        {
            Wait-Event $identifier -Timeout ($port.ReadTimeout/1000) -ErrorAction Stop
            "data or timeout?"
            $port.ReadExisting()

        # How do I catch the timeout, it aint the following;
        } catch [System.Management.Automation.PSEventArgs]{
            "hey caught a timeout"

        # How do I catch success?
        } catch {
            "Cool, Got some data"
            $counter += 1
            "Event count: $counter"
            # Dump the entire buffer
            $port.ReadExisting()
        } finally {
            "Clean up connections"
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
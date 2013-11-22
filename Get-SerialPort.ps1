<#
.Synopsis
   Print a line of whatever data comes int he Serial Port. Read Only
.DESCRIPTION
   Echo all incoming data on the serial port. I want to wrap this with node and use this as a dev module instead of installing VS 2013 to just compile nodeserialport
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
        $port = New-Object system.io.ports.serialport COM3,9600,none,8,one;
        $port.ReadTimeout = 4000; # 4 seconds
        $port.open();
    }
    Process
    {
        $job = Register-ObjectEvent `
                -InputObject $port `
                -EventName "DataReceived" `
                -SourceIdentifier $identifier `
                -MessageData 5 `
                -Action {
                    $Script:counter += 1

                    Write-Host "Event count: $counter"
                    write-host $sender.ReadExisting()

                    if($counter -ge $event.messageData)
                    {
                        Write-Host "Remove Event:" $event.SourceIdentifier
                        Unregister-Event $event.SourceIdentifier
                    }
                }

        try
        {
            Wait-Event $identifier
        } finally {
            $port.Close();
            $port.Dispose();
            Unregister-Event $identifier
        }
    }
    End
    {
    }
}
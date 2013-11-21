<#
.Synopsis
   Short description
.DESCRIPTION
   Long description
.EXAMPLE
   Example of how to use this cmdlet
.EXAMPLE
   Another example of how to use this cmdlet
.INPUTS
   Inputs to this cmdlet (if any)
.OUTPUTS
   Output from this cmdlet (if any)
.NOTES
   General notes
.COMPONENT
   The component this cmdlet belongs to
.ROLE
   The role this cmdlet belongs to
.FUNCTIONALITY
   The functionality that best describes this cmdlet
#>
function Get-SerialPort
{
    [CmdletBinding(DefaultParameterSetName='Parameter Set 1', 
                  SupportsShouldProcess=$true, 
                  PositionalBinding=$false,
                  HelpUri = 'http://www.microsoft.com/',
                  ConfirmImpact='Medium')]
    [OutputType([String])]
    Param
    (
        # Param1 help description
        [Parameter(ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true, 
                   ValueFromRemainingArguments=$false, 
                   Position=0,
                   ParameterSetName='Parameter Set 1')]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [ValidateCount(0,5)]
        [ValidateSet("sun", "moon", "earth")]
        [Alias("p1")] 
        $Param1,

        # Param2 help description
        [Parameter(ParameterSetName='Parameter Set 1')]
        [AllowNull()]
        [AllowEmptyCollection()]
        [AllowEmptyString()]
        [ValidateScript({$true})]
        [ValidateRange(0,5)]
        [int]
        $Param2,

        # Event Identifier
        [Parameter(ParameterSetName='Event Identifier')]
        [ValidatePattern("[a-z]*")]
        [ValidateLength(0,15)]
        [String]
        $identifier = "Serial"
    )

    Begin
    {
        $port = New-Object system.io.ports.serialport COM3,9600,none,8,one;
        $port.ReadTimeout = 4000; # 2 seconds
        $port.open();
    }
    Process
    {
        try
        {
            if ($pscmdlet.ShouldProcess("Target", "Operation"))
            {
                $job = Register-ObjectEvent `
                            -InputObject $port `
                            -EventName "DataReceived" `
                            -SourceIdentifier $identifier `
                            -MessageData 5 `
                            -Action {
                                $Script:counter += 1
                                Write-Host "Event count: $counter"

                                if($counter -ge $event.messageData)
                                {
                                    Write-Host "Stop Event"
                                    # exit
                                }

                                write-host $sender.ReadExisting()
                            }

                Wait-Event $identifier

                #Receive-Job $identifier

                # $port.ReadTo("sta1234rt   , ");
            }
        } finally {
            $port.Close();
            $port.Dispose();

            Unregister-Event $identifier
        }
    }
    End
    {
        $port.Close();
        $port.Dispose();

        Unregister-Event $identifier
    }
}
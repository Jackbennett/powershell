<#
.Synopsis
   Print a line of whatever data comes in the Serial Port. Read Only.
.DESCRIPTION
   Echo all incoming data on the serial port.
   
   I want to wrap this with node and use this as a dev module instead of 
   installing VS 2013 to just compile nodeserialport
.EXAMPLE
    New-SerialPort | Show-SerialPort

    prints data to the host as it comes in
#>
function New-SerialPort
{
    [CmdletBinding()]
    [OutputType([System.IO.Ports.SerialPort])]
    Param
    (
        # Event Identifier
        [Parameter()]
        [ValidatePattern("[a-z]*")]
        [String]
        $identifier = "Serial"

        , # Event Identifier
        [Parameter()]
        [ValidatePattern("[a-z]*")]
        [String]
        $name = "COM3"


     # This does not work, Didn't think it would
     #   , # Force precence of outVaraible
     #   [Parameter(Mandatory=$true)]
     #   $OutVariable
    )
    $error.Clear()

    $port = InstancePort -Name $name

    # Print data only when recieved, No polling the port that's crazy talk.
    $obj = Register-ObjectEvent `
            -InputObject $port `
            -EventName "DataReceived" `
            -SourceIdentifier $port.identifier

    try
    {
        $port.open()
    } catch {
        Unregister-Event $port.identifier

        foreach($e in $error.ToArray())
        {
            Write-Error $e
        }
    }
    if(-not $error)
    {
        Write-Output -InputObject [System.IO.Ports.SerialPort]$port
    }
}

function Get-SerialPort
{
    [CmdletBinding()]
    [OutputType([PSObject])]
    Param
    (
        # Return this port object
        [Parameter()]
        [string]
        $port
    )

    if($port)
    {
        InstancePort $port | Write-Output
    } else {
        Write-Output ([System.IO.Ports.SerialPort]::getportnames())
    }
}

function Show-SerialPort
{
    [CmdletBinding()]
    [OutputType([string])]
    Param
    (
        # Serial Port Object
        [Parameter(Mandatory=$true,
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true)]
        [System.IO.Ports.SerialPort]
        $port
    )

    Write-Verbose "Open port for reading"
    $port.open()

    Write-Verbose "Waiting on data"
    Wait-Event $port.identifier -Timeout ($port.ReadTimeout/1000)

    # How do I catch this?
    "data or timeout?"

    # Why does this just loop the same event output 
    Write-Host ($port.ReadExisting())

    Show-SerialPort($port)
}

function Remove-SerialPort
{
    [CmdletBinding()]
    [OutputType([PSObject])]
    Param
    (
        # Event Identifier
        [Parameter(Mandatory=$true,
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true)]
        [PSObject]
        $port

        , # Remove events too
        [switch]
        $clean
    )

    "Clean up connections"
    # Stop Listening to data

    $port.Close()
    # Free the resources just to be sure it's safely unbound for sucessive runs of the script
    $port.Dispose()
    # Dispose of the event handler to make sure we're all clean
    Unregister-Event $port.identifier

    switch ($clean)
    {
        $true {
            Remove-Event -SourceIdentifier $port.identifier
        }
        Default {}
    }
}

function instancePort()
{
    [CmdletBinding()]
    [OutputType([System.IO.Ports.SerialPort])]
    Param
    (
        # Event Identifier
        [Parameter()]
        [ValidatePattern("[a-z]*")]
        [String]
        $identifier = "Serial"

        , # Port Name
        [Parameter(position=0)]
        [ValidatePattern("[a-z]*")]
        [String]
        $name = "COM3"

        , # Baud Rate
        $BaudRate = 9600

        , # Parity Bit
        $ParityBit = "None"

        , # Data Bits
        $DataBits = 8

        , # Stop Bit
        $StopBit = "one"
    )

    $port = New-Object system.io.ports.serialport $name,$BaudRate,$ParityBit,$DataBits,$StopBit
    $port.ReadTimeout = 1000 # milliseconds
    
    $port | Add-Member -MemberType "NoteProperty" -Name "identifier" -Value "Serial"

    Write-Output $port

}
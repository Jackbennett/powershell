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
function New-SerialPort {
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

        # Q. Can I force the cmdletBindings() -outvariable to be set?
        # This does not work, Didn't think it would
        #   , # Force precence of outVaraible
        #   [Parameter(Mandatory=$true)]
        #   $OutVariable
    )
    $error.Clear()

    # Q. How can I get if there's already an existing instance and not do this?
    $port = InstancePort -Name $name

    # Print data only when recieved, No polling the port that's crazy talk.
    $obj = Register-ObjectEvent `
        -InputObject $port `
        -EventName "DataReceived" `
        -SourceIdentifier $port.identifier `
        -ErrorAction stop

    if (-not $error) {
        Write-Output -InputObject $port
    }
    else {
        Unregister-Event $port.identifier
        foreach ($e in $error.ToArray()) {
            Write-Error $e
        }
    }
}

function Get-SerialPort {
    [CmdletBinding()]
    [OutputType([System.IO.Ports.SerialPort])]
    Param
    (
        # Name of port to find, default all
        [Parameter()]
        [string]
        $port
    )

    $real = [System.IO.Ports.SerialPort]::getportnames() |
        ForEach-Object {
        new-object -TypeName PSCustomObject -Property @{"type" = "Physical"; "name" = $psitem.PortName; "port" = $psitem}
    }

    $virtual = Get-EventSubscriber -SourceIdentifier "Serial*" |
        Select-Object -ExpandProperty SourceObject |
        ForEach-Object {
        new-object -TypeName PSCustomObject -Property @{"type" = "Virtual"; "name" = $psitem.PortName; "port" = $psitem}
    }

    $real + $virtual | Write-Output

}

function Show-SerialPort {
    [CmdletBinding()]
    [OutputType([string])]
    Param
    (
        # Serial Port Object
        [Parameter(Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [System.IO.Ports.SerialPort]
        $port
    )

    # Q. wat? new-serialport -outvariable p 
    # Show-SerialPort : Cannot process argument transformation on parameter 'port'. Cannot convert the "System.Collections.ArrayList" value of type "System.Collections.ArrayList" to type "System.IO.Ports.SerialPort".
    # At line:1 char:23
    # + Show-SerialPort -port $p
    # +                       ~~
    # + CategoryInfo          : InvalidData: (:) [Show-SerialPort], ParameterBindingArgumentTransformationException
    # + FullyQualifiedErrorId : ParameterArgumentTransformationError,Show-SerialPort


    Write-Verbose "Open port for reading"
    Write-verbose ("Is prot open? " + $port.isOpen)
    if ( -not $port.isOpen) { $port.open() }

    Write-Verbose "Waiting on data"
    Write-Output $port | gm

    Wait-Event $port.identifier -Timeout ($port.ReadTimeout / 1000)

    # Q. How do I catch the difference in this?
    "data or timeout?"

    # Why does this just loop the same event output 
    Write-Output ($port.ReadExisting())

    Show-SerialPort($port)
}

function Remove-SerialPort {
    [CmdletBinding()]
    [OutputType([PSObject])]
    Param
    (
        # Serial port reference
        [Parameter(Position = 0,
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [System.IO.Ports.SerialPort]
        $port

        , # Remove all events in log
        [switch]
        $clean
    )

    "Clean up connections"
    # Stop Listening to data

    Write-host $port.isOpen
    $port.Close()
    # Free the resources just to be sure it's safely unbound for sucessive runs of the script
    $port.Dispose()
    # Dispose of the event handler to make sure we're all clean
    Unregister-Event $port.identifier -ErrorAction SilentlyContinue

    switch ($clean) {
        $true {
            Remove-Event -SourceIdentifier $port.identifier -ErrorAction SilentlyContinue
        }
        Default {}
    }
    Write-Output "Event count: " (get-event | measure | select count)
    Write-Output "Subscribers: " (Get-EventSubscriber | select SourceIdentifier)

}

function instancePort() {
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
        [Parameter(position = 0)]
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

    $port = New-Object system.io.ports.serialport $name, $BaudRate, $ParityBit, $DataBits, $StopBit
    $port.ReadTimeout = 1000 # milliseconds
    
    $port | Add-Member -MemberType "NoteProperty" -Name "identifier" -Value "Serial"

    Write-Output $port

}
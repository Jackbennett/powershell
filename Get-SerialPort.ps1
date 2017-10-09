New-Module {
    <#
.Synopsis
   Create a new serial port to read or write to.
.DESCRIPTION

.EXAMPLE
    $myport = New-SerialPort

    Create a new port with a .net event subscribed to the incoming data
.EXAMPLE
    New-SerialPort -outvariable port -Name Serial -number 5

Create a new port whislt seing it's configuration.

    Identifier             : Serial5
    BaseStream             :
    BaudRate               : 9600
    BreakState             :
    BytesToWrite           :
    BytesToRead            :
    CDHolding              :
    CtsHolding             :
    DataBits               : 8
    DiscardNull            : False
    DsrHolding             :
    DtrEnable              : False
    Encoding               : System.Text.ASCIIEncoding
    Handshake              : None
    IsOpen                 : False
    NewLine                :

    Parity                 : None
    ParityReplace          : 63
    PortName               : com3
    ReadBufferSize         : 4096
    ReadTimeout            : 1000
    ReceivedBytesThreshold : 1
    RtsEnable              : False
    StopBits               : One
    WriteBufferSize        : 2048
    WriteTimeout           : -1
    Site                   :
    Container              :

#>
    function New-SerialPort {
        [CmdletBinding()]
        [OutputType([System.IO.Ports.SerialPort])]
        Param
        (
            # Event Identifier
            [Parameter()]
            [ValidatePattern("[a-zA-Z]\d")]
            [String]
            $Name = "COM3"
        )
        $error.Clear()

        if (Get-Serialport -Name "$Name $Number") {
            throw "Name already exists, use Get-SerialPort"
        }

        $port = InstancePort -Name $Name

        if ($port) {
            # Print data only when recieved, No polling the port that's crazy talk.
            Register-ObjectEvent -InputObject $port -EventName "DataReceived" -SourceIdentifier $Name > $null
        }
        else {
            throw "Port is not defined"
        }

        $port | Write-Output
    }

    function Get-SerialPort {
        [CmdletBinding()]
        [OutputType([System.IO.Ports.SerialPort])]
        Param
        (
            # Name of port to find, default all
            [Parameter()]
            [string]
            $name = '*'
        )

        $real = [System.IO.Ports.SerialPort]::getportnames() |
            ForEach-Object {
            new-object -TypeName PSCustomObject -Property @{
                "type" = "Physical"
                "name" = $psitem.PortName
                "port" = $psitem
            }
        }

        # TODO: implement some kind of virtual port
        # Wrote all of this without testing if you can open a port that doesn't exist in hardware.
        $virtual = Get-EventSubscriber -SourceIdentifier $name -ErrorAction SilentlyContinue |
            Select-Object -ExpandProperty SourceObject |
            ForEach-Object {
            new-object -TypeName PSCustomObject -Property @{
                "type" = "Virtual"
                "name" = $psitem.PortName
                "port" = $psitem
            }
        }

        $real + $virtual | Write-Output

    }

    function Show-SerialPort {
        [CmdletBinding(DefaultParameterSetName = "Name")]
        [OutputType([string])]
        Param
        (
            # Serial Port Object
            [Parameter(ParameterSetName = "Object",
                Mandatory = $true,
                Position = 0,
                ValueFromPipeline = $true,
                ValueFromPipelineByPropertyName = $true)]
            [System.IO.Ports.SerialPort]
            $Port

            , # Port Name
            [Parameter(ParameterSetName = "Name",
                Mandatory = $true,
                Position = 0,
                ValueFromPipeline = $true,
                ValueFromPipelineByPropertyName = $true)]
            [string]
            $Name
        )

        if ($Name) {
            $port = Get-SerialPort -Name $Name |
                Where-Object type -eq "Physical" |
                Select-Object -ExpandProperty port
        }

        if (-not $port) {
            throw "No physical port found to open."
        }

        Write-verbose ("Current port open status: " + $port.isOpen)
        if ( -not $port.isOpen) { $port.open() }

        Write-Verbose "Waiting on data"

        while ($true) {
            Wait-Event -SourceIdentifier $port.portname -Timeout ($port.ReadTimeout / 1000)
        }

        # TODO: catch the difference between data or timeout

        # Why does this just loop the same event output
        Write-Output ($port.ReadExisting())
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
            [System.IO.Ports.SerialPort[]]
            $port

            , # Remove all events in log
            [switch]
            $clean
        )

        Process {
            Write-Verbose "Stop Listening to data"
            Write-Verbose "$($port.portname) status: $($port.isOpen)"
            $port.Close()

            # Free the resources just to be sure it's safely unbound for sucessive runs of the script
            $port.Dispose()

            # Dispose of the event handler to make sure we're all clean
            Unregister-Event $port.portname -ErrorAction SilentlyContinue
            switch ($clean) {
                $true {
                    Remove-Event -SourceIdentifier $port.portName -ErrorAction SilentlyContinue
                }
                Default {}
            }
            Write-Verbose "Event count: $(get-event | measure | select -expandproperty count)"
        }



    }

    function instancePort() {
        [CmdletBinding()]
        [OutputType([System.IO.Ports.SerialPort])]
        Param
        (
            # Port Name
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

        Write-Output $port

    }

    Export-ModuleMember "*-*"
}

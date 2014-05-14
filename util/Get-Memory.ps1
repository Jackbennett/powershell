<#
.Synopsis
    Show the memory configuration
.DESCRIPTION
    Use a WMI query to show the current memory configuration of the target computer
.EXAMPLE
    Get-Memory

    Computer Name : TECH-02
    Manufacturer  : Corsair
    Speed (MHz)   : 1600
    Capacity (MB) : 4096
    DeviceLocator : DIMM 1
    Memory Type   : DDR 3

    Get a list of the memory configuration of the `localhost` computer
.EXAMPLE
    get-memory -ComputerName 50-02 | format-table -autosize

    Computer Name Manufacturer                     Speed (MHz) Capacity (MB) DeviceLocator Memory Type
    ------------- ------------                     ----------- ------------- ------------- -----------
    50-02         JEDEC ID:7F 7F FE 00 00 00 00 00         667          1024 XMM2          DDR-2
    50-02         JEDEC ID:7F 7F 7F 0B 00 00 00 00         667          1024 XMM4          DDR-2

    Get the memory configuration of a remote computer formatted in an easy to read way
.EXAMPLE
    get-memory | select 'computer name','capacity (MB)'

    Computer Name Capacity (MB)
    ------------- -------------
    TECH-02                4096

    Select specific fields from the dataset. Number of fields 4 or below automatically formats as a table.
#>
function Get-Memory
{
    [CmdletBinding()]
    [OutputType([psobject])]
    Param
    (
        # Target computer names
        [Parameter(ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        $ComputerName = 'localhost'
    )

    Begin
    {
        # Inconsistent notation to increase readability.
        $ListOfMemory = @{
            0  = "DDR 3"
            21 = "DDR-2"
            20 = "DDR"
        }

        $Speed = @{
            Name = "Speed (MHz)"
            Expression = {
                $_.speed
            }
        }
        $Capacity = @{
            Name = "Capacity (MB)"
            Expression = {
                [Math]::Round( $_.Capacity / 1mb , 0)
            }
        }
        $SourceComputer = @{
            name="Computer Name"
            expression={
                $_.__SERVER
            }
        }
        $MemoryType = @{
            name="Memory Type"
            expression={
                $_.MemoryType
                $ListOfMemory.Item($_.MemoryType)
            }
        }

    }
    Process
    {
        Get-WmiObject `
            -class win32_PhysicalMemory `
            -ComputerName $ComputerName `
            |
            select `
                $SourceComputer,
                Manufacturer,
                $Speed,
                $Capacity,
                DeviceLocator,
                $MemoryType `
                |
                where { $_.DeviceLocator -notmatch "SYSTEM ROM" } `
                |
                Write-Output
    }
}
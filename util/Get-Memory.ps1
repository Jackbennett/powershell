<#
.Synopsis
   Show the memory configuration
.DESCRIPTION
   Use a WMI query to show the current memory configuration of the target computer
.EXAMPLE
   Example of how to use this cmdlet
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
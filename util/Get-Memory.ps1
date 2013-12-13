<#
.Synopsis
   WMI Get memory
.DESCRIPTION
   Long description
.EXAMPLE
   Example of how to use this cmdlet
.EXAMPLE
   Another example of how to use this cmdlet
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
    }
    Process
    {
        $speed = @{
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

        Get-WmiObject `
            -class win32_PhysicalMemory `
            -ComputerName $computerName `
            -ErrorAction SilentlyContinue `
            |
            select `
                $SourceComputer,
                Manufacturer,
                $speed,
                $Capacity,
                DeviceLocator `
                |
                Write-Output
    }
}
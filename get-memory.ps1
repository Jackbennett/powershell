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
    [OutputType([int])]
    Param
    (
        # Optional Computer to run on
        [Parameter(ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        [string]
        $computerName = 'localhost'

        , # Query String
        [string]
        $Query = "Select Manufacturer,Speed,Capacity,DeviceLocator,__SERVER from win32_PhysicalMemory"
    )

    Begin
    {
    }
    Process
    {
        $results = Get-WmiObject -Query $query -ComputerName $computerName | 
            select  Manufacturer,
                @{Name="Speed/MHz";Expression={$_."speed"}},
                @{Name="Capacity/MB";Expression={$_."Capacity"/1mb}},
                DeviceLocator,
                __SERVER
    }
    End
    {
        return $results
    }
}
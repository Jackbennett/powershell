<#
.Synopsis
   List free space and total sizes on selected machines.
.DESCRIPTION
   List free space and total sizes on selected machines.
.EXAMPLE
   Example of how to use this cmdlet
.EXAMPLE
   Another example of how to use this cmdlet
#>
function Get-FreeSpace
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
        $FreeSpace = @{
            name="FreeSpace (GB)"
            expression={
                [Math]::Round($_.freeSpace/1gb, 2)
            }
        }

        $Size = @{
            name="Size (GB)"
            expression={
                [Math]::Round($_.Size/1gb, 2)
            }
        }
        $SourceComputer = @{
            name="Computer Name"
            expression={
                $_.__SERVER
            }
        }

        Get-WmiObject `
            -Class win32_logicaldisk `
            -ComputerName $ComputerName `
            -ErrorAction SilentlyContinue `
            |
            select `
                $SourceComputer,
                deviceid,
                $FreeSpace,
                $Size `
                |
                Write-Output
    }
}
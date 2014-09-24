<#
.Synopsis
   Enable Jumbo Packets
.DESCRIPTION
   enable the use of Jumbo Packets on all ethernet adapters
.EXAMPLE
   Example of how to use this cmdlet
.EXAMPLE
   Another example of how to use this cmdlet
#>
function Enable-JumboPacket
{
    [CmdletBinding()]
    [OutputType([int])]
    Param
    (
        # Target Computer
        [Parameter(ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        [Alias('ComputerName')]
        $CimSession
    )

    Begin
    {
        if(($CimSession) -and ($CimSession -isnot [Microsoft.Management.Infrastructure.CimSession]) ){
            try{
                $CimSession = $CimSession | New-CimSession
                throw
            } catch {
                exit
            }
        }

        function adapter{
            Get-NetAdapterAdvancedProperty -RegistryKeyword '*JumboPacket'
            # Set-NetAdapterAdvancedProperty -RegistryValue '9014' -NoRestart
        }
    }
    Process
    {
        if($CimSession){
            $CimSession | adapter
        } else {
            adapter
        }
    }
    End
    {
        Write-Output "Target computer should be restarted."

        $CimSession | Remove-CimSession
    }
}

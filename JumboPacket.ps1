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
        $Computername
    )

    Begin
    {
        if($Computername -isnot [Microsoft.Management.Infrastructure.CimSession]){
            try{
                $Computername = $Computername | New-CimSession
            } catch {
                throw
                exit
            }
        }
    }
    Process
    {
        $Computername | Get-NetAdapterAdvancedProperty -DisplayName “Jumbo Packet” 

           # Set-NetAdapterAdvancedProperty -RegistryValue '9014' -NoRestart
    }
    End
    {
        Write-Output "Target computer should be restarted."

        $Computername | Remove-CimSession
    }
}
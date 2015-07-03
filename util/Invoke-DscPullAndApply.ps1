function Invoke-DscPullAndApply
{
Param
(
  [Parameter(Mandatory)]
  [ValidateNotNullOrEmpty()]
  [String[]]$ComputerName
)

# Gets latest configuration from  pull server and apply immediately
$InvokeMethodSplat = @{
  ComputerName = $ComputerName
  Namespace = 'root/microsoft/windows/desiredstateconfiguration'
  ClassName = 'MSFT_DscLocalConfigurationManager'
  MethodName = 'PerformRequiredConfigurationChecks'
  Arguments = @{Flags = [UInt32]1}
  Verbose = $true
}

Invoke-CimMethod @InvokeMethodSplat
}
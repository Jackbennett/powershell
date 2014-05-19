<#
.Synopsis
   Short description
.DESCRIPTION
   Long description
.EXAMPLE
   Example of how to use this cmdlet
.EXAMPLE
   Another example of how to use this cmdlet
#>
function Set-Proxy
{
    [CmdletBinding()]
    [OutputType([int])]
    Param
    (
        # Param1 help description
        [Parameter(ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        $proxy = "http://proxy.lancsngfl.ac.uk:8080"

        , # If you want to permenantly set this. reqires restart
        [switch]
        $global
    )

    Begin
    {
    }
    Process
    {
        Get-SSID | select ssid | foreach-object {
	        if ($_.ssid -match "upholland"){
                if($global){
                    [environment]::SetEnvironmentVariable("http_proxy", $proxy, "User")
                    [environment]::SetEnvironmentVariable("https_proxy", $proxy, "User")
                } else {
                    $env:http_proxy = $proxy
                    $env:https_proxy = $proxy
                }
		        git config --global --add http.proxy $proxy
		        git config --global --add https.proxy $proxy
	        } else {
                if($global){
                    [environment]::SetEnvironmentVariable("http_proxy", $null, "User")
                    [environment]::SetEnvironmentVariable("https_proxy", $null, "User")
                } else {
                    Remove-Variable $env:http_proxy
                    Remove-Variable $env:https_proxy
                }
		        git config --global --remove-section http
		        git config --global --remove-section https
	        }
        }
    }
    End
    {
    }
}
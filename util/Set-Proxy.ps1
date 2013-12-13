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

    )

    Begin
    {
    }
    Process
    {
        Get-SSID | select ssid | foreach-object {
	        if ($_.ssid -match "upholland"){
                [environment]::SetEnvironmentVariable("http_proxy", $proxy, "User")
                [environment]::SetEnvironmentVariable("https_proxy", $proxy, "User")
		        git config --global --add http.proxy $proxy
		        git config --global --add https.proxy $proxy
	        } else {
                [environment]::SetEnvironmentVariable("http_proxy", $null, "User")
                [environment]::SetEnvironmentVariable("https_proxy", $null, "User")
		        git config --global --remove-section http
		        git config --global --remove-section https
	        }
        }
    }
    End
    {
    }
}
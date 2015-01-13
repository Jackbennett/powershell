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
        $proxy = "http://10.201.0.27:801"

        , # If you want to permenantly set this. reqires restart
        [switch]
        $global

        , # SSID to automatically detect
        [string]
        $SSID
    )

    Begin
    {
        function setProxyConfiguration
        {
            if($global){
                [environment]::SetEnvironmentVariable("http_proxy", $proxy, "User")
                [environment]::SetEnvironmentVariable("https_proxy", $proxy, "User")
            } else {
                $env:http_proxy = $proxy
                $env:https_proxy = $proxy
            }
		    git config --global --add http.proxy $proxy
		    git config --global --add https.proxy $proxy
        }

        function removeProxyConfiguration
        {
            if($global){
                [environment]::SetEnvironmentVariable("http_proxy", $null, "User")
                [environment]::SetEnvironmentVariable("https_proxy", $null, "User")
            } else {
                Remove-Item env:http_proxy
                Remove-Item env:https_proxy
            }
		    git config --global --remove-section http
		    git config --global --remove-section https
        }
    }

    Process
    {
        if($SSID){
            Get-SSID | select ssid | foreach-object {
	            if ($_.ssid -match $SSID){
                    setProxyConfiguration
	            } else {
                    removeProxyConfiguration
	            }
            }
            return
        }

        setProxyConfiguration

    }
}

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
function Set-Proxy {
    [CmdletBinding()]
    [OutputType([int])]
    Param
    (
        # Param1 help description
        [Parameter(ValueFromPipelineByPropertyName = $true,
            Position = 0)]
        $proxy = "http://10.201.0.27:801"

        , # If you want to permenantly set this. reqires restart
        [switch]
        $global

        , # SSID to automatically detect
        [string]
        $SSID
    )

    Begin {
        $RegistryPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings"

        function setProxyConfiguration {
            if ($global) {
                [environment]::SetEnvironmentVariable("http_proxy", $proxy, "User")
                [environment]::SetEnvironmentVariable("https_proxy", $proxy, "User")
            }
            else {
                $env:http_proxy = $proxy
                $env:https_proxy = $proxy
            }

            git config --global --add http.proxy $proxy
            git config --global --add https.proxy $proxy
            
            Set-ItemProperty -Path $RegistryPath -Name ProxyServer -Value $proxy
            Set-ItemProperty -Path $RegistryPath -Name ProxyEnable -Value $true

        }

        function removeProxyConfiguration {
            if ($global) {
                [environment]::SetEnvironmentVariable("http_proxy", $null, "User")
                [environment]::SetEnvironmentVariable("https_proxy", $null, "User")
            }
            else {
                Remove-Item env:http_proxy
                Remove-Item env:https_proxy
            }
            git config --global --remove-section http
            git config --global --remove-section https
            
            Set-ItemProperty -Path $RegistryPath -Name ProxyEnable -Value $false
        }

        function notifyAllWindows {
            #This I don't understand one iota. What's with the numbers?
            $method = 'SendMessageTimeout_6a057adb_f92f_4e34_bda2_42bc79d05f5c'
            $type = $method -as [type]

            if ($global) {
                if (-not $type) {
                    #import sendmessagetimeout from win32
                    $type = Add-Type -pass -Name $method -MemberDefinition @"
[DllImport("user32", SetLastError = true)]
public static extern IntPtr SendMessageTimeout(
    IntPtr hWnd, uint Msg, UIntPtr wParam, string lParam,
    uint fuFlags, uint uTimeout, out UIntPtr lpdwResult);
"@
                }

                $HWND_BROADCAST = [intptr]0xffff
                $WM_SETTINGCHANGE = [uint32]0x1a
                $result = [uintptr]::zero
                $SMTO_NORMAL = [uint32]0

                #Notify all windows of the envornment change
                $type::SendMessageTimeout(
                    $HWND_BROADCAST,
                    $WM_SETTINGCHANGE,
                    [uintptr]::zero,
                    "Environment",
                    $SMTO_NORMAL,
                    1000,
                    [ref]$result)
            }
        }
    }

    Process {
        if ($SSID) {
            Get-SSID | select ssid | foreach-object {
                if ($_.ssid -match $SSID) {
                    setProxyConfiguration
                }
                else {
                    removeProxyConfiguration
                }
            }
            return
        }

        setProxyConfiguration

        if ($global) {
            notifyAllWindows
        }

    }
}

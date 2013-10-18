
$proxy = "http://proxy.lancsngfl.ac.uk:8080"

Get-SSID | select ssid | foreach-object {
	if ($_.ssid -match "upholland"){
        [environment]::SetEnvironmentVariable("http_proxy", $proxy, "User")
        [environment]::SetEnvironmentVariable("https_proxy", $proxy, "User")
		git config --global --add http.proxy $proxy
		git config --global --add https.proxy $proxy
	} else {
        [environment]::SetEnvironmentVariable("http_proxy", $null, "User")
        [environment]::SetEnvironmentVariable("https_proxy", $null, "User")
		git config --global --unset-all http.proxy
		git config --global --unset-all https.proxy
	}
}
function New-Directory{
	new-item -type directory -name $args[0] > $null
	Set-Location $args[0]
}

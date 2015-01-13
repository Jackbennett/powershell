Push-Location 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Console\TrueTypeFont'
New-ItemProperty -Path . -Name 1 -Value 'Fantasque Sans Mono Regular' -PropertyType string
Pop-Location

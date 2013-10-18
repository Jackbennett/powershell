set-location hklm:

$profileList = "\Software\Microsoft\Windows NT\CurrentVersion\ProfileList"

Get-ChildItem $profileList | foreach {
    Get-ItemProperty $_ | select profileImagePath, psChildName
}
$date = Get-Date -format MMddyyyyHHmm
$policy = New-WBPolicy
$volume = Get-WBVolume -AllVolumes
$backupLocation = New-WBBackupTarget -NetworkPath "\\ts-xl19c\share\WindowsImageBackup\Hyper-A\$date"

New-Item "\\ts-xl19c\share\WindowsImageBackup\Hyper-A\$date" -type directory

Add-WBVolume -Policy $policy -Volume $volume 
Add-WBSystemState $policy 
Add-WBBareMetalRecovery $policy 
Add-WBBackupTarget -Policy $policy -Target $backupLocation 
Set-WBVssBackupOptions -Policy $policy -VssCopyBackup 
Start-WBBackup -Policy $policy
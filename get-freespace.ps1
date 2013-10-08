$disk = Get-WmiObject Win32_LogicalDisk -ComputerName remotecomputer -Filter "DeviceID='C:'" |
Select-Object Size,FreeSpace

$disk.Size
$disk.FreeSpace
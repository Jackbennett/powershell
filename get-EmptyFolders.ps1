Write-Warning "Make sure you own permissions to read the contents of all the directories" 

Pause

ls | ?{$_.PSIsContainer -eq $true} | ? {$_.getFiles().count -eq0 } | select @{name="Path";expression={$_.fullname}}
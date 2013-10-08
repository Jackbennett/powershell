
Get-WindowsFeature | 
where {$_.installed -eq 'false'} | 
Select-Object installed,displayNAme,name | 
ConvertTo-Json | 
out-file c:\test.json
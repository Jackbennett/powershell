# Alias for 7-zip
if (-not (test-path "$env:ProgramFiles\7-Zip\7z.exe")) {throw "$env:ProgramFiles\7-Zip\7z.exe needed"}
set-alias sz "$env:ProgramFiles\7-Zip\7z.exe"
 
# directories to use
$base = 'uhserver1\HomeStaff\'
$zipdir = 'TS-XL19c\share\'
 
# Zip-file name
$name = split-path $base -leaf
$zipfile = $zipdir + $name +"-" + (get-date -f dd-MM-yyyy)+ '.7z'
$zipoption = ' -t7z "' + $zipfile + '"'
 
# Files to compress
$from = $base + "*.*"
 
# Create zip-file
write-host "from:\\" $from
write-host "zipopt:\\" $zipoption
 
sz a -r -t7z "\\$zipfile" "\\$from"
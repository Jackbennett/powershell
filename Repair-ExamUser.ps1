$source = @'
\\upholland.lancsngfl.ac.uk\usershares\PupilShared\examination share\Unit 9 Using ICT in Business Teachers' Notes Files\*
'@

$users = Get-ADGroup -Identity examination |
    Get-ADGroupMember |
    Get-ADUser -Properties HomeDirectory |
    sort-object -Property SamAccountName

# empty the home folder
$users |
    select @{n="LiteralPath";e={$psitem.HomeDirectory}} |
    Get-ChildItem -Force |
    Remove-Item -Recurse -Force

# copy in new source files
$users |
    select @{n="Destination";e={$psitem.HomeDirectory}} |
    copy-item -Path $source -Force

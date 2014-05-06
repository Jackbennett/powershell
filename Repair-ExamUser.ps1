<#
.Synopsis
    Batch clear then copy boilerplate documents into exam accounts.
.NOTES
    Possible additions

    * Move the exsiting files to an archive isntead of deletion
    * Batch reset the exam account password
    * Set a script to run on first login to GUI prompt for candidate number and name
        * Create a file of info to link the current state of the folder to a user
        * Use details to pre-populate the office template headers so students can't forget it.
        * if number changes lock folder permissions of old details and start a new folder.
#>
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
<#
.Synopsis
   Do all the eactive directory accounts have the correct profile path
.DESCRIPTION
   If any profile path is set, does it also contains the users account name.
   Troubleshooting an issue where users seems to randomly get another users profiles set for them at logoff.
.EXAMPLE
   Example of how to use this cmdlet
.EXAMPLE
   Another example of how to use this cmdlet
#>
function Report-ProfilePath
{
    Process
    {
        get-aduser -filter * -properties "SamAccountName","ProfilePath" | 
        where {$psitem.profilePath -notmatch $psitem.samAccontName}
    }
}
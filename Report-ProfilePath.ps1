<#
.Synopsis
   Do all the eactive directory accounts have the correct profile path
.DESCRIPTION
   If any profile path is set, does it also contains the users account name.
   Troubleshooting an issue where users seems to randomly get another users profiles set for them at logoff.
.EXAMPLE
    Report-ProfilePath
    Got 1371 users
    Problems on:

    SamAccountName      ProfilePath
    --------------      -----------
    07test              \\uhserver1\users$\08test\profile.v2
#>
function Report-ProfilePath
{
    Process
    {
        $result = get-aduser -filter * -properties "SamAccountName","ProfilePath" -OutVariable users |
            where {($psitem.profilePath -ne $null) -and ($psitem.ProfilePath -notmatch $psitem.SamAccountName)}
    }
    End{
        Write-Output "Got $($users.count) users"
        if($result){
            Write-Output "Problems on:"
            Write-Output $result | select SamAccountName, ProfilePath
        } else {
            Write-Output "No incorrect profiles found"
        }
    }
}
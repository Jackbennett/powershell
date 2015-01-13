<#
.Synopsis
   Short description
.DESCRIPTION
   Long description
.EXAMPLE
   Import-CSV './users.csv' | Format-ActiveLearnUsers | ConvertTo-CSV | Out-File 'Formatted-Users.csv'
.EXAMPLE
   Another example of how to use this cmdlet
#>
function Format-ActiveLearnUsers
{
    [CmdletBinding()]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$true,
                   ValueFromPipeline=$true,
                   Position=0)]
        $CSV
        
        , [string]
        $password = "ChangeMe144"

        , [string]
        $Prefix = "UHHS-"
    )

    Process
    {
        $row = $CSV |
            Select @{
                Name='DOB';
                Expression={
                    $date = [datetime]$_.DOB
                    $date.ToShortDateString()
                }
            },@{
                Name='Year';
                Expression={
                    Remove-Variable matches
                    $_.Year -match "\d+" > $null
                    $matches.Values
                };
            },@{
                Name = 'startYear';
                Expression={
                    Remove-Variable matches
                    $_."Year of entry" -match "\d{2}$" > $null
                    $matches.Values[0]
                };
            },
            Forename,
            Surname 

        $row | Add-Member -MemberType NoteProperty -Name Password -Value $password
        $row | Add-Member -MemberType NoteProperty -Name Username -Value ($prefix + $row.startYear + $_.surname + $_.forename[0])

        $row | select -property * -exclude  "startYear"
    }
}
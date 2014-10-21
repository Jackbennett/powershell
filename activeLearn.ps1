<#
.Synopsis
   Short description
.DESCRIPTION
   Long description
.EXAMPLE
   Example of how to use this cmdlet
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
        $password = "ChangeMe133"

        , [string]
        $Prefix = "UHHS-"
    )

    Process
    {
        $CSV |
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
                    $matches.Values
                };
            },
            Forename,
            Surname |
            Add-Member -MemberType NoteProperty -Name Password -Value $password -PassThru | 
            Add-Member -MemberType NoteProperty -Name Username -Value ($prefix + $_.startYear + $_.surname + $_.forename[0]) -PassThru |
            select -property * -exclude  "startYear"
    }
}
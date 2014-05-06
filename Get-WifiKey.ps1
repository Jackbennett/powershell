<#
.Synopsis
    Compute a decent wifi key from a memorable string
.DESCRIPTION
    This functions is to consistently get a kind of good password
    that's always the same when given the same hint. This is so administrators can remember 
    an easy keyword to pull up the password to hand out to guests quickly but avoiding a
    simple to guess password.
.EXAMPLE
    Get-WifiKey september
    110cea74c
#>
function Get-WifiKey
{
    [CmdletBinding()]
    [OutputType([string])]
    Param
    (
        # What to use as a hint for the key
        [Parameter(Mandatory=$true,
                   Position=0)]
        [string]$hint

        , # The length of the returned key
        [ValidateRange(1,31)]
        [int]$length = 9
    )

    Begin
    {
        $Algorithm = new-object -TypeName System.Security.Cryptography.MD5CryptoServiceProvider
        $Text = New-Object -TypeName System.Text.UTF8Encoding

    }
    Process
    {
        $Key = [System.BitConverter]::ToString(
        $Algorithm.ComputeHash(
            $text.GetBytes( $hint )
            )
        ).replace('-','').remove($length).ToLower()

    }
    End
    {
        Write-Output $Key
    }
}
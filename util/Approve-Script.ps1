<#
.Synopsis
   Sign the given script
.DESCRIPTION
   Use the default key at the top of the current users certificate store
.EXAMPLE
   Example of how to use this cmdlet
.EXAMPLE
   Another example of how to use this cmdlet
#>
function Approve-Script
{
    [CmdletBinding()]
    [OutputType([System.IO.FileInfo])]
    Param
    (
        # The script to sign
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        [Alias('Path')]
        [String[]]
        $Name

        , # 
        $Store = "Cert:\CurrentUser\My"
        , # which certificate to use in the given store
        $Index = 0
    )

    Begin
    {
        # Do not leak the certificate into the session
        $private:cert

        try{
            $cert = (Get-ChildItem $Store -ErrorAction Stop)[$Index]
        }
        catch {
            Write-Error "Certificate not found in $Store at $Index"
        }
    }
    Process
    {
        $Name | Set-AuthenticodeSignature -Certificate $cert
    }
    End
    {
        
    }
}
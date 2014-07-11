<#
.Synopsis
   Sign the given script
.DESCRIPTION
   Use the default key at the top of the current users certificate store
.EXAMPLE
   Approve-Script .\HelloWorld.ps1

   Sign the script `HelloWorld.ps1` with out default code signing key added to the user account
.EXAMPLE
   Get-ChildItem . | Approve-Script

   Sign everything in the current folder.
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

        , # Path to the certificate store to use.
        $CertificateStore = "Cert:\CurrentUser\My"
        , # which certificate to use in the given store.
        $StoreIndex = 0
    )

    Begin
    {
        # Do not leak the certificate into the session
        $private:cert

        try{
            $private:cert = (Get-ChildItem $CertificateStore -ErrorAction Stop)[$StoreIndex]
        }
        catch {
            Write-Error "Certificate not found in $CertificateStore at $StoreIndex"
        }
    }
    Process
    {
        $Name | Set-AuthenticodeSignature -Certificate $private:cert
    }
    End
    {
        
    }
}
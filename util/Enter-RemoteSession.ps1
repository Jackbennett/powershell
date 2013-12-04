<#
.Synopsis
    Drop into a remote powershell session
.DESCRIPTION
    Wrapping 'Enter-PSSession' to drop into a remote powershell session with the authentication method CredSSP.

    This allows the remote session to delegate credentials to initiate other remote sessions. 
    For example copying a file c:\example.txt to \\server\share
.EXAMPLE
    Enter-RemoteSession 52-01
    [52-01.domain.name]: PS C:\Users\j\Documents> _
.EXAMPLE
    $c = get-credential
    C:\PS>Enter-RemoteSession 52-01 $c

    Set your credentails before hand to pass into the cmdelt without prompting
.OUTPUTS
   REPL on remote computer
#>
function Enter-RemoteSession
{
    [CmdletBinding(PositionalBinding=$false)]
    Param
    (
        # Computer or hostname of the target machine
        [Parameter(Mandatory=$true, 
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true, 
                   ValueFromRemainingArguments=$false, 
                   Position=0)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [Alias("hostname")]
        [string]
        $ComputerName

        , # Credentials of the user account to remote as. 
        [Parameter(ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true, 
                   ValueFromRemainingArguments=$false,
                   Position=1)]
        [PSCredential]
        $Credential = (Get-Credential (whoami))

        , # Domain name of the target machine for the SPN WSMAN/*.domain to find
        [String]
        $Domain = [System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain().name
    )

    Begin
    {
    }
    Process
    {
        Enter-PSSession -ComputerName "$ComputerName.$Domain" `
            -Authentication Credssp `
            -Credential $Credential
    }
    End
    {
    }
}
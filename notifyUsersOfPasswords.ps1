if(-not $cred){
    $cred = get-credential
}

try{
    $users = import-csv 'newUserPasswords'
} catch {
    Write-Error 'Probably can`t find the file'
    Write-Error 'Using test accounts'
    #testing
    $users = @(
        @{
            to = # Secret - don't check into vcs
            password = 'example'
        }
        @{
            to = # Secret - don't check into vcs
            password = 'hunter2'
        }
    )
}

$users |
    ForEach-Object {
        $email = @{
            Subject = "New Email Passwords"
            smtpServer = # Secret - don't check into vcs
            port = 587
            from = # Secret - don't check into vcs
            priority = "High"
            Credential = $cred
            to = $_.to
            BodyAsHtml = $true
            #Intending isn't broken. Multiline strings must be at the beginning of new lines
Body = @"
<h1>Pending Email Migration</h1>
<h2>18th of December</h2>
<h3>New password: $($_.password)</h3>

<p>On the 18th of December Lancashire will migrate our emails to a new service</p>

<p>After the migration your account password will have been reset.
To log in after the 18th you have to know you password: <strong>$($_.password)</strong></p>
"@
 }

        # -- testing line. comment me out after verifying objects
        $email | ft

        # -- the "Do you really mean it" line
        #Send-MailMessage @email
    }
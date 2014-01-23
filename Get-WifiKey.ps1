$Input = 'september'

$Algorithm = new-object -TypeName System.Security.Cryptography.MD5CryptoServiceProvider

$Text = New-Object -TypeName System.Text.UTF8Encoding

$Key = [System.BitConverter]::ToString(
    $Algorithm.ComputeHash(
        $text.GetBytes( $Input )
        )
    ).replace('-','').remove(9).ToLower()

$Key
New-PSDrive -Name psStore -PSProvider FileSystem -Root \\uhserver1\psstore -Description "Powershell script and module store"

if($env:PSModulePath -notmatch ';psStore:')
{
    $env:PSModulePath += ';psStore:\'
}
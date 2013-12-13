Get-ChildItem -Path $PSScriptRoot\*.ps1 `
|
Foreach-Object{
    $v = measure-command {
        . $_.FullName
    }
    Write-Host $v.TotalSeconds ' seconds - ' $_.FullName
}
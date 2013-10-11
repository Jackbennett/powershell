New-PSDrive -Name psStore -PSProvider FileSystem -Root \\uhserver1\psstore -Description "Powershell script and module store"

if($env:PSModulePath -notmatch ';psStore:')
{
    $env:PSModulePath += ';psStore:\'
}


<#
 # I don't think this is nescsary once you've added the psstore to the module path
#>
    <#
    function Import-All($alias){
        Get-ChildItem -Path psstore:\ -Directory | select name | Import-Module $_
    }
    #>
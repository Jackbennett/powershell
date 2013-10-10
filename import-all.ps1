Get-ChildItem -Path $PSScriptRoot\*.psm1 -Recurse | Foreach-Object{ import-module $_.FullName }


. \\uhserver1\psstore\add-psstore.ps1
<#
.Synopsis
   Helper script to register the context menu entry to run 'Submit-Finishedwork'
.DESCRIPTION
   Must run as administrator
.EXAMPLE
   .\Register-FinishedWork.ps1

   Execute this file will run the function it exporots. It will not leave a new drive in the scope. 
#>
function Register-FinishedWork
{
    [CmdletBinding()]
    Param
    (

    )

    Begin
    {
        New-PSDrive -Name HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT
    }
    Process
    {
        New-Item -Path "HKCR:\`*\Shell\Powershell" -Force -Value "Submit Finished Work"
        New-Item -Path "HKCR:\`*\Shell\Powershell\Command" -Force -Value "C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\powershell.exe -executionPolicy Bypass -NoProfile -Noninteractive -NoLogo -File N:\ps\exams\Submit-FinishedWork.ps1 `"%1`""
    }
    End
    {
    }
}

Register-FinishedWork

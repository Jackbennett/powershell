<#
.Description
Caveats;
1. Can't remote onto computers you are logged onto already
2. Warning Messages for each computer that hasn't worked. 
    Will continue through the whole list regardless
.EXAMPLE
.\Exit-Sims.ps1 -ComputerName tech-03,tech-01
@{computerName=tech-03}
Have SIMS running. Use -Exit to close these
.EXAMPLE
.\Exit-Sims.ps1 -ComputerName tech-03,localhost,tech-01 -Exit
#>
Param(
    [string[]]$ComputerName = 'localhost'
    
    , # Close the remote instance of SIMS
    [switch]$Exit
)

$ScriptBlock = { Get-Process -name "Pulsar" -ErrorAction SilentlyContinue | Stop-Process -Force }

switch ($Exit)
{
    $true
    {
        Invoke-Command $ComputerName -ScriptBlock $ScriptBlock -ErrorAction Continue
    }
    $false
    {
        [string[]]$names = Get-Process -name 'Pulsar' -ComputerName $ComputerName -ErrorAction Continue | 
            Select @{name='computerName'; expression={$_.MachineName} }

        if($names)
        {
            $names
            Write-Output "Have SIMS running. Use -Exit to close these"
        }
    }
}
$Office = @{
    j = @('TECH-02','TECH-03')
    Robert = @('TECH-01','TECH-04')
}

# Quit if we're not on one of these computers
$HostcomputerTest = $Office.keys | foreach { $env:COMPUTERNAME -in $Office[$_] }
if($HostcomputerTest -eq $false){
    Exit
}

# Preserve a variable outside the foreach cmdlet scope.
[string]$StopLast = $null

# Must not turn off host PC before sending stop-computer to the others.
[scriptblock]$EachComputer = {
    if($_ -eq $env:COMPUTERNAME){
        $StopLast = $_
    } else {
        Stop-Computer -ComputerName $_ -Force
    }
}

$Office[$env:username] |
    ForEach-Object -Process $EachComputer -End {
        Stop-Computer -ComputerName $StopLast -Force
    }

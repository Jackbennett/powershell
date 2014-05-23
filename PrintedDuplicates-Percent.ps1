$printing = Import-csv .\r36-Apr-25--May-23.csv | where "Printer Name" -Like "brother hl-2250dn room 36" | where "Printed" -eq "Y"

$Sorted = $printing | Group-Object -Property "Username","Document" | where "count" -GT 1
$SortedValues = $Sorted | measure-object -Property "count" -sum


$Jobs = $printing.count
$dupe = $SortedValues.Sum - $SortedValues.Count

$dupe / $Jobs * 100
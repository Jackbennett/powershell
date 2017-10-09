function Get-AuditLog{
[CmdletBinding(DefaultParameterSetName='Default')]
Param(
    $server = "bhs-fs02"
    ,$Path = "C:\Temp\4663Events-$((get-date -Format s).Replace(':', '.')).csv"
    ,$StartDate = (get-date)
    ,$EndDate = (get-date).AddDays(1)
)

$ns = @{e="http://schemas.microsoft.com/win/2004/08/events/event"}
$xml = New-Object -TypeName XML
$AccessLookup = @{
 0x1     = 'Read Data / List Directory'
 0x2     = 'Write Data / Add File'
 0x4     = 'Append Data / Create Subdirectory'
 0x20    = 'Execute / Traverse Directory'
 0x40    = 'Delete Directory and all children'
 0x100   = 'Change file Attributes'
 0x10000 = 'Delete'
}

$outStream = (new-item -ItemType File -Path $Path).AppendText()
$outStream.WriteLine("Server,EventID,Time,UserName,Path,AccessMask")

foreach ($svr in $server){

    $queryTime = measure-command {
    $evts = Get-WinEvent -computer $svr -Oldest -FilterHashtable @{
        ProviderName = "Microsoft-Windows-Security-Auditing";
        ID = "4663";
        StartTime = $StartDate.toShortDateString();
        EndTime = $EndDate.toShortDateString();
    }
    }

    Write-Verbose "Found $($evts.Length) events in $($queryTime.TotalSeconds) seconds."

    foreach($evt in $evts){

        $xml.loadXML($evt.ToXml())

        $SubjectUserName = Select-Xml -Xml $xml -Namespace $ns -XPath "//e:Data[@Name='SubjectUserName']/text()" | Select-Object -ExpandProperty Node | Select-Object -ExpandProperty Value

        $ObjectName = Select-Xml -Xml $xml -Namespace $ns -XPath "//e:Data[@Name='ObjectName']/text()" | Select-Object -ExpandProperty Node | Select-Object -ExpandProperty Value

        $AccessMask = Select-Xml -Xml $xml -Namespace $ns -XPath "//e:Data[@Name='AccessMask']/text()" | Select-Object -ExpandProperty Node | Select-Object -ExpandProperty Value

        $Mask = [convert]::ToInt32($AccessMask,16)

        if($AccessLookup[$Mask]){
            $AccessMask = $AccessLookup[$Mask]
        }


        $outStream.WriteLine("$($svr),$($evt.id),$($evt.TimeCreated),$SubjectUserName,$ObjectName,$AccessMask")

    }

}

$outStream.close()

}

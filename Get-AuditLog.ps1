﻿$server = "bhs-fs02"
$outStream = (new-item -ItemType File -Path "C:\Temp\4663Events-$((get-date -Format s).Replace(':', '.')).csv").AppendText()
$ns = @{e = "http://schemas.microsoft.com/win/2004/08/events/event"}
$StartDate = Get-Date
$EndDate = $StartDate.AddDays(1)
$xml = New-Object -TypeName XML
$AccessMaskLookup = @{
 0x1     = 'Read Data / List Directory'
 0x2     = 'Write Data / Add File'
 0x4     = 'Append Data / Create Subdirectory'
 0x20    = 'Execute / Traverse Directory'
 0x40    = 'Delete Directory and all children'
 0x100   = 'Change file Attributes'
 0x10000 = 'Delete'
}
$outStream.WriteLine("ServerName,EventID,TimeCreated,UserName,File_or_Folder,AccessMask")

foreach ($svr in $server){
    $evts = Get-WinEvent -computer $svr -Oldest -FilterHashtable @{
        logname = "security";
        id = "4663";
        StartTime = $StartDate.toShortDateString();
        EndTime = $EndDate.toShortDateString();
    }

    foreach($evt in $evts){

        $xml.loadXML($evt.ToXml())

        $SubjectUserName = Select-Xml -Xml $xml -Namespace $ns -XPath "//e:Data[@Name='SubjectUserName']/text()" | Select-Object -ExpandProperty Node | Select-Object -ExpandProperty Value

        $ObjectName = Select-Xml -Xml $xml -Namespace $ns -XPath "//e:Data[@Name='ObjectName']/text()" | Select-Object -ExpandProperty Node | Select-Object -ExpandProperty Value

        $AccessMask = Select-Xml -Xml $xml -Namespace $ns -XPath "//e:Data[@Name='AccessMask']/text()" | Select-Object -ExpandProperty Node | Select-Object -ExpandProperty Value

        if($AccessMaskLookup[[convert]::ToInt32($AccessMask,16)]){
            $AccessMask = $AccessMaskLookup[[convert]::ToInt32($AccessMask,16)]
        }

        $outStream.WriteLine("$($svr),$($evt.id),$($evt.TimeCreated),$SubjectUserName,$ObjectName,$AccessMask")

    }

}

$outStream.close()

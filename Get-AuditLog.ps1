$server = "bhs-fs02"
$out = (new-item -ItemType File -Path 'C:\Temp\4663Events.csv').AppendText()
$out.WriteLine("ServerName,EventID,TimeCreated,UserName,File_or_Folder,AccessMask")
$ns = @{e = "http://schemas.microsoft.com/win/2004/08/events/event"}
$AccessMaskLookup = @{
 0x1     = 'Read Data / List Directory'
 0x2     = 'Write Data / Add File'
 0x4     = 'Append Data / Create Subdirectory'
 0x20    = 'Execute / Traverse Directory'
 0x40    = 'Delete Directory and all children'
 0x100   = 'Change file Attributes'
 0x10000 = 'Delete'
}

foreach ($svr in $server)
    {    $evts = Get-WinEvent -computer $svr -FilterHashtable @{logname="security";id="4663"} -oldest

    foreach($evt in $evts)
        {
        $xml = [xml]$evt.ToXml()

        $SubjectUserName = Select-Xml -Xml $xml -Namespace $ns -XPath "//e:Data[@Name='SubjectUserName']/text()" | Select-Object -ExpandProperty Node | Select-Object -ExpandProperty Value

        $ObjectName = Select-Xml -Xml $xml -Namespace $ns -XPath "//e:Data[@Name='ObjectName']/text()" | Select-Object -ExpandProperty Node | Select-Object -ExpandProperty Value

        $AccessMask = Select-Xml -Xml $xml -Namespace $ns -XPath "//e:Data[@Name='AccessMask']/text()" | Select-Object -ExpandProperty Node | Select-Object -ExpandProperty Value

        if($AccessMaskLookup[[convert]::ToInt32($AccessMask,16)]){
            $AccessMask = $AccessMaskLookup[[convert]::ToInt32($AccessMask,16)]
        }

        $out.WriteLine("$($svr),$($evt.id),$($evt.TimeCreated),$SubjectUserName,$ObjectName, $AccessMask")

        Write-Verbose $svr
        Write-Verbose "$($evt.id), $($evt.TimeCreated), $SubjectUserName, $ObjectName, $AccessMask"

        }
    }

$out.close()

sc config CscService start= disabled

new-itemproperty -path HKLM:\SYSTEM\CurrentControlSet\Services\Csc\Parameters -name FormatDatabase -propertytype DWORD -value 1
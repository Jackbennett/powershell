function Show-ChildItem(){
    Param(
    [switch]$Directory
    )
	get-childitem @args | sort name | ForEach-Object -Begin {$lastLetter} -Process {
        if($lastLetter -ne $PSItem.Name[0]){
            $LastLetter =  $PSItem.Name[0]
            write-host -NoNewline $PSItem.name[0] -ForegroundColor Red
            write-host $PSItem.name.substring(1)
            # hints
            #"\x1b[31m" ansi
            # [consoleColor]::Red
        } else {
            write-host $PSItem.name
        }
    } | format-wide -autosize
}
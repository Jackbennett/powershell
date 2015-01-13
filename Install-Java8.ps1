param (
    [Parameter(Mandatory=$true)]
    [IO.FileInfo]
    $MSI

    , [string]
    $Name
)

if (!(Test-Path $MSI.FullName)) {
    throw "File '{0}' does not exist" -f $MSI.FullName
}

# All this just the get the version string from the MSI
try {
    $windowsInstaller = New-Object -com WindowsInstaller.Installer
    $database = $windowsInstaller.GetType().InvokeMember(
        "OpenDatabase", "InvokeMethod", $Null,
        $windowsInstaller, @($MSI.FullName, 0)
    )

    $q = "SELECT Value FROM Property WHERE Property = 'ProductVersion'"
    $View = $database.GetType().InvokeMember(
        "OpenView", "InvokeMethod", $Null, $database, ($q)
    )

    $View.GetType().InvokeMember("Execute", "InvokeMethod", $Null, $View, $Null)
    $record = $View.GetType().InvokeMember( "Fetch", "InvokeMethod", $Null, $View, $Null )
    [version]$UpdateNumber = $record.GetType().InvokeMember( "StringData", "GetProperty", $Null, $record, 1 )

} catch {
    throw "Failed to get MSI file version: {0}." -f $_
}

# Now the installed version string, if any. win32_product is super slow :(
# Could maybe check the registry for this key. Need to deal with different x86 and x64 paths.
[version]$Version = Get-WmiObject -Class Win32_Product -Filter "Name Like '$Name%'" |
                        Select -ExpandProperty Version

# Compare versions of [version] type and install if needed
if($Version -lt $UpdateNumber){
    "run install"
    #Invoke-Expression "msiexec /i $MSI AUTOUPDATE=0 REBOOT=0 WEB_JAVA=1 /qn /lv C:\Install-$Name.log"
}

<#
.Synopsis
    Find an installed application on a computer

.DESCRIPTION
    Get a list of applications installed on a computer, the local computer or many remote computers.

    Add the module to your session with;
    Import-Module .\Application.psm1

.EXAMPLE
    Get-Application

    IdentifyingNumber : {7416D1B0-2497-45CF-9260-530E48A89AB7}
    Name              : CCC Help Polish
    Vendor            : Advanced Micro Devices, Inc.
    Version           : 2013.0322.0412.5642
    Caption           : CCC Help Polish

    IdentifyingNumber : {C3D791F1-31E0-212A-EEB8-54D9A11AC179}
    Name              : CCC Help Russian
    Vendor            : Advanced Micro Devices, Inc.
    Version           : 2013.0322.0412.5642
    Caption           : CCC Help Russian

.EXAMPLE
    Get-Application -computerName 25-13 | Format-Table ID,Name -AutoSize

    ID Name                                                     
    -- ----                                                     
     0 Microsoft Office Professional Plus 2010                  
     1 Microsoft Office OneNote MUI (English) 2010              
     2 Microsoft Office InfoPath MUI (English) 2010             
     3 Microsoft Office Access MUI (English) 2010
     ...

.EXAMPLE
    Get-Application -name Google -computerName 25-13 | Format-Table ID,Name -AutoSize

    ID Name                                
    -- ----                                
    17 Google Earth                        
    18 Google Toolbar for Internet Explorer
    19 Google SketchUp 8                   
    31 Google Update Helper                
    38 Google SketchUp 7
#>
function Get-Application
{
    [CmdletBinding()]
    Param
    (
        # Find an application by name
        [Parameter(ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        [string]
        $name

        , # Target computer for search
        [Parameter(Mandatory=$false,
                   ValueFromPipelineByPropertyName=$true)]
        [Alias('hostname','IP')]
        [string[]]
        $computerName = 'localhost'
    )

    Begin
    {
    }
    Process
    {
        Write-Verbose "Get all applications on computer: $computerName"

        try
        {
            # Get everything installed on the target machine. Don't bother filtering because you must use WQL
            $app = Get-WmiObject -class Win32_Product -ComputerName $computerName -ErrorAction SilentlyContinue

            Write-Verbose ('Installed programs: ' + $app.length)
        }
        catch
        {
            Write-error "Caught error: Computer is probably offline"
            return
        }

        <#
            Here we're going to add and ID field so you can pipe the output to a table
            and see what $obj[<number>] the application is to remove.
        #>
        for ($i = 0; $i -lt $app.name.length; $i++)
        {
            $app[$i] | Add-Member -Name ID -Value ($i + 1) -MemberType NoteProperty
        }

        #Here is where we filter on the provided name if any.
        if($name)
        {
            Write-Verbose "Now filtering out everything that doesn't match '$name'"
            $app = $app | where { $_.name -Match $name }
        }
    }
    End
    {
        $app | select ID,name,version,@{n='ComputerName';e={ $_.__SERVER} } | sort name 
    }
}


<#
.Synopsis
   Remove an application from a computer.
.DESCRIPTION
   Give a remote computer to remove an application from.

.EXAMPLE
   Example of how to use this cmdlet

$name |
    foreach-object {$counter = -1} {$counter++; $psItem |
    Add-Member -Name ID -Value $counter -MemberType NoteProperty -PassThru} |
    Format-Table ID, name

#>
function Remove-Application
{
    [CmdletBinding(SupportsShouldProcess=$true)]
    Param
    (
        # Full application name to be removed
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        [string]
        $name

        , # Target computer for application removal
        [Parameter(Mandatory=$false,
                   ValueFromPipelineByPropertyName=$true)]
        [Alias('hostname','IP')]
        [string[]]
        $computerName = 'localhost'
    )

    Begin
    {
    }
    Process
    {
        Write-Verbose "Unintstall $name on computer: "

        foreach($c in $computerName){
            Write-Verbose $c
        }

        foreach($c in $computerName){
            try{
                Get-WmiObject -class Win32_Product `
                    -filter ("name = '" + $name + "'" ) `
                    -ComputerName $c `
                    -OutVariable app `
                    -ErrorAction Stop
            }
            catch{
                Write-error "Stop: $c"
                return
            }

            Write-Output $app
        
            $app.uninstall()
        }
    }
    End
    {
    }
}
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
            $c

            try{
                Get-WmiObject -class Win32_Product `
                    -filter "name = '" + $name.toString() + "'" `
                    -ComputerName $c `
                    -OutVariable app `
                    -ErrorAction Stop -debug
            }
            catch{
                Write-error "Stop."
            }
            finally{
                Write-Output $app
            }
        
            # $app.uninstall()
        }
    }
    End
    {
    }
}


<#
.Synopsis
   Find an installed application on a computer
.DESCRIPTION
   Get a list of applications installed on a computer, the local computer or many remote computers.
.EXAMPLE
   get-application *google*

$name |
    foreach-object {$counter = -1} {$counter++; $psItem |
    Add-Member -Name ID -Value $counter -MemberType NoteProperty -PassThru} |
    Format-Table ID, name
#>
function Get-Application
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
    $name
    }
    Process
    {
        $app = Get-WmiObject -class Win32_Product `
            -filter "name = '" + $name + "'" `
            -ComputerName $computerName `
            -ErrorAction Stop -debug
    }
    End
    {
        $app
    }
}
<#
.Synopsis
   Find the Installation date of Windows
.DESCRIPTION
   Waht is the windows install date of the operating system for the target computer.
.EXAMPLE
   Get-InstallDate

   installDate                                                         ComputerName                                                      
   -----------                                                         ------------                                                      
   16/12/2013 11:48:21                                                 TECH-01   
.EXAMPLE
   Get-InstallDate -ComputerName Hyper-A

   installDate                                                         ComputerName                                                      
   -----------                                                         ------------                                                      
   17/02/2014 12:53:53                                                 HYPER-A  
#>
function Get-InstallDate
{
    [CmdletBinding()]
    Param
    (
        # Target Computer
        [Parameter(ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        [string[]]
        $ComputerName = 'localhost'
    )

    Begin
    {
    }
    Process
    {
        gwmi win32_operatingsystem -ComputerName $ComputerName | select @{name='installDate';expression={[Management.ManagementDateTimeConverter]::ToDateTime($psItem.installDate)} } ,@{name='ComputerName';expression={$psItem.CSName} }
        
        # Win 8.1, R2 and WMF 4.0 Only. Won't be using get-CimInstance for a while
        # Get-CimInstance win32_operatingsystem | select installDate
    }
    End
    {
    }
}


Configuration Create_xDscWebService
{
    param
    (
        [string[]]$NodeName = 'localhost',
 
        [ValidateNotNullOrEmpty()]
        [string] $certificateThumbPrint
    )
 
    Import-DSCResource -Module xPSDesiredStateConfiguration
 
    Node $NodeName
    {
        WindowsFeature WebServer
        {
            Ensure = "Present" # To uninstall the role, set Ensure to "Absent"
            Name = "Web-Server"
        }

        WindowsFeature IISMgmtTools 
        {
            Ensure = "Present"
            Name   = "Web-Mgmt-Tools"
        }

        WindowsFeature IISMgmtCon
        {
            Ensure = "Present"
            Name   = "Web-Mgmt-Console"
        }

        WindowsFeature IISScriptingTools
        {
            Ensure = "Present"
            Name   = "Web-Scripting-Tools"
        }

        WindowsFeature DSCServiceFeature
        {
            Ensure = "Present"
            Name   = "DSC-Service"
        }
 
        xDscWebService PSDSCPullServer
        {
            Ensure                  = "Present"
            EndpointName            = "DSCPull"
            Port                    = 80
            PhysicalPath            = "$env:SystemDrive\inetpub\wwwroot\DSCPull"
            CertificateThumbPrint   = "AllowUnencryptedTraffic"
            ModulePath              = "$env:PROGRAMFILES\WindowsPowerShell\DscService\Modules"
            ConfigurationPath       = "$env:PROGRAMFILES\WindowsPowerShell\DscService\Configuration"
            State                   = "Started"
            DependsOn               = "[WindowsFeature]DSCServiceFeature"
        }
 
        xDscWebService PSDSCComplianceServer
        {
            Ensure                  = "Present"
            EndpointName            = "DSCCompliance"
            Port                    = 8080
            PhysicalPath            = "$env:SystemDrive\inetpub\wwwroot\DSCCompliance"
            CertificateThumbPrint   = "AllowUnencryptedTraffic"
            State                   = "Started"
            IsComplianceServer      = $true
            DependsOn               = @("[WindowsFeature]DSCServiceFeature","[xDSCWebService]PSDSCPullServer")
        }
    }
}

Configuration bennett
{
   # A Configuration block can have zero or more Node blocks
   Node localhost
   {
      # Next, specify one or more resource blocks

      # WindowsFeature is one of the built-in resources you can use in a Node block
      # This example ensures the Web Server (IIS) role is installed
      WindowsFeature IPAM
      {
          Ensure = "Present" # To uninstall the role, set Ensure to "Absent"
          Name = "IPAM-Client-Feature"
      }
      WindowsFeature WINS
      {
          Ensure = "Present" # To uninstall the role, set Ensure to "Absent"
          Name = "RSAT-WINS"
      }
      WindowsFeature DNS
      {
          Ensure = "Present" # To uninstall the role, set Ensure to "Absent"
          Name = "RSAT-DNS-Server"
      }
      WindowsFeature DHCP
      {
          Ensure = "Present" # To uninstall the role, set Ensure to "Absent"
          Name = "RSAT-DHCP"
      }
      WindowsFeature WindowsUpdate
      {
          Ensure = "Present" # To uninstall the role, set Ensure to "Absent"
          Name = "UpdateServices-RSAT"
      }
      WindowsFeature hyperVTools
      {
          Ensure = "Present" # To uninstall the role, set Ensure to "Absent"
          Name = "RSAT-Hyper-V-Tools"
      }
      WindowsFeature ADAdmin
      {
          Ensure = "Present" # To uninstall the role, set Ensure to "Absent"
          Name = "RSAT-ADDS-Tools"
      }
      WindowsFeature ADPS
      {
          Ensure = "Present" # To uninstall the role, set Ensure to "Absent"
          Name = "RSAT-AD-Powershell"
      }
   }
} 

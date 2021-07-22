#
# Module manifest for module 'PSToolbox'
#
# Generated by: Benjamin Heater
#
# Generated on: 7/4/2021
#

@{

# Script module or binary module file associated with this manifest.
RootModule = 'PSToolbox.psm1'

# Version number of this module.
ModuleVersion = '1.0'

# Supported PSEditions
# CompatiblePSEditions = @()

# ID used to uniquely identify this module
GUID = 'cc35fed0-0e87-4477-9008-28282e5e74ba'

# Author of this module
Author = 'Benjamin Heater'

# Company or vendor of this module
CompanyName = ''

# Copyright statement for this module
Copyright = 'c 2020 All rights reserved.'

# Description of the functionality provided by this module
Description = 'PowerShell module with a set of generally helpful tools.'

# Minimum version of the PowerShell engine required by this module
# PowerShellVersion = ''

# Name of the PowerShell host required by this module
# PowerShellHostName = ''

# Minimum version of the PowerShell host required by this module
# PowerShellHostVersion = ''

# Minimum version of Microsoft .NET Framework required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
# DotNetFrameworkVersion = ''

# Minimum version of the common language runtime (CLR) required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
# ClrVersion = ''

# Processor architecture (None, X86, Amd64) required by this module
# ProcessorArchitecture = ''

# Modules that must be imported into the global environment prior to importing this module
# RequiredModules = @()

# Assemblies that must be loaded prior to importing this module
# RequiredAssemblies = @()

# Script files (.ps1) that are run in the caller's environment prior to importing this module.
# ScriptsToProcess = @()

# Type files (.ps1xml) to be loaded when importing this module
# TypesToProcess = @()

# Format files (.ps1xml) to be loaded when importing this module
# FormatsToProcess = @()

# Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
# NestedModules = @()

# Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
FunctionsToExport = 'Convert-DecimalToIPAddress', 'Convert-IPAddressToDecimal', 
               'Convert-NmapXmlToObject', 'Convert-StringToHash', 
               'Convert-VerizonFirewallLog', 'ConvertFrom-Base64', 
               'ConvertFrom-ByteArray', 'ConvertFrom-SecureString', 
               'ConvertFrom-UnixTime', 'ConvertTo-Base64', 'ConvertTo-ByteArray', 
               'ConvertTo-ProperNounFormat', 'Disable-CertificateValidation', 
               'Enable-CertificateValidation', 'Find-WordInFile', 'Get-DnsRecord', 
               'Get-DotNetClassName', 'Get-HostOperatingSystem', 
               'Get-HostPublicIPAddress', 'Get-IPGeoLocation', 
               'Get-PSElevationStatus', 'Get-RandomPassword', 
               'Get-ThisPowerShellProcess', 'Get-WhoIsInfo', 'Join-Substrings', 
               'New-AdminCredential', 'Out-RotatedString', 'Out-Uri', 
               'Out-UrlEncoding', 'Remove-AdminCredential', 'Remove-HtmlTags', 
               'Remove-InvalidCharacters', 'Restart-ProcessAsAdmin', 
               'Search-HtmlString', 'Set-Countdown', 'Undo-UrlEncoding', 
               'Update-PSGalleryModules', 'Write-LogMessage'

# Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
CmdletsToExport = '*'

# Variables to export from this module
VariablesToExport = '*'

# Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
AliasesToExport = 'stringhash', 'grpw', 'password', 'ncred', 'rcred', 'RunAsAdmin'

# DSC resources to export from this module
# DscResourcesToExport = @()

# List of all modules packaged with this module
# ModuleList = @()

# List of all files packaged with this module
# FileList = @()

# Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
PrivateData = @{

    PSData = @{

        # Tags applied to this module. These help with module discovery in online galleries.
        # Tags = @()

        # A URL to the license for this module.
        # LicenseUri = ''

        # A URL to the main website for this project.
        # ProjectUri = ''

        # A URL to an icon representing this module.
        # IconUri = ''

        # ReleaseNotes of this module
        # ReleaseNotes = ''

        # Prerelease string of this module
        # Prerelease = ''

        # Flag to indicate whether the module requires explicit user acceptance for install/update/save
        # RequireLicenseAcceptance = $false

        # External dependent modules of this module
        # ExternalModuleDependencies = @()

    } # End of PSData hashtable

} # End of PrivateData hashtable

# HelpInfo URI of this module
# HelpInfoURI = ''

# Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
# DefaultCommandPrefix = ''

}


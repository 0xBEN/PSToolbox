function Get-HostOperatingSystem {

    [CmdletBinding()]
    Param()
    
    begin{

        class OperatingSystem {

            [string]$OS
            [datetime]$InstallationDate

        }

    }
    process {

        $operatingSystem = New-Object OperatingSystem
        if ($PSVersionTable.OS) {

            if ($PSVersionTable.OS -like '*windows*' -or $PSVersionTable.Platform -like '*win32*') { $operatingSystem.OS = 'Windows' }
            elseif ($PSVersionTable.OS -like '*Linux*') { $operatingSystem.OS = 'Linux'}
            elseif ($PSVersionTable.Platform -eq 'Unix' -and (sysctl -a | grep apple)) { $operatingSystem.OS = 'MacOS'}

        }
        else {

            $operatingSystem.OS = 'Windows'

        }

        if ($operatingSystem.OS -eq 'Windows') { $operatingSystem.InstallationDate = (Get-CimInstance -ClassName Win32_OperatingSystem).InstallDate }
        elseif ($operatingSystem.OS -eq 'Linux') { $operatingSystem.InstallationDate = (ls -lact --full-time /etc | tail -1 | awk '{print $6,$7}' | Get-Date) }
        elseif ($operatingSystem.OS -eq 'MacOs') { $operatingSystem.InstallationDate = ((Get-ChildItem -Hidden -Path '/var/db/.AppleSetupDone').LastWriteTime | Get-Date) }

        if (-not $operatingSystem) { Write-Error "Unable to determing host operating system." }
        else { return $operatingSystem }
        
    }

}
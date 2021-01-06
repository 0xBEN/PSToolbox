function Write-LogMessage {

    [CmdletBinding()]
    Param (

        [Parameter(
            Mandatory = $true,
            Position = 0
        )]
        [ValidateSet('ERROR', 'INFO', 'LOG')]
        [String]
        $LogLevel,

        [Parameter(
            Mandatory = $true,
            Position = 1
        )]
        [ValidateNotNullOrEmpty()]
        [String]
        $LogMessage

    )
    process {

        "[$LogLevel] [$((Get-Date).ToUniversalTime().ToString('yyyy-MM-ddTHH:mm:ssZ'))] $LogMessage"

    }

}
function Convert-IPAddressToDecimal {

    [CmdletBinding()]
    Param (

        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true    
        )]
        [ValidateNotNullOrEmpty()]
        [string[]]
        $IPAddress

    )
    process {

        $IPAddress | ForEach-Object {

            return ([ipaddress]$_).Address

        }

    }

}
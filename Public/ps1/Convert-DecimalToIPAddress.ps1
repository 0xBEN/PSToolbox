function Convert-DecimalToIpAddress {

    [CmdletBinding()]
    Param (

        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true    
        )]
        [int[]]
        $Decimal

    )
    begin {

        $template = [ipaddress]"0.0.0.0"

    }
    process {

        $Decimal | ForEach-Object {

            $template.Address = $_
            return $template.IPAddressToString

        }

    }

}
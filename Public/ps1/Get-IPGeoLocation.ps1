function Get-IPGeoLocation {

    [CmdletBinding()]
    Param (

        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true
        )]
        [ValidateScript({
            
            if (-not ($_ -as [System.Net.IPAddress])) {

                throw "Please pass a valid IPv4 address."

            }
            elseif (([System.Net.IPAddress]$_).AddressFamily -eq 'InterNetworkV6') {

                throw "Please pass an IPv4 address."

            }
            else {

                $splitIpAddress = $_.IPAddressToString.Split('.')
                if (($splitIpAddress[0] -eq '10') -or (($splitIpAddress[0,1] -join '.') -eq '192.168') -or (($splitIpAddress[0] -eq '172') -and ($splitIpAddress[1] -in (16..31)))) { throw "Please pass a public IPv4 address" }
                else { return $true }

            }
                   
        })]
        [System.Net.IPAddress]
        $IPV4Address

    )
    process {

        $apiCall = Invoke-RestMethod -Uri "https://tools.keycdn.com/geo.json?host=$($IPV4Address.IPAddressToString)" -Method Get
        return $apiCall.data.geo

    }

}
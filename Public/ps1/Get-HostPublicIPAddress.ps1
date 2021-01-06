function Get-HostPublicIPAddress {

    [CmdletBinding(DefaultParameterSetName = 'ipv4')]
    Param (

        [Parameter(ParameterSetName = 'ipv4')]
        [switch]
        $ReturnIPv4,

        [Parameter(ParameterSetName = 'ipv6')]
        [switch]
        $ReturnIPv6

    )
    process {

        if ($PSCmdlet.ParameterSetName -eq 'ipv4') { $apiCall = Invoke-RestMethod -Uri 'https://api.ipify.org' -Method Get }
        else { $apiCall = Invoke-RestMethod -Uri 'https://api6.ipify.org' -Method Get }

        return $apiCall.ToString()

    }

}
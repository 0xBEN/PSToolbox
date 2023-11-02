function Get-WhoIsInfo {
    
    [CmdletBinding(DefaultParameterSetName = 'IPAddress')]
    Param (
        [Parameter(
            Position= 0,
            Mandatory = $true,
            ParameterSetName = 'IPAddress'
        )]
        [ValidateScript({[IPAddress]::Parse($_)})]
        [String[]]$IPAddress,

        [Parameter(
            Position= 0,
            Mandatory = $true,
            ParameterSetName = 'Domain'
        )]
        [ValidateScript({try { Resolve-DnsName $_ -ErrorAction Stop } catch { throw $_ } })]
        [String[]]$Domain
    )
    begin {

        if ($PSCmdlet.ParameterSetName -eq 'IPAddress') {
            $baseUri = 'https://rdap.arin.net/registry/ip/'
            $inputObject = $IPAddress
        }
        else {
            $baseUri = 'https://rdap.verisign.com/com/v1/domain/'
            $inputObject = $Domain
        }

    }
    process {

        $inputObject | ForEach-Object {

            try {
                $uri = $baseUri + $_
                Write-Verbose $uri
                Invoke-RestMethod $uri
            }
            catch {
                $_ | Write-Error
            }

        }

    }
    end { }

}

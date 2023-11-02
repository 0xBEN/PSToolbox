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
        [ValidateScript({

            $testInput = $_
            try { 
                
                if ($testInput -as [IPAddress]) {
                    throw "You have provided an IP address for the Domain parameter set."
                }
                else {
                    Resolve-DnsName $testInput -ErrorAction Stop 
                }
                
            } 
            catch { 
                throw $_ 
            } 

        })]
        [String[]]$Domain
    )
    begin {

        if ($PSCmdlet.ParameterSetName -eq 'IPAddress') {
            $baseUri = 'https://rdap.arin.net/registry/ip/'
        }
        else {
            $baseUri = 'https://rdap.verisign.com/com/v1/domain/'
        }

    }
    process {

        if ($PSCmdlet.ParameterSetName -eq 'IPAddress') {
            
            $IPAddress | ForEach-Object {
                
                try {
                    $uri = $baseUri + $_
                    Invoke-RestMethod $uri
                }
                catch {
                    $_ | Write-Error
                }
    
            }

        }
        else {

            $Domain | ForEach-Object {
                
                try {
                    $verisign = $baseUri + $_
                    $verisignData = Invoke-RestMethod $verisign

                    $uri = $verisignData.links[1].value
                    Invoke-RestMethod $uri
                }
                catch {
                    $_ | Write-Error
                }
    
            }

        }

    }
    end { }

}

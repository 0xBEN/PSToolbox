function Get-HostPublicIPAddress {

    [CmdletBinding()]
    Param ()
    begin { 
        $uri = 'https://accountws.arin.net/public/rest/myip'
        $headers = @{
            'Content-Type' = 'application/json'
        }
        $method = 'GET'
    }
    process {

        try {
            $parameters = @{
                'Method' = $method
                'Headers' = $headers
                'Uri' = $uri
            }
            Invoke-RestMethod @parameters
        }
        catch {
            throw $_
        }
        
    }
    end {}

}

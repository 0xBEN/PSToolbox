function Get-HostPublicIPAddress {

    [CmdletBinding()]
    Param ()
    begin { 
        $uri = 'https://accountws.arin.net/public/rest/myip'
        $headers = @{
            'Content-Type' = 'application/json'
        }
        $method = 'GET'
        $userAgent = [Microsoft.PowerShell.Commands.PSUserAgent]::Chrome
    }
    process {

        try {
            $parameters = @{
                'Method' = $method
                'Headers' = $headers
                'Uri' = $uri
                'UserAgent' = $userAgent
            }
            Invoke-RestMethod @parameters
        }
        catch {
            throw $_
        }
        
    }
    end {}

}

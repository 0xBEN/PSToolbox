function Get-IPGeoLocation {

    [CmdletBinding()]
    [Alias("Get-IPLookup","Get-IPInfo","iplookup","ipinfo")]
    Param (

        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true
        )]
        [ValidateScript({
            
            if (-not ($_ -as [System.Net.IPAddress])) {
                throw "Please pass a valid IP address."
            }
            else {
                return $true
            }
                  
        })]
        [System.Net.IPAddress]
        $IPAddress

    )
    begin{
        $baseUri = "https://rdap.arin.net/registry/ip/"
        $userAgent = [Microsoft.PowerShell.Commands.PSUserAgent]::Chrome
    }
    process {
        
        try {
            $uri = $baseUri + $IPAddress
            Invoke-RestMethod $uri -UserAgent $userAgent -ErrorAction Stop
        }
        catch {
            throw $_.Exception
        }
        
    }

}

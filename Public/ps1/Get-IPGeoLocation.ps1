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
    process {
        
        try {
            Invoke-RestMethod "https://rdap.arin.net/registry/ip/$IPAddress" -ErrorAction Stop
        }
        catch {
            throw $_.Exception
        }
        
    }

}

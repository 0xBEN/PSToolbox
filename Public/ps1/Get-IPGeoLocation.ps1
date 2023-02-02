function Get-IPGeoLocation {

    [CmdletBinding()]
    Param (

        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true
        )]
        [ValidateScript({
            
            if (-not ($_ -as [System.Net.IPAddress])) {
                throw "Please pass a valid IP address."
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

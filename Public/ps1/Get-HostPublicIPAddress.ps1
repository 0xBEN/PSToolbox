function Get-HostPublicIPAddress {

    [CmdletBinding()]
    Param ()
    begin { }
    process {

        try {
            $webRequest = Invoke-WebRequest https://cloudflare.com/cdn-cgi/trace -UseBasicParsing
            $ip = $webRequest.Content.Split("`n") | Where-Object {$_ -like 'ip=*'}
            $ip.Split('=')[1]
        }
        catch {
            throw $_
        }
        
    }
    end {}

}
